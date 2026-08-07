use "../data"
use time = "time"

actor _GatewayBucket
    let _connection: _GatewayConnection
    let _timers: time.Timers
    embed _queue: _Queue[GatewaySendableEvent] = _Queue[GatewaySendableEvent]

    let _commands: _RateLimitWindow = _RateLimitConstants.command_window()
    let _presences: _RateLimitWindow = _RateLimitConstants.presence_window()
    let _identifies: _RateLimitWindow = _RateLimitConstants.identify_window()

    var _open: Bool = false
    var _generation: USize = 0
    var _drain_scheduled: Bool = false
    var _disposed: Bool = false

    new create(connection: _GatewayConnection, timers: time.Timers) =>
        _connection = connection
        _timers = timers

    be enqueue(event: GatewaySendableEvent) =>
        if _disposed then return end

        _queue.enqueue(event)
        _drain()

    be handshake(event: GatewaySendableEvent) =>
        if _disposed then return end

        _handshake(event, _generation)

    be heartbeat(event: GatewaySendableEvent) =>
        if _disposed then return end

        _commands.spend(time.Time.nanos())
        _connection._raw_send(event)

    be close() =>
        _open = false
        _generation = _generation + 1

    be dispose() =>
        _disposed = true
        _open = false
        _generation = _generation + 1
        _queue.clear()

    be _retry_handshake(event: GatewaySendableEvent, generation: USize) =>
        if _disposed or (generation != _generation) then return end

        _handshake(event, generation)

    be _wake() =>
        _drain_scheduled = false
        _drain()

    fun ref _handshake(event: GatewaySendableEvent, generation: USize) =>
        let now = time.Time.nanos()

        if _IsIdentify(event) then
            match _identifies.blocked_until(now)
            | let at: U64 =>
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

        _open = true
        _drain()

    fun ref _drain() =>
        if _disposed or not _open then return end

        while _queue.size() > 0 do
            let now = time.Time.nanos()
            let event = try _queue.dequeue()? else return end

            match _blocked_until(event, now)
            | let at: U64 =>
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

            _connection._raw_send(event)
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
