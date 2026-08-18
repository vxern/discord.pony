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

class val _QueuedRequest
    let request: courier.HTTPRequest val
    let handler: RawResponseHandler
    let route: String
    let attempts: USize
        """
        How many times the request has been sent and come back as a hiccup on
        Discord's side, rather than as an answer.
        """
    let rate_limit_attempts: USize
        """
        How many times the request has come back 429. Counted apart from
        `attempts`, since being told to wait is not the request failing.
        """

    new val create(
        request': courier.HTTPRequest val,
        handler': RawResponseHandler,
        route': String,
        attempts': USize = 0,
        rate_limit_attempts': USize = 0
    ) =>
        request = request'
        handler = handler'
        route = route'
        attempts = attempts'
        rate_limit_attempts = rate_limit_attempts'

    fun val retried(): _QueuedRequest =>
        _QueuedRequest(
            request, handler, route, attempts + 1, rate_limit_attempts
        )

    fun val throttled(): _QueuedRequest =>
        _QueuedRequest(
            request, handler, route, attempts, rate_limit_attempts + 1
        )

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
    var _swept: Bool = false
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
        request: courier.HTTPRequest val,
        handler: RawResponseHandler,
        route: String
    ) =>
        _admit(_QueuedRequest(request, handler, route))

    be adopt(job: _QueuedRequest) =>
        """
        Takes on a request another bucket was holding for the same limit,
        keeping the counts it has already run up.
        """

        _admit(job)

    be migrate_to(target: Bucket) =>
        """
        Hands everything still queued to the bucket that already serves this
        limit, so two of them do not spend the same budget.
        """

        if _disposed then return end

        Debug.out(
            "[rest/" + _id + "] handing " + _queue.size().string()
            + " queued request(s) to the bucket that already serves its limit"
        )

        while _queue.size() > 0 do
            try target.adopt(_queue.dequeue()?) else break end
        end

    fun ref _admit(job: _QueuedRequest) =>
        if _swept then
            Debug.out(
                "[rest/" + _id + "] handing " + job.request.method.string()
                + " " + job.request.path
                + " back: the bucket went away before it arrived"
            )

            _api._readmit(job)

            return
        end

        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] dropping a request: the bucket was disposed of"
            )

            _options.on_error(
                RestError(job.request, "the bucket was disposed of")
            )

            return
        end

        let cap = RestConstants.max_queued_requests_per_bucket()
        if _queue.size() >= cap then
            Debug.out(
                "[rest/" + _id + "] the queue is full at " + cap.string()
                + ", refusing " + job.request.method.string() + " "
                + job.request.path
            )

            _options.on_error(
                RestError(
                    job.request, "the bucket queue is full at " + cap.string()
                )
            )

            return
        end

        _queue.enqueue(job)

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

            _api._bucket_busy(this)

            return
        end

        Debug.out("[rest/" + _id + "] idle, letting the bucket go")

        _disposed = true
        _swept = true
        _api._bucket_swept(this)

    be dispose() =>
        Debug.out(
            "[rest/" + _id + "] disposing, failing " + _queue.size().string()
            + " queued request(s)"
        )

        _disposed = true

        while _queue.size() > 0 do
            try
                _options.on_error(
                    RestError(
                        _queue.dequeue()?.request, "the bucket was disposed of"
                    )
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
                let job = _queue.dequeue()?

                _requests_outstanding = _requests_outstanding + 1
                _requests_remaining = _requests_remaining - 1

                Debug.out(
                    "[rest/" + _id
                    + "] handing a request to the global bucket, "
                    + _requests_outstanding.string() + " outstanding, "
                    + _requests_remaining.string() + " slot(s) left"
                )

                _global_bucket.enqueue(
                    job.request,
                    {(
                        request': courier.HTTPRequest val,
                        response': courier.HTTPResponse val
                    ) =>
                        self.on_response_received(response', job)
                    },
                    {() => self.on_request_failed(job)}
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

    be on_request_failed(job: _QueuedRequest) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] dropping a failure: the bucket was disposed of"
            )

            _options.on_error(
                RestError(job.request, "the bucket was disposed of")
            )

            return
        end

        Debug.out("[rest/" + _id + "] a request never came back")

        _requests_outstanding = _requests_outstanding - 1

        if not _retry(job, "it never came back") then
            _options.on_error(
                RestError(
                    job.request,
                    "it never came back, and gave up after "
                    + RestConstants.max_attempts().string() + " attempt(s)"
                )
            )
        end

        _drain()

    be _requeue(job: _QueuedRequest) =>
        if _disposed then
            Debug.out(
                "[rest/" + _id
                + "] abandoning a retry: the bucket was disposed of"
            )

            _options.on_error(
                RestError(job.request, "the bucket was disposed of")
            )

            return
        end

        Debug.out(
            "[rest/" + _id + "] retrying " + job.request.method.string() + " "
            + job.request.path
        )

        _queue.enqueue_at_beginning(job)
        _drain()

    be on_response_received(
        response: courier.HTTPResponse val,
        job: _QueuedRequest
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
                    job.route,
                    hash,
                    hash + "|" + _MajorParameter(job.request),
                    _id
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
            let throttled = job.rate_limit_attempts + 1
            let giving_up =
                throttled >= RestConstants.max_rate_limit_attempts()

            _requests_remaining = 0

            if giving_up then
                Debug.out(
                    "[rest/" + _id + "] 429 on " + job.request.method.string()
                    + " " + job.request.path + " for the " + throttled.string()
                    + " time, handing it to the caller rather than waiting on "
                    + "a limit that is not lifting"
                )
            else
                Debug.out(
                    "[rest/" + _id + "] 429 on " + job.request.method.string()
                    + " " + job.request.path
                    + ", putting it back at the front of the queue"
                )

                _queue.enqueue_at_beginning(job.throttled())
            end

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

            if giving_up then job.handler(job.request, response) end
        else
            let retrying =
                _IsRetriable(response.status, job.request.method)
                    and _retry(
                        job,
                        "Discord answered " + response.status.string() + " "
                        + response.reason
                    )

            if not retrying then
                Debug.out(
                    "[rest/" + _id + "] handing " + response.status.string()
                    + " on " + job.request.method.string() + " "
                    + job.request.path + " to the caller"
                )
                job.handler(job.request, response)
            end
        end

        _drain()

    fun ref _retry(job: _QueuedRequest, reason: String): Bool =>
        let retried = job.retried()

        if retried.attempts >= RestConstants.max_attempts() then
            Debug.out(
                "[rest/" + _id + "] giving up on "
                + job.request.method.string() + " " + job.request.path
                + " after " + retried.attempts.string() + " attempt(s): "
                + reason
            )

            return false
        end

        let delay = _Backoff(retried.attempts, _rand.real())

        Debug.out(
            "[rest/" + _id + "] " + job.request.method.string() + " "
            + job.request.path + " goes again in "
            + (delay / 1_000_000).string() + "ms, attempt "
            + (retried.attempts + 1).string() + " of "
            + RestConstants.max_attempts().string() + ": " + reason
        )

        let self: Bucket tag = this
        _timers(
            time.Timer(_Elapsed({() => self._requeue(retried)}), delay)
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
