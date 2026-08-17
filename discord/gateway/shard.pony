use "../data"
use "debug"
use time = "time"

primitive GatewayShardsAutomatic
class val GatewayShardSet
    let count: USize
    let ids: Array[USize] val

    new val create(count': USize, ids': (Array[USize] val | None) = None) =>
        let total = count'.max(1).min(GatewayConstants.max_shards())

        count = total
        ids =
            match ids'
            | let named: Array[USize] val =>
                recover val
                    let kept = Array[USize](named.size())
                    for id in named.values() do
                        if id < total then kept.push(id) end
                    end
                    kept
                end
            else
                recover val
                    let all = Array[USize](total)
                    var id: USize = 0
                    while id < total do
                        all.push(id)
                        id = id + 1
                    end
                    all
                end
            end

type GatewaySharding is (GatewayShardsAutomatic | GatewayShardSet | None)

primitive GatewayShardFor
    fun apply(guild_id: Snowflake, count: USize): USize =>
        if count <= 1 then return 0 end

        ((guild_id.value >> 22) % count.u64()).usize()

trait tag _WantsIdentify
    be _identify_granted()

class _IdentifyBucket
    embed queue: Array[_WantsIdentify] = Array[_WantsIdentify]

    var last: U64 = 0
    var scheduled: Bool = false

    new create() => None

actor _GatewayIdentifyGate
    let _timers: time.Timers
    let _on_error: GatewayErrorHandler

    embed _buckets: Array[_IdentifyBucket] = Array[_IdentifyBucket]

    var _budget: (USize | None) = None
    var _total: USize = 0
    var _resets_at: U64 = 0
    var _reset_scheduled: Bool = false

    new create(
        timers: time.Timers,
        concurrency: USize = 1,
        on_error: GatewayErrorHandler = GatewayDefaults.on_error()
    ) =>
        _timers = timers
        _on_error = on_error
        _widen(concurrency)

    be set_concurrency(concurrency: USize) =>
        let wanted =
            concurrency.max(1).min(GatewayConstants.max_identify_concurrency())

        if wanted <= _buckets.size() then return end

        Debug.out(
            "[gateway/shards] the identify limit is now " + wanted.string()
            + " at a time, was " + _buckets.size().string()
        )

        _widen(wanted)

    be set_session_limit(remaining: USize, total: USize, reset_after: U64) =>
        _budget = remaining
        _total = total
        _resets_at = time.Time.nanos() + time.Nanos.from_millis(reset_after)

        Debug.out(
            "[gateway/shards] " + remaining.string() + " of " + total.string()
            + " session start(s) are left, the limit resets in "
            + reset_after.string() + "ms"
        )

        _pump_all()

    be request(shard_id: USize, connection: _WantsIdentify) =>
        let index = shard_id % _buckets.size()

        try
            let bucket = _buckets(index)?
            bucket.queue.push(connection)

            Debug.out(
                "[gateway/shards] shard " + shard_id.string()
                + " wants an identify slot, " + bucket.queue.size().string()
                + " waiting on bucket " + index.string()
            )
        end

        _pump(index)

    be _wake(index: USize) =>
        try _buckets(index)?.scheduled = false end

        _pump(index)

    be _reset() =>
        _reset_scheduled = false

        _pump_all()

    fun ref _pump_all() =>
        var index: USize = 0

        while index < _buckets.size() do
            _pump(index)
            index = index + 1
        end

    fun ref _spend(now: U64): Bool =>
        let left =
            match _budget
            | let left': USize => left'
            else
                return true
            end

        if left > 0 then
            _budget = left - 1
            return true
        end

        if now >= _resets_at then
            Debug.out(
                "[gateway/shards] the session start limit has reset, so "
                + "identifies can go out again"
            )

            if _total > 0 then
                _budget = _total - 1
                _resets_at = now
                    + time.Nanos.from_millis(
                        GatewayConstants.session_limit_window_ms()
                    )
            else
                _budget = None
                _resets_at = 0
            end

            return true
        end

        _hold(now)

        false

    fun ref _hold(now: U64) =>
        if _reset_scheduled then return end

        _reset_scheduled = true

        let wait = if _resets_at > now then _resets_at - now else 0 end
        let left: String = (wait / 1_000_000).string()

        Debug.out(
            "[gateway/shards] the session start limit of " + _total.string()
            + " is spent, so identifies are held for " + left + "ms"
        )
        _on_error(
            GatewayError(
                "the session start limit of " + _total.string()
                + " is spent, so identifies are held for " + left + "ms"
            )
        )

        let self: _GatewayIdentifyGate tag = this
        _timers(
            time.Timer(_Elapsed({() => self._reset()}), wait)
        )

    fun ref _widen(concurrency: USize) =>
        let wanted =
            concurrency.max(1).min(GatewayConstants.max_identify_concurrency())

        while _buckets.size() < wanted do
            _buckets.push(_IdentifyBucket)
        end

    fun ref _pump(index: USize) =>
        let interval =
            time.Nanos.from_millis(GatewayConstants.identify_interval_ms())

        try
            let bucket = _buckets(index)?
            let now = time.Time.nanos()

            if
                (bucket.queue.size() > 0)
                    and (
                        (bucket.last == 0)
                            or ((now - bucket.last) >= interval)
                    )
            then
                if not _spend(now) then return end

                let connection = bucket.queue.shift()?
                bucket.last = now

                Debug.out(
                    "[gateway/shards] bucket " + index.string()
                    + " is handing out an identify slot, "
                    + bucket.queue.size().string() + " still waiting"
                )

                connection._identify_granted()
            end

            if (bucket.queue.size() == 0) or bucket.scheduled then return end

            let since = time.Time.nanos() - bucket.last
            let wait = if since >= interval then 0 else interval - since end

            bucket.scheduled = true

            let self: _GatewayIdentifyGate tag = this
            _timers(
                time.Timer(_Elapsed({() => self._wake(index)}), wait)
            )
        end

primitive _GatewayRoute
    fun apply(
        event: GatewaySendableEvent,
        count: USize
    ): Array[(USize, GatewaySendableEvent)] val =>
        if count <= 1 then return _one(0, event) end

        match event
        | let members: GatewayRequestGuildMembersEvent =>
            _one(GatewayShardFor(members.guild_id, count), event)
        | let voice: GatewayVoiceStateUpdateEvent =>
            _one(GatewayShardFor(voice.guild_id, count), event)
        | let channel: GatewayRequestChannelInfoEvent =>
            _one(GatewayShardFor(channel.guild_id, count), event)
        | let sounds: GatewayRequestSoundboardSoundsEvent =>
            _split(sounds.guild_ids, count)
        else
            _all(event, count)
        end

    fun _one(
        id: USize,
        event: GatewaySendableEvent
    ): Array[(USize, GatewaySendableEvent)] val =>
        recover val [(id, event)] end

    fun _all(
        event: GatewaySendableEvent,
        count: USize
    ): Array[(USize, GatewaySendableEvent)] val =>
        recover val
            let routed = Array[(USize, GatewaySendableEvent)](count)

            var id: USize = 0

            while id < count do
                routed.push((id, event))
                id = id + 1
            end

            routed
        end

    fun _split(
        guild_ids: Array[Snowflake] val,
        count: USize
    ): Array[(USize, GatewaySendableEvent)] val =>
        recover val
            let owners = Array[USize]

            for guild_id in guild_ids.values() do
                let id = GatewayShardFor(guild_id, count)
                var known = false

                for owner in owners.values() do
                    if owner == id then
                        known = true
                        break
                    end
                end

                if not known then owners.push(id) end
            end

            let routed = Array[(USize, GatewaySendableEvent)](owners.size())

            for owner in owners.values() do
                routed.push(
                    (
                        owner,
                        GatewayRequestSoundboardSoundsEvent(
                            recover val
                                let mine = Array[Snowflake]

                                for guild_id in guild_ids.values() do
                                    if
                                        GatewayShardFor(guild_id, count)
                                            == owner
                                    then
                                        mine.push(guild_id)
                                    end
                                end

                                mine
                            end
                        )
                    )
                )
            end

            routed
        end
