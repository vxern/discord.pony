use "../data"
use "pony_test"
use random = "random"
use rest = "../rest"
use time = "time"

class iso _StressShardFormula is UnitTest
    fun name(): String => "stress/shard/formula"

    fun apply(h: TestHelper) ? =>
        h.assert_eq[USize](
            0,
            GatewayShardFor(Snowflake(1_206_309_358_925_783_100), 1),
            "one shard owns everything"
        )

        let rand = random.Rand(0x5ad, 0x1)
        let counts: Array[USize] = [1; 2; 3; 16; 64; 250]

        for count in counts.values() do
            let seen = Array[USize].init(0, count)

            var index: USize = 0

            while index < 100_000 do
                let guild = Snowflake(rand.u64())
                let shard = GatewayShardFor(guild, count)

                h.assert_true(
                    shard < count,
                    "shard " + shard.string() + " is outside a set of "
                    + count.string()
                )

                h.assert_eq[USize](
                    ((guild.value >> 22) % count.u64()).usize(),
                    shard,
                    "the mapping drifted from (guild_id >> 22) % count"
                )

                h.assert_eq[USize](
                    shard,
                    GatewayShardFor(guild, count),
                    "the mapping is not stable for the same guild"
                )

                seen(shard)? = seen(shard)? + 1
                index = index + 1
            end

            var empty: USize = 0

            for owned in seen.values() do
                if owned == 0 then empty = empty + 1 end
            end

            h.assert_eq[USize](
                0,
                empty,
                empty.string() + " of " + count.string()
                + " shard(s) were handed no guilds at all"
            )
        end

class iso _StressShardSet is UnitTest
    fun name(): String => "stress/shard/set"

    fun apply(h: TestHelper) ? =>
        let all = GatewayShardSet(8)

        h.assert_eq[USize](8, all.count)
        h.assert_eq[USize](8, all.ids.size())

        var index: USize = 0

        while index < 8 do
            h.assert_eq[USize](index, all.ids(index)?)
            index = index + 1
        end

        let subset = GatewayShardSet(8, [2; 5])

        h.assert_eq[USize](8, subset.count)
        h.assert_eq[USize](2, subset.ids.size())
        h.assert_eq[USize](2, subset.ids(0)?)
        h.assert_eq[USize](5, subset.ids(1)?)

        let bogus = GatewayShardSet(4, [0; 4; 9; 3])

        h.assert_eq[USize](2, bogus.ids.size(), "ids past the count must go")
        h.assert_eq[USize](0, bogus.ids(0)?)
        h.assert_eq[USize](3, bogus.ids(1)?)

        h.assert_eq[USize](1, GatewayShardSet(0).count, "a set is never empty")

class iso _StressIdentifyGateConcurrent is UnitTest
    fun name(): String => "stress/shard/identify_gate_concurrent"

    fun exclusion_group(): String => "gate"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(30))

        let shards: USize = 16
        let timers = time.Timers
        let gate = _GatewayIdentifyGate(timers, shards)
        let watch = _Grants(h, shards, timers)

        var index: USize = 0

        while index < shards do
            gate.request(index, _Applicant(index, watch))
            index = index + 1
        end

        watch.settle(
            { (h': TestHelper, at: Array[(USize, U64)] val) =>
                var widest: U64 = 0

                for (_, when) in at.values() do widest = widest.max(when) end

                h'.log(
                    at.size().string() + " shard(s) identified within "
                    + widest.string() + "ms of each other"
                )

                h'.assert_eq[USize](
                    16,
                    at.size(),
                    "every shard should get a slot"
                )

                h'.assert_true(
                    widest < 2_000,
                    "with a concurrency of 16 every shard should identify at "
                    + "once, but the set took " + widest.string() + "ms"
                )
            }
        )

    fun timed_out(h: TestHelper) => h.fail("the gate never handed out its slots")

class iso _StressIdentifyGateSerial is UnitTest
    fun name(): String => "stress/shard/identify_gate_serial"

    fun exclusion_group(): String => "gate"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let shards: USize = 4
        let timers = time.Timers
        let gate = _GatewayIdentifyGate(timers, 1)
        let watch = _Grants(h, shards, timers)

        var index: USize = 0

        while index < shards do
            gate.request(index, _Applicant(index, watch))
            index = index + 1
        end

        watch.settle(
            { (h': TestHelper, at: Array[(USize, U64)] val) =>
                h'.assert_eq[USize](
                    4,
                    at.size(),
                    "every shard should get a slot even when they queue"
                )

                try
                    var index': USize = 0

                    while index' < at.size() do
                        (let shard, let when) = at(index')?

                        h'.log(
                            "shard " + shard.string() + " identified at "
                            + when.string() + "ms"
                        )

                        h'.assert_eq[USize](
                            index',
                            shard,
                            "the gate handed out slots out of order"
                        )

                        if index' > 0 then
                            (let _, let previous) = at(index' - 1)?
                            let gap = when - previous

                            h'.assert_true(
                                gap >= 4_800,
                                "shards " + (index' - 1).string() + " and "
                                + shard.string() + " identified "
                                + gap.string() + "ms apart, inside the 5s the "
                                + "gateway allows"
                            )
                        end

                        index' = index' + 1
                    end
                end
            }
        )

    fun timed_out(h: TestHelper) => h.fail("the gate never handed out its slots")

class iso _StressIdentifyGateBudget is UnitTest
    fun name(): String => "stress/shard/identify_gate_budget"

    fun exclusion_group(): String => "gate"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(30))

        let shards: USize = 4
        let timers = time.Timers
        let gate = _GatewayIdentifyGate(timers, shards)
        let watch = _Grants(h, shards, timers)

        gate.set_session_limit(2, 4, 3_000)

        var index: USize = 0

        while index < shards do
            gate.request(index, _Applicant(index, watch))
            index = index + 1
        end

        watch.settle(
            { (h': TestHelper, at: Array[(USize, U64)] val) =>
                h'.assert_eq[USize](
                    4,
                    at.size(),
                    "every shard should identify once the limit resets"
                )

                try
                    var index': USize = 0

                    while index' < at.size() do
                        (let shard, let when) = at(index')?

                        h'.log(
                            "shard " + shard.string() + " identified at "
                            + when.string() + "ms"
                        )

                        if index' < 2 then
                            h'.assert_true(
                                when < 1_000,
                                "shard " + shard.string() + " waited "
                                + when.string() + "ms even though the limit "
                                + "had a session start to spare"
                            )
                        else
                            h'.assert_true(
                                when >= 2_800,
                                "shard " + shard.string() + " identified at "
                                + when.string() + "ms, spending a session "
                                + "start the limit did not have"
                            )
                        end

                        index' = index' + 1
                    end
                end
            }
        )

    fun timed_out(h: TestHelper) =>
        h.fail("the gate never handed out its slots")

type _Verdict is {(TestHelper, Array[(USize, U64)] val)} val

actor _Applicant is _WantsIdentify
    let _shard: USize
    let _watch: _Grants

    new create(shard: USize, watch: _Grants) =>
        _shard = shard
        _watch = watch

    be _identify_granted() => _watch.granted(_shard)

actor _Grants
    let _h: TestHelper
    let _wanted: USize
    let _timers: time.Timers
    let _started: U64 = time.Time.nanos()

    embed _at: Array[(USize, U64)] = Array[(USize, U64)]

    var _verdict: (_Verdict | None) = None
    var _rounds: USize = 0
    var _done: Bool = false

    new create(h: TestHelper, wanted: USize, timers: time.Timers) =>
        _h = h
        _wanted = wanted
        _timers = timers

    be granted(shard: USize) =>
        _at.push((shard, (time.Time.nanos() - _started) / 1_000_000))

    be settle(verdict: _Verdict) =>
        _verdict = verdict
        _poll()

    be _poll() =>
        if _done then return end

        _rounds = _rounds + 1

        if (_at.size() < _wanted) and (_rounds < 240) then
            let self: _Grants tag = this

            _timers(
                time.Timer(
                    _Elapsed({() => self._poll()}),
                    time.Nanos.from_millis(250)
                )
            )

            return
        end

        _done = true

        var copy = recover iso Array[(USize, U64)] end
        for entry in _at.values() do copy.push(entry) end

        match _verdict
        | let verdict: _Verdict => verdict(_h, consume copy)
        end

        _timers.dispose()

        _h.complete(true)

class iso _LiveSharding is UnitTest
    fun name(): String => "live/stress/sharding"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) =>
        match _Live.token(h.env)
        | let token: String =>
            h.long_test(time.Nanos.from_seconds(150))
            _LiveShards(h, token, GatewayShardSet(2), 2).start()
        else
            h.log("skipped: DISCORD_TOKEN is not set")
        end

    fun timed_out(h: TestHelper) => h.fail("the shards never all came up")

class iso _LiveUnsharded is UnitTest
    fun name(): String => "live/unsharded_api"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) =>
        match _Live.token(h.env)
        | let token: String =>
            h.long_test(time.Nanos.from_seconds(90))
            _LiveShards(h, token, None, 1).start()
        else
            h.log("skipped: DISCORD_TOKEN is not set")
        end

    fun timed_out(h: TestHelper) => h.fail("the connection never came ready")

class iso _LiveShardsAutomatic is UnitTest
    fun name(): String => "live/stress/sharding_automatic"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) =>
        match _Live.token(h.env)
        | let token: String =>
            h.long_test(time.Nanos.from_seconds(120))
            _LiveShards(h, token, GatewayShardsAutomatic, 1).start()
        else
            h.log("skipped: DISCORD_TOKEN is not set")
        end

    fun timed_out(h: TestHelper) => h.fail("the shards never all came up")

class iso _LiveShardSubset is UnitTest
    fun name(): String => "live/stress/sharding_subset"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) =>
        match _Live.token(h.env)
        | let token: String =>
            h.long_test(time.Nanos.from_seconds(120))
            _LiveShards(h, token, GatewayShardSet(2, [1]), 1, Snowflake(0))
                .start()
        else
            h.log("skipped: DISCORD_TOKEN is not set")
        end

    fun timed_out(h: TestHelper) => h.fail("the shard never came up")

actor _LiveShards
    let _h: TestHelper
    let _count: USize
    let _sharding: GatewaySharding
    let _probe: (Snowflake | None)
    let _rest: rest.Rest
    let _api: GatewayApi
    let _timers: time.Timers = time.Timers
    let _started: U64 = time.Time.nanos()

    embed _ready_at: Array[(USize, U64)] = Array[(USize, U64)]
    embed _guilds: Array[Snowflake] = Array[Snowflake]

    var _user: (Snowflake | None) = None
    var _guild_creates: USize = 0
    var _chunks: USize = 0
    var _closes: USize = 0
    var _unroutable: USize = 0
    var _probed: Bool = false
    var _elapsed: U64 = 0
    var _done: Bool = false

    new create(
        h: TestHelper,
        token: String,
        sharding: GatewaySharding,
        count: USize,
        probe: (Snowflake | None) = None
    ) =>
        _h = h
        _count = count
        _sharding = sharding
        _probe = probe
        _rest = rest.Rest(h.env, rest.RestOptions(token))

        let self: _LiveShards tag = this

        _api = GatewayApi(
            h.env,
            GatewayOptions(
                token,
                _Live.intents()
                where
                on_error' = { (err: GatewayError) => self.trouble(err) },
                sharding' = sharding
            ),
            _rest.routes
        )

    be start() =>
        let self: _LiveShards tag = this
        let events = Events(_api)

        events.on_ready(
            { (ready: GatewayReady) =>
                self.ready(
                    match ready.shard
                    | (let id: USize, let _: USize) => id
                    else
                        0
                    end,
                    ready.user.id
                )
            }
        )

        events.on_guild_create(
            { (guild: (GuildCreate | UnavailableGuild)) =>
                match guild
                | let available: GuildCreate => self.guild(available.guild.id)
                | let unavailable: UnavailableGuild => self.guild(unavailable.id)
                end
            }
        )

        events.on_guild_members_chunk(
            { (chunk: GuildMembersChunk) => self.chunk() }
        )

        _api._listen(events)
        _tick_later()

    be ready(shard: USize, user: Snowflake) =>
        let at = (time.Time.nanos() - _started) / 1_000_000

        _user = user
        _ready_at.push((shard, at))
        _h.log("shard " + shard.string() + " ready at " + at.string() + "ms")

    be guild(id: Snowflake) =>
        _guild_creates = _guild_creates + 1

        for known in _guilds.values() do
            if known == id then return end
        end

        _guilds.push(id)

    be chunk() => _chunks = _chunks + 1

    be trouble(err: GatewayError) =>
        _h.log("on_error: " + err.reason)

        if err.reason.contains("closed the connection") then
            _closes = _closes + 1
        elseif err.reason.contains("not running in this process") then
            _unroutable = _unroutable + 1
        end

    be tick() =>
        if _done then return end

        _elapsed = _elapsed + 1

        if (not _probed) and (_ready_at.size() >= _count) then
            match (_target(), _user)
            | (let target: Snowflake, let user: Snowflake) =>
                _probed = true
                _h.log("probing with guild " + target.string())
                _api.send_message(
                    GatewayRequestGuildMembersEvent(
                        target where user_ids' = user, nonce' = "routed"
                    )
                )
            end
        end

        if
            ((_ready_at.size() >= _count) and _probed and (_elapsed >= 20))
                or (_elapsed >= 110)
        then
            _finish()
            return
        end

        _tick_later()

    fun _target(): (Snowflake | None) =>
        match _probe
        | let explicit: Snowflake => explicit
        else
            try _guilds(0)? end
        end

    fun _total(): USize =>
        match _sharding
        | let set: GatewayShardSet => set.count
        else
            _count
        end

    fun ref _tick_later() =>
        let self: _LiveShards tag = this

        _timers(
            time.Timer(
                _Elapsed({() => self.tick()}),
                time.Nanos.from_seconds(1)
            )
        )

    fun ref _finish() =>
        if _done then return end

        _done = true

        _report()

        _api.dispose()
        _rest.dispose()
        _timers.dispose()

        _h.complete(true)

    fun _report() =>
        _h.assert_eq[USize](
            _count,
            _ready_at.size(),
            "every shard here should have identified exactly once"
        )

        match _sharding
        | let set: GatewayShardSet =>
            for wanted in set.ids.values() do
                var up = false

                for (shard, _) in _ready_at.values() do
                    if shard == wanted then up = true end
                end

                h_assert(up, "shard " + wanted.string() + " never came ready")
            end
        end

        if _count > 1 then
            try
                (let _, let first) = _ready_at(0)?
                (let _, let second) = _ready_at(1)?
                let gap = second - first

                _h.log("the shards identified " + gap.string() + "ms apart")

                _h.assert_true(
                    gap >= 4_000,
                    "the shards identified " + gap.string()
                    + "ms apart, inside the 5s the gateway allows at a "
                    + "max_concurrency of 1"
                )
            end
        end

        _h.assert_eq[USize](0, _closes, "the gateway closed on a shard")

        _verdict()

    fun h_assert(condition: Bool, reason: String) =>
        _h.assert_true(condition, reason)

    fun _verdict() =>
        let owner =
            match _target()
            | let target: Snowflake => GatewayShardFor(target, _total())
            else
                return
            end

        var running = false

        for (shard, _) in _ready_at.values() do
            if shard == owner then running = true end
        end

        _h.log(
            "the probe guild belongs to shard " + owner.string() + " of "
            + _total().string() + ", which is "
            + (if running then "running here" else "running elsewhere" end)
            + ": " + _chunks.string() + " chunk(s) back, "
            + _unroutable.string() + " unroutable report(s), "
            + _guild_creates.string() + " guild create(s)"
        )

        if running then
            _h.assert_true(
                _chunks >= 1,
                "the routed request never came back, so it did not reach the "
                + "shard that owns the guild"
            )
            _h.assert_eq[USize](
                0,
                _unroutable,
                "an event was called unroutable even though its shard is up"
            )
        else
            _h.assert_eq[USize](
                0,
                _chunks,
                "a shard that does not own the guild answered for it"
            )
            _h.assert_true(
                _unroutable >= 1,
                "an event for a shard running elsewhere was dropped without "
                + "saying so"
            )
        end
