use "../data"
use "debug"
use time = "time"

actor _GatewayBucket
    let _connection: _GatewayConnection
    let _timers: time.Timers
    embed _queue: _Queue[GatewaySendableEvent] = _Queue[GatewaySendableEvent]

    let _commands: _RateLimitWindow = _RateLimitConstants.command_window()
    let _presences: _RateLimitWindow = _RateLimitConstants.presence_window()
    let _identifies: _RateLimitWindow = _RateLimitConstants.identify_window()

    var _open: Bool = false
    var _throttled: Bool = false
    var _overflowing: Bool = false
    var _dropped: USize = 0
    var _generation: USize = 0
    var _drain_scheduled: Bool = false
    var _disposed: Bool = false

    new create(connection: _GatewayConnection, timers: time.Timers) =>
        _connection = connection
        _timers = timers

    be enqueue(event: GatewaySendableEvent) =>
        if _disposed then
            Debug.out("[gateway/bucket] dropping an event: the bucket was disposed of")
            return
        end

        _queue.enqueue(event)

        let cap = GatewayConstants.max_queued_events()
        if _queue.size() > cap then
            try _queue.dequeue()? end
            _dropped = _dropped + 1

            Debug.out(
                "[gateway/bucket] the queue is full at " + cap.string()
                + ", so the oldest event was dropped, " + _dropped.string()
                + " lost so far"
            )

            if not _overflowing then
                _overflowing = true
                _connection._queue_overflowed(cap)
            end
        else
            Debug.out(
                "[gateway/bucket] queued opcode " + event.opcode().value().string()
                + ", " + _queue.size().string() + " waiting"
            )
        end

        _drain()

    be handshake(event: GatewaySendableEvent) =>
        if _disposed then
            Debug.out("[gateway/bucket] dropping a handshake: the bucket was disposed of")
            return
        end

        Debug.out(
            "[gateway/bucket] handshaking with opcode "
            + event.opcode().value().string()
        )

        _handshake(event, _generation)

    be heartbeat(event: GatewaySendableEvent) =>
        if _disposed then
            Debug.out("[gateway/bucket] dropping a heartbeat: the bucket was disposed of")
            return
        end

        Debug.out("[gateway/bucket] letting a heartbeat past the queue")

        _commands.spend(time.Time.nanos())
        _connection._raw_send(event)

    be throttle() =>
        Debug.out(
            "[gateway/bucket] the connection is backed up, holding "
            + _queue.size().string() + " event(s) back"
        )

        _throttled = true

    be unthrottle() =>
        Debug.out("[gateway/bucket] the connection has caught up, draining again")

        _throttled = false
        _drain()

    be close() =>
        Debug.out(
            "[gateway/bucket] closing, " + _queue.size().string()
            + " event(s) stay queued for the next connection"
        )

        _open = false
        _throttled = false
        _generation = _generation + 1

    be dispose() =>
        Debug.out(
            "[gateway/bucket] disposing, dropping " + _queue.size().string()
            + " queued event(s)"
        )

        _disposed = true
        _open = false
        _generation = _generation + 1
        _queue.clear()

    be _retry_handshake(event: GatewaySendableEvent, generation: USize) =>
        if _disposed then
            Debug.out("[gateway/bucket] abandoning a handshake retry: the bucket was disposed of")
            return
        end

        if generation != _generation then
            Debug.out(
                "[gateway/bucket] abandoning a handshake retry from generation "
                + generation.string() + ", we are on " + _generation.string()
            )
            return
        end

        Debug.out("[gateway/bucket] retrying the handshake")

        _handshake(event, generation)

    be _wake() =>
        Debug.out("[gateway/bucket] woken up to drain the queue")

        _drain_scheduled = false
        _drain()

    fun ref _handshake(event: GatewaySendableEvent, generation: USize) =>
        let now = time.Time.nanos()

        if _IsIdentify(event) then
            match _identifies.blocked_until(now)
            | let at: U64 =>
                Debug.out(
                    "[gateway/bucket] the identify window is spent, holding the identify for "
                    + ((at - now) / 1_000_000).string() + "ms"
                )

                let self: _GatewayBucket tag = this
                _timers(
                    time.Timer(
                        _OnceElapsed(
                            {() => self._retry_handshake(event, generation)}
                        ),
                        at - now
                    )
                )

                return
            end

            _identifies.spend(now)
        end

        _commands.spend(now)
        _connection._raw_send(event)

        Debug.out(
            "[gateway/bucket] the handshake is away, the queue is open with "
            + _queue.size().string() + " event(s) waiting"
        )

        _open = true
        _drain()

    fun ref _drain() =>
        if _disposed then
            Debug.out("[gateway/bucket] not draining: the bucket was disposed of")
            return
        end

        if not _open then
            Debug.out(
                "[gateway/bucket] not draining: the handshake has not gone through yet, "
                + _queue.size().string() + " event(s) held back"
            )
            return
        end

        if _throttled then
            Debug.out(
                "[gateway/bucket] not draining: the connection is backed up, "
                + _queue.size().string() + " event(s) held back"
            )
            return
        end

        while _queue.size() > 0 do
            let now = time.Time.nanos()
            let event = try _queue.dequeue()? else return end

            match _blocked_until(event, now)
            | let at: U64 =>
                Debug.out(
                    "[gateway/bucket] rate limited, putting opcode "
                    + event.opcode().value().string() + " back and waiting "
                    + ((at - now) / 1_000_000).string() + "ms"
                )

                _queue.enqueue_at_beginning(event)

                if not _drain_scheduled then
                    _drain_scheduled = true
                    let self: _GatewayBucket tag = this
                    _timers(
                        time.Timer(_OnceElapsed({() => self._wake()}), at - now)
                    )
                end

                return
            end

            _commands.spend(now)
            if _IsPresenceUpdate(event) then _presences.spend(now) end

            Debug.out(
                "[gateway/bucket] releasing opcode "
                + event.opcode().value().string() + ", "
                + _queue.size().string() + " left in the queue"
            )

            _connection._raw_send(event)

            if
                _overflowing
                    and (_queue.size()
                        <= (GatewayConstants.max_queued_events() / 2))
            then
                _overflowing = false
                _connection._queue_recovered(_dropped)
                _dropped = 0
            end
        end

    fun _blocked_until(event: GatewaySendableEvent, now: U64): (U64 | None) =>
        var at: U64 = 0

        match _commands.blocked_until(
            now,
            _RateLimitConstants.heartbeat_reserve()
        )
        | let commands_at: U64 => at = at.max(commands_at)
        end

        if _IsPresenceUpdate(event) then
            match _presences.blocked_until(now)
            | let presences_at: U64 => at = at.max(presences_at)
            end
        end

        if at > now then at end
