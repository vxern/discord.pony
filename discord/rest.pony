use "files"
use "data"
use collections = "collections"
use time = "time"
use courier = "courier"
use json = "json"
use lori = "lori"
use ssl = "ssl/net"

type Reason is (String | None)

type ResponseHandler[A: Any val] is {(A)} val

type EmptyResponseHandler is {()} val

type RawResponseHandler is {(courier.HTTPRequest val, courier.HTTPResponse val)} val

type RawFailureHandler is {()} val

class val RestError
    let request: courier.HTTPRequest val
    let reason: String

    new val create(request': courier.HTTPRequest val, reason': String) =>
        request = request'
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

actor RestApi
    let options: RestOptions
    let _env: Env
    let _auth: lori.TCPConnectAuth
    let _ssl_context: (ssl.SSLContext val | None)
    let _timers: time.Timers = time.Timers

    embed _buckets: collections.Map[String, Bucket] = collections.Map[String, Bucket]
    let _global_bucket: GlobalBucket

    new create(env: Env, options': RestOptions) =>
        options = options'
        _env = env
        _auth = lori.TCPConnectAuth(env.root)
        _ssl_context =
            try
                recover val
                    ssl.SSLContext
                    .> set_client_verify(true)
                    .> set_authority(
                        FilePath(
                            FileAuth(env.root),
                            options'.ca_certificates_path
                        )
                    )?
                end
            end
        _global_bucket = GlobalBucket(this, _timers)

    be send_request(request: courier.HTTPRequest val, handler: RawResponseHandler) =>
        let id = _BucketId(request)
        let bucket =
            try
                _buckets(id)?
            else
                let bucket' = Bucket(_env, _global_bucket, id, _timers)
                _buckets(id) = bucket'
                bucket'
            end

        bucket.enqueue(request, handler)

    be dispose() =>
        _global_bucket.dispose()
        _timers.dispose()
        _buckets.clear()

    be _raw_send_request(request: courier.HTTPRequest val, handler: RawResponseHandler, on_failure: RawFailureHandler) =>
        match _ssl_context
        | let ssl_context: ssl.SSLContext val =>
            _RequestSender(_auth, ssl_context, options, request, handler, on_failure)
        else
            options.on_error(
                RestError(
                    request,
                    "no certificate authority at " + options.ca_certificates_path
                )
            )
            on_failure()
        end

actor _RequestSender is courier.HTTPClientConnectionActor
    var _http: courier.HTTPClientConnection = courier.HTTPClientConnection.none()
    var _collector: courier.ResponseCollector = courier.ResponseCollector
    let _options: RestOptions
    let _request: courier.HTTPRequest val
    let _handler: RawResponseHandler
    let _on_failure: RawFailureHandler
    var _settled: Bool = false

    new create(
        auth: lori.TCPConnectAuth,
        ssl_context: ssl.SSLContext val,
        options: RestOptions,
        request: courier.HTTPRequest val,
        handler: RawResponseHandler,
        on_failure: RawFailureHandler
    ) =>
        _options = options
        _request = request
        _handler = handler
        _on_failure = on_failure
        _http = courier.HTTPClientConnection.ssl(
            auth,
            ssl_context,
            RestConstants.host(),
            RestConstants.port(),
            this,
            courier.ClientConnectionConfig
        )

    fun ref _http_client_connection(): courier.HTTPClientConnection => _http

    fun ref on_connected() =>
        _http.send_request(_request)

    fun ref on_response(response: courier.Response val) =>
        _collector = courier.ResponseCollector
        _collector.set_response(response)

    fun ref on_body_chunk(data: Array[U8] val) =>
        _collector.add_chunk(data)

    fun ref on_response_complete() =>
        try
            let response = _collector.build()?
            _settled = true
            _handler(_request, response)
        else
            _fail("response could not be assembled")
        end
        _http.close()

    fun ref on_connection_failure(reason: courier.ConnectionFailureReason) =>
        _fail(reason.string())

    fun ref on_parse_error(err: courier.ParseError) =>
        _fail(err.string())

    fun ref on_closed() =>
        _fail("connection closed before a response arrived")

    fun ref _fail(reason: String) =>
        if not _settled then
            _settled = true
            _options.on_error(RestError(_request, reason))
            _on_failure()
        end

primitive RestConstants
    fun host(): String => "discord.com"

    fun port(): String => "443"

class val RestOptions
    let token: String
        """
        The bot token every request is authorised with.
        """
    let version: RestVersion val
    let user_agent: String
    let ca_certificates_path: String
    let on_error: RestErrorHandler

    new val create(
        token': String,
        version': RestVersion val = RestDefaults.version(),
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
        Prefixes `route` with the API mount point and the configured API version.
        """

        "/api/" + version.id() + route

    fun build_request(method: courier.Method, route: String, query: (_RequestQuery | None) = None, body: (_RequestBody | None) = None, reason: Reason = None): courier.HTTPRequest val =>
        courier.HTTPRequest(method, build_path(route, query), build_headers(body, reason), build_body(body))
    
    fun build_path(route: String, query: (_RequestQuery | None) = None): String => 
        match query
        | let query': _RequestQuery if query'.size() > 0 => path(route) + "?" + courier.QueryParams(query')
        else
            path(route)
        end

    fun build_headers(body: (_RequestBody | None) = None, reason: (Reason | None) = None): courier.Headers val =>
        recover val
            let headers' = courier.Headers
            headers'.set("User-Agent", user_agent)
            headers'.set("Authorization", "Bot " + token)

            match body
            | let _: String => headers'.set("Content-Type", "application/json")
            end

            match reason
            | let reason': String => headers'.set("X-Audit-Log-Reason", reason')
            end

            headers'
        end

    fun build_body(body: (_RequestBody | None) = None): (Array[U8] val | None) =>
        match body
        | let body': String => body'.array()
        end

trait val RestVersion is _Enum[RestVersion]
    fun value(): U64

    fun id(): String => "v" + value().string()

    fun hash(): USize => value().hash()

    fun eq(that: RestVersion): Bool => value() == that.value()
primitive RestVersion6 is RestVersion
    fun value(): U64 => 6
primitive RestVersion7 is RestVersion
    fun value(): U64 => 7
primitive RestVersion8 is RestVersion
    fun value(): U64 => 8
primitive RestVersion9 is RestVersion
    fun value(): U64 => 9
primitive RestVersion10 is RestVersion
    fun value(): U64 => 10

primitive RestDefaults
    fun version(): RestVersion val => RestVersion10

    fun user_agent(): String =>
        "discord.pony (https://github.com/vxern/discord.pony, 1.0.0)"

    fun ca_certificates_path(): String =>
        ifdef osx then
            "/etc/ssl/cert.pem"
        else
            "/etc/ssl/certs/ca-certificates.crt"
        end

    fun on_error(): RestErrorHandler => {(error': RestError) => None }
