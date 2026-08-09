use "../data"
use "pony_test"
use rest = "../rest"
use time = "time"

primitive _Live
    fun token(env: Env): (String | None) =>
        for entry in env.vars.values() do
            if entry.at("DISCORD_TOKEN=", 0) then
                let value = entry.substring(14)

                if value.size() > 0 then return consume value end
            end
        end

    fun intents(): Array[GatewayIntent] val =>
        [
            GatewayIntentGuilds
            GatewayIntentGuildMessages
            GatewayIntentGuildMessageReactions
            GatewayIntentGuildVoiceStates
            GatewayIntentDirectMessages
        ]

    fun run(h: TestHelper, plan: String, budget: U64) =>
        match token(h.env)
        | let token': String =>
            h.long_test(time.Nanos.from_seconds(budget + 60))
            _LiveSession(h, plan, budget, token').start()
        else
            h.log("skipped: DISCORD_TOKEN is not set")
        end

class iso _LiveConnect is UnitTest
    fun name(): String => "live/connect"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "connect", 30)

    fun timed_out(h: TestHelper) => h.fail("the gateway never reached ready")

class iso _LiveHeartbeat is UnitTest
    fun name(): String => "live/heartbeat"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "heartbeat", 95)

    fun timed_out(h: TestHelper) => h.fail("the heartbeat run never finished")

class iso _LiveResume is UnitTest
    fun name(): String => "live/resume"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "resume", 85)

    fun timed_out(h: TestHelper) => h.fail("the resume run never finished")

class iso _LiveMembers is UnitTest
    fun name(): String => "live/members"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "members", 40)

    fun timed_out(h: TestHelper) => h.fail("the member request never came back")

class iso _LiveCommandBudget is UnitTest
    fun name(): String => "live/command_budget"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "commands", 150)

    fun timed_out(h: TestHelper) => h.fail("the command burst never drained")

class iso _LiveOversize is UnitTest
    fun name(): String => "live/oversize"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "oversize", 40)

    fun timed_out(h: TestHelper) => h.fail("the oversize run never finished")

class iso _LiveSustained is UnitTest
    fun name(): String => "live/stress/sustained"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "sustained", 420)

    fun timed_out(h: TestHelper) => h.fail("the sustained run never drained")

class iso _LiveResumeChurn is UnitTest
    fun name(): String => "live/stress/resume_churn"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "churn", 260)

    fun timed_out(h: TestHelper) => h.fail("the churn run never finished")

class iso _LivePresenceChurn is UnitTest
    fun name(): String => "live/stress/presence_churn"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "presences", 260)

    fun timed_out(h: TestHelper) => h.fail("the presence run never finished")

class iso _LiveQueueOverflow is UnitTest
    fun name(): String => "live/stress/queue_overflow"

    fun exclusion_group(): String => "live"

    fun apply(h: TestHelper) => _Live.run(h, "overflow", 180)

    fun timed_out(h: TestHelper) => h.fail("the overflow run never finished")

actor _LiveSession
    let _h: TestHelper
    let _plan: String
    let _budget: U64
    let _rest: rest.Rest
    let _idle: GatewayApi
    let _connection: _GatewayConnection
    let _timers: time.Timers = time.Timers

    embed _errors: Array[String] = Array[String]
    embed _guilds: Array[Snowflake] = Array[Snowflake]

    var _user: (Snowflake | None) = None
    var _readies: USize = 0
    var _resumes: USize = 0
    var _chunks: USize = 0
    var _members: USize = 0
    var _nesting_drops: USize = 0
    var _oversize_drops: USize = 0
    var _overflows: USize = 0
    var _recoveries: USize = 0
    var _heartbeat_drops: USize = 0
    var _closes: USize = 0
    var _sent: USize = 0
    var _forced: USize = 0
    var _elapsed: U64 = 0
    var _ready_at: U64 = 0
    var _first_chunk_at: U64 = 0
    var _last_chunk_at: U64 = 0
    var _quiet_gap: U64 = 0
    var _longest_gap: U64 = 0
    var _is_ready: Bool = false
    var _saw_chunk: Bool = false
    var _fired: Bool = false
    var _done: Bool = false

    new create(h: TestHelper, plan: String, budget: U64, token: String) =>
        _h = h
        _plan = plan
        _budget = budget
        _rest = rest.Rest(h.env, rest.RestOptions(token))

        let self: _LiveSession tag = this
        let options = GatewayOptions(
            token,
            _Live.intents()
            where on_error' = { (err: GatewayError) => self.trouble(err) }
        )

        _idle = GatewayApi(h.env, options, _rest.routes)
        _connection = _GatewayConnection(h.env, options, _rest.routes)

    be start() =>
        let self: _LiveSession tag = this
        let events = Events(_idle)

        events.on_ready(
            { (ready: GatewayReady) =>
                self.ready(ready.user.id, ready.session_id, ready.guilds.size())
            }
        )

        events.on_resumed({ () => self.resumed() })

        events.on_guild_create(
            { (guild: (GuildCreate | UnavailableGuild)) =>
                match guild
                | let available: GuildCreate => self.guild(available.guild.id)
                | let unavailable: UnavailableGuild => self.guild(unavailable.id)
                end
            }
        )

        events.on_guild_members_chunk(
            { (chunk: GuildMembersChunk) => self.chunk(chunk.members.size()) }
        )

        _connection._listen(events)
        _tick_later()

    be ready(user: Snowflake, session: String, guilds: USize) =>
        _readies = _readies + 1
        _user = user

        if not _is_ready then
            _is_ready = true
            _ready_at = _elapsed
        end

        _h.log(
            "ready after " + _elapsed.string() + "s on session " + session
            + " with " + guilds.string() + " guild(s)"
        )

    be resumed() =>
        _resumes = _resumes + 1

    be guild(id: Snowflake) =>
        for known in _guilds.values() do
            if known == id then return end
        end

        _guilds.push(id)

    be chunk(members: USize) =>
        _chunks = _chunks + 1
        _members = _members + members

        if not _saw_chunk then
            _saw_chunk = true
            _first_chunk_at = _elapsed
        end

        _last_chunk_at = _elapsed
        _quiet_gap = 0

    be trouble(err: GatewayError) =>
        if err.reason.contains("nests deeper") then
            _nesting_drops = _nesting_drops + 1
        elseif err.reason.contains("over the gateway limit") then
            _oversize_drops = _oversize_drops + 1
        elseif err.reason.contains("queue is full") then
            _overflows = _overflows + 1
            _errors.push(err.reason)
        elseif err.reason.contains("caught up") then
            _recoveries = _recoveries + 1
            _errors.push(err.reason)
        elseif err.reason.contains("heartbeat was dropped") then
            _heartbeat_drops = _heartbeat_drops + 1
        elseif err.reason.contains("closed the connection") then
            _closes = _closes + 1
            _errors.push(err.reason)
        else
            _errors.push(err.reason)
        end

    be tick() =>
        if _done then return end

        _elapsed = _elapsed + 1

        if _fired and (_chunks > 0) and (_chunks < _sent) then
            _quiet_gap = _quiet_gap + 1
            _longest_gap = _longest_gap.max(_quiet_gap)
        end

        match _plan
        | "connect" => if _is_ready then _finish() end
        | "resume" => _drive_forced_drops(3, 6, 20)
        | "churn" => _drive_forced_drops(15, 4, 15)
        | "members" => _drive_members()
        | "commands" => _drive_burst(8, 130)
        | "sustained" => _drive_burst(0, 700)
        | "presences" => _drive_burst(60, 0)
        | "overflow" => _drive_burst(0, 1_500)
        | "oversize" => _drive_oversize()
        end

        if (not _done) and (_elapsed >= _budget) then _finish() end
        if not _done then _tick_later() end

    fun ref _drive_forced_drops(total: USize, first: U64, gap: U64) =>
        if
            _is_ready
                and (_forced < total)
                and (_elapsed >= (_ready_at + first + (_forced.u64() * gap)))
        then
            _forced = _forced + 1
            _connection._heartbeat_timed_out()
        end

    fun ref _drive_members() =>
        if (not _fired) and _is_ready and (_guilds.size() > 0) then
            match _user
            | let user: Snowflake =>
                _fired = true

                try
                    _connection._send_message(
                        GatewayRequestGuildMembersEvent(
                            _guilds(0)?
                            where user_ids' = user, nonce' = "members"
                        )
                    )
                    _sent = _sent + 1
                end
            end
        end

    fun ref _drive_oversize() =>
        if (not _fired) and _is_ready then
            _fired = true
            _connection._send_message(_Fat(GatewayOpcodeRequestGuildMembers, 0))
        end

    fun ref _drive_burst(presences: USize, requests: USize) =>
        if _fired or (not _is_ready) then return end

        if (requests > 0) and (_guilds.size() == 0) then return end

        _fired = true

        var index: USize = 0

        while index < presences do
            _connection._send_message(
                GatewayPresenceUpdateEvent(
                    GatewayPresenceUpdate(
                        None,
                        [ Activity(where
                            name' = "stress " + index.string(),
                            type'' = ListeningActivityType) ],
                        OnlineStatusType,
                        false
                    )
                )
            )

            _sent = _sent + 1
            index = index + 1
        end

        index = 0

        while index < requests do
            try
                _connection._send_message(
                    GatewayRequestGuildMembersEvent(
                        _guilds(0)?
                        where user_ids' = _user as Snowflake,
                        nonce' = index.string()
                    )
                )

                _sent = _sent + 1
            end

            index = index + 1
        end

        _h.log(
            _sent.string() + " command(s) handed to the bucket at "
            + _elapsed.string() + "s"
        )

    fun ref _tick_later() =>
        let self: _LiveSession tag = this

        _timers(
            time.Timer(
                _OnceElapsed({() => self.tick()}),
                time.Nanos.from_seconds(1)
            )
        )

    fun ref _finish() =>
        if _done then return end

        _done = true

        _report()

        _connection.dispose()
        _idle.dispose()
        _rest.dispose()
        _timers.dispose()

        _h.complete(true)

    fun _report() =>
        for reason in _errors.values() do _h.log("on_error: " + reason) end

        _h.assert_eq[USize](
            0,
            _nesting_drops,
            "the nesting guard turned away traffic the gateway really sent"
        )

        match _plan
        | "connect" =>
            _h.assert_eq[USize](1, _readies, "the gateway did not come ready once")
            _h.assert_eq[USize](0, _closes, "the gateway closed on us")
        | "heartbeat" =>
            _h.log(
                _elapsed.string() + "s up, " + _readies.string() + " ready(s), "
                + _resumes.string() + " resume(s)"
            )
            _h.assert_eq[USize](
                1,
                _readies,
                "the connection was re-identified, so a heartbeat was missed"
            )
            _h.assert_eq[USize](
                0,
                _resumes,
                "the connection dropped and resumed inside two heartbeats"
            )
            _h.assert_eq[USize](0, _closes, "the gateway closed on us")
        | "resume" => _report_drops(3)
        | "churn" => _report_drops(15)
        | "members" =>
            _h.log(
                _chunks.string() + " chunk(s) carrying " + _members.string()
                + " member(s)"
            )
            _h.assert_true(_chunks >= 1, "no member chunk came back")
            _h.assert_true(_members >= 1, "the chunk carried no members")
        | "commands" => _report_burst(130, 45)
        | "sustained" => _report_burst(700, 240)
        | "presences" =>
            _h.log(
                _sent.string() + " presence update(s) sent over "
                + _elapsed.string() + "s"
            )
            _h.assert_eq[USize](
                0,
                _closes,
                "the gateway closed on us, so the presence window was overrun"
            )
            _h.assert_eq[USize](1, _readies, "the connection was rebuilt")
        | "overflow" =>
            _h.log(
                _sent.string() + " command(s) queued against a cap of "
                + GatewayConstants.max_queued_events().string() + ", "
                + _chunks.string() + " chunk(s) back, " + _overflows.string()
                + " overflow report(s), " + _recoveries.string()
                + " recovery report(s)"
            )
            _h.assert_eq[USize](
                1,
                _overflows,
                "the queue cap should announce itself once, not once per drop"
            )
            _h.assert_true(_chunks > 0, "the queue never drained on the wire")
            _h.assert_eq[USize](
                0,
                _closes,
                "the gateway closed on us while the queue was overflowing"
            )
            _h.assert_eq[USize](1, _readies, "the connection was rebuilt")
        | "oversize" =>
            _h.assert_eq[USize](
                1,
                _oversize_drops,
                "the oversize payload was not turned away before the wire"
            )
            _h.assert_eq[USize](
                0,
                _closes,
                "the gateway closed on us over an oversize payload"
            )
            _h.assert_eq[USize](1, _readies, "the connection was rebuilt")
        end

    fun _report_drops(total: USize) =>
        _h.log(
            _forced.string() + " forced drop(s), " + _resumes.string()
            + " resume(s), " + _readies.string() + " ready(s), "
            + _closes.string() + " close(s)"
        )

        _h.assert_eq[USize](total, _forced, "the run did not force every drop")
        _h.assert_eq[USize](
            total,
            _resumes,
            "a forced drop did not come back as a resume"
        )
        _h.assert_eq[USize](
            1,
            _readies,
            "the session was thrown away and identified afresh, which spends a "
            + "session start the resume was meant to save"
        )

    fun _report_burst(requests: USize, spread: U64) =>
        let width = _last_chunk_at - _first_chunk_at

        _h.log(
            _sent.string() + " command(s) sent, " + _chunks.string()
            + " chunk(s) back, spread over " + width.string() + "s from "
            + _first_chunk_at.string() + "s to " + _last_chunk_at.string()
            + "s, longest quiet gap " + _longest_gap.string() + "s"
        )

        _h.assert_eq[USize](
            0,
            _closes,
            "the gateway closed on us, so the command budget was overrun"
        )
        _h.assert_eq[USize](
            1,
            _readies,
            "the connection was rebuilt during the burst"
        )
        _h.assert_eq[USize](
            0,
            _heartbeat_drops,
            "a heartbeat was dropped, so the burst ate into the reserve"
        )
        _h.assert_true(
            _chunks >= ((requests * 95) / 100),
            "only " + _chunks.string() + " of " + requests.string()
            + " request(s) came back"
        )
        _h.assert_true(
            width >= spread,
            "the burst came back in " + width.string()
            + "s, so it was never paced against the 120 per 60s budget"
        )
