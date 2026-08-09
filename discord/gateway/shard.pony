use "../data"
use "debug"
use time = "time"

primitive GatewayShardsAutomatic
class val GatewayShardSet
    let count: USize
    let ids: Array[USize] val

    new val create(count': USize, ids': (Array[USize] val | None) = None) =>
        let total = count'.max(1)

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

actor _GatewayIdentifyGate
    let _timers: time.Timers

    embed _last: Array[U64] = Array[U64]
    embed _queues: Array[Array[_WantsIdentify]] =
        Array[Array[_WantsIdentify]]
    embed _scheduled: Array[Bool] = Array[Bool]

    var _concurrency: USize = 0

    new create(timers: time.Timers, concurrency: USize = 1) =>
        _timers = timers
        _widen(concurrency)

    be set_concurrency(concurrency: USize) =>
        if concurrency <= _concurrency then return end

        Debug.out(
            "[gateway/shards] the identify limit is now " + concurrency.string()
            + " at a time, was " + _concurrency.string()
        )

        _widen(concurrency)

    be request(shard_id: USize, connection: _WantsIdentify) =>
        let bucket = shard_id % _concurrency

        try
            _queues(bucket)?.push(connection)

            Debug.out(
                "[gateway/shards] shard " + shard_id.string()
                + " wants an identify slot, " + _queues(bucket)?.size().string()
                + " waiting on bucket " + bucket.string()
            )
        end

        _pump(bucket)

    be _wake(bucket: USize) =>
        try _scheduled(bucket)? = false end

        _pump(bucket)

    fun ref _widen(concurrency: USize) =>
        let wanted = concurrency.max(1)

        while _concurrency < wanted do
            _last.push(0)
            _queues.push(Array[_WantsIdentify])
            _scheduled.push(false)
            _concurrency = _concurrency + 1
        end

    fun ref _pump(bucket: USize) =>
        let interval =
            time.Nanos.from_millis(GatewayConstants.identify_interval_ms())

        try
            let queue = _queues(bucket)?
            let last = _last(bucket)?
            let now = time.Time.nanos()

            if
                (queue.size() > 0)
                    and ((last == 0) or ((now - last) >= interval))
            then
                let connection = queue.shift()?
                _last(bucket)? = now

                Debug.out(
                    "[gateway/shards] bucket " + bucket.string()
                    + " is handing out an identify slot, "
                    + queue.size().string() + " still waiting"
                )

                connection._identify_granted()
            end

            if (_queues(bucket)?.size() == 0) or _scheduled(bucket)? then
                return
            end

            let since = time.Time.nanos() - _last(bucket)?
            let wait = if since >= interval then 0 else interval - since end

            _scheduled(bucket)? = true

            let self: _GatewayIdentifyGate tag = this
            _timers(
                time.Timer(_Elapsed({() => self._wake(bucket)}), wait)
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
        let owners: Array[USize] val =
            recover val
                let found = Array[USize]

                for guild_id in guild_ids.values() do
                    let id = GatewayShardFor(guild_id, count)
                    var known = false

                    for owner in found.values() do
                        if owner == id then
                            known = true
                            break
                        end
                    end

                    if not known then found.push(id) end
                end

                found
            end

        recover val
            let routed = Array[(USize, GatewaySendableEvent)](owners.size())

            for owner in owners.values() do
                var mine = recover iso Array[Snowflake] end

                for guild_id in guild_ids.values() do
                    if GatewayShardFor(guild_id, count) == owner then
                        mine.push(guild_id)
                    end
                end

                routed.push(
                    (
                        owner,
                        GatewayRequestSoundboardSoundsEvent(consume mine)
                    )
                )
            end

            routed
        end
