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

class _IdentifyBucket
    embed queue: Array[_WantsIdentify] = Array[_WantsIdentify]

    var last: U64 = 0
    var scheduled: Bool = false

    new create() => None

actor _GatewayIdentifyGate
    let _timers: time.Timers

    embed _buckets: Array[_IdentifyBucket] = Array[_IdentifyBucket]

    new create(timers: time.Timers, concurrency: USize = 1) =>
        _timers = timers
        _widen(concurrency)

    be set_concurrency(concurrency: USize) =>
        if concurrency <= _buckets.size() then return end

        Debug.out(
            "[gateway/shards] the identify limit is now " + concurrency.string()
            + " at a time, was " + _buckets.size().string()
        )

        _widen(concurrency)

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

    fun ref _widen(concurrency: USize) =>
        while _buckets.size() < concurrency.max(1) do
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
