use "../data"
use "pony_test"
use courier = "courier"
use time = "time"

actor Main is TestList
    new create(env: Env) => PonyTest(env, this)

    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_TestBucketIdMasksMinorIds)
        test(_TestBucketIdKeepsMajorIds)
        test(_TestBucketIdIgnoresQuery)
        test(_TestBucketIdSeparatesMethods)
        test(_TestMajorParameter)
        test(_TestRedactedPath)
        test(_TestRestErrorRedacts)
        test(_TestQueuedRequestCounters)
        test(_TestRateLimitNeedsSomething)
        test(_TestRateLimitFromHeaders)
        test(_TestRateLimitFallsBackToRetryAfter)
        test(_TestRateLimitIsNewerThan)
        test(_TestRateLimitWindow)
        test(_TestIsGlobalRateLimit)
        test(_TestIsRetriable)
        test(_TestBackoffGrowsAndStaysBounded)
        test(_TestQueueOrdering)
        test(_TestMultipartCarriesPayloadAndFiles)
        test(_TestBuildPath)
        test(_TestBuildHeaders)
        test(_TestDecodeRejectsNonSuccess)
        test(_TestExcerptTrimsAndScrubs)
        test(_TestDecodeRejectsDeepNesting)

primitive _Fixtures
    fun request(
        method: courier.Method,
        path: String
    ): courier.HTTPRequest val =>
        courier.HTTPRequest(method, path)

    fun headers(pairs: Array[(String, String)] val): courier.Headers val =>
        recover val
            let headers' = courier.Headers
            for (name, value) in pairs.values() do headers'.set(name, value) end
            headers'
        end

    fun response(
        status: U16,
        headers': courier.Headers val = recover val courier.Headers end,
        body: String = ""
    ): courier.HTTPResponse val =>
        courier.HTTPResponse(
            courier.HTTP11, status, "", headers', body.array()
        )

    fun options(): RestOptions =>
        RestOptions("token" where version' = ApiVersion10)

class iso _TestBucketIdMasksMinorIds is UnitTest
    fun name(): String => "rest/bucket_id/masks minor ids"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            "GET/api/v10/channels/123/messages/*/reactions",
            _BucketId(
                _Fixtures.request(
                    courier.GET,
                    "/api/v10/channels/123/messages/456/reactions"
                )
            )
        )

class iso _TestBucketIdKeepsMajorIds is UnitTest
    fun name(): String => "rest/bucket_id/keeps major ids apart"

    fun apply(h: TestHelper) =>
        let one = _BucketId(
            _Fixtures.request(courier.POST, "/api/v10/channels/1/messages")
        )
        let two = _BucketId(
            _Fixtures.request(courier.POST, "/api/v10/channels/2/messages")
        )

        h.assert_ne[String](one, two)

        let guild = _BucketId(
            _Fixtures.request(courier.GET, "/api/v10/guilds/7/roles")
        )
        h.assert_true(guild.contains("guilds/7"))

class iso _TestBucketIdIgnoresQuery is UnitTest
    fun name(): String => "rest/bucket_id/ignores the query string"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            _BucketId(
                _Fixtures.request(courier.GET, "/api/v10/channels/1/messages")
            ),
            _BucketId(
                _Fixtures.request(
                    courier.GET, "/api/v10/channels/1/messages?limit=50"
                )
            )
        )

class iso _TestBucketIdSeparatesMethods is UnitTest
    fun name(): String => "rest/bucket_id/separates methods"

    fun apply(h: TestHelper) =>
        h.assert_ne[String](
            _BucketId(_Fixtures.request(courier.GET, "/api/v10/channels/1")),
            _BucketId(_Fixtures.request(courier.DELETE, "/api/v10/channels/1"))
        )

class iso _TestMajorParameter is UnitTest
    fun name(): String => "rest/major_parameter"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            "channels/123",
            _MajorParameter(
                _Fixtures.request(
                    courier.GET, "/api/v10/channels/123/messages/456"
                )
            )
        )

        h.assert_eq[String](
            "guilds/9",
            _MajorParameter(
                _Fixtures.request(courier.GET, "/api/v10/guilds/9/roles")
            )
        )

        h.assert_eq[String](
            "",
            _MajorParameter(
                _Fixtures.request(courier.GET, "/api/v10/users/@me")
            )
        )

class iso _TestRedactedPath is UnitTest
    fun name(): String => "rest/redacted path"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            "/api/v10/webhooks/123/*",
            _RedactedPath("/api/v10/webhooks/123/tokenish")
        )

        h.assert_eq[String](
            "/api/v10/webhooks/123/*/messages/@original",
            _RedactedPath("/api/v10/webhooks/123/tokenish/messages/@original")
        )

        h.assert_eq[String](
            "/api/v10/interactions/123/*/callback",
            _RedactedPath("/api/v10/interactions/123/tokenish/callback")
        )

        h.assert_eq[String](
            "/api/v10/channels/123/webhooks",
            _RedactedPath("/api/v10/channels/123/webhooks")
        )

        h.assert_eq[String](
            "/api/v10/users/@me", _RedactedPath("/api/v10/users/@me")
        )

class iso _TestRestErrorRedacts is UnitTest
    fun name(): String => "rest/error redacts the credentials"

    fun apply(h: TestHelper) =>
        let error' = RestError(
            courier.HTTPRequest(
                courier.POST,
                "/api/v10/interactions/123/tokenish/callback",
                _Fixtures.headers(
                    [
                        ("Authorization", "Bot secret")
                        ("User-Agent", "discord.pony")
                    ]
                )
            ),
            "nope"
        )

        h.assert_is[(String | None)](
            None, error'.request.headers.get("Authorization")
        )
        h.assert_eq[USize](1, error'.request.headers.size())
        h.assert_false(error'.string().contains("secret"))
        h.assert_false(error'.string().contains("tokenish"))

class iso _TestQueuedRequestCounters is UnitTest
    fun name(): String => "rest/queued request counts retries apart from 429s"

    fun apply(h: TestHelper) =>
        let job = _QueuedRequest(
            _Fixtures.request(courier.GET, "/api/v10/users/@me"),
            {(
                request: courier.HTTPRequest val,
                response: courier.HTTPResponse val
            ) => None},
            "GET/api/v10/users/@me"
        )

        h.assert_eq[USize](0, job.attempts)
        h.assert_eq[USize](0, job.rate_limit_attempts)

        let retried = job.retried()
        h.assert_eq[USize](1, retried.attempts)
        h.assert_eq[USize](0, retried.rate_limit_attempts)

        let throttled = retried.throttled()
        h.assert_eq[USize](1, throttled.attempts)
        h.assert_eq[USize](1, throttled.rate_limit_attempts)
        h.assert_eq[String]("GET/api/v10/users/@me", throttled.route)

class iso _TestRateLimitNeedsSomething is UnitTest
    fun name(): String => "rest/rate_limit/needs a usable header"

    fun apply(h: TestHelper) =>
        h.assert_error(
            {() ? =>
                _RateLimit.from_headers(
                    _Fixtures.headers([("x-ratelimit-limit", "5")])
                )?
            }
        )

class iso _TestRateLimitFromHeaders is UnitTest
    fun name(): String => "rest/rate_limit/reads the headers"

    fun apply(h: TestHelper) ? =>
        let rate_limit = _RateLimit.from_headers(
            _Fixtures.headers(
                [
                    ("X-RateLimit-Limit", "5")
                    ("X-RateLimit-Remaining", "3")
                    ("X-RateLimit-Reset", "1470173023")
                    ("X-RateLimit-Reset-After", "1.5")
                    ("X-RateLimit-Bucket", "abcd1234")
                ]
            )
        )?

        h.assert_eq[USize](3, rate_limit.remaining)
        h.assert_eq[F64](1.5, rate_limit.reset_after_s)
        h.assert_eq[String]("abcd1234", rate_limit.bucket as String)
        h.assert_eq[USize](5, rate_limit.limit as USize)

class iso _TestRateLimitFallsBackToRetryAfter is UnitTest
    fun name(): String => "rest/rate_limit/falls back to retry-after"

    fun apply(h: TestHelper) ? =>
        let rate_limit = _RateLimit.from_headers(
            _Fixtures.headers([("Retry-After", "2.5")])
        )?

        h.assert_eq[F64](2.5, rate_limit.reset_after_s)
        h.assert_eq[USize](0, rate_limit.remaining)

class iso _TestRateLimitIsNewerThan is UnitTest
    fun name(): String => "rest/rate_limit/spots a newer window"

    fun apply(h: TestHelper) ? =>
        let held = _RateLimit.from_headers(
            _Fixtures.headers(
                [
                    ("X-RateLimit-Remaining", "3")
                    ("X-RateLimit-Reset", "100")
                    ("X-RateLimit-Reset-After", "5")
                ]
            )
        )?

        let newer = _RateLimit.from_headers(
            _Fixtures.headers(
                [
                    ("X-RateLimit-Remaining", "2")
                    ("X-RateLimit-Reset", "100")
                    ("X-RateLimit-Reset-After", "4")
                ]
            )
        )?

        h.assert_true(newer.is_newer_than(held))
        h.assert_false(held.is_newer_than(newer))
        h.assert_true(held.is_newer_than(None))

class iso _TestRateLimitWindow is UnitTest
    fun name(): String => "rest/rate_limit/window holds the line"

    fun apply(h: TestHelper) =>
        let window = _RateLimitWindow(2, 1000)
        let start = time.Nanos.from_millis(1_000)

        h.assert_is[(U64 | None)](None, window.blocked_until(start))

        window.spend(start)
        h.assert_is[(U64 | None)](None, window.blocked_until(start))

        window.spend(start)

        match window.blocked_until(start)
        | let at: U64 =>
            h.assert_eq[U64](start + time.Nanos.from_millis(1000), at)
        else
            h.fail("a spent window should block")
        end

        h.assert_is[(U64 | None)](
            None, window.blocked_until(start + time.Nanos.from_millis(1001))
        )

class iso _TestIsGlobalRateLimit is UnitTest
    fun name(): String => "rest/rate_limit/tells global from route-scoped"

    fun apply(h: TestHelper) =>
        h.assert_true(
            _IsGlobalRateLimit(
                _Fixtures.headers([("X-RateLimit-Scope", "global")])
            )
        )

        h.assert_false(
            _IsGlobalRateLimit(
                _Fixtures.headers(
                    [
                        ("X-RateLimit-Scope", "user")
                        ("X-RateLimit-Bucket", "abcd")
                    ]
                )
            )
        )

        h.assert_true(
            _IsGlobalRateLimit(
                _Fixtures.headers([("X-RateLimit-Global", "true")])
            )
        )

        h.assert_true(_IsGlobalRateLimit(_Fixtures.headers([])))

        h.assert_false(
            _IsGlobalRateLimit(
                _Fixtures.headers([("X-RateLimit-Bucket", "abcd")])
            )
        )

class iso _TestIsRetriable is UnitTest
    fun name(): String => "rest/retriable statuses"

    fun apply(h: TestHelper) =>
        h.assert_true(_IsRetriable(500, courier.GET))
        h.assert_true(_IsRetriable(502, courier.GET))
        h.assert_true(_IsRetriable(503, courier.GET))
        h.assert_true(_IsRetriable(504, courier.GET))
        h.assert_false(_IsRetriable(200, courier.GET))
        h.assert_false(_IsRetriable(400, courier.GET))
        h.assert_false(_IsRetriable(403, courier.GET))
        h.assert_false(_IsRetriable(429, courier.GET))
        h.assert_false(_IsRetriable(501, courier.GET))

        h.assert_true(_IsRetriable(500, courier.HEAD))
        h.assert_true(_IsRetriable(500, courier.PUT))
        h.assert_true(_IsRetriable(500, courier.DELETE))

        h.assert_false(_IsRetriable(500, courier.POST))
        h.assert_false(_IsRetriable(502, courier.POST))
        h.assert_false(_IsRetriable(503, courier.POST))
        h.assert_false(_IsRetriable(504, courier.POST))
        h.assert_false(_IsRetriable(500, courier.PATCH))

class iso _TestBackoffGrowsAndStaysBounded is UnitTest
    fun name(): String => "rest/backoff grows and stays bounded"

    fun apply(h: TestHelper) =>
        let base = RestConstants.base_backoff_ms()
        let ceiling =
            (time.Nanos.from_millis(
                base * (U64(1) << RestConstants.max_backoff_exponent().u64())
            ) * 3) / 2

        var previous: U64 = 0
        var attempts: USize = 1

        while attempts <= 3 do
            let delay = _Backoff(attempts, 0)

            h.assert_true(delay >= time.Nanos.from_millis(base / 2))
            h.assert_true(delay > previous)

            previous = delay
            attempts = attempts + 1
        end

        var far: USize = 1
        while far <= 32 do
            h.assert_true(_Backoff(far, 1) <= ceiling)
            far = far + 1
        end

class iso _TestQueueOrdering is UnitTest
    fun name(): String => "rest/queue ordering"

    fun apply(h: TestHelper) ? =>
        let queue = _Queue[String]

        queue.enqueue("a")
        queue.enqueue("b")
        queue.enqueue_at_beginning("c")

        h.assert_eq[USize](3, queue.size())
        h.assert_eq[String]("c", queue.dequeue()?)
        h.assert_eq[String]("a", queue.dequeue()?)
        h.assert_eq[String]("b", queue.dequeue()?)
        h.assert_eq[USize](0, queue.size())

        queue.enqueue("d")
        queue.clear()
        h.assert_eq[USize](0, queue.size())

class iso _TestMultipartCarriesPayloadAndFiles is UnitTest
    fun name(): String => "rest/multipart carries the payload and the files"

    fun apply(h: TestHelper) =>
        let multipart = _Multipart.payload(
            "{\"content\":\"hi\"}",
            [FileUpload("note.txt", "inside".array(), "text/plain")]
        )

        h.assert_true(multipart.content_type.contains("multipart/form-data"))
        h.assert_true(multipart.content_type.contains("boundary="))

        let body = String.from_array(multipart.body)

        h.assert_true(body.contains("name=\"payload_json\""))
        h.assert_true(body.contains("{\"content\":\"hi\"}"))
        h.assert_true(body.contains("name=\"files[0]\""))
        h.assert_true(body.contains("filename=\"note.txt\""))
        h.assert_true(body.contains("inside"))

class iso _TestBuildPath is UnitTest
    fun name(): String => "rest/options/builds a path"

    fun apply(h: TestHelper) =>
        let options = _Fixtures.options()

        h.assert_eq[String]("/api/v10/users/@me", options.path("/users/@me"))

        h.assert_eq[String](
            "/api/v10/users/@me", options.build_path("/users/@me")
        )

        h.assert_eq[String](
            "/api/v10/channels/1/messages?limit=50",
            options.build_path("/channels/1/messages", [("limit", "50")])
        )

        h.assert_eq[String](
            "/api/v10/channels/1/messages",
            options.build_path("/channels/1/messages", recover val
                Array[(String, String)]
            end)
        )

class iso _TestBuildHeaders is UnitTest
    fun name(): String => "rest/options/builds headers"

    fun apply(h: TestHelper) ? =>
        let options = _Fixtures.options()

        let bare = options.build_headers()
        h.assert_eq[String]("Bot token", bare.get("Authorization") as String)
        h.assert_is[(String | None)](None, bare.get("Content-Type"))
        h.assert_is[(String | None)](None, bare.get("X-Audit-Log-Reason"))

        let json = options.build_headers("{}", "because")
        h.assert_eq[String](
            "application/json", json.get("Content-Type") as String
        )
        h.assert_eq[String](
            "because", json.get("X-Audit-Log-Reason") as String
        )

        let multipart = options.build_headers(
            _Multipart.payload("{}", [FileUpload("a.txt", "b".array())])
        )
        h.assert_true(
            (multipart.get("Content-Type") as String).contains(
                "multipart/form-data"
            )
        )

class iso _TestDecodeRejectsNonSuccess is UnitTest
    fun name(): String => "rest/decode/rejects a non-success status"

    fun apply(h: TestHelper) =>
        let request = _Fixtures.request(courier.GET, "/api/v10/users/@me")

        h.assert_is[(RestError | None)](
            None,
            _Decode.rejected(request, _Fixtures.response(200))
        )

        h.assert_is[(RestError | None)](
            None,
            _Decode.rejected(request, _Fixtures.response(204))
        )

        match _Decode.rejected(
            request,
            _Fixtures.response(
                403 where body = "{\"code\":50001}"
            )
        )
        | let error': RestError =>
            h.assert_true(error'.reason.contains("403"))
            h.assert_true(error'.reason.contains("50001"))
        else
            h.fail("a 403 should be rejected")
        end

class iso _TestExcerptTrimsAndScrubs is UnitTest
    fun name(): String => "rest/excerpt trims and scrubs a body"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            "{\"code\":50001}", _Excerpt("{\"code\":50001}".array())
        )

        h.assert_eq[String]("a  b c", _Excerpt("a\r\nb\tc".array()))

        let long: String val = recover val
            let body = String(20_000)
            while body.size() < 20_000 do body.push('x') end
            body
        end

        let excerpt = _Excerpt(long.array())
        h.assert_true(excerpt.size() < 600)
        h.assert_true(excerpt.contains("... (20000 bytes in all)"))

        let undecodable = _Decode.undecodable(
            _Fixtures.request(courier.GET, "/api/v10/webhooks/123"),
            _Fixtures.response(200 where body = "{\"token\":\"secret\"}")
        )

        h.assert_false(undecodable.reason.contains("secret"))
        h.assert_true(undecodable.reason.contains("18 bytes"))

primitive _Nested
    fun apply(depth: USize): String val =>
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

class iso _TestDecodeRejectsDeepNesting is UnitTest
    fun name(): String => "rest/decode/rejects a body nested past the limit"

    fun apply(h: TestHelper) =>
        let limit = RestConstants.max_response_nesting_depth()

        h.assert_true(
            _ResponseNesting.within(
                """{"embeds":[{"fields":[{"name":"[{"}]}]}""".array(), limit
            ),
            "a body nested the way Discord nests them was turned away"
        )

        h.assert_true(
            _ResponseNesting.within("""{"a":"\"[[[["}""".array(), 1),
            "brackets behind an escaped quote were counted as nesting"
        )

        h.assert_false(
            _ResponseNesting.within("""{"a":"\\","b":[[[]]]}""".array(), 3),
            "an escaped backslash swallowed the quote that closed the string"
        )

        h.assert_true(
            _ResponseNesting.within(_Nested(limit).array(), limit),
            "a body exactly at the depth limit was turned away"
        )

        h.assert_false(
            _ResponseNesting.within(_Nested(limit + 1).array(), limit),
            "a body one level past the limit was let through"
        )

        try
            _Decode.parse(
                _Fixtures.response(200 where body = _Nested(limit + 1))
            )?
            h.fail("a body past the depth limit was parsed")
        end

        try
            _Decode.parse(
                _Fixtures.response(200 where body = """{"id":"1"}""")
            )?
        else
            h.fail("a body Discord would send was turned away")
        end
