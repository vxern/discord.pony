use time = "time"
use courier = "courier"

actor GlobalBucket
    let _api: RestApi
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler, RawFailureHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler, RawFailureHandler)]

    // A request only goes out if every window has room for it.
    let _windows: Array[_RateLimitWindow] = _RateLimitConstants.windows()

    var _disposed: Bool = false
    var _paused: Bool = false
    var _paused_until: U64 = 0
    var _pause_generation: USize = 0
    var _drain_scheduled: Bool = false

    new create(api: RestApi, timers: time.Timers) =>
        _api = api
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler, on_failure: RawFailureHandler) =>
        if _disposed then return end

        _queue.enqueue((request, handler, on_failure))
        _drain()

    be _pause(seconds: F64) =>
        if _disposed then return end

        let duration = time.Nanos.from_seconds_f(
            seconds.max(_RateLimitConstants.minimum_pause_s())
        )
        let resume_at = time.Time.nanos() + duration

        if _paused and (resume_at <= _paused_until) then return end

        _paused = true
        _paused_until = resume_at

        _pause_generation = _pause_generation + 1
        let generation = _pause_generation

        let self: GlobalBucket tag = this
        _timers(
            time.Timer(
                _OnceElapsed({() => self._resume(generation)}),
                duration
            )
        )

    be _resume(generation: USize) =>
        if generation != _pause_generation then return end

        _paused = false
        _drain()

    be dispose() =>
        _disposed = true
        _queue.clear()

    be _wake() =>
        _drain_scheduled = false
        _drain()

    fun ref _drain() =>
        if _paused then return end

        while _queue.size() > 0 do
            let now = time.Time.nanos()

            match _blocked_until(now)
            | let at: U64 =>
                if not _drain_scheduled then
                    _drain_scheduled = true
                    let self: GlobalBucket tag = this
                    _timers(time.Timer(_OnceElapsed({() => self._wake()}), at - now))
                end

                return
            end

            try
                (let request, let handler, let on_failure) = _queue.dequeue()?

                for window in _windows.values() do
                    window.spend(now)
                end

                _api._raw_send_request(request, handler, on_failure)
            else
                return
            end
        end

    fun _blocked_until(now: U64): (U64 | None) =>
        var at: U64 = 0

        for window in _windows.values() do
            match window.blocked_until(now)
            | let window_at: U64 => at = at.max(window_at)
            end
        end

        if at > now then at end

actor Bucket
    let _env: Env
    let _global_bucket: GlobalBucket
    let _id: String
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler)]

    var _rate_limit: (_RateLimit | None) = None
    var _requests_in_flight: USize = 0
    var _requests_remaining: USize = 1

    var _disposed: Bool = false
    var _restarting: Bool = false

    new create(env: Env, global_bucket: GlobalBucket, id: String, timers: time.Timers) =>
        _env = env
        _global_bucket = global_bucket
        _id = id
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler) =>
        if _disposed then return end

        _queue.enqueue((request, handler))
        _drain()

    be dispose() =>
        _disposed = true
        _queue.clear()

    be _drain() =>
        if _disposed or _restarting then return end

        let self: Bucket tag = this

        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                (let request, let handler) = _queue.dequeue()?

                _requests_in_flight = _requests_in_flight + 1
                _requests_remaining = _requests_remaining - 1

                _global_bucket.enqueue(
                    request,
                    {(request': courier.HTTPRequest val, response': courier.HTTPResponse val) =>
                        self.on_response_received(request', response', handler)
                    },
                    {() => self.on_request_failed()}
                )
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

    be on_request_failed() =>
        _requests_in_flight = _requests_in_flight - 1
        _drain()

    be on_response_received(request: courier.HTTPRequest, response: courier.HTTPResponse, handler: RawResponseHandler) =>
        if _disposed then return end

        _requests_in_flight = _requests_in_flight - 1

        let rate_limit = try _RateLimit.from_headers(response.headers)? end

        match rate_limit
        | let rate_limit': _RateLimit if rate_limit'.is_newer_than(_rate_limit) =>
            _rate_limit = rate_limit'
            _requests_remaining = rate_limit'.remaining - _requests_in_flight.min(rate_limit'.remaining)
        end

        if response.status == 429 then
            _queue.enqueue_at_beginning((request, handler))
            _requests_remaining = 0

            if _IsGlobalRateLimit(response.headers) then
                _global_bucket._pause(
                    match rate_limit
                    | let rate_limit': _RateLimit => rate_limit'.reset_after_s
                    else
                        _RateLimitConstants.blind_pause_s()
                    end
                )
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
    let duration_ns: U64

    embed _sent_at: Array[U64]
    var _sends: USize = 0

    new create(max_count': USize, duration_ms': USize) =>
        max_count = max_count'
        duration_ns = time.Nanos.from_millis(duration_ms'.u64())
        _sent_at = Array[U64].init(0, max_count')

    fun blocked_until(now: U64): (U64 | None) =>
        if _sends < max_count then return None end

        let frees_at = try _sent_at(_sends % max_count)? + duration_ns else return None end
        if frees_at > now then frees_at end

    fun ref spend(now: U64) =>
        try _sent_at(_sends % max_count)? = now end
        _sends = _sends + 1

primitive _IsGlobalRateLimit
    fun apply(headers: courier.Headers val): Bool =>
        match headers.get(_RateLimitConstants.scope_header_name())
        | let scope: String => return scope == "global"
        end

        match headers.get(_RateLimitConstants.global_header_name())
        | let global: String => return global == "true"
        end

        headers.get(_RateLimitConstants.bucket_header_name()) is None

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

    fun bucket_header_name(): String => "X-RateLimit-Bucket".lower()

    fun minimum_pause_s(): F64 =>
        """
        The least time the global bucket sits out a 429, however short a wait the
        response asks for.
        """

        1

    fun blind_pause_s(): F64 =>
        """
        How long the global bucket sits out a 429 that names no wait at all.

        Long enough not to walk straight back into a Cloudflare ban, short enough
        that taking a route's limit for a global one is not costly.
        """

        60
