use "../data"
use "pony_test"
use collections = "collections"
use json = "json"
use random = "random"
use rest = "../rest"
use time = "time"

actor Main is TestList
    new create(env: Env) => PonyTest(env, this)

    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_StressWindowSafety)
        test(_StressWindowAgainstModel)
        test(_StressQueue)
        test(_StressBucketBurst)
        test(_StressBucketOrdering)
        test(_StressBucketPresences)
        test(_StressBucketHeartbeatBypass)
        test(_StressBucketIdentifyConcurrency)
        test(_StressConnectionQueueCap)
        test(_StressDispatchNameScan)
        test(_StressDispatchSubscriptions)
        test(_StressDispatchRegistry)
        test(_StressReceiveNesting)
        test(_StressReceiveStall)
        test(_StressShardFormula)
        test(_StressShardSet)
        test(_StressIdentifyGateConcurrent)
        test(_StressIdentifyGateSerial)
        test(_StressIdentifyGateBudget)
        test(_StressRouteGuild)
        test(_StressRouteBroadcast)
        test(_StressRouteSoundboard)
        test(_LiveConnect)
        test(_LiveHeartbeat)
        test(_LiveResume)
        test(_LiveMembers)
        test(_LiveCommandBudget)
        test(_LiveOversize)
        test(_LiveSustained)
        test(_LiveResumeChurn)
        test(_LivePresenceChurn)
        test(_LiveQueueOverflow)
        test(_LiveSharding)
        test(_LiveUnsharded)
        test(_LiveShardsAutomatic)
        test(_LiveShardSubset)

class val _Fat is GatewaySendableEvent
    let _opcode: GatewayOpcode
    let _query: String

    new val create(opcode': GatewayOpcode, index: USize) =>
        _opcode = opcode'

        let bare = GatewayEventPayload(
            opcode', json.JsonObject.update("q", "")
        ).to_json().print().size()

        _query = recover val
            String.from_array(
                recover val Array[U8].init('a', (4097 + index) - bare) end
            )
        end

    fun opcode(): GatewayOpcode => _opcode

    fun data(): json.JsonValue => json.JsonObject.update("q", _query)

type _Judge is {(TestHelper, Array[USize] val)} val

primitive _Stress
    fun connection(
        h: TestHelper,
        on_error: GatewayErrorHandler
    ): (_GatewayConnection, rest.RestApi) =>
        let client = rest.Rest(h.env, rest.RestOptions("stress"))

        (
            _GatewayConnection(
                h.env,
                GatewayOptions("stress", [] where on_error' = on_error),
                client.routes
            ),
            client.api
        )

    fun open(bucket: _GatewayBucket) =>
        bucket.handshake(GatewayResumeEvent("stress", "session", 1))

    fun index_of(err: GatewayError): (USize | None) =>
        let parts = err.reason.split(" ")

        try
            if parts(0)? != "an" then return None end

            parts(4)?.usize()? - 4097
        end

    fun ordering(h: TestHelper, seen: Array[USize] val) =>
        var index: USize = 1
        var ordered = true
        var duplicated = false

        try
            while index < seen.size() do
                let previous = seen(index - 1)?
                let current = seen(index)?

                if current == previous then duplicated = true end
                if current < previous then ordered = false end

                index = index + 1
            end
        end

        h.assert_true(ordered, "events came out in a different order than they went in")
        h.assert_false(duplicated, "an event came out twice")

class iso _StressWindowSafety is UnitTest
    fun name(): String => "stress/rate_limit/safety"

    fun apply(h: TestHelper) ? =>
        let cases: Array[(USize, USize, USize)] = [
            (120, 60 * 1000, 0)
            (120, 60 * 1000, 5)
            (5, 20 * 1000, 0)
            (1, 5 * 1000, 0)
            (16, 5 * 1000, 0)
            (2, 1000, 1)
        ]

        for (max_count, duration_ms, reserved) in cases.values() do
            let duration = time.Nanos.from_millis(duration_ms.u64())
            let capacity = max_count - reserved.min(max_count)
            let window = _RateLimitWindow(max_count, duration_ms)
            let rand = random.Rand(0x5eed, max_count.u64())
            let sent = Array[U64]

            var now: U64 = 0
            var spends: USize = 0

            while spends < 100_000 do
                match window.blocked_until(now, reserved)
                | let at: U64 =>
                    h.assert_true(
                        at > now,
                        "the window asked us to wait until a time that has passed"
                    )
                    now = at
                else
                    window.spend(now)
                    sent.push(now)
                    spends = spends + 1
                    now = now + rand.int(duration / 40).u64()
                end
            end

            var index = capacity

            while index < sent.size() do
                let elapsed = sent(index)? - sent(index - capacity)?

                h.assert_true(
                    elapsed >= duration,
                    "with max_count " + max_count.string() + " and reserved "
                    + reserved.string() + ", sends " + (index - capacity).string()
                    + " and " + index.string() + " are only " + elapsed.string()
                    + "ns apart, inside the " + duration.string() + "ns window"
                )

                index = index + 1
            end
        end

class iso _StressWindowAgainstModel is UnitTest
    fun name(): String => "stress/rate_limit/model"

    fun apply(h: TestHelper) ? =>
        let max_count: USize = 120
        let duration_ms: USize = 60 * 1000
        let duration = time.Nanos.from_millis(duration_ms.u64())
        let window = _RateLimitWindow(max_count, duration_ms)
        let rand = random.Rand(0xd15c, 0x0d)
        let sent = Array[U64]

        var now: U64 = 0
        var step: USize = 0
        var blocks: USize = 0

        while step < 250_000 do
            let reserved = rand.int(8).usize()
            let capacity = max_count - reserved.min(max_count)

            let expected =
                if capacity == 0 then
                    true
                else
                    var in_window: USize = 0
                    var index = sent.size()

                    while (index > 0) and (in_window < capacity) do
                        index = index - 1

                        if (sent(index)? + duration) > now then
                            in_window = in_window + 1
                        else
                            break
                        end
                    end

                    in_window >= capacity
                end

            let actual =
                match window.blocked_until(now, reserved)
                | let _: U64 => true
                else
                    false
                end

            h.assert_eq[Bool](
                expected,
                actual,
                "at t=" + now.string() + " with reserved " + reserved.string()
                + " after " + sent.size().string() + " send(s)"
            )

            if actual then
                blocks = blocks + 1
            else
                window.spend(now)
                sent.push(now)
            end

            now = now + rand.int(duration / 400).u64()
            step = step + 1
        end

        h.log(
            step.string() + " probe(s), " + sent.size().string() + " spend(s), "
            + blocks.string() + " block(s)"
        )

class iso _StressQueue is UnitTest
    fun name(): String => "stress/queue"

    fun apply(h: TestHelper) ? =>
        let queue = collections.List[GatewaySendableEvent]
        let rand = random.Rand(0xfeed, 0xbeef)

        var pushed: USize = 0
        var popped: USize = 0
        var round: USize = 0

        while round < 2_000 do
            let batch = rand.int(200).usize()
            var index: USize = 0

            while index < batch do
                queue.push(GatewayHeartbeatEvent(pushed))
                pushed = pushed + 1
                index = index + 1
            end

            h.assert_eq[USize](pushed - popped, queue.size())

            let take = rand.int((batch + 1).u64()).usize()
            index = 0

            while (index < take) and (queue.size() > 0) do
                let event = queue.shift()?

                if (rand.int(4) == 0) and (queue.size() > 0) then
                    queue.unshift(consume event)
                else
                    popped = popped + 1
                end

                index = index + 1
            end

            round = round + 1
        end

        h.assert_eq[USize](pushed - popped, queue.size())
        h.log(pushed.string() + " event(s) through the queue")

        queue.clear()

        h.assert_eq[USize](0, queue.size())

class iso _StressBucketBurst is UnitTest
    fun name(): String => "stress/bucket/burst"

    fun exclusion_group(): String => "bucket"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let flood: USize = 300
        let observer = _Releases(
            h,
            { (h': TestHelper, seen: Array[USize] val) =>
                h'.log(
                    seen.size().string() + " of " + flood.string()
                    + " event(s) went out in the opening burst"
                )

                _Stress.ordering(h', seen)

                h'.assert_true(
                    seen.size() <= 120,
                    "the opening burst must stop at the command budget, but "
                    + seen.size().string() + " event(s) went out"
                )

                h'.assert_true(
                    seen.size() >= 100,
                    "the opening burst must use the budget it has, but only "
                    + seen.size().string() + " event(s) went out"
                )
            }
        )

        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => observer.saw(err) }
        )
        let timers = time.Timers
        let bucket = _GatewayBucket(connection, timers)

        var index: USize = 0

        while index < flood do
            bucket.enqueue(_Fat(GatewayOpcodeRequestGuildMembers, index))
            index = index + 1
        end

        _Stress.open(bucket)

        observer.settle(bucket, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the bucket never went quiet")

class iso _StressBucketOrdering is UnitTest
    fun name(): String => "stress/bucket/ordering"

    fun exclusion_group(): String => "bucket"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let flood: USize = 200
        let observer = _Releases(
            h,
            { (h': TestHelper, seen: Array[USize] val) =>
                h'.log(
                    seen.size().string() + " of " + flood.string()
                    + " event(s) survived the throttle storm"
                )

                _Stress.ordering(h', seen)

                h'.assert_true(
                    seen.size() > 0,
                    "the bucket stalled for good after being unthrottled"
                )
            }
        )

        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => observer.saw(err) }
        )
        let timers = time.Timers
        let bucket = _GatewayBucket(connection, timers)

        _Stress.open(bucket)

        var index: USize = 0

        while index < flood do
            bucket.enqueue(_Fat(GatewayOpcodeRequestGuildMembers, index))

            if (index % 7) == 0 then bucket.throttle() end
            if (index % 7) == 3 then bucket.unthrottle() end

            index = index + 1
        end

        bucket.unthrottle()

        observer.settle(bucket, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the bucket never went quiet")

class iso _StressBucketPresences is UnitTest
    fun name(): String => "stress/bucket/presences"

    fun exclusion_group(): String => "bucket"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let observer = _Releases(
            h,
            { (h': TestHelper, seen: Array[USize] val) =>
                h'.log(
                    seen.size().string()
                    + " presence update(s) went out in the first burst"
                )

                _Stress.ordering(h', seen)

                h'.assert_eq[USize](
                    5,
                    seen.size(),
                    "the presence window is 5 per 20s"
                )
            }
        )

        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => observer.saw(err) }
        )
        let timers = time.Timers
        let bucket = _GatewayBucket(connection, timers)

        _Stress.open(bucket)

        var index: USize = 0

        while index < 40 do
            bucket.enqueue(_Fat(GatewayOpcodePresenceUpdate, index))
            index = index + 1
        end

        observer.settle(bucket, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the bucket never went quiet")

class iso _StressBucketHeartbeatBypass is UnitTest
    fun name(): String => "stress/bucket/heartbeat_bypass"

    fun exclusion_group(): String => "bucket"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let beats: USize = 400
        let marker: USize = 100_000
        let observer = _Releases(
            h,
            { (h': TestHelper, seen: Array[USize] val) =>
                var sent_beats: USize = 0
                var queued_went_out = false

                for index in seen.values() do
                    if index == marker then
                        queued_went_out = true
                    else
                        sent_beats = sent_beats + 1
                    end
                end

                h'.log(
                    sent_beats.string() + " of " + beats.string()
                    + " requested heartbeat(s) went on the wire"
                )

                h'.assert_true(
                    sent_beats <= 120,
                    "heartbeats must not walk the client past the 120 per 60s "
                    + "command budget, but " + sent_beats.string() + " went out"
                )

                h'.assert_true(
                    queued_went_out,
                    "heartbeats must leave room for the queue, but the one "
                    + "queued command never went out"
                )
            }
        )

        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => observer.saw(err) }
        )
        let timers = time.Timers
        let bucket = _GatewayBucket(connection, timers)

        _Stress.open(bucket)

        var index: USize = 0

        while index < beats do
            bucket.heartbeat(_Fat(GatewayOpcodeHeartbeat, index))
            index = index + 1
        end

        bucket.enqueue(_Fat(GatewayOpcodeRequestGuildMembers, marker))

        observer.settle(bucket, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the bucket never went quiet")

class iso _StressBucketIdentifyConcurrency is UnitTest
    fun name(): String => "stress/bucket/identify_concurrency"

    fun exclusion_group(): String => "bucket"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(60))

        let observer = _Releases(
            h,
            { (h': TestHelper, seen: Array[USize] val) =>
                h'.log(
                    seen.size().string()
                    + " identify(s) went out back to back across a concurrency "
                    + "change"
                )

                h'.assert_true(
                    seen.size() <= 2,
                    "lowering the concurrency must not forget the identifies "
                    + "already spent, but " + seen.size().string()
                    + " went out inside 5s"
                )
            }
        )

        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => observer.saw(err) }
        )
        let timers = time.Timers
        let bucket = _GatewayBucket(connection, timers)

        bucket.set_identify_concurrency(2)
        bucket.handshake(_Fat(GatewayOpcodeIdentify, 0))
        bucket.handshake(_Fat(GatewayOpcodeIdentify, 1))
        bucket.set_identify_concurrency(1)
        bucket.handshake(_Fat(GatewayOpcodeIdentify, 2))

        observer.settle(bucket, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the bucket never went quiet")

class iso _StressConnectionQueueCap is UnitTest
    fun name(): String => "stress/connection/queue_cap"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(120))

        let flood: USize = 200_000
        let counter = _Overflows(h, flood)
        (let connection, let api) = _Stress.connection(
            h, { (err: GatewayError) => counter.saw(err) }
        )
        let timers = time.Timers

        var index: USize = 0

        while index < flood do
            connection._send_message(GatewayHeartbeatEvent(index))
            index = index + 1
        end

        counter.settle(connection, timers, api)

    fun timed_out(h: TestHelper) => h.fail("the connection never went quiet")

class iso _StressDispatchNameScan is UnitTest
    fun name(): String => "stress/dispatch/name_scan"

    fun apply(h: TestHelper) =>
        let names = [
            "READY"
            "CHANNEL_CREATE"
            "MESSAGE_CREATE"
            "WEBHOOKS_UPDATE"
            "NOT_AN_EVENT"
        ]

        let rounds: USize = 200_000

        for event_name in names.values() do
            let started = time.Time.nanos()
            var index: USize = 0

            while index < rounds do
                try GatewayDispatchEvents.from(event_name, None)? end
                index = index + 1
            end

            let elapsed = time.Time.nanos() - started

            h.log(
                event_name + ": " + (elapsed / rounds.u64()).string()
                + "ns per decode attempt"
            )
        end

class iso _StressDispatchSubscriptions is UnitTest
    fun name(): String => "stress/dispatch/subscriptions"

    fun apply(h: TestHelper) =>
        let noisy = ["PRESENCE_UPDATE"; "TYPING_START"; "MESSAGE_REACTION_ADD"]

        for event_name in noisy.values() do
            h.assert_true(
                _GatewayWanted(event_name, None),
                event_name + " was skipped before any listener was registered"
            )
        end

        let none = recover val collections.Set[String] end

        h.assert_true(
            _GatewayWanted("READY", none),
            "READY was skipped, so the session could not be tracked"
        )
        h.assert_true(
            _GatewayWanted("RESUMED", none),
            "RESUMED was skipped, so the backoff could not be reset"
        )

        for event_name in noisy.values() do
            h.assert_false(
                _GatewayWanted(event_name, none),
                event_name + " was decoded with nothing listening for it"
            )
        end

        let wanted = recover val
            collections.Set[String] .> set("MESSAGE_CREATE")
        end

        h.assert_true(
            _GatewayWanted("MESSAGE_CREATE", wanted),
            "MESSAGE_CREATE was skipped with a listener registered on it"
        )

        for event_name in noisy.values() do
            h.assert_false(
                _GatewayWanted(event_name, wanted),
                event_name + " was decoded for a bot listening only for "
                + "messages"
            )
        end

actor _Heard
    let _h: TestHelper
    var _count: USize = 0

    new create(h: TestHelper) => _h = h

    be saw() => _count = _count + 1

    be settle(expected: USize, gateway: GatewayApi, api: rest.RestApi) =>
        _h.assert_eq[USize](
            expected, _count, "a listener ran a different number of times"
        )

        gateway.dispose()
        api.dispose()

        _h.complete(true)

class iso _StressDispatchRegistry is UnitTest
    fun name(): String => "stress/dispatch/registry"

    fun apply(h: TestHelper) =>
        h.long_test(time.Nanos.from_seconds(30))

        let client = rest.Rest(h.env, rest.RestOptions("stress"))
        let gateway = GatewayApi(
            h.env, GatewayOptions("stress", []), client.routes
        )
        let api = client.api
        let events = Events(gateway)
        let heard = _Heard(h)
        let handler: GatewayEventHandler[None] = { (data: None) => heard.saw() }

        events.on_resumed(handler)
        events._dispatch("RESUMED", None)
        events.off(handler)
        events._dispatch("RESUMED", None)
        events.on_resumed({ (data: None) => heard.settle(1, gateway, api) })
        events._dispatch("RESUMED", None)

    fun timed_out(h: TestHelper) => h.fail("the dispatcher never ran a listener")

class iso _StressReceiveNesting is UnitTest
    fun name(): String => "stress/receive/nesting"

    fun apply(h: TestHelper) =>
        let limit = GatewayConstants.max_receive_nesting_depth()

        h.assert_true(
            _GatewayNesting.within(
                """{"t":"MESSAGE_CREATE","d":{"embeds":[{"fields":[{"n":"[{"}]}]}}""",
                limit
            ),
            "a payload nested the way Discord nests them was turned away"
        )

        h.assert_true(
            _GatewayNesting.within(_Nested(limit), limit),
            "a payload exactly at the depth limit was turned away"
        )

        h.assert_false(
            _GatewayNesting.within(_Nested(limit + 1), limit),
            "a payload one level past the limit was let through"
        )

        let deep = _Nested(1_000_000)
        let started = time.Time.nanos()
        let passed = _GatewayNesting.within(deep, limit)
        let elapsed = (time.Time.nanos() - started) / 1_000_000

        h.assert_false(passed, "a million levels of nesting was let through")

        h.log(
            "the guard turned away " + deep.size().string() + " bytes in "
            + elapsed.string() + "ms"
        )

class iso _StressReceiveStall is UnitTest
    fun name(): String => "stress/receive/stall"

    fun apply(h: TestHelper) =>
        let sample: USize = 1_048_576

        let text = recover val
            let source = String(sample + 16)
            source.append("[")

            while source.size() < (sample - 1) do source.append("1,") end

            source.append("1]")
            source
        end

        let started = time.Time.nanos()
        let parsed = json.JsonParser.parse(text)
        let elapsed = (time.Time.nanos() - started) / 1_000_000

        let cap = GatewayConstants.max_receive_message_size_bytes()
        let at_cap = (elapsed * cap.u64()) / text.size().u64()

        h.log(
            text.size().string() + " bytes of flat values took "
            + elapsed.string() + "ms to parse, so a frame at the "
            + cap.string() + " byte receive cap would take about "
            + at_cap.string() + "ms"
        )

        match parsed
        | let _: json.JsonParseError => h.fail("the sample would not parse")
        end

        h.assert_true(
            cap <= 4_194_304,
            "the parse tree runs to roughly 200 bytes a byte and this machine "
            + "reads " + elapsed.string() + "ms a mebibyte, so a receive cap of "
            + cap.string() + " bytes puts about " + at_cap.string()
            + "ms and a gigabyte of heap on the connection actor"
        )

primitive _Nested
    fun apply(depth: USize): String =>
        recover val
            let source = String((depth * 2) + 1)
            var index: USize = 0

            while index < depth do
                source.append("[")
                index = index + 1
            end

            index = 0

            while index < depth do
                source.append("]")
                index = index + 1
            end

            source
        end

actor _Releases
    let _h: TestHelper
    let _judge: _Judge

    embed _seen: Array[USize] = Array[USize]

    var _quiet: USize = 0
    var _last: USize = 0
    var _rounds: USize = 0
    var _done: Bool = false

    new create(h: TestHelper, judge: _Judge) =>
        _h = h
        _judge = judge

    be saw(err: GatewayError) =>
        match _Stress.index_of(err)
        | let index: USize => _seen.push(index)
        end

    be settle(
        bucket: _GatewayBucket,
        timers: time.Timers,
        api: rest.RestApi
    ) =>
        if _done then return end

        _rounds = _rounds + 1
        _quiet = if _seen.size() == _last then _quiet + 1 else 0 end
        _last = _seen.size()

        if (_quiet < 4) and (_rounds < 40) then
            let self: _Releases tag = this

            timers(
                time.Timer(
                    _Elapsed({() => self.settle(bucket, timers, api)}),
                    time.Nanos.from_millis(250)
                )
            )

            return
        end

        _done = true

        var copy = recover iso Array[USize] end
        for index in _seen.values() do copy.push(index) end

        _judge(_h, consume copy)

        bucket.dispose()
        timers.dispose()
        api.dispose()

        _h.complete(true)

actor _Overflows
    let _h: TestHelper
    let _flood: USize

    var _overflows: USize = 0
    var _recoveries: USize = 0
    var _quiet: USize = 0
    var _last: USize = 0
    var _rounds: USize = 0
    var _done: Bool = false

    new create(h: TestHelper, flood: USize) =>
        _h = h
        _flood = flood

    be saw(err: GatewayError) =>
        if err.reason.contains("queue is full") then
            _overflows = _overflows + 1
        elseif err.reason.contains("caught up") then
            _recoveries = _recoveries + 1
        end

    be settle(
        connection: _GatewayConnection,
        timers: time.Timers,
        api: rest.RestApi
    ) =>
        if _done then return end

        let reports = _overflows + _recoveries

        _rounds = _rounds + 1
        _quiet =
            if (reports > 0) and (reports == _last) then _quiet + 1 else 0 end
        _last = reports

        if (_quiet < 4) and (_rounds < 40) then
            let self: _Overflows tag = this

            timers(
                time.Timer(
                    _Elapsed({() => self.settle(connection, timers, api)}),
                    time.Nanos.from_millis(250)
                )
            )

            return
        end

        _done = true

        _h.log(
            _flood.string() + " event(s) into a closed queue drew "
            + _overflows.string() + " overflow report(s) and "
            + _recoveries.string() + " recovery report(s)"
        )

        _h.assert_eq[USize](
            1,
            _overflows,
            "the queue cap should announce itself once, not once per drop"
        )

        connection.dispose()
        timers.dispose()
        api.dispose()

        _h.complete(true)
