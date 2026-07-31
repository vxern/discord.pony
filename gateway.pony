use collections = "collections"

trait val GatewayOpcode is (collections.Hashable & Equatable[GatewayOpcode])
    """
    All gateway events in Discord are tagged with an opcode that denotes the payload type. Your connection to our gateway may also sometimes close. When it does, you will receive a close code that tells you what happened.
    """

    fun value(): U8
    fun hash(): USize => value().hash()
    fun eq(that: GatewayOpcode): Bool => value() == that.value()
primitive GatewayOpcodeDispatch is GatewayOpcode
    """
    Action: Receive

    An event was dispatched.
    """

    fun value(): U8 => 0
primitive GatewayOpcodeHeartbeat is GatewayOpcode
    """
    Action: Send/Receive

    Fired periodically by the client to keep the connection alive.
    """

    fun value(): U8 => 1
primitive GatewayOpcodeIdentify is GatewayOpcode
    """
    Action: Send

    Starts a new session during the initial handshake.
    """

    fun value(): U8 => 2
primitive GatewayOpcodePresenceUpdate is GatewayOpcode
    """
    Action: Send

    Update the client’s presence.
    """

    fun value(): U8 => 3
primitive GatewayOpcodeVoiceStateUpdate is GatewayOpcode
    """
    Action: Send

    Used to join/leave or move between voice channels.
    """

    fun value(): U8 => 4
primitive GatewayOpcodeResume is GatewayOpcode
    """
    Action: Send

    Resume a previous session that was disconnected.
    """

    fun value(): U8 => 6
primitive GatewayOpcodeReconnect is GatewayOpcode
    """
    Action: Receive

    You should attempt to reconnect and resume immediately.
    """

    fun value(): U8 => 7
primitive GatewayOpcodeRequestGuildMembers is GatewayOpcode
    """
    Action: Send

    Request information about offline guild members in a large guild.
    """

    fun value(): U8 => 8
primitive GatewayOpcodeInvalidSession is GatewayOpcode
    """
    Action: Receive

    The session has been invalidated. You should reconnect and identify/resume accordingly.
    """

    fun value(): U8 => 9
primitive GatewayOpcodeHello is GatewayOpcode
    """
    Action: Receive

    Sent immediately after connecting, contains the heartbeat_interval to use.
    """

    fun value(): U8 => 10
primitive GatewayOpcodeHeartbeatACK is GatewayOpcode
    """
    Action: Receive

    Sent in response to receiving a heartbeat to acknowledge that it has been received.
    """

    fun value(): U8 => 11
primitive GatewayOpcodeRequestSoundboardSounds is GatewayOpcode
    """
    Action: Send

    Request information about soundboard sounds in a set of guilds.
    """

    fun value(): U8 => 31
primitive GatewayOpcodeRequestChannelInfo is GatewayOpcode
    """
    Action: Send

    Request ephemeral channel data for channels in a guild.
    """

    fun value(): U8 => 43

trait val GatewayCloseEventCode is (collections.Hashable & Equatable[GatewayCloseEventCode])
    """
    In order to prevent broken reconnect loops, you should consider some close codes as a signal to stop reconnecting. This can be because your token expired, or your identification is invalid. This table explains what the application defined close codes for the gateway are, and which close codes you should not attempt to reconnect.
    """

    fun value(): U16
    fun reconnect(): Bool
    fun hash(): USize => value().hash()
    fun eq(that: GatewayCloseEventCode): Bool => value() == that.value()
primitive GatewayCloseEventCodeUnknownError is GatewayCloseEventCode
    """
    We’re not sure what went wrong. Try reconnecting?
    """

    fun value(): U16 => 4000
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeUnknownOpcode is GatewayCloseEventCode
    """
    You sent an invalid Gateway opcode or an invalid payload for an opcode. Don’t do that!
    """

    fun value(): U16 => 4001
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeDecodeError is GatewayCloseEventCode
    """
    You sent an invalid payload to Discord. Don’t do that!
    """

    fun value(): U16 => 4002
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeNotAuthenticated is GatewayCloseEventCode
    """
    You sent us a payload prior to identifying, or this session has been invalidated.
    """

    fun value(): U16 => 4003
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeAuthenticationFailed is GatewayCloseEventCode
    """
    The account token sent with your identify payload is incorrect.
    """

    fun value(): U16 => 4004
    fun reconnect(): Bool => false
primitive GatewayCloseEventCodeAlreadyAuthenticated is GatewayCloseEventCode
    """
    You sent more than one identify payload. Don’t do that!
    """

    fun value(): U16 => 4005
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeInvalidSequence is GatewayCloseEventCode
    """
    The sequence sent when resuming the session was invalid. Reconnect and start a new session.
    """

    fun value(): U16 => 4007
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeRateLimited is GatewayCloseEventCode
    """
    Woah nelly! You’re sending payloads to us too quickly. Slow it down! You will be disconnected on receiving this.
    """

    fun value(): U16 => 4008
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeSessionTimedOut is GatewayCloseEventCode
    """
    Your session timed out. Reconnect and start a new one.
    """

    fun value(): U16 => 4009
    fun reconnect(): Bool => true
primitive GatewayCloseEventCodeInvalidShard is GatewayCloseEventCode
    """
    You sent us an invalid shard when identifying.
    """

    fun value(): U16 => 4010
    fun reconnect(): Bool => false
primitive GatewayCloseEventCodeShardingRequired is GatewayCloseEventCode
    """
    The session would have handled too many guilds - you are required to shard your connection in order to connect.
    """

    fun value(): U16 => 4011
    fun reconnect(): Bool => false
primitive GatewayCloseEventCodeInvalidAPIVersion is GatewayCloseEventCode
    """
    You sent an invalid version for the gateway.
    """

    fun value(): U16 => 4012
    fun reconnect(): Bool => false
primitive GatewayCloseEventCodeInvalidIntents is GatewayCloseEventCode
    """
    You sent an invalid intent for a Gateway Intent. You may have incorrectly calculated the bitwise value.
    """

    fun value(): U16 => 4013
    fun reconnect(): Bool => false
primitive GatewayCloseEventCodeDisallowedIntents is GatewayCloseEventCode
    """
    You sent a disallowed intent for a Gateway Intent. You may have tried to specify an intent that you have not enabled or are not approved for.
    """

    fun value(): U16 => 4014
    fun reconnect(): Bool => false

// TODO(vxern): (Maybe) add RPC error codes
// TODO(vxern): (Maybe) add RPC close event codes

actor Gateway
    fun base_url(): String => "wss://gateway.discord.gg"

    fun max_message_size_bytes(): USize => 4096

    // TODO(vxern): Implement, waiting on a WS client library to proceed...
    be connect() => None
