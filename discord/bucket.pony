use time = "time"
use courier = "courier"
use collections = "collections"

actor GlobalBucket
    let _api: RestApi
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler)]

    // A request only goes out if every window has requests remaining.
    let _windows: Array[_RateLimitWindow] = _RateLimitConstants.windows()

    var _disposed: Bool = false
    var _paused: Bool = false

    new create(api: RestApi, timers: time.Timers) =>
        _api = api
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler) =>
        if _disposed then return end

        _queue.enqueue((request, handler))
        _drain()

    be _pause(seconds: F64) =>
        if _disposed or _paused then return end

        _paused = true

        let self: GlobalBucket tag = this
        _timers(
            time.Timer(
                _OnceElapsed({() => self._resume()}),
                time.Nanos.from_seconds_f(seconds).max(time.Nanos.from_seconds(1))
            )
        )

    be _resume() =>
        _paused = false
        _drain()

    be dispose() =>
        _disposed = true
        _queue.clear()

    be _reset_window(index: USize) =>
        try _windows(index)?.reset() end
        _drain()

    fun ref _drain() =>
        let self: GlobalBucket tag = this

        while _can_send() and (_queue.size() > 0) do
            try
                (let request, let handler) = _queue.dequeue()?

                for (index, window) in _windows.pairs() do
                    // A window starts with the first request spent in it, rather
                    // than ticking along on its own.
                    if not window.started then
                        window.started = true
                        _timers(
                            time.Timer(
                                _OnceElapsed({() => self._reset_window(index)}),
                                time.Nanos.from_millis(window.duration_ms.u64())
                            )
                        )
                    end

                    window.spend()
                end

                _api._raw_send_request(request, handler)
            else
                break
            end
        end

    fun _can_send(): Bool =>
        if _paused then return false end

        for window in _windows.values() do
            if window.remaining == 0 then return false end
        end

        true

actor Bucket
    let _env: Env
    let _global_bucket: GlobalBucket
    let _id: String
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler)]

    var _rate_limit: (_RateLimit | None) = None
    var _requests_in_flight: USize = 0
    var _requests_remaining: USize = 1

    var _restarting: Bool = false

    new create(env: Env, global_bucket: GlobalBucket, id: String, timers: time.Timers) =>
        _env = env
        _global_bucket = global_bucket
        _id = id
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler) =>
        _queue.enqueue((request, handler))
        _drain()

    be _drain() =>
        if _restarting then return end

        let self: Bucket tag = this

        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                (let request, let handler) = _queue.dequeue()?

                _requests_in_flight = _requests_in_flight + 1
                _requests_remaining = _requests_remaining - 1

                _global_bucket.enqueue(request, {(request': courier.HTTPRequest val, response': courier.HTTPResponse val) =>
                    self.on_response_received(request', response', handler)
                })
            else
                break
            end
        end

        if (_requests_in_flight == 0) and (_requests_remaining == 0) and (_queue.size() > 0) then
            _restarting = true
            let delay = try time.Nanos.from_seconds_f((_rate_limit as _RateLimit).reset_after_s) else 0 end
            _timers(time.Timer(_OnceElapsed({() => self._restart()}), delay))
        end

    be _restart() =>
        _restarting = false
        _rate_limit = None
        _requests_remaining = 1
        _drain()

    be on_response_received(request: courier.HTTPRequest, response: courier.HTTPResponse, handler: RawResponseHandler) =>
        _requests_in_flight = _requests_in_flight - 1

        try
            let rate_limit = _RateLimit.from_headers(response.headers)?
            if rate_limit.is_newer_than(_rate_limit) then
                _rate_limit = rate_limit
                _requests_remaining = rate_limit.remaining - _requests_in_flight.min(rate_limit.remaining)
            end
        end

        if response.status == 429 then
            _queue.enqueue_at_beginning((request, handler))
            _requests_remaining = 0

            if _IsGlobalRateLimit(response.headers) then
                _global_bucket._pause(try (_rate_limit as _RateLimit).reset_after_s else 5 end)
            end
        else
            handler(request, response)
        end

        _drain()

primitive _BucketId
    fun apply(request: courier.HTTPRequest val): String =>
        let path = try request.path.split_by("?")(0)? else request.path end
        let segments: Array[String] ref = path.split_by("/")

        for (index, segment) in segments.pairs() do
            let previous = try segments(index - 1)? else "" end
            let major = _BucketConstants.major_parameters().contains(previous, {(a, b) => a == b})

            if _is_id(segment) and not major then
                try segments(index)? = "*" end
            end
        end

        request.method.string() + "/".join(segments.values())

    fun _is_id(segment: String box): Bool =>
        if segment.size() == 0 then return false end

        for character in segment.values() do
            if (character < '0') or (character > '9') then return false end
        end

        true

primitive _BucketConstants
    fun major_parameters(): Array[String] val =>
        """
        The route segments whose id decides which bucket a request falls in.
        """

        ["channels"; "guilds"; "webhooks"]

class val _RateLimit
    let limit: (USize | None)
    let remaining: USize
    let reset_s: F64
    let reset_after_s: F64
    let bucket: (String | None)

    new val from_headers(headers: courier.Headers val) ? =>
        var limit': (USize | None) = None
        var remaining': (USize | None) = None
        var reset_s': (F64 | None) = None
        var reset_after_s': (F64 | None) = None
        var retry_after_s': (F64 | None) = None
        var bucket': (String | None) = None

        for (key, value) in headers.values() do
            match key
            | "x-ratelimit-limit" => limit' = value.usize()?
            | "x-ratelimit-remaining" => remaining' = value.usize()?
            | "x-ratelimit-reset" => reset_s' = value.f64()?
            | "x-ratelimit-reset-after" => reset_after_s' = value.f64()?
            | "x-ratelimit-bucket" => bucket' = value
            | "retry-after" => retry_after_s' = value.f64()?
            end
        end

        // A global rate limit only sends `X-RateLimit-Retry-After`, so a response is worth
        // something as long as it tells us either how much is left or how long
        // to wait for.
        if (remaining' is None) and (reset_after_s' is None) and (retry_after_s' is None) then
            error
        end

        limit = limit'
        bucket = bucket'
        remaining = try remaining' as USize else 0 end
        reset_s = try reset_s' as F64 else 0 end
        reset_after_s =
            match (reset_after_s', retry_after_s')
            | (let seconds: F64, _) => seconds
            | (_, let seconds: F64) => seconds
            else
                0
            end

    fun is_newer_than(other: (_RateLimit | None)): Bool =>
        match other
        | let other': _RateLimit =>
            (reset_s > other'.reset_s)
            or (reset_after_s < other'.reset_after_s)
            or (remaining < other'.remaining)
        else
            true
        end

class _RateLimitWindow
    let max_count: USize
    let duration_ms: USize

    var remaining: USize
    var started: Bool = false
        """
        Whether the span is under way, and so a timer is set to end it.
        """

    new create(max_count': USize, duration_ms': USize) =>
        max_count = max_count'
        duration_ms = duration_ms'
        remaining = max_count'

    fun ref spend() =>
        remaining = remaining - remaining.min(1)

    fun ref reset() =>
        remaining = max_count
        started = false

primitive _IsGlobalRateLimit
    fun apply(headers: courier.Headers val): Bool =>
        match (
            headers.get(_RateLimitConstants.scope_header_name()),
            headers.get(_RateLimitConstants.global_header_name())
        )
        | (let scope: String, _) => scope == "global"
        | (_, let global: String) => global == "true"
        else
            false
        end

primitive _RateLimitConstants
    fun windows(): Array[_RateLimitWindow] =>
        """
        How many requests the API takes, and in what span of time.

        Going over the Cloudflare limit results in an hour-long ban, so it's extremely key we don't exceed that.
        """

        [
            // Discord: 50 a second
            _RateLimitWindow(50, 1000)
            // Cloudflare: 10,000 in 10 minutes (~16.7 requests per second)
            _RateLimitWindow(10_000, 10 * 60 * 1000)
        ]

    fun global_header_name(): String => "X-RateLimit-Global".lower()

    fun scope_header_name(): String => "X-RateLimit-Scope".lower()
