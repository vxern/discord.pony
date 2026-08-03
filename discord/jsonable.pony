use json = "json"

trait val ToJsonable is Stringable
    fun to_json(): json.JsonObject

    fun string(): String iso^ => to_json().pretty_print()

trait val FromJsonable
    new val from_json(obj: json.JsonObject) ?

trait val ToJsonableArray is Stringable
    fun to_json(): json.JsonArray

    fun string(): String iso^ => to_json().pretty_print()

trait val Jsonable is (ToJsonable & FromJsonable)
