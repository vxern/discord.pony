use "../data"
use "debug"
use files = "files"
use collections = "collections"
use time = "time"
use courier = "courier"
use lori = "lori"
use ssl = "ssl/net"

type ResponseHandler[A: Any val] is {(A)} val

type EmptyResponseHandler is {()} val

type RawResponseHandler is {
    (courier.HTTPRequest val, courier.HTTPResponse val)
} val

type RawFailureHandler is {()} val

primitive _Redacted
    """
    Drops the credential from a copy of the headers, so an error handed to the
    caller cannot carry the bot token into a log.
    """

    fun apply(headers: courier.Headers val): courier.Headers val =>
        recover val
            let safe = courier.Headers

            for (name, value) in headers.values() do
                if name != "authorization" then safe.set(name, value) end
            end

            safe
        end

primitive _RedactedPath
    """
    Masks the webhook and interaction tokens a path carries, which stand in for
    the credential just as the header does.
    """

    fun apply(path: String val): String val =>
        let segments: Array[String] ref = path.split_by("/")
        var redacted = false

        for (index, segment) in segments.pairs() do
            if
                (segment == "webhooks") or (segment == "interactions")
            then
                try
                    segments(index + 2)? = "*"
                    redacted = true
                end
            end
        end

        if not redacted then return path end

        "/".join(segments.values())

class val RestError
    let request: courier.HTTPRequest val
    let reason: String

    new val create(request': courier.HTTPRequest val, reason': String) =>
        request = courier.HTTPRequest(
            request'.method,
            _RedactedPath(request'.path),
            _Redacted(request'.headers),
            request'.body
        )
        reason = reason'

    fun string(): String =>
        request.method.string() + " " + request.path + ": " + reason

type RestErrorHandler is {(RestError)} val

class Rest
    let options: RestOptions
    let api: RestApi
    let routes: Routes

    new create(env: Env, options': RestOptions) =>
        options = options'
        api = RestApi(env, options')
        routes = Routes(api, options')

    fun dispose() => api.dispose()

class val _RequestJob
    let request: courier.HTTPRequest val
    let handler: RawResponseHandler
    let on_failure: RawFailureHandler

    new val create(
        request': courier.HTTPRequest val,
        handler': RawResponseHandler,
        on_failure': RawFailureHandler
    ) =>
        request = request'
        handler = handler'
        on_failure = on_failure'

actor RestApi
    let options: RestOptions
    let _auth: lori.TCPConnectAuth
    let _ssl_context: (ssl.SSLContext val | None)
    let _timers: time.Timers = time.Timers

    embed _buckets: collections.Map[String, Bucket] =
        collections.Map[String, Bucket]
    embed _bucket_used: collections.Map[String, U64] =
        collections.Map[String, U64]
    embed _hashes: collections.Map[String, String] =
        collections.Map[String, String]
    embed _route_used: collections.Map[String, U64] =
        collections.Map[String, U64]

    embed _senders: collections.SetIs[_RequestSender tag] =
        collections.SetIs[_RequestSender tag]
    embed _idle_senders: collections.SetIs[_RequestSender tag] =
        collections.SetIs[_RequestSender tag]
    embed _pending: _Queue[_RequestJob] = _Queue[_RequestJob]

    let _global_bucket: GlobalBucket
    var _disposed: Bool = false

    new create(env: Env, options': RestOptions) =>
        options = options'
        _auth = lori.TCPConnectAuth(env.root)
        _ssl_context =
            try
                recover val
                    ssl.SSLContext
                    .> set_client_verify(true)
                    .> set_authority(
                        files.FilePath(
                            files.FileAuth(env.root),
                            options'.ca_certificates_path
                        )
                    )?
                end
            end
        _global_bucket = GlobalBucket(this, options', _timers)

        Debug.out(
            "[rest] starting up on api v" + options.version.value().string()
            + " against " + RestConstants.host()
        )

        if _ssl_context is None then
            Debug.out(
                "[rest] could not build an SSL context from "
                + options.ca_certificates_path
            )
        end

        let self: RestApi tag = this
        let sweep = time.Nanos.from_millis(RestConstants.bucket_sweep_ms())
        _timers(
            time.Timer(_Elapsed({() => self._sweep()}, true), sweep, sweep)
        )

    be send_request(
        request: courier.HTTPRequest val,
        handler: RawResponseHandler
    ) =>
        if _disposed then
            Debug.out(
                "[rest] dropping " + request.method.string() + " "
                + request.path + ": the client was disposed of"
            )
            options.on_error(RestError(request, "the client was disposed of"))
            return
        end

        let route = _BucketId(request)
        let id = _bucket_key(route, request)
        let now = time.Time.nanos()

        _route_used(route) = now
        _bucket_used(id) = now

        let bucket =
            try
                _buckets(id)?
            else
                Debug.out("[rest] opening a new bucket for " + id)
                let bucket' = Bucket(this, options, _global_bucket, id, _timers)
                _buckets(id) = bucket'
                bucket'
            end

        Debug.out(
            "[rest] " + request.method.string() + " " + request.path
            + " goes to bucket " + id
        )

        bucket.enqueue(request, handler, route)

    be dispose() =>
        Debug.out(
            "[rest] disposing of " + _buckets.size().string()
            + " bucket(s), " + _senders.size().string() + " connection(s) and "
            + _pending.size().string() + " queued request(s)"
        )

        _disposed = true

        for bucket in _buckets.values() do bucket.dispose() end
        _buckets.clear()
        _bucket_used.clear()
        _hashes.clear()
        _route_used.clear()

        for sender in _senders.values() do sender.dispose() end
        _senders.clear()
        _idle_senders.clear()

        while _pending.size() > 0 do
            try _pending.dequeue()?.on_failure() else break end
        end

        _pending.clear()

        _global_bucket.dispose()
        _timers.dispose()

    be _bucket_hash_learned(
        route: String,
        hash: String,
        key: String,
        from_id: String
    ) =>
        if _disposed then return end

        if try _hashes(route)? == hash else false end then return end

        Debug.out("[rest] " + route + " is served by bucket " + hash)

        _hashes(route) = hash

        if from_id == key then return end

        let source =
            match try _buckets(from_id)? end
            | let bucket: Bucket => bucket
            else
                return
            end

        match try _buckets(key)? end
        | let target: Bucket =>
            Debug.out(
                "[rest] bucket " + from_id + " shares a limit with " + key
                + ", handing its queue over rather than running both"
            )

            source.migrate_to(target)
        else
            Debug.out(
                "[rest] moving bucket " + from_id + " to " + key
                + " rather than opening a second one for the same limit"
            )

            _buckets(key) = source
        end

        _bucket_used(key) = time.Time.nanos()

        try _buckets.remove(from_id)? end
        try _bucket_used.remove(from_id)? end

    be _sender_idle(sender: _RequestSender tag) =>
        if _disposed then return end

        try
            let job = _pending.dequeue()?

            Debug.out(
                "[rest] a connection came free, handing it a queued request, "
                + _pending.size().string() + " still waiting"
            )

            sender.assign(job)
        else
            _idle_senders.set(sender)

            Debug.out(
                "[rest] a connection came free, " + _idle_senders.size().string()
                + " of " + _senders.size().string() + " now idle"
            )
        end

    be _sender_closed(sender: _RequestSender tag) =>
        if _disposed then return end

        _senders.unset(sender)
        _idle_senders.unset(sender)

        Debug.out(
            "[rest] a connection went away, " + _senders.size().string()
            + " left"
        )

        _open_for_pending()

    be _sweep() =>
        if _disposed then return end

        let now = time.Time.nanos()
        let ttl = time.Nanos.from_millis(RestConstants.bucket_ttl_ms())

        let buckets = Array[String]
        for (id, at) in _bucket_used.pairs() do
            if (now - at) > ttl then buckets.push(id) end
        end

        for id in buckets.values() do
            try _buckets(id)?.sweep_if_idle() end
        end

        let routes = Array[String]
        for (route, at) in _route_used.pairs() do
            if (now - at) > ttl then routes.push(route) end
        end

        for route in routes.values() do
            try _hashes.remove(route)? end
            try _route_used.remove(route)? end
        end

        if (buckets.size() > 0) or (routes.size() > 0) then
            Debug.out(
                "[rest] asked " + buckets.size().string()
                + " idle bucket(s) to go and dropped " + routes.size().string()
                + " route mapping(s), " + _buckets.size().string()
                + " bucket(s) left"
            )
        end

    be _bucket_busy(id: String) =>
        if _disposed then return end

        _bucket_used(id) = time.Time.nanos()

    be _bucket_swept(id: String) =>
        if _disposed then return end

        try _buckets.remove(id)? end
        try _bucket_used.remove(id)? end

        Debug.out(
            "[rest] a bucket went away, " + _buckets.size().string() + " left"
        )

    be _raw_send_request(
        request: courier.HTTPRequest val,
        handler: RawResponseHandler,
        on_failure: RawFailureHandler
    ) =>
        if _disposed then
            Debug.out(
                "[rest] cannot send " + request.method.string() + " "
                + request.path + ": the client was disposed of"
            )
            on_failure()
            return
        end

        match _ssl_context
        | let ssl_context: ssl.SSLContext val =>
            Debug.out(
                "[rest] sending " + request.method.string() + " " + request.path
            )
            _assign(_RequestJob(request, handler, on_failure), ssl_context)
        else
            Debug.out(
                "[rest] cannot send " + request.method.string() + " "
                + request.path
                + ": there is no SSL context"
            )
            options.on_error(
                RestError(
                    request,
                    "no certificate authority at "
                    + options.ca_certificates_path
                )
            )
            on_failure()
        end

    fun _bucket_key(route: String, request: courier.HTTPRequest val): String =>
        try
            _hashes(route)? + "|" + _MajorParameter(request)
        else
            route
        end

    fun ref _assign(job: _RequestJob, ssl_context: ssl.SSLContext val) =>
        match try _idle_senders.values().next()? end
        | let sender: _RequestSender tag =>
            _idle_senders.unset(sender)

            Debug.out(
                "[rest] reusing an open connection, "
                + _idle_senders.size().string() + " idle left"
            )

            sender.assign(job)
            return
        end

        if _senders.size() < RestConstants.max_connections() then
            Debug.out(
                "[rest] opening connection " + (_senders.size() + 1).string()
                + " of " + RestConstants.max_connections().string()
            )

            _senders.set(_RequestSender(this, _auth, ssl_context, options, job))
            return
        end

        let cap = RestConstants.max_queued_requests()
        if _pending.size() >= cap then
            Debug.out(
                "[rest] every connection is busy and the queue is full at "
                + cap.string() + ", refusing "
                + job.request.method.string() + " " + job.request.path
            )

            options.on_error(
                RestError(
                    job.request, "the connection queue is full at "
                    + cap.string()
                )
            )
            job.on_failure()
            return
        end

        _pending.enqueue(job)

        Debug.out(
            "[rest] every connection is busy, queued a request, "
            + _pending.size().string() + " waiting"
        )

    fun ref _open_for_pending() =>
        match _ssl_context
        | let ssl_context: ssl.SSLContext val =>
            while
                (_pending.size() > 0)
                    and (_senders.size() < RestConstants.max_connections())
            do
                try
                    let job = _pending.dequeue()?

                    Debug.out(
                        "[rest] opening a connection for a queued request, "
                        + _pending.size().string() + " still waiting"
                    )

                    _senders.set(
                        _RequestSender(this, _auth, ssl_context, options, job)
                    )
                else
                    return
                end
            end
        end

actor _RequestSender is courier.HTTPClientConnectionActor
    var _http: courier.HTTPClientConnection =
        courier.HTTPClientConnection.none()
    var _collector: courier.ResponseCollector = courier.ResponseCollector
    let _api: RestApi
    let _options: RestOptions

    var _job: (_RequestJob | None)
    var _connected: Bool = false
    var _closed: Bool = false
    var _deadline: (lori.TimerToken | None) = None

    new create(
        api: RestApi,
        auth: lori.TCPConnectAuth,
        ssl_context: ssl.SSLContext val,
        options: RestOptions,
        job: _RequestJob
    ) =>
        _api = api
        _options = options
        _job = job
        _http = courier.HTTPClientConnection.ssl(
            auth,
            ssl_context,
            RestConstants.host(),
            RestConstants.port(),
            this,
            _ConnectionConfig()
        )

    fun ref _http_client_connection(): courier.HTTPClientConnection => _http

    be assign(job: _RequestJob) =>
        if _closed then
            Debug.out(
                "[rest] " + job.request.method.string() + " "
                + job.request.path
                + " landed on a connection that has gone, handing it back"
            )
            job.on_failure()
            return
        end

        if _job isnt None then
            Debug.out(
                "[rest] " + job.request.method.string() + " "
                + job.request.path
                + " landed on a connection already working on one, handing it "
                + "back"
            )
            job.on_failure()
            return
        end

        _job = job

        if _connected then _write() end

    be dispose() =>
        Debug.out("[rest] disposing of a connection")

        _closed = true
        _connected = false
        _cancel_deadline()

        match _job = None
        | let job: _RequestJob => job.on_failure()
        end

        _http.close()

    fun ref on_connected() =>
        Debug.out("[rest] a connection is up")

        _connected = true

        if _job isnt None then _write() end

    fun ref on_response(response: courier.Response val) =>
        Debug.out("[rest] " + response.status.string() + " on the wire")

        _collector = courier.ResponseCollector
        _collector.set_response(response)

    fun ref on_body_chunk(chunk: Array[U8] val) =>
        Debug.out(
            "[rest] read a body chunk of " + chunk.size().string() + " bytes"
        )
        _collector.add_chunk(chunk)

    fun ref on_response_complete() =>
        _cancel_deadline()

        match _job = None
        | let job: _RequestJob =>
            try
                let response = _collector.build()?

                Debug.out(
                    "[rest] the response to " + job.request.method.string()
                    + " " + job.request.path + " is complete"
                )

                job.handler(job.request, response)
            else
                Debug.out(
                    "[rest] the response to " + job.request.method.string()
                    + " " + job.request.path + " could not be assembled"
                )

                _options.on_error(
                    RestError(job.request, "response could not be assembled")
                )
                job.on_failure()
            end
        end

        if not _closed then _api._sender_idle(this) end

    fun ref on_connection_failure(reason: courier.ConnectionFailureReason) =>
        _shutdown(reason.string())

    fun ref on_parse_error(err: courier.ParseError) =>
        _shutdown(err.string())

    fun ref on_closed() =>
        _shutdown("connection closed before a response arrived")

    fun ref on_timer(token: lori.TimerToken) =>
        _deadline = None
        _shutdown(
            "no response inside "
            + RestConstants.response_timeout_ms().string() + "ms"
        )

    fun ref on_timer_failure() =>
        Debug.out("[rest] the response deadline could not be armed")
        _deadline = None

    fun ref _write() =>
        match _job
        | let job: _RequestJob =>
            Debug.out(
                "[rest] writing " + job.request.method.string() + " "
                + job.request.path
            )

            match _http.send_request(job.request)
            | let _: courier.SendRequestError =>
                _shutdown("the request could not be written")
            else
                _arm_deadline()
            end
        end

    fun ref _shutdown(reason: String) =>
        let first = not _closed

        _closed = true
        _connected = false

        _cancel_deadline()

        match _job = None
        | let job: _RequestJob =>
            Debug.out(
                "[rest] " + job.request.method.string() + " "
                + job.request.path + " failed: " + reason
            )

            _options.on_error(RestError(job.request, reason))
            job.on_failure()
        end

        _http.close()

        if first then _api._sender_closed(this) end

    fun ref _arm_deadline() =>
        match lori.MakeTimerDuration(RestConstants.response_timeout_ms())
        | let duration: lori.TimerDuration =>
            match _http.set_timer(duration)
            | let token: lori.TimerToken => _deadline = token
            end
        end

    fun ref _cancel_deadline() =>
        match _deadline = None
        | let token: lori.TimerToken => _http.cancel_timer(token)
        end

primitive RestConstants
    fun host(): String => "discord.com"

    fun port(): String => "443"

    fun connect_timeout_ms(): U64 => 15_000

    fun response_timeout_ms(): U64 => 30_000

    fun max_connections(): USize => 20

    fun max_queued_requests(): USize => 10_000

    fun max_queued_requests_per_bucket(): USize => 1_000

    fun max_attempts(): USize => 3

    fun max_rate_limit_attempts(): USize =>
        """
        How many times a request is put back after a 429 before the status is
        handed to the caller instead.

        A 429 is not the request failing, so it is counted apart from
        `max_attempts`, but a route that keeps answering 429 however long the
        bucket rests is not going to start answering anything else.
        """

        5

    fun base_backoff_ms(): U64 => 500

    fun max_backoff_exponent(): USize => 4

    fun bucket_ttl_ms(): U64 =>
        """
        How long a bucket goes unused before it is forgotten, so a long-lived
        client does not hold one per channel it has ever touched.
        """

        600_000

    fun bucket_sweep_ms(): U64 => 60_000

primitive _ConnectionConfig
    fun apply(): courier.ClientConnectionConfig =>
        let connect_timeout =
            match lori.MakeConnectionTimeout(
                RestConstants.connect_timeout_ms()
            )
            | let timeout: lori.ConnectionTimeout => timeout
            end

        courier.ClientConnectionConfig(
            where connection_timeout' = connect_timeout
        )

primitive RestDefaults
    fun version(): ApiVersion val => ApiVersion10

    fun user_agent(): String =>
        "discord.pony (https://github.com/vxern/discord.pony, 1.0.0)"

    fun ca_certificates_path(): String =>
        ifdef osx then
            "/etc/ssl/cert.pem"
        else
            "/etc/ssl/certs/ca-certificates.crt"
        end

    fun on_error(): RestErrorHandler => { (error': RestError) => None }

class val RestOptions
    let token: String
        """
        The bot token every request is authorised with.
        """
    let version: ApiVersion val
    let user_agent: String
    let ca_certificates_path: String
    let on_error: RestErrorHandler

    new val create(
        token': String,
        version': ApiVersion val = RestDefaults.version(),
        user_agent': String = RestDefaults.user_agent(),
        ca_certificates_path': String = RestDefaults.ca_certificates_path(),
        on_error': RestErrorHandler = RestDefaults.on_error()
    ) =>
        token = token'
        version = version'
        user_agent = user_agent'
        ca_certificates_path = ca_certificates_path'
        on_error = on_error'

    fun path(route: String): String =>
        """
        Prefixes `route` with the API mount point and the configured API
        version.
        """

        "/api/" + version.id() + route

    fun build_request(
        method: courier.Method,
        route: String,
        query: (_RequestQuery | None) = None,
        body: (_RequestBody | None) = None,
        reason: (Reason | None) = None
    ): courier.HTTPRequest val =>
        courier.HTTPRequest(
            method,
            build_path(route, query),
            build_headers(body, reason),
            build_body(body)
        )

    fun build_path(
        route: String,
        query: (_RequestQuery | None) = None
    ): String =>
        match query
        | let query': _RequestQuery if query'.size() > 0 => path(
            route
        ) + "?" + courier.QueryParams(query')
        else
            path(route)
        end

    fun build_headers(
        body: (_RequestBody | None) = None,
        reason: (Reason | None) = None
    ): courier.Headers val =>
        recover val
            let headers' = courier.Headers
            headers'.set("User-Agent", _HeaderValue(user_agent))
            headers'.set("Authorization", _HeaderValue("Bot " + token))

            match body
            | let _: String => headers'.set("Content-Type", "application/json")
            | let multipart: _Multipart =>
                headers'.set("Content-Type", multipart.content_type)
            end

            match reason
            | let reason': String =>
                headers'.set("X-Audit-Log-Reason", _HeaderValue(reason'))
            end

            headers'
        end

    fun build_body(
        body: (_RequestBody | None) = None
    ): (Array[U8] val | None) =>
        match body
        | let body': String => body'.array()
        | let multipart: _Multipart => multipart.body
        end
