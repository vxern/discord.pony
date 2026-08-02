use courier = "courier"
use collections = "collections"
use json = "json"

type Reason is (String | None)

primitive Null
    """
    https://docs.discord.com/developers/reference#nullable-and-optional-resource-fields

    Serialised as JSON `null`, explicitly clearing a field. Distinct from `None`, which omits the field from the request body altogether.
    """

type Nullable[A: Any val] is (A | Null | None)
    """
    A request field Discord documents as nullable: it may carry a value, be cleared with `Null`, or be left out entirely with `None`.

    Discord treats the two absences differently — sending `null` resets the field to its default, whereas omitting the key leaves the current value untouched — so the distinction cannot be collapsed.
    """

primitive _CommaSeparated
    """
    Joins values for query parameters documented as comma-delimited sets.
    """

    fun apply(ids: Array[Snowflake] val): String =>
        var buffer = recover iso String end
        var first = true
        for id in ids.values() do
            if not first then buffer.push(',') end
            first = false
            buffer.append(id.string())
        end
        consume buffer

class Rest
    let options: RestOptions
    let api: RestApi
    let routes: Routes

    new create(options': RestOptions = RestOptions) =>
        options = options'
        api = RestApi(options')
        routes = Routes(api, options')

actor RestApi
    let options: RestOptions

    new create(options': RestOptions) => options = options'

    be send_request(request: courier.HTTPRequest val, handler: ResponseReceiver) =>
        """
        Dispatches `request` and hands the response to `handler`.
        """

        // TODO(vxern): Send the request to `RestConstants.url()`, authorising it with the bot token and respecting rate limits. Until then, every request is answered with an empty `200 OK`.
        handler.on_response_received(request, courier.HTTPResponse(courier.HTTP11, 200, "OK", recover val courier.Headers end, recover val Array[U8] end))

primitive RestConstants
    fun url(): String => "https://discord.com/api"

type RequestQuery is Array[(String, String)] val
    """
    Query parameters to append to a route, or `None` for a route called without any.
    """

type RequestBody is String
    """
    A serialised request body, or `None` for a route called without one.
    """

class val RestOptions
    let version: RestVersion val
    let user_agent: String

    new val create(
        version': RestVersion val = RestDefaults.version(),
        user_agent': String = RestDefaults.user_agent()
    ) =>
        version = version'
        user_agent = user_agent'

    fun path(route: String): String =>
        """
        Prefixes `route` with the API mount point and the configured API version.
        """

        "/api/" + version.id() + route

    fun build_request(method: courier.Method, route: String, query: (RequestQuery | None) = None, body: (RequestBody | None) = None, reason: Reason = None): courier.HTTPRequest val =>
        courier.HTTPRequest(method, build_path(route, query), build_headers(body, reason), build_body(body))
    
    fun build_path(route: String, query: (RequestQuery | None) = None): String => 
        match query
        | let query': RequestQuery if query'.size() > 0 => path(route) + "?" + courier.QueryParams(query')
        else
            path(route)
        end

    fun build_headers(body: (RequestBody | None) = None, reason: (Reason | None) = None): courier.Headers val =>
        recover val
            let headers' = courier.Headers
            headers'.set("User-Agent", user_agent)

            match body
            | let _: String => headers'.set("Content-Type", "application/json")
            end

            match reason
            | let reason': String => headers'.set("X-Audit-Log-Reason", reason')
            end

            headers'
        end

    fun build_body(body: (RequestBody | None) = None): (Array[U8] val | None) =>
        match body
        | let body': String => body'.array()
        end

trait val RestVersion is (collections.Hashable & Equatable[RestVersion])
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
    fun version(): RestVersion val => RestVersion6

    fun user_agent(): String =>
        "discord.pony (https://github.com/vxern/discord.pony, 1.0.0)"
