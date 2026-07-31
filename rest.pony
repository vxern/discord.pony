actor Rest
    let options: RestOptions

    new create(options': RestOptions) => options = options'

    fun base_url() => "https://discord.com/api"

    fun bot_authorization_header(token: String) => "Authorization: Bot " + token

class val RestOptions
    let version: RestVersion val
    let user_agent: String

    new create(
        version': RestVersion val = RestDefaults.version(),
        user_agent': String = RestDefaults.user_agent()
    ) =>
        version = version'
        user_agent = user_agent'

trait RestVersion
    fun value(): U64
    fun id(): String => "v" + value().string()
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
