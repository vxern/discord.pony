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

trait val _Enum[
    A: _Enum[A, V] val, V: (collections.Hashable val & Equatable[V] val)
] is (collections.Hashable & Equatable[A])
    fun value(): V

    fun hash(): USize => value().hash()

    fun eq(that: A): Bool => value() == that.value()

trait val ToJsonable is Stringable
    fun to_json(): json.JsonObject

    fun string(): String iso^ => to_json().pretty_print()

trait val FromJsonable
    new val from_json(obj: json.JsonObject) ?

trait val ToJsonableArray is Stringable
    fun to_json(): json.JsonArray

    fun string(): String iso^ => to_json().pretty_print()

trait val Jsonable is (ToJsonable & FromJsonable)

primitive _Unsigned
    fun usize(value: json.JsonValue): USize ? =>
        """
        Decodes a non-negative integer that fits in a `USize`.
        """

        let integer = value as I64
        if (integer < 0) or (integer.u64() > USize.max_value().u64()) then
            error
        end
        integer.usize()

    fun u64(value: json.JsonValue): U64 ? =>
        """
        Decodes a non-negative integer that fits in a `U64`.
        """

        let integer = value as I64
        if integer < 0 then error end
        integer.u64()

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
    Query parameters to append to a route, or `None` for a route called without
    any.
    """

type _RequestBody is String
    """
    A serialised request body, or `None` for a route called without one.
    """
