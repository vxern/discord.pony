use "debug"
use random = "random"
use time = "time"
use courier = "courier"

actor GlobalBucket
    let _api: RestApi
    let _options: RestOptions
    let _timers: time.Timers
    embed _queue: _Queue[
        (courier.HTTPRequest, RawResponseHandler, RawFailureHandler)
    ] =
        _Queue[(courier.HTTPRequest, RawResponseHandler, RawFailureHandler)]

    // A request only goes out if every window has room for it.
    let _windows: Array[_RateLimitWindow] = _RateLimitConstants.windows()

    var _disposed: Bool = false
    var _paused: Bool = false
    var _paused_until: U64 = 0
    var _pause_generation: USize = 0
    var _drain_scheduled: Bool = false

    new create(api: RestApi, options: RestOptions, timers: time.Timers) =>
        _api = api
        _options = options
        _timers = timers

    be enqueue(
        request: courier.HTTPRequest,
        handler: RawResponseHandler,
        on_failure: RawFailureHandler
    ) =>
        if _disposed then
            Debug.out(
                "[rest/global] dropping a request: the global bucket was "
                + "disposed of"
            )
            on_failure()
            return
        end

        let cap = RestConstants.max_queued_requests()
        if _queue.size() >= cap then
            Debug.out(
                "[rest/global] the queue is full at " + cap.string()
                + ", refusing " + request.method.string() + " " + request.path
            )

            _options.on_error(
                RestError(
                    request, "the global queue is full at " + cap.string()
                )
            )
            on_failure()
            return
        end

        _queue.enqueue((request, handler, on_failure))

        Debug.out(
            "[rest/global] queued a request, " + _queue.size().string()
            + " waiting"
        )

        _drain()

    be _pause(seconds: F64) =>
        if _disposed then
            Debug.out(
                "[rest/global] ignoring a pause: the global bucket was "
                + "disposed of"
            )
            return
        end

        let duration = time.Nanos.from_seconds_f(
            seconds.max(_RateLimitConstants.minimum_pause_s())
        )
        let resume_at = time.Time.nanos() + duration

        if _paused and (resume_at <= _paused_until) then
            Debug.out(
                "[rest/global] already paused for longer than the "
                + seconds.string() + "s asked for"
            )
            return
        end

        Debug.out(
            "[rest/global] globally rate limited, pausing everything for "
            + (duration / 1_000_000).string() + "ms"
        )

        _paused = true
        _paused_until = resume_at

        _pause_generation = _pause_generation + 1
        let generation = _pause_generation

        let self: GlobalBucket tag = this
        _timers(
            time.Timer(
                _Elapsed({() => self._resume(generation)}),
                duration
            )
        )

    be _resume(generation: USize) =>
        if generation != _pause_generation then
            Debug.out(
                "[rest/global] ignoring a stale resume from pause "
                + generation.string()
            )
            return
        end

        Debug.out(
            "[rest/global] the global pause is over, " + _queue.size().string()
            + " request(s) to work through"
        )

        _paused = false
        _drain()

    be dispose() =>
        Debug.out(
            "[rest/global] disposing, failing " + _queue.size().string()
            + " queued request(s)"
        )

        _disposed = true

        while _queue.size() > 0 do
            try
                (let request, let handler, let on_failure) = _queue.dequeue()?
                on_failure()
            else
                break
            end
        end

        _queue.clear()

    be _wake() =>
        Debug.out("[rest/global] woken up to drain the queue")

        _drain_scheduled = false
        _drain()

    fun ref _drain() =>
        if _disposed then
            Debug.out(
                "[rest/global] not draining: the global bucket was disposed of"
            )
            return
        end

        if _paused then
            Debug.out(
                "[rest/global] not draining: paused with "
                + _queue.size().string()
                + " request(s) held"
            )
            return
        end

        while _queue.size() > 0 do
            let now = time.Time.nanos()

            match _blocked_until(now)
            | let at: U64 =>
                Debug.out(
                    "[rest/global] out of budget, holding "
                    + _queue.size().string()
                    + " request(s) for " + (
                        (at - now) / 1_000_000
                    ).string() + "ms"
                )

                if not _drain_scheduled then
                    _drain_scheduled = true
                    let self: GlobalBucket tag = this
                    _timers(
                        time.Timer(_Elapsed({() => self._wake()}), at - now)
                    )
                end

                return
            end

            try
                (let request, let handler, let on_failure) = _queue.dequeue()?

                for window in _windows.values() do
                    window.spend(now)
                end

                Debug.out(
                    "[rest/global] releasing a request, "
                    + _queue.size().string()
                    + " left in the queue"
                )

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

type _QueuedRequest is
    (courier.HTTPRequest, RawResponseHandler, String, USize)

actor Bucket
    let _api: RestApi
    let _options: RestOptions
    let _global_bucket: GlobalBucket
    let _id: String
    let _timers: time.Timers
    let _rand: random.Rand
    embed _queue: _Queue[_QueuedRequest] = _Queue[_QueuedRequest]

    var _rate_limit: (_RateLimit | None) = None
    var _requests_outstanding: USize = 0
    var _requests_remaining: USize = 1

    var _disposed: Bool = false
    var _restarting: Bool = false

    new create(
        api: RestApi,
        options: RestOptions,
        global_bucket: GlobalBucket,
        id: String,
        timers: time.Timers
    ) =>
        _api = api
        _options = options
        _global_bucket = global_bucket
        _id = id
        _timers = timers

        (let seconds, let nanoseconds) = time.Time.now()
        _rand = random.Rand(seconds.u64(), nanoseconds.u64())

    be enqueue(
        request: courier.HTTPRequest,
        handler: RawResponseHandler,
        route: String
    ) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] dropping a request: the bucket was disposed of"
            )

            _options.on_error(
                RestError(request, "the bucket was disposed of")
            )

            return
        end

        let cap = RestConstants.max_queued_requests_per_bucket()
        if _queue.size() >= cap then
            Debug.out(
                "[rest/" + _id + "] the queue is full at " + cap.string()
                + ", refusing " + request.method.string() + " " + request.path
            )

            _options.on_error(
                RestError(
                    request, "the bucket queue is full at " + cap.string()
                )
            )

            return
        end

        _queue.enqueue((request, handler, route, 0))

        Debug.out(
            "[rest/" + _id + "] queued a request, " + _queue.size().string()
            + " waiting, " + _requests_remaining.string() + " slot(s) left"
        )

        _drain()

    be sweep_if_idle() =>
        if _disposed then return end

        if
            (_queue.size() > 0) or (_requests_outstanding > 0) or _restarting
        then
            Debug.out(
                "[rest/" + _id + "] not sweeping: " + _queue.size().string()
                + " queued, " + _requests_outstanding.string()
                + " outstanding"
            )

            _api._bucket_busy(_id)

            return
        end

        Debug.out("[rest/" + _id + "] idle, letting the bucket go")

        _disposed = true
        _api._bucket_swept(_id)

    be dispose() =>
        Debug.out(
            "[rest/" + _id + "] disposing, failing " + _queue.size().string()
            + " queued request(s)"
        )

        _disposed = true

        while _queue.size() > 0 do
            try
                (let request, let handler, let route, let attempts) =
                    _queue.dequeue()?

                _options.on_error(
                    RestError(request, "the bucket was disposed of")
                )
            else
                break
            end
        end

        _queue.clear()

    be _drain() =>
        if _disposed then
            Debug.out(
                "[rest/" + _id + "] not draining: the bucket was disposed of"
            )
            return
        end

        if _restarting then
            Debug.out(
                "[rest/" + _id
                + "] not draining: waiting on the window to reset"
            )
            return
        end

        let self: Bucket tag = this

        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                (let request, let handler, let route, let attempts) =
                    _queue.dequeue()?

                _requests_outstanding = _requests_outstanding + 1
                _requests_remaining = _requests_remaining - 1

                Debug.out(
                    "[rest/" + _id
                    + "] handing a request to the global bucket, "
                    + _requests_outstanding.string() + " outstanding, "
                    + _requests_remaining.string() + " slot(s) left"
                )

                _global_bucket.enqueue(
                    request,
                    {(
                        request': courier.HTTPRequest val,
                        response': courier.HTTPResponse val
                    ) =>
                        self.on_response_received(
                            request', response', handler, route, attempts
                        )
                    },
                    {() =>
                        self.on_request_failed(
                            request, handler, route, attempts
                        )
                    }
                )
            else
                break
            end
        end

        if (_requests_outstanding == 0) and (_requests_remaining == 0) and (
            _queue.size() > 0
        ) then
            _restarting = true
            let rest_s =
                try
                    (_rate_limit as _RateLimit).reset_after_s
                else
                    0
                end
            let delay =
                time.Nanos.from_seconds_f(
                    rest_s.max(_RateLimitConstants.minimum_rest_s())
                )

            Debug.out(
                "[rest/" + _id + "] out of slots with " + _queue.size().string()
                + " request(s) queued, resting for "
                + (delay / 1_000_000).string() + "ms"
            )

            _timers(time.Timer(_Elapsed({() => self._restart()}), delay))
        end

    be _restart() =>
        Debug.out(
            "[rest/" + _id + "] the window reset, probing with one request"
        )

        _restarting = false
        _rate_limit = None
        _requests_remaining = 1
        _drain()

    be on_request_failed(
        request: courier.HTTPRequest,
        handler: RawResponseHandler,
        route: String,
        attempts: USize
    ) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] dropping a failure: the bucket was disposed of"
            )
            return
        end

        Debug.out("[rest/" + _id + "] a request never came back")

        _requests_outstanding = _requests_outstanding - 1

        _retry(request, handler, route, attempts, "it never came back")

        _drain()

    be _requeue(
        request: courier.HTTPRequest,
        handler: RawResponseHandler,
        route: String,
        attempts: USize
    ) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] abandoning a retry: the bucket was disposed of"
            )
            return
        end

        Debug.out(
            "[rest/" + _id + "] retrying " + request.method.string() + " "
            + request.path
        )

        _queue.enqueue_at_beginning((request, handler, route, attempts))
        _drain()

    be on_response_received(
        request: courier.HTTPRequest,
        response: courier.HTTPResponse,
        handler: RawResponseHandler,
        route: String,
        attempts: USize
    ) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] dropping a response: the bucket was disposed of"
            )
            return
        end

        _requests_outstanding = _requests_outstanding - 1

        let rate_limit = try _RateLimit.from_headers(response.headers)? end

        match rate_limit
        | let rate_limit': _RateLimit =>
            match rate_limit'.bucket
            | let hash: String =>
                _api._bucket_hash_learned(
                    route, hash, hash + "|" + _MajorParameter(request), _id
                )
            end
        end

        match rate_limit
        | let rate_limit': _RateLimit if rate_limit'.is_newer_than(
            _rate_limit
        ) =>
            _rate_limit = rate_limit'
            _requests_remaining =
                rate_limit'.remaining - _requests_outstanding.min(
                    rate_limit'.remaining
                )

            Debug.out(
                "[rest/" + _id + "] the headers say "
                + rate_limit'.remaining.string()
                + " left, resetting in " + rate_limit'.reset_after_s.string()
                + "s, so " + _requests_remaining.string()
                + " slot(s) after the " + _requests_outstanding.string()
                + " outstanding"
            )
        | let _: _RateLimit =>
            Debug.out(
                "[rest/"
                + _id
                + "] ignoring rate limit headers that are older than what we "
                + "hold"
            )
        else
            Debug.out(
                "[rest/" + _id + "] the response carried no rate limit headers"
            )
        end

        if response.status == 429 then
            Debug.out(
                "[rest/" + _id + "] 429 on " + request.method.string() + " "
                + request.path + ", putting it back at the front of the queue"
            )

            _queue.enqueue_at_beginning((request, handler, route, attempts))
            _requests_remaining = 0

            if _IsGlobalRateLimit(response.headers) then
                Debug.out(
                    "[rest/" + _id + "] the 429 is global, pausing every bucket"
                )
                _global_bucket._pause(
                    match rate_limit
                    | let rate_limit': _RateLimit => rate_limit'.reset_after_s
                    else
                        _RateLimitConstants.blind_pause_s()
                    end
                )
            else
                Debug.out(
                    "[rest/" + _id
                    + "] the 429 is route-scoped, only this bucket rests"
                )
            end
        else
            let retrying =
                _IsRetriable(response.status)
                    and _retry(
                        request,
                        handler,
                        route,
                        attempts,
                        "Discord answered " + response.status.string() + " "
                        + response.reason
                    )

            if not retrying then
                Debug.out(
                    "[rest/" + _id + "] handing " + response.status.string()
                    + " on "
                    + request.method.string() + " " + request.path
                    + " to the caller"
                )
                handler(request, response)
            end
        end

        _drain()

    fun ref _retry(
        request: courier.HTTPRequest,
        handler: RawResponseHandler,
        route: String,
        attempts: USize,
        reason: String
    ): Bool =>
        let attempts' = attempts + 1

        if attempts' >= RestConstants.max_attempts() then
            Debug.out(
                "[rest/" + _id + "] giving up on " + request.method.string()
                + " " + request.path + " after " + attempts'.string()
                + " attempt(s): " + reason
            )

            return false
        end

        let delay = _Backoff(attempts', _rand.real())

        Debug.out(
            "[rest/" + _id + "] " + request.method.string() + " "
            + request.path + " goes again in " + (delay / 1_000_000).string()
            + "ms, attempt " + (attempts' + 1).string() + " of "
            + RestConstants.max_attempts().string() + ": " + reason
        )

        let self: Bucket tag = this
        _timers(
            time.Timer(
                _Elapsed(
                    {() => self._requeue(request, handler, route, attempts')}
                ),
                delay
            )
        )

        true

primitive _BucketId
    fun apply(request: courier.HTTPRequest val): String =>
        let path = try request.path.split_by("?")(0)? else request.path end
        let segments: Array[String] ref = path.split_by("/")
        let normalised = Array[String](segments.size())

        for (index, segment) in segments.pairs() do
            let previous =
                if index == 0 then
                    ""
                else
                    try segments(index - 1)? else "" end
                end
            let major =
                _BucketConstants.major_parameters().contains(
                    previous, {(a, b) => a == b}
                )

            normalised.push(
                if _is_id(segment) and not major then "*" else segment end
            )
        end

        request.method.string() + "/".join(normalised.values())

    fun _is_id(segment: String box): Bool =>
        if segment.size() == 0 then return false end

        for character in segment.values() do
            if (character < '0') or (character > '9') then return false end
        end

        true

primitive _MajorParameter
    fun apply(request: courier.HTTPRequest val): String =>
        """
        The `collection/id` pair a request is scoped to, which Discord counts
        separately even when two routes share a bucket.
        """

        let path = try request.path.split_by("?")(0)? else request.path end
        let segments: Array[String] ref = path.split_by("/")

        for (index, segment) in segments.pairs() do
            if
                _BucketConstants.major_parameters().contains(
                    segment, {(a, b) => a == b}
                )
            then
                return
                    try segment + "/" + segments(index + 1)? else segment end
            end
        end

        ""

primitive _BucketConstants
    fun major_parameters(): Array[String] val =>
        """
        The route segments whose id decides which bucket a request falls in.
        """

        ["channels"; "guilds"; "webhooks"]
