"""
https://docs.discord.com/developers/reference#snowflakes
"""
class Snowflake
    let value: U64

    new apply(value': U64) => value = value'

    new from_timestamp(value': U64) => value = (value' - SnowflakeDefaults.discord_epoch_ms()) << 22

    fun timestamp(): U64 => (value >> 22) + SnowflakeDefaults.discord_epoch_ms()

    fun worker_id(): U64 => (value and 0x3E0000) >> 17

    fun process_id(): U64 => (value and 0x1F000) >> 12

    fun increment(): U64 => value and 0xFFF

primitive SnowflakeDefaults
    fun discord_epoch_ms(): U64 => 1420070400000
