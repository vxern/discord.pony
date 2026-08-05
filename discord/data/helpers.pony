use json = "json"
use collections = "collections"

primitive Null

type Nullable[A: Any val] is (A | Null | None)

type ISO8601 is String

type ImageData is String
    """
    https://docs.discord.com/developers/reference#image-data

    An image uploaded to the API as a base64-encoded data URI, of the form
    `data:image/{jpeg,png,gif};base64,{data}`.
    """

type _Enum[A: Equatable[A] #read] is (collections.Hashable & Equatable[A])

trait val ToJsonable is Stringable
    fun to_json(): json.JsonObject

    fun string(): String iso^ => to_json().pretty_print()

trait val FromJsonable
    new val from_json(obj: json.JsonObject) ?

trait val ToJsonableArray is Stringable
    fun to_json(): json.JsonArray

    fun string(): String iso^ => to_json().pretty_print()

trait val Jsonable is (ToJsonable & FromJsonable)

primitive _CommaSeparated
    fun apply(ids: Array[Snowflake] val): String =>
        var buffer = recover iso String end
        var first = true
        for id in ids.values() do
            if not first then buffer.push(',') end
            first = false
            buffer.append(id.string())
        end
        consume buffer

type _RequestQuery is Array[(String, String)] val
    """
    Query parameters to append to a route, or `None` for a route called without any.
    """

type _RequestBody is String
    """
    A serialised request body, or `None` for a route called without one.
    """
