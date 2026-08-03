"""
https://docs.discord.com/developers/reference#snowflakes
"""
use collections = "collections"
use json = "json"

class val Snowflake is (Stringable & collections.Hashable & Equatable[Snowflake])
    let value: U64

    new val create(value': U64) => value = value'

    new val from_timestamp(value': U64) => value = (value' - SnowflakeDefaults.discord_epoch_ms()) << 22

    new val from_json(value': json.JsonValue) ? =>
        """
        Snowflakes are serialised as strings since they do not fit in the 53 bits of precision a JSON number is guaranteed to carry.
        """

        value = (value' as String).u64()?

    fun to_json(): json.JsonValue => value.string()

    fun timestamp(): U64 => (value >> 22) + SnowflakeDefaults.discord_epoch_ms()

    fun worker_id(): U64 => (value and 0x3E0000) >> 17

    fun process_id(): U64 => (value and 0x1F000) >> 12

    fun increment(): U64 => value and 0xFFF

    fun hash(): USize => value.hash()

    fun eq(that: Snowflake): Bool => value == that.value

    fun string(): String iso^ => value.string()

primitive _Snowflakes
    fun apply(value: json.JsonValue): Array[Snowflake] val ? =>
        """
        Decodes an array of snowflakes.
        """

        let array = value as json.JsonArray
        recover val
            let ids = Array[Snowflake](array.size())
            for id in array.values() do ids.push(Snowflake.from_json(id)?) end
            ids
        end

    fun to_json(ids: Array[Snowflake] val): json.JsonArray =>
        var array = json.JsonArray
        for id in ids.values() do array = array.push(id.to_json()) end
        array

primitive SnowflakeDefaults
    fun discord_epoch_ms(): U64 => 1420070400000
