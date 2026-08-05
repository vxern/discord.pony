// TODO(vxern): (Maybe) add RPC error codes
// TODO(vxern): (Maybe) add RPC close event codes

actor Gateway
    fun base_url(): String => "wss://gateway.discord.gg"

    fun max_message_size_bytes(): USize => 4096

    // TODO(vxern): Implement, waiting on a WS client library to proceed...
    be connect() => None

    be dispose() => None
