use time = "time"
use courier = "courier"
use collections = "collections"

actor GlobalBucket
    let _api: RestApi
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler)]

    var _requests_remaining: USize = _RateLimitConstants.global_rate_limit_max_count()
    var _window_open: Bool = false
    var _disposed: Bool = false

    new create(api: RestApi, timers: time.Timers) =>
        _api = api
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler) =>
        if _disposed then return end

        _queue.enqueue((request, handler))
        _drain()

    be dispose() =>
        _disposed = true
        _queue.clear()

    be _open_window() =>
        _window_open = false
        _requests_remaining = _RateLimitConstants.global_rate_limit_max_count()
        _drain()

    fun ref _drain() =>
        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                (let request, let handler) = _queue.dequeue()?

                if not _window_open then
                    _window_open = true
                    _timers(
                        time.Timer(
                            _GlobalBucketOpen(this),
                            time.Nanos.from_millis(
                                _RateLimitConstants.global_rate_limit_window_ms().u64()
                            )
                        )
                    )
                end

                _requests_remaining = _requests_remaining - 1
                _api._raw_send_request(request, handler)
            else
                break
            end
        end

actor Bucket
    let _env: Env
    let _global: GlobalBucket
    let _id: String
    let _timers: time.Timers
    embed _queue: Queue[(courier.HTTPRequest, RawResponseHandler)] = Queue[(courier.HTTPRequest, RawResponseHandler)]

    var _rate_limit: (_RateLimit | None) = None
    var _requests_in_flight: USize = 0
    var _requests_remaining: USize = 1

    var _restarting: Bool = false

    new create(env: Env, global: GlobalBucket, id: String, timers: time.Timers) =>
        _env = env
        _global = global
        _id = id
        _timers = timers

    be enqueue(request: courier.HTTPRequest, handler: RawResponseHandler) =>
        _queue.enqueue((request, handler))
        _drain()

    be _drain() =>
        if _restarting then return end

        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                (let request, let handler) = _queue.dequeue()?

                _requests_in_flight = _requests_in_flight + 1
                _requests_remaining = _requests_remaining - 1

                let self: Bucket tag = this
                _global.enqueue(request, {(request': courier.HTTPRequest val, response': courier.HTTPResponse val) =>
                    self.on_response_received(request', response', handler)
                })
            else
                break
            end
        end

        if (_requests_remaining == 0) and (_queue.size() > 0) then
            _restarting = true
            let delay =
                match _rate_limit
                | let rate_limit: _RateLimit =>
                    time.Nanos.from_seconds_f(rate_limit.reset_after_s)
                else
                    0
                end
            _timers(time.Timer(_BucketRestart(this), delay))
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

class iso _BucketRestart is time.TimerNotify
    let _bucket: Bucket

    new iso create(bucket: Bucket) =>
        _bucket = bucket

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _bucket._restart()
        false

class iso _GlobalBucketOpen is time.TimerNotify
    let _bucket: GlobalBucket

    new iso create(bucket: GlobalBucket) =>
        _bucket = bucket

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _bucket._open_window()
        false

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

        // A global rate limit only sends `retry-after`, so a response is worth
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

primitive _BucketConstants
    fun major_parameters(): Array[String] val =>
        """
        The route segments whose id decides which bucket a request falls in.
        """

        ["channels"; "guilds"; "webhooks"]

primitive _RateLimitConstants
    fun global_rate_limit_max_count(): USize =>
        """
        How many requests can be made to the API.
        """

        50

    fun global_rate_limit_window_ms(): USize =>
        """
        What window of time the requests can be made to the API in.
        """

        1000 // 1 second

    fun cloudflare_rate_limit_max_count(): USize =>
        """
        How many requests can be made via Cloudflare's proxy.
        """

        10_000

    fun cloudflare_rate_limit_window_ms(): USize =>
        """
        What window of time the requests can be made via Cloudflare's proxy in.
        """

        10 * 60 * 1000 // 10 minutes

    fun global_header_name(): String => "X-RateLimit-Global".lower()

    fun scope_header_name(): String => "X-RateLimit-Scope".lower()
