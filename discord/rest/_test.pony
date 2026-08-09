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
        h.assert_true(_IsRetriable(500))
        h.assert_true(_IsRetriable(502))
        h.assert_true(_IsRetriable(503))
        h.assert_true(_IsRetriable(504))
        h.assert_false(_IsRetriable(200))
        h.assert_false(_IsRetriable(400))
        h.assert_false(_IsRetriable(403))
        h.assert_false(_IsRetriable(429))
        h.assert_false(_IsRetriable(501))

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
            h.assert_true(_Backoff(far, 999) <= ceiling)
            far = far + 1
        end

class iso _TestQueueOrdering is UnitTest
    fun name(): String => "rest/queue ordering"

    fun apply(h: TestHelper) ? =>
        let queue = Queue[String]

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
