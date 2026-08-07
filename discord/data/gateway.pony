use json = "json"

class val GatewayInfo is Jsonable
    """
    https://docs.discord.com/developers/events/gateway#get-gateway

    Apps should cache this value and only call the route again when they are
    unable to properly establish a connection using the cached one.
    """

    let url: String
        """
        WSS URL that can be used for connecting to the Gateway
        """

    new val create(url': String) =>
        url = url'

    new val from_json(obj: json.JsonObject) ? =>
        var url': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "url" => url' = value as String
            end
        end

        url = url' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("url", url)

class val GatewayBotInfo is Jsonable
    """
    https://docs.discord.com/developers/events/gateway#get-gateway-bot-json-response

    Unlike `GatewayInfo`, this should not be cached for extended periods of
    time, as the value is not guaranteed to be the same per-call and changes as
    the bot joins and leaves guilds.
    """

    let url: String
        """
        WSS URL that can be used for connecting to the Gateway
        """

    let shards: USize
        """
        Recommended number of shards to use when connecting
        """

    let session_start_limit: SessionStartLimit
        """
        Information on the current session start limit
        """

    new val create(
        url': String,
        shards': USize,
        session_start_limit': SessionStartLimit
    ) =>
        url = url'
        shards = shards'
        session_start_limit = session_start_limit'

    new val from_json(obj: json.JsonObject) ? =>
        var url': (String | None) = None
        var shards': (USize | None) = None
        var session_start_limit': (SessionStartLimit | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "url" => url' = value as String
            | "shards" => shards' = (value as I64).usize()
            | "session_start_limit" => session_start_limit' = SessionStartLimit.from_json(value as json.JsonObject)?
            end
        end

        url = url' as String
        shards = shards' as USize
        session_start_limit = session_start_limit' as SessionStartLimit

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("url", url)
            .update("shards", shards.i64())
            .update("session_start_limit", session_start_limit.to_json())

class val SessionStartLimit is Jsonable
    """
    https://docs.discord.com/developers/events/gateway#session-start-limit-object-session-start-limit-structure
    """

    let total: USize
        """
        Total number of session starts the current user is allowed
        """

    let remaining: USize
        """
        Remaining number of session starts the current user is allowed
        """

    let reset_after: U64
        """
        Number of milliseconds after which the limit resets
        """

    let max_concurrency: USize
        """
        Number of identify requests allowed per 5 seconds
        """

    new val create(
        total': USize,
        remaining': USize,
        reset_after': U64,
        max_concurrency': USize
    ) =>
        total = total'
        remaining = remaining'
        reset_after = reset_after'
        max_concurrency = max_concurrency'

    new val from_json(obj: json.JsonObject) ? =>
        var total': (USize | None) = None
        var remaining': (USize | None) = None
        var reset_after': (U64 | None) = None
        var max_concurrency': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "total" => total' = (value as I64).usize()
            | "remaining" => remaining' = (value as I64).usize()
            | "reset_after" => reset_after' = (value as I64).u64()
            | "max_concurrency" => max_concurrency' = (value as I64).usize()
            end
        end

        total = total' as USize
        remaining = remaining' as USize
        reset_after = reset_after' as U64
        max_concurrency = max_concurrency' as USize

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("total", total.i64())
            .update("remaining", remaining.i64())
            .update("reset_after", reset_after.i64())
            .update("max_concurrency", max_concurrency.i64())

trait val GatewayOpcode is _Enum[GatewayOpcode, U8]
    """
    All gateway events in Discord are tagged with an opcode that denotes the payload type. Your connection to our gateway may also sometimes close. When it does, you will receive a close code that tells you what happened.
    """
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
primitive GatewayOpcodes
    fun from(value: U8): GatewayOpcode ? =>
        match value
        | 0 => GatewayOpcodeDispatch
        | 1 => GatewayOpcodeHeartbeat
        | 2 => GatewayOpcodeIdentify
        | 3 => GatewayOpcodePresenceUpdate
        | 4 => GatewayOpcodeVoiceStateUpdate
        | 6 => GatewayOpcodeResume
        | 7 => GatewayOpcodeReconnect
        | 8 => GatewayOpcodeRequestGuildMembers
        | 9 => GatewayOpcodeInvalidSession
        | 10 => GatewayOpcodeHello
        | 11 => GatewayOpcodeHeartbeatACK
        | 31 => GatewayOpcodeRequestSoundboardSounds
        | 43 => GatewayOpcodeRequestChannelInfo
        else error
        end

trait val GatewayCloseEventCode is _Enum[GatewayCloseEventCode, U16]
    """
    In order to prevent broken reconnect loops, you should consider some close codes as a signal to stop reconnecting. This can be because your token expired, or your identification is invalid. This table explains what the application defined close codes for the gateway are, and which close codes you should not attempt to reconnect.
    """

    fun reconnect(): Bool
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
primitive GatewayCloseEventCodes
    fun from(value: U16): GatewayCloseEventCode ? =>
        match value
        | 4000 => GatewayCloseEventCodeUnknownError
        | 4001 => GatewayCloseEventCodeUnknownOpcode
        | 4002 => GatewayCloseEventCodeDecodeError
        | 4003 => GatewayCloseEventCodeNotAuthenticated
        | 4004 => GatewayCloseEventCodeAuthenticationFailed
        | 4005 => GatewayCloseEventCodeAlreadyAuthenticated
        | 4007 => GatewayCloseEventCodeInvalidSequence
        | 4008 => GatewayCloseEventCodeRateLimited
        | 4009 => GatewayCloseEventCodeSessionTimedOut
        | 4010 => GatewayCloseEventCodeInvalidShard
        | 4011 => GatewayCloseEventCodeShardingRequired
        | 4012 => GatewayCloseEventCodeInvalidAPIVersion
        | 4013 => GatewayCloseEventCodeInvalidIntents
        | 4014 => GatewayCloseEventCodeDisallowedIntents
        else error
        end

class val GatewayEventPayload is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#payload-structure

    Gateway event payloads have a common structure, but the contents of the associated data (d) varies between the different events.
    """

    let op: GatewayOpcode
        """
        Gateway opcode, which indicates the payload type
        """

    let d: json.JsonValue
        """
        Event data
        """

    let s: (USize | None)
        """
        Sequence number of event used for resuming sessions and heartbeating

        `None` when `op` is not `GatewayOpcodeDispatch`.
        """

    let t: (String | None)
        """
        Event name

        `None` when `op` is not `GatewayOpcodeDispatch`.
        """

    new val create(
        op': GatewayOpcode,
        d': json.JsonValue = None,
        s': (USize | None) = None,
        t': (String | None) = None
    ) =>
        op = op'
        d = d'
        s = s'
        t = t'

    new val from_json(obj: json.JsonObject) ? =>
        var op': (GatewayOpcode | None) = None
        var d': json.JsonValue = None
        var s': (USize | None) = None
        var t': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "op" => op' = GatewayOpcodes.from((value as I64).u8())?
            | "d" => d' = value
            | "s" => s' = match value | let sequence: I64 => sequence.usize() end
            | "t" => t' = match value | let name: String => name end
            end
        end

        op = op' as GatewayOpcode
        d = d'
        s = s'
        t = t'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("op", op.value().i64())
            .update("d", d)

        match s
        | let s': USize => obj = obj.update("s", s'.i64())
        end

        match t
        | let t': String => obj = obj.update("t", t')
        end

        obj

trait val GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#send-events

    Send events are Gateway events encapsulated in an event payload, and are sent by an app to Discord through a Gateway connection.
    """

    fun opcode(): GatewayOpcode

    fun data(): json.JsonValue => None

    fun payload(): GatewayEventPayload =>
        GatewayEventPayload(opcode(), data())

class val GatewayIdentifyEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#identify

    Used to trigger the initial handshake with the gateway.
    """

    let token: String
        """
        Authentication token
        """

    let properties: IdentifyConnectionProperties
        """
        Connection properties
        """

    let compress: (Bool | None)
        """
        Whether this connection supports compression of packets

        Defaults to `false`.
        """

    let large_threshold: (USize | None)
        """
        Value between 50 and 250, total number of members where the gateway will stop sending offline members in the guild member list

        Defaults to `50`.
        """

    let shard: ((USize, USize) | None)
        """
        Used for Guild Sharding
        """

    let presence: (GatewayPresenceUpdate | None)
        """
        Presence structure for initial presence information
        """

    let intents: Array[GatewayIntent] val
        """
        Gateway Intents you wish to receive
        """

    new val create(
        token': String,
        properties': IdentifyConnectionProperties,
        compress': (Bool | None) = None,
        large_threshold': (USize | None) = None,
        shard': ((USize, USize) | None) = None,
        presence': (GatewayPresenceUpdate | None) = None,
        intents': Array[GatewayIntent] val
    ) =>
        token = token'
        properties = properties'
        compress = compress'
        large_threshold = large_threshold'
        shard = shard'
        presence = presence'
        intents = intents'

    fun opcode(): GatewayOpcode => GatewayOpcodeIdentify

    fun data(): json.JsonValue =>
        var obj = json.JsonObject
            .update("token", token)
            .update("properties", properties.to_json())
            .update("intents", _GatewayIntents.to_json(intents))

        match compress
        | let compress': Bool => obj = obj.update("compress", compress')
        end

        match large_threshold
        | let large_threshold': USize => obj = obj.update("large_threshold", large_threshold'.i64())
        end

        match shard
        | (let shard_id: USize, let num_shards: USize) =>
            obj = obj.update("shard", json.JsonArray.push(shard_id.i64()).push(num_shards.i64()))
        end

        match presence
        | let presence': GatewayPresenceUpdate => obj = obj.update("presence", presence'.to_json())
        end

        obj

class val GatewayResumeEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#resume

    Used to replay missed events when a disconnected client resumes.
    """

    let token: String
        """
        Session token
        """

    let session_id: String
        """
        Session ID
        """

    let seq: USize
        """
        Last sequence number received
        """

    new val create(token': String, session_id': String, seq': USize) =>
        token = token'
        session_id = session_id'
        seq = seq'

    fun opcode(): GatewayOpcode => GatewayOpcodeResume

    fun data(): json.JsonValue =>
        json.JsonObject
            .update("token", token)
            .update("session_id", session_id)
            .update("seq", seq.i64())

class val GatewayHeartbeatEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#heartbeat

    Used to maintain an active gateway connection. Must be sent every `heartbeat_interval` milliseconds after the Hello payload is received.
    """

    let seq: (USize | None)
        """
        The last sequence number received by the client, or `None` if it has not yet received one
        """

    new val create(seq': (USize | None) = None) =>
        seq = seq'

    fun opcode(): GatewayOpcode => GatewayOpcodeHeartbeat

    fun data(): json.JsonValue =>
        match seq
        | let seq': USize => seq'.i64()
        end

class val GatewayRequestGuildMembersEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#request-guild-members

    Used to request all members for a guild. The server will send Guild Members Chunk events in response with up to 1000 members per chunk until all members that match the request have been sent.

    The `GUILD_PRESENCES` intent is required to set `presences` to `true`, and the `GUILD_MEMBERS` intent is required to request the entire member list. Requesting a prefix or user ids returns a maximum of 100 members.
    """

    let guild_id: Snowflake
        """
        ID of the guild to get members for
        """

    let query: (String | None)
        """
        string that username starts with, or an empty string to return all members

        One of `query` or `user_ids` is required.
        """

    let limit: USize
        """
        maximum number of members to send matching the `query`; a limit of `0` can be used with an empty string `query` to return all members
        """

    let presences: (Bool | None)
        """
        used to specify if we want the presences of the matched members
        """

    let user_ids: (Snowflake | Array[Snowflake] val | None)
        """
        used to specify which users you wish to fetch

        One of `query` or `user_ids` is required.
        """

    let nonce: (String | None)
        """
        nonce to identify the Guild Members Chunk response

        Can only be up to 32 bytes. If you send an invalid nonce it will be ignored and the reply member chunk(s) will not have a nonce set.
        """

    new val create(
        guild_id': Snowflake,
        query': (String | None) = None,
        limit': USize = 0,
        presences': (Bool | None) = None,
        user_ids': (Snowflake | Array[Snowflake] val | None) = None,
        nonce': (String | None) = None
    ) =>
        guild_id = guild_id'
        query = query'
        limit = limit'
        presences = presences'
        user_ids = user_ids'
        nonce = nonce'

    fun opcode(): GatewayOpcode => GatewayOpcodeRequestGuildMembers

    fun data(): json.JsonValue =>
        var obj = json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("limit", limit.i64())

        match query
        | let query': String => obj = obj.update("query", query')
        end

        match presences
        | let presences': Bool => obj = obj.update("presences", presences')
        end

        match user_ids
        | let user_id: Snowflake => obj = obj.update("user_ids", user_id.to_json())
        | let user_ids': Array[Snowflake] val => obj = obj.update("user_ids", _Snowflakes.to_json(user_ids'))
        end

        match nonce
        | let nonce': String => obj = obj.update("nonce", nonce')
        end

        obj

class val GatewayRequestSoundboardSoundsEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#request-soundboard-sounds

    Used to request soundboard sounds for a list of guilds. The server will send Soundboard Sounds events for each guild in response.
    """

    let guild_ids: Array[Snowflake] val
        """
        IDs of the guilds to get soundboard sounds for
        """

    new val create(guild_ids': Array[Snowflake] val) =>
        guild_ids = guild_ids'

    fun opcode(): GatewayOpcode => GatewayOpcodeRequestSoundboardSounds

    fun data(): json.JsonValue =>
        json.JsonObject.update("guild_ids", _Snowflakes.to_json(guild_ids))

class val GatewayRequestChannelInfoEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#request-channel-info

    Requests ephemeral channel data for channels in a guild. The server will send a Channel Info event in response.
    """

    let guild_id: Snowflake
        """
        The guild id to request channel info for
        """

    let fields: Array[String] val
        """
        The fields to request. The current available fields are `status` and `voice_start_time`.
        """

    new val create(guild_id': Snowflake, fields': Array[String] val) =>
        guild_id = guild_id'
        fields = fields'

    fun opcode(): GatewayOpcode => GatewayOpcodeRequestChannelInfo

    fun data(): json.JsonValue =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("fields", _Strings.to_json(fields))

class val GatewayVoiceStateUpdateEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#update-voice-state

    Sent when a client wants to join, move, or disconnect from a voice channel.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let channel_id: (Snowflake | None)
        """
        ID of the voice channel client wants to join (null if disconnecting)
        """

    let self_mute: Bool
        """
        Whether the client is muted
        """

    let self_deaf: Bool
        """
        Whether the client deafened
        """

    new val create(
        guild_id': Snowflake,
        channel_id': (Snowflake | None),
        self_mute': Bool,
        self_deaf': Bool
    ) =>
        guild_id = guild_id'
        channel_id = channel_id'
        self_mute = self_mute'
        self_deaf = self_deaf'

    fun opcode(): GatewayOpcode => GatewayOpcodeVoiceStateUpdate

    fun data(): json.JsonValue =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("channel_id", match channel_id | let channel_id': Snowflake => channel_id'.to_json() end)
            .update("self_mute", self_mute)
            .update("self_deaf", self_deaf)

class val GatewayPresenceUpdateEvent is GatewaySendableEvent
    """
    https://docs.discord.com/developers/events/gateway-events#update-presence

    Sent by the client to indicate a presence or status update.
    """

    let presence: GatewayPresenceUpdate
        """
        The presence to update to
        """

    new val create(presence': GatewayPresenceUpdate) =>
        presence = presence'

    fun opcode(): GatewayOpcode => GatewayOpcodePresenceUpdate

    fun data(): json.JsonValue => presence.to_json()

trait val GatewayIntent is _Enum[GatewayIntent, U8]
    """
    https://docs.discord.com/developers/events/gateway#list-of-intents

    Intents are bitwise values passed in the `intents` parameter when identifying which correlate to a set of related events. If you do not specify an intent when identifying, you will not receive any of the Gateway events associated with that intent.

    Any events not associated with an intent will always be sent to your app.
    """

    fun privileged(): Bool
        """
        Whether the intent must be toggled for the app in the Developer Portal, and approved after verification, before it can be identified with.
        """
primitive GatewayIntentGuilds is GatewayIntent
    """
    GUILD_CREATE, GUILD_UPDATE, GUILD_DELETE, GUILD_ROLE_CREATE, GUILD_ROLE_UPDATE, GUILD_ROLE_DELETE, CHANNEL_CREATE, CHANNEL_UPDATE, CHANNEL_DELETE, CHANNEL_PINS_UPDATE, THREAD_CREATE, THREAD_UPDATE, THREAD_DELETE, THREAD_LIST_SYNC, THREAD_MEMBER_UPDATE, THREAD_MEMBERS_UPDATE, STAGE_INSTANCE_CREATE, STAGE_INSTANCE_UPDATE, STAGE_INSTANCE_DELETE, VOICE_CHANNEL_STATUS_UPDATE, VOICE_CHANNEL_START_TIME_UPDATE
    """

    fun value(): U8 => 0

    fun privileged(): Bool => false
primitive GatewayIntentGuildMembers is GatewayIntent
    """
    GUILD_MEMBER_ADD, GUILD_MEMBER_UPDATE, GUILD_MEMBER_REMOVE, THREAD_MEMBERS_UPDATE
    """

    fun value(): U8 => 1

    fun privileged(): Bool => true
primitive GatewayIntentGuildModeration is GatewayIntent
    """
    GUILD_AUDIT_LOG_ENTRY_CREATE, GUILD_BAN_ADD, GUILD_BAN_REMOVE
    """

    fun value(): U8 => 2

    fun privileged(): Bool => false
primitive GatewayIntentGuildExpressions is GatewayIntent
    """
    GUILD_EMOJIS_UPDATE, GUILD_STICKERS_UPDATE, GUILD_SOUNDBOARD_SOUND_CREATE, GUILD_SOUNDBOARD_SOUND_UPDATE, GUILD_SOUNDBOARD_SOUND_DELETE, GUILD_SOUNDBOARD_SOUNDS_UPDATE
    """

    fun value(): U8 => 3

    fun privileged(): Bool => false
primitive GatewayIntentGuildIntegrations is GatewayIntent
    """
    GUILD_INTEGRATIONS_UPDATE, INTEGRATION_CREATE, INTEGRATION_UPDATE, INTEGRATION_DELETE
    """

    fun value(): U8 => 4

    fun privileged(): Bool => false
primitive GatewayIntentGuildWebhooks is GatewayIntent
    """
    WEBHOOKS_UPDATE
    """

    fun value(): U8 => 5

    fun privileged(): Bool => false
primitive GatewayIntentGuildInvites is GatewayIntent
    """
    INVITE_CREATE, INVITE_DELETE
    """

    fun value(): U8 => 6

    fun privileged(): Bool => false
primitive GatewayIntentGuildVoiceStates is GatewayIntent
    """
    VOICE_CHANNEL_EFFECT_SEND, VOICE_STATE_UPDATE
    """

    fun value(): U8 => 7

    fun privileged(): Bool => false
primitive GatewayIntentGuildPresences is GatewayIntent
    """
    PRESENCE_UPDATE
    """

    fun value(): U8 => 8

    fun privileged(): Bool => true
primitive GatewayIntentGuildMessages is GatewayIntent
    """
    MESSAGE_CREATE, MESSAGE_UPDATE, MESSAGE_DELETE, MESSAGE_DELETE_BULK
    """

    fun value(): U8 => 9

    fun privileged(): Bool => false
primitive GatewayIntentGuildMessageReactions is GatewayIntent
    """
    MESSAGE_REACTION_ADD, MESSAGE_REACTION_REMOVE, MESSAGE_REACTION_REMOVE_ALL, MESSAGE_REACTION_REMOVE_EMOJI
    """

    fun value(): U8 => 10

    fun privileged(): Bool => false
primitive GatewayIntentGuildMessageTyping is GatewayIntent
    """
    TYPING_START
    """

    fun value(): U8 => 11

    fun privileged(): Bool => false
primitive GatewayIntentDirectMessages is GatewayIntent
    """
    MESSAGE_CREATE, MESSAGE_UPDATE, MESSAGE_DELETE, CHANNEL_PINS_UPDATE
    """

    fun value(): U8 => 12

    fun privileged(): Bool => false
primitive GatewayIntentDirectMessageReactions is GatewayIntent
    """
    MESSAGE_REACTION_ADD, MESSAGE_REACTION_REMOVE, MESSAGE_REACTION_REMOVE_ALL, MESSAGE_REACTION_REMOVE_EMOJI
    """

    fun value(): U8 => 13

    fun privileged(): Bool => false
primitive GatewayIntentDirectMessageTyping is GatewayIntent
    """
    TYPING_START
    """

    fun value(): U8 => 14

    fun privileged(): Bool => false
primitive GatewayIntentMessageContent is GatewayIntent
    """
    Does not represent individual events, but rather affects what data is present for events that could contain message content fields.
    """

    fun value(): U8 => 15

    fun privileged(): Bool => true
primitive GatewayIntentGuildScheduledEvents is GatewayIntent
    """
    GUILD_SCHEDULED_EVENT_CREATE, GUILD_SCHEDULED_EVENT_UPDATE, GUILD_SCHEDULED_EVENT_DELETE, GUILD_SCHEDULED_EVENT_USER_ADD, GUILD_SCHEDULED_EVENT_USER_REMOVE
    """

    fun value(): U8 => 16

    fun privileged(): Bool => false
primitive GatewayIntentAutoModerationConfiguration is GatewayIntent
    """
    AUTO_MODERATION_RULE_CREATE, AUTO_MODERATION_RULE_UPDATE, AUTO_MODERATION_RULE_DELETE
    """

    fun value(): U8 => 20

    fun privileged(): Bool => false
primitive GatewayIntentAutoModerationExecution is GatewayIntent
    """
    AUTO_MODERATION_ACTION_EXECUTION
    """

    fun value(): U8 => 21

    fun privileged(): Bool => false
primitive GatewayIntentGuildMessagePolls is GatewayIntent
    """
    MESSAGE_POLL_VOTE_ADD, MESSAGE_POLL_VOTE_REMOVE
    """

    fun value(): U8 => 24

    fun privileged(): Bool => false
primitive GatewayIntentDirectMessagePolls is GatewayIntent
    """
    MESSAGE_POLL_VOTE_ADD, MESSAGE_POLL_VOTE_REMOVE
    """

    fun value(): U8 => 25

    fun privileged(): Bool => false
primitive GatewayIntents
    fun from(value: U8): GatewayIntent ? =>
        match value
        | 0 => GatewayIntentGuilds
        | 1 => GatewayIntentGuildMembers
        | 2 => GatewayIntentGuildModeration
        | 3 => GatewayIntentGuildExpressions
        | 4 => GatewayIntentGuildIntegrations
        | 5 => GatewayIntentGuildWebhooks
        | 6 => GatewayIntentGuildInvites
        | 7 => GatewayIntentGuildVoiceStates
        | 8 => GatewayIntentGuildPresences
        | 9 => GatewayIntentGuildMessages
        | 10 => GatewayIntentGuildMessageReactions
        | 11 => GatewayIntentGuildMessageTyping
        | 12 => GatewayIntentDirectMessages
        | 13 => GatewayIntentDirectMessageReactions
        | 14 => GatewayIntentDirectMessageTyping
        | 15 => GatewayIntentMessageContent
        | 16 => GatewayIntentGuildScheduledEvents
        | 20 => GatewayIntentAutoModerationConfiguration
        | 21 => GatewayIntentAutoModerationExecution
        | 24 => GatewayIntentGuildMessagePolls
        | 25 => GatewayIntentDirectMessagePolls
        else error
        end

primitive _GatewayIntents
    fun apply(bits: U64): Array[GatewayIntent] val =>
        recover val
            let intents = Array[GatewayIntent]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try intents.push(GatewayIntents.from(shift)?) end
                end
                shift = shift + 1
            end
            intents
        end

    fun to_json(intents: Array[GatewayIntent] val): I64 =>
        var bits: U64 = 0
        for intent in intents.values() do bits = bits or (U64(1) << intent.value().u64()) end
        bits.i64()

class val IdentifyConnectionProperties is ToJsonable
    """
    https://docs.discord.com/developers/events/gateway-events#identify-identify-connection-properties
    """

    let os: String
        """
        Your operating system
        """

    let browser: String
        """
        Your library name
        """

    let device: String
        """
        Your library name
        """

    new val create(os': String, browser': String, device': String) =>
        os = os'
        browser = browser'
        device = device'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("os", os)
            .update("browser", browser)
            .update("device", device)

class val GatewayPresenceUpdate is ToJsonable
    """
    https://docs.discord.com/developers/events/gateway-events#update-presence-gateway-presence-update-structure

    Sent by the client to indicate a presence or status update.

    Clients may only update their game status 5 times per 20 seconds.
    """

    let since: (U64 | None)
        """
        Unix time (in milliseconds) of when the client went idle, or null if the client is not idle
        """

    let activities: Array[Activity] val
        """
        User's activities
        """

    let status: StatusType
        """
        User's new status
        """

    let afk: Bool
        """
        Whether or not the client is afk
        """

    new val create(
        since': (U64 | None),
        activities': Array[Activity] val,
        status': StatusType,
        afk': Bool
    ) =>
        since = since'
        activities = activities'
        status = status'
        afk = afk'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("since", match since | let since': U64 => since'.i64() end)
            .update("activities", _Activities.to_json(activities))
            .update("status", status.value())
            .update("afk", afk)

trait val StatusType is _Enum[StatusType, String]
    """
    https://docs.discord.com/developers/events/gateway-events#update-presence-status-types
    """
primitive OnlineStatusType is StatusType
    """
    Online
    """

    fun value(): String => "online"
primitive DoNotDisturbStatusType is StatusType
    """
    Do Not Disturb
    """

    fun value(): String => "dnd"
primitive IdleStatusType is StatusType
    """
    AFK
    """

    fun value(): String => "idle"
primitive InvisibleStatusType is StatusType
    """
    Invisible and shown as offline
    """

    fun value(): String => "invisible"
primitive OfflineStatusType is StatusType
    """
    Offline
    """

    fun value(): String => "offline"
primitive StatusTypes
    fun from(value: String): StatusType ? =>
        match value
        | "online" => OnlineStatusType
        | "dnd" => DoNotDisturbStatusType
        | "idle" => IdleStatusType
        | "invisible" => InvisibleStatusType
        | "offline" => OfflineStatusType
        else error
        end

class val Activity is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-structure

    Bot users are only able to set `name`, `state`, `type`, and `url`.
    """

    let name: String
        """
        Activity's name
        """

    let type': ActivityType
        """
        Activity type
        """

    let url: (String | None)
        """
        Stream URL, is validated when type is 1
        """

    let created_at: U64
        """
        Unix timestamp (in milliseconds) of when the activity was added to the user's session
        """

    let timestamps: (ActivityTimestamps | None)
        """
        Unix timestamps for start and/or end of the game
        """

    let application_id: (Snowflake | None)
        """
        Application ID for the game
        """

    let status_display_type: (StatusDisplayType | None)
        """
        Status display type; controls which field is displayed in the user's status text in the member list
        """

    let details: (String | None)
        """
        What the player is currently doing
        """

    let details_url: (String | None)
        """
        URL that is linked when clicking on the details text
        """

    let state: (String | None)
        """
        User's current party status, or text used for a custom status
        """

    let state_url: (String | None)
        """
        URL that is linked when clicking on the state text
        """

    let emoji: (ActivityEmoji | None)
        """
        Emoji used for a custom status
        """

    let party: (ActivityParty | None)
        """
        Information for the current party of the player
        """

    let assets: (ActivityAssets | None)
        """
        Images for the presence and their hover texts
        """

    let secrets: (ActivitySecrets | None)
        """
        Secrets for Rich Presence joining and spectating
        """

    let instance: (Bool | None)
        """
        Whether or not the activity is an instanced game session
        """

    let flags: (Array[ActivityFlag] val | None)
        """
        Activity flags `OR`d together, describes what the payload includes
        """

    let buttons: (Array[ActivityButton] val | Array[String] val | None)
        """
        Custom buttons shown in the Rich Presence (max 2)

        When received over the gateway, the buttons are the button labels alone: bots cannot access a user's activity button URLs.
        """

    new val create(
        name': String,
        type'': ActivityType,
        url': (String | None) = None,
        created_at': U64 = 0,
        timestamps': (ActivityTimestamps | None) = None,
        application_id': (Snowflake | None) = None,
        status_display_type': (StatusDisplayType | None) = None,
        details': (String | None) = None,
        details_url': (String | None) = None,
        state': (String | None) = None,
        state_url': (String | None) = None,
        emoji': (ActivityEmoji | None) = None,
        party': (ActivityParty | None) = None,
        assets': (ActivityAssets | None) = None,
        secrets': (ActivitySecrets | None) = None,
        instance': (Bool | None) = None,
        flags': (Array[ActivityFlag] val | None) = None,
        buttons': (Array[ActivityButton] val | Array[String] val | None) = None
    ) =>
        name = name'
        type' = type''
        url = url'
        created_at = created_at'
        timestamps = timestamps'
        application_id = application_id'
        status_display_type = status_display_type'
        details = details'
        details_url = details_url'
        state = state'
        state_url = state_url'
        emoji = emoji'
        party = party'
        assets = assets'
        secrets = secrets'
        instance = instance'
        flags = flags'
        buttons = buttons'

    new val from_json(obj: json.JsonObject) ? =>
        var name': (String | None) = None
        var type'': (ActivityType | None) = None
        var url': (String | None) = None
        var created_at': (U64 | None) = None
        var timestamps': (ActivityTimestamps | None) = None
        var application_id': (Snowflake | None) = None
        var status_display_type': (StatusDisplayType | None) = None
        var details': (String | None) = None
        var details_url': (String | None) = None
        var state': (String | None) = None
        var state_url': (String | None) = None
        var emoji': (ActivityEmoji | None) = None
        var party': (ActivityParty | None) = None
        var assets': (ActivityAssets | None) = None
        var secrets': (ActivitySecrets | None) = None
        var instance': (Bool | None) = None
        var flags': (Array[ActivityFlag] val | None) = None
        var buttons': (Array[ActivityButton] val | Array[String] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "name" => name' = value as String
            | "type" => type'' = ActivityTypes.from((value as I64).u8())?
            | "url" =>
                match value | let string: String => url' = string end
            | "created_at" => created_at' = (value as I64).u64()
            | "timestamps" => timestamps' = ActivityTimestamps.from_json(value as json.JsonObject)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "status_display_type" =>
                match value | let integer: I64 => status_display_type' = StatusDisplayTypes.from(integer.u8())? end
            | "details" =>
                match value | let string: String => details' = string end
            | "details_url" =>
                match value | let string: String => details_url' = string end
            | "state" =>
                match value | let string: String => state' = string end
            | "state_url" =>
                match value | let string: String => state_url' = string end
            | "emoji" =>
                match value | let obj': json.JsonObject => emoji' = ActivityEmoji.from_json(obj')? end
            | "party" => party' = ActivityParty.from_json(value as json.JsonObject)?
            | "assets" => assets' = ActivityAssets.from_json(value as json.JsonObject)?
            | "secrets" => secrets' = ActivitySecrets.from_json(value as json.JsonObject)?
            | "instance" => instance' = value as Bool
            | "flags" => flags' = _ActivityFlags((value as I64).u64())
            | "buttons" => buttons' = _ActivityButtons(value)?
            end
        end

        name = name' as String
        type' = type'' as ActivityType
        url = url'
        created_at = created_at' as U64
        timestamps = timestamps'
        application_id = application_id'
        status_display_type = status_display_type'
        details = details'
        details_url = details_url'
        state = state'
        state_url = state_url'
        emoji = emoji'
        party = party'
        assets = assets'
        secrets = secrets'
        instance = instance'
        flags = flags'
        buttons = buttons'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("type", type'.value().i64())
            .update("created_at", created_at.i64())

        match url
        | let url': String => obj = obj.update("url", url')
        end

        match timestamps
        | let timestamps': ActivityTimestamps => obj = obj.update("timestamps", timestamps'.to_json())
        end

        match application_id
        | let application_id': Snowflake => obj = obj.update("application_id", application_id'.to_json())
        end

        match status_display_type
        | let status_display_type': StatusDisplayType => obj = obj.update("status_display_type", status_display_type'.value().i64())
        end

        match details
        | let details': String => obj = obj.update("details", details')
        end

        match details_url
        | let details_url': String => obj = obj.update("details_url", details_url')
        end

        match state
        | let state': String => obj = obj.update("state", state')
        end

        match state_url
        | let state_url': String => obj = obj.update("state_url", state_url')
        end

        match emoji
        | let emoji': ActivityEmoji => obj = obj.update("emoji", emoji'.to_json())
        end

        match party
        | let party': ActivityParty => obj = obj.update("party", party'.to_json())
        end

        match assets
        | let assets': ActivityAssets => obj = obj.update("assets", assets'.to_json())
        end

        match secrets
        | let secrets': ActivitySecrets => obj = obj.update("secrets", secrets'.to_json())
        end

        match instance
        | let instance': Bool => obj = obj.update("instance", instance')
        end

        match flags
        | let flags': Array[ActivityFlag] val => obj = obj.update("flags", _ActivityFlags.to_json(flags'))
        end

        match buttons
        | let buttons': Array[ActivityButton] val => obj = obj.update("buttons", _ActivityButtons.to_json(buttons'))
        | let labels: Array[String] val => obj = obj.update("buttons", _Strings.to_json(labels))
        end

        obj

primitive _Activities
    fun apply(value: json.JsonValue): Array[Activity] val ? =>
        """
        Decodes an array of activities.
        """

        let array = value as json.JsonArray
        recover val
            let activities = Array[Activity](array.size())
            for activity in array.values() do activities.push(Activity.from_json(activity as json.JsonObject)?) end
            activities
        end

    fun to_json(activities: Array[Activity] val): json.JsonArray =>
        var array = json.JsonArray
        for activity in activities.values() do array = array.push(activity.to_json()) end
        array

trait val ActivityType is _Enum[ActivityType, U8]
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-types
    """
primitive PlayingActivityType is ActivityType
    """
    Playing `{name}`
    """

    fun value(): U8 => 0
primitive StreamingActivityType is ActivityType
    """
    Streaming `{details}`

    The streaming type currently only supports Twitch and YouTube. Only `https://twitch.tv/` and `https://youtube.com/` urls will work.
    """

    fun value(): U8 => 1
primitive ListeningActivityType is ActivityType
    """
    Listening to `{name}`
    """

    fun value(): U8 => 2
primitive WatchingActivityType is ActivityType
    """
    Watching `{name}`
    """

    fun value(): U8 => 3
primitive CustomActivityType is ActivityType
    """
    `{emoji}` `{state}`
    """

    fun value(): U8 => 4
primitive CompetingActivityType is ActivityType
    """
    Competing in `{name}`
    """

    fun value(): U8 => 5
primitive ActivityTypes
    fun from(value: U8): ActivityType ? =>
        match value
        | 0 => PlayingActivityType
        | 1 => StreamingActivityType
        | 2 => ListeningActivityType
        | 3 => WatchingActivityType
        | 4 => CustomActivityType
        | 5 => CompetingActivityType
        else error
        end

trait val StatusDisplayType is _Enum[StatusDisplayType, U8]
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-status-display-types

    This applies to all activity types. "Listening" is used to serve as a consistent example of what the different fields might be used for.
    """
primitive NameStatusDisplayType is StatusDisplayType
    """
    "Listening to Spotify"
    """

    fun value(): U8 => 0
primitive StateStatusDisplayType is StatusDisplayType
    """
    "Listening to Rick Astley"
    """

    fun value(): U8 => 1
primitive DetailsStatusDisplayType is StatusDisplayType
    """
    "Listening to Never Gonna Give You Up"
    """

    fun value(): U8 => 2
primitive StatusDisplayTypes
    fun from(value: U8): StatusDisplayType ? =>
        match value
        | 0 => NameStatusDisplayType
        | 1 => StateStatusDisplayType
        | 2 => DetailsStatusDisplayType
        else error
        end

class val ActivityTimestamps is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-timestamps

    For Listening and Watching activities, you can include both start and end timestamps to display a time bar.
    """

    let start: (U64 | None)
        """
        Unix time (in milliseconds) of when the activity started
        """

    let end': (U64 | None)
        """
        Unix time (in milliseconds) of when the activity ends
        """

    new val create(start': (U64 | None) = None, end'': (U64 | None) = None) =>
        start = start'
        end' = end''

    new val from_json(obj: json.JsonObject) ? =>
        var start': (U64 | None) = None
        var end'': (U64 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "start" => start' = (value as I64).u64()
            | "end" => end'' = (value as I64).u64()
            end
        end

        start = start'
        end' = end''

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match start
        | let start': U64 => obj = obj.update("start", start'.i64())
        end

        match end'
        | let end'': U64 => obj = obj.update("end", end''.i64())
        end

        obj

class val ActivityEmoji is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-emoji
    """

    let name: String
        """
        Name of the emoji
        """

    let id: (Snowflake | None)
        """
        ID of the emoji
        """

    let animated: (Bool | None)
        """
        Whether the emoji is animated
        """

    new val create(
        name': String,
        id': (Snowflake | None) = None,
        animated': (Bool | None) = None
    ) =>
        name = name'
        id = id'
        animated = animated'

    new val from_json(obj: json.JsonObject) ? =>
        var name': (String | None) = None
        var id': (Snowflake | None) = None
        var animated': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "name" => name' = value as String
            | "id" => id' = Snowflake.from_json(value)?
            | "animated" => animated' = value as Bool
            end
        end

        name = name' as String
        id = id'
        animated = animated'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match id
        | let id': Snowflake => obj = obj.update("id", id'.to_json())
        end

        match animated
        | let animated': Bool => obj = obj.update("animated", animated')
        end

        obj

class val ActivityParty is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-party
    """

    let id: (String | None)
        """
        ID of the party
        """

    let size: ((USize, USize) | None)
        """
        Used to show the party's current and maximum size
        """

    new val create(id': (String | None) = None, size': ((USize, USize) | None) = None) =>
        id = id'
        size = size'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (String | None) = None
        var size': ((USize, USize) | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = value as String
            | "size" =>
                let sizes = _USizes(value as json.JsonArray)?
                size' = (sizes(0)?, sizes(1)?)
            end
        end

        id = id'
        size = size'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match id
        | let id': String => obj = obj.update("id", id')
        end

        match size
        | (let current_size: USize, let max_size: USize) =>
            obj = obj.update("size", json.JsonArray.push(current_size.i64()).push(max_size.i64()))
        end

        obj

class val ActivityAssets is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-assets

    Activity asset images are arbitrary strings which usually contain snowflake IDs or prefixed image IDs. Treat data within these fields carefully, as it is user-specifiable and not sanitized.

    To use an external image via media proxy, specify the URL as the field's value when sending. You will only receive the `mp:` prefix via the gateway.
    """

    let large_image: (String | None)
        """
        See Activity Asset Image
        """

    let large_text: (String | None)
        """
        Text displayed when hovering over the large image of the activity
        """

    let large_url: (String | None)
        """
        URL that is opened when clicking on the large image
        """

    let small_image: (String | None)
        """
        See Activity Asset Image
        """

    let small_text: (String | None)
        """
        Text displayed when hovering over the small image of the activity
        """

    let small_url: (String | None)
        """
        URL that is opened when clicking on the small image
        """

    let invite_cover_image: (String | None)
        """
        See Activity Asset Image. Displayed as a banner on a Game Invite.
        """

    new val create(
        large_image': (String | None) = None,
        large_text': (String | None) = None,
        large_url': (String | None) = None,
        small_image': (String | None) = None,
        small_text': (String | None) = None,
        small_url': (String | None) = None,
        invite_cover_image': (String | None) = None
    ) =>
        large_image = large_image'
        large_text = large_text'
        large_url = large_url'
        small_image = small_image'
        small_text = small_text'
        small_url = small_url'
        invite_cover_image = invite_cover_image'

    new val from_json(obj: json.JsonObject) ? =>
        var large_image': (String | None) = None
        var large_text': (String | None) = None
        var large_url': (String | None) = None
        var small_image': (String | None) = None
        var small_text': (String | None) = None
        var small_url': (String | None) = None
        var invite_cover_image': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "large_image" => large_image' = value as String
            | "large_text" => large_text' = value as String
            | "large_url" => large_url' = value as String
            | "small_image" => small_image' = value as String
            | "small_text" => small_text' = value as String
            | "small_url" => small_url' = value as String
            | "invite_cover_image" => invite_cover_image' = value as String
            end
        end

        large_image = large_image'
        large_text = large_text'
        large_url = large_url'
        small_image = small_image'
        small_text = small_text'
        small_url = small_url'
        invite_cover_image = invite_cover_image'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match large_image
        | let large_image': String => obj = obj.update("large_image", large_image')
        end

        match large_text
        | let large_text': String => obj = obj.update("large_text", large_text')
        end

        match large_url
        | let large_url': String => obj = obj.update("large_url", large_url')
        end

        match small_image
        | let small_image': String => obj = obj.update("small_image", small_image')
        end

        match small_text
        | let small_text': String => obj = obj.update("small_text", small_text')
        end

        match small_url
        | let small_url': String => obj = obj.update("small_url", small_url')
        end

        match invite_cover_image
        | let invite_cover_image': String => obj = obj.update("invite_cover_image", invite_cover_image')
        end

        obj

class val ActivitySecrets is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-secrets
    """

    let join: (String | None)
        """
        Secret for joining a party
        """

    let spectate: (String | None)
        """
        Secret for spectating a game
        """

    let match': (String | None)
        """
        Secret for a specific instanced match
        """

    new val create(
        join': (String | None) = None,
        spectate': (String | None) = None,
        match'': (String | None) = None
    ) =>
        join = join'
        spectate = spectate'
        match' = match''

    new val from_json(obj: json.JsonObject) ? =>
        var join': (String | None) = None
        var spectate': (String | None) = None
        var match'': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "join" => join' = value as String
            | "spectate" => spectate' = value as String
            | "match" => match'' = value as String
            end
        end

        join = join'
        spectate = spectate'
        match' = match''

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match join
        | let join': String => obj = obj.update("join", join')
        end

        match spectate
        | let spectate': String => obj = obj.update("spectate", spectate')
        end

        match match'
        | let match'': String => obj = obj.update("match", match'')
        end

        obj

trait val ActivityFlag is _Enum[ActivityFlag, U8]
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-flags
    """
primitive InstanceActivityFlag is ActivityFlag
    fun value(): U8 => 0
primitive JoinActivityFlag is ActivityFlag
    fun value(): U8 => 1
primitive SpectateActivityFlag is ActivityFlag
    fun value(): U8 => 2
primitive JoinRequestActivityFlag is ActivityFlag
    fun value(): U8 => 3
primitive SyncActivityFlag is ActivityFlag
    fun value(): U8 => 4
primitive PlayActivityFlag is ActivityFlag
    fun value(): U8 => 5
primitive PartyPrivacyFriendsActivityFlag is ActivityFlag
    fun value(): U8 => 6
primitive PartyPrivacyVoiceChannelActivityFlag is ActivityFlag
    fun value(): U8 => 7
primitive EmbeddedActivityFlag is ActivityFlag
    fun value(): U8 => 8
primitive ActivityFlags
    fun from(value: U8): ActivityFlag ? =>
        match value
        | 0 => InstanceActivityFlag
        | 1 => JoinActivityFlag
        | 2 => SpectateActivityFlag
        | 3 => JoinRequestActivityFlag
        | 4 => SyncActivityFlag
        | 5 => PlayActivityFlag
        | 6 => PartyPrivacyFriendsActivityFlag
        | 7 => PartyPrivacyVoiceChannelActivityFlag
        | 8 => EmbeddedActivityFlag
        else error
        end

primitive _ActivityFlags
    fun apply(bits: U64): Array[ActivityFlag] val =>
        recover val
            let flags = Array[ActivityFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(ActivityFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[ActivityFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

class val ActivityButton is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#activity-object-activity-buttons
    """

    let label: String
        """
        Text shown on the button (1-32 characters)
        """

    let url: String
        """
        URL opened when clicking the button (1-512 characters)
        """

    new val create(label': String, url': String) =>
        label = label'
        url = url'

    new val from_json(obj: json.JsonObject) ? =>
        var label': (String | None) = None
        var url': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "label" => label' = value as String
            | "url" => url' = value as String
            end
        end

        label = label' as String
        url = url' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("label", label)
            .update("url", url)

primitive _ActivityButtons
    fun apply(value: json.JsonValue): (Array[ActivityButton] val | Array[String] val) ? =>
        """
        Decodes an array of activity buttons, which Discord sends as an array of labels and accepts as an array of objects.
        """

        let array = value as json.JsonArray
        match array(0)?
        | let _: String => _Strings(value)?
        else
            recover val
                let buttons = Array[ActivityButton](array.size())
                for button in array.values() do buttons.push(ActivityButton.from_json(button as json.JsonObject)?) end
                buttons
            end
        end

    fun to_json(buttons: Array[ActivityButton] val): json.JsonArray =>
        var array = json.JsonArray
        for button in buttons.values() do array = array.push(button.to_json()) end
        array

class val ClientStatus is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#client-status-object

    Active sessions are indicated with an "online", "idle", or "dnd" string per platform. If a user is offline or invisible, the corresponding field is not present.
    """

    let desktop: (StatusType | None)
        """
        User's status set for an active desktop (Windows, Linux, Mac) application session
        """

    let mobile: (StatusType | None)
        """
        User's status set for an active mobile (iOS, Android) application session
        """

    let web: (StatusType | None)
        """
        User's status set for an active web (browser, bot user) application session
        """

    let vr: (StatusType | None)
        """
        User's status set for an active virtual reality application session
        """

    new val create(
        desktop': (StatusType | None) = None,
        mobile': (StatusType | None) = None,
        web': (StatusType | None) = None,
        vr': (StatusType | None) = None
    ) =>
        desktop = desktop'
        mobile = mobile'
        web = web'
        vr = vr'

    new val from_json(obj: json.JsonObject) ? =>
        var desktop': (StatusType | None) = None
        var mobile': (StatusType | None) = None
        var web': (StatusType | None) = None
        var vr': (StatusType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "desktop" => desktop' = StatusTypes.from(value as String)?
            | "mobile" => mobile' = StatusTypes.from(value as String)?
            | "web" => web' = StatusTypes.from(value as String)?
            | "vr" => vr' = StatusTypes.from(value as String)?
            end
        end

        desktop = desktop'
        mobile = mobile'
        web = web'
        vr = vr'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match desktop
        | let desktop': StatusType => obj = obj.update("desktop", desktop'.value())
        end

        match mobile
        | let mobile': StatusType => obj = obj.update("mobile", mobile'.value())
        end

        match web
        | let web': StatusType => obj = obj.update("web", web'.value())
        end

        match vr
        | let vr': StatusType => obj = obj.update("vr", vr'.value())
        end

        obj

class val Presence is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#presence-update

    A user's presence is their current state on a guild. This event is sent when a user's presence or info, such as name or avatar, is updated.

    The user object within this event can be partial, the only field which must be sent is the `id` field, everything else is optional. Along with this limitation, no fields are required, and the types of the fields are not validated. Your client should expect any combination of fields and types within this event.

    Guilds sent in a `GUILD_CREATE` carry presences of this shape too, in which case they are partial.
    """

    let user: (PartialUser | None)
        """
        User whose presence is being updated
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let status: (StatusType | None)
        """
        Either "idle", "dnd", "online", or "offline"
        """

    let activities: (Array[Activity] val | None)
        """
        User's current activities
        """

    let client_status: (ClientStatus | None)
        """
        User's platform-dependent status
        """

    new val create(
        user': (PartialUser | None) = None,
        guild_id': (Snowflake | None) = None,
        status': (StatusType | None) = None,
        activities': (Array[Activity] val | None) = None,
        client_status': (ClientStatus | None) = None
    ) =>
        user = user'
        guild_id = guild_id'
        status = status'
        activities = activities'
        client_status = client_status'

    new val from_json(obj: json.JsonObject) ? =>
        var user': (PartialUser | None) = None
        var guild_id': (Snowflake | None) = None
        var status': (StatusType | None) = None
        var activities': (Array[Activity] val | None) = None
        var client_status': (ClientStatus | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user" => user' = PartialUser.from_json(value as json.JsonObject)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "status" => status' = StatusTypes.from(value as String)?
            | "activities" => activities' = _Activities(value)?
            | "client_status" => client_status' = ClientStatus.from_json(value as json.JsonObject)?
            end
        end

        user = user'
        guild_id = guild_id'
        status = status'
        activities = activities'
        client_status = client_status'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match user
        | let user': PartialUser => obj = obj.update("user", user'.to_json())
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match status
        | let status': StatusType => obj = obj.update("status", status'.value())
        end

        match activities
        | let activities': Array[Activity] val => obj = obj.update("activities", _Activities.to_json(activities'))
        end

        match client_status
        | let client_status': ClientStatus => obj = obj.update("client_status", client_status'.to_json())
        end

        obj

primitive _Presences
    fun apply(value: json.JsonValue): Array[Presence] val ? =>
        """
        Decodes an array of presences.
        """

        let array = value as json.JsonArray
        recover val
            let presences = Array[Presence](array.size())
            for presence in array.values() do presences.push(Presence.from_json(presence as json.JsonObject)?) end
            presences
        end

    fun to_json(presences: Array[Presence] val): json.JsonArray =>
        var array = json.JsonArray
        for presence in presences.values() do array = array.push(presence.to_json()) end
        array

class val GatewayHello is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#hello

    Sent on connection to the websocket. Defines the heartbeat interval that an app should heartbeat to.
    """

    let heartbeat_interval: USize
        """
        Interval (in milliseconds) an app should heartbeat with
        """

    new val create(heartbeat_interval': USize) =>
        heartbeat_interval = heartbeat_interval'

    new val from_json(obj: json.JsonObject) ? =>
        var heartbeat_interval': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "heartbeat_interval" => heartbeat_interval' = (value as I64).usize()
            end
        end

        heartbeat_interval = heartbeat_interval' as USize

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("heartbeat_interval", heartbeat_interval.i64())

class val GatewayReady is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#ready

    The ready event is dispatched when a client has completed the initial handshake with the gateway (for new sessions). The ready event can be the largest and most complex event the gateway will send, as it contains all the state required for a client to begin interacting with the rest of the platform.
    """

    let v: ApiVersion
        """
        API version
        """

    let user: User
        """
        Information about the user including email
        """

    let guilds: Array[UnavailableGuild] val
        """
        Guilds the user is in

        They start out as unavailable when you connect to the gateway. As they become available, your bot will be notified via `GUILD_CREATE` events.
        """

    let session_id: String
        """
        Used for resuming connections
        """

    let resume_gateway_url: String
        """
        Gateway URL for resuming connections
        """

    let shard: ((USize, USize) | None)
        """
        Shard information associated with this session, if sent when identifying
        """

    let application: PartialApplication
        """
        Contains `id` and `flags`
        """

    new val create(
        v': ApiVersion,
        user': User,
        guilds': Array[UnavailableGuild] val,
        session_id': String,
        resume_gateway_url': String,
        shard': ((USize, USize) | None) = None,
        application': PartialApplication
    ) =>
        v = v'
        user = user'
        guilds = guilds'
        session_id = session_id'
        resume_gateway_url = resume_gateway_url'
        shard = shard'
        application = application'

    new val from_json(obj: json.JsonObject) ? =>
        var v': (ApiVersion | None) = None
        var user': (User | None) = None
        var guilds': (Array[UnavailableGuild] val | None) = None
        var session_id': (String | None) = None
        var resume_gateway_url': (String | None) = None
        var shard': ((USize, USize) | None) = None
        var application': (PartialApplication | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "v" => v' = ApiVersions.from((value as I64).u8())?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "guilds" => guilds' = _UnavailableGuilds(value)?
            | "session_id" => session_id' = value as String
            | "resume_gateway_url" => resume_gateway_url' = value as String
            | "shard" =>
                let shards = _USizes(value as json.JsonArray)?
                shard' = (shards(0)?, shards(1)?)
            | "application" => application' = PartialApplication.from_json(value as json.JsonObject)?
            end
        end

        v = v' as ApiVersion
        user = user' as User
        guilds = guilds' as Array[UnavailableGuild] val
        session_id = session_id' as String
        resume_gateway_url = resume_gateway_url' as String
        shard = shard'
        application = application' as PartialApplication

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("v", v.value().i64())
            .update("user", user.to_json())
            .update("guilds", _UnavailableGuilds.to_json(guilds))
            .update("session_id", session_id)
            .update("resume_gateway_url", resume_gateway_url)
            .update("application", application.to_json())

        match shard
        | (let shard_id: USize, let num_shards: USize) =>
            obj = obj.update("shard", json.JsonArray.push(shard_id.i64()).push(num_shards.i64()))
        end

        obj

type GatewayRateLimitMetadata is RequestGuildMembersRateLimitMetadata
    """
    https://docs.discord.com/developers/events/gateway-events#rate-limited-rate-limit-metadata-for-opcode-structure

    Metadata for the event that was rate limited. `GatewayOpcodeRequestGuildMembers` is the only opcode Discord documents metadata for.
    """

class val GatewayRateLimited is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#rate-limited

    Sent when an app encounters a gateway rate limit for an event, such as Request Guild Members.
    """

    let opcode: GatewayOpcode
        """
        Gateway opcode of the event that was rate limited
        """

    let retry_after: F64
        """
        The number of seconds to wait before submitting another request
        """

    let meta: GatewayRateLimitMetadata
        """
        Metadata for the event that was rate limited
        """

    new val create(
        opcode': GatewayOpcode,
        retry_after': F64,
        meta': GatewayRateLimitMetadata
    ) =>
        opcode = opcode'
        retry_after = retry_after'
        meta = meta'

    new val from_json(obj: json.JsonObject) ? =>
        var opcode': (GatewayOpcode | None) = None
        var retry_after': (F64 | None) = None
        var meta': (GatewayRateLimitMetadata | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "opcode" => opcode' = GatewayOpcodes.from((value as I64).u8())?
            | "retry_after" =>
                match value
                | let float: F64 => retry_after' = float
                | let integer: I64 => retry_after' = integer.f64()
                end
            | "meta" => meta' = RequestGuildMembersRateLimitMetadata.from_json(value as json.JsonObject)?
            end
        end

        opcode = opcode' as GatewayOpcode
        retry_after = retry_after' as F64
        meta = meta' as GatewayRateLimitMetadata

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("opcode", opcode.value().i64())
            .update("retry_after", retry_after)
            .update("meta", meta.to_json())

class val RequestGuildMembersRateLimitMetadata is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#rate-limited-request-guild-member-rate-limit-metadata-structure
    """

    let guild_id: Snowflake
        """
        ID of the guild to get members for
        """

    let nonce: (String | None)
        """
        nonce to identify the Guild Members Chunk response
        """

    new val create(guild_id': Snowflake, nonce': (String | None) = None) =>
        guild_id = guild_id'
        nonce = nonce'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var nonce': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "nonce" => nonce' = value as String
            end
        end

        guild_id = guild_id' as Snowflake
        nonce = nonce'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("guild_id", guild_id.to_json())

        match nonce
        | let nonce': String => obj = obj.update("nonce", nonce')
        end

        obj

class val AutoModerationActionExecution is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#auto-moderation-action-execution

    Sent when a rule is triggered and an action is executed (e.g. when a message is blocked).
    """

    let guild_id: Snowflake
        """
        ID of the guild in which action was executed
        """

    let action: AutoModerationAction
        """
        Action which was executed
        """

    let rule_id: Snowflake
        """
        ID of the rule which action belongs to
        """

    let rule_trigger_type: AutoModerationTriggerType
        """
        Trigger type of rule which was triggered
        """

    let user_id: Snowflake
        """
        ID of the user which generated the content which triggered the rule
        """

    let channel_id: (Snowflake | None)
        """
        ID of the channel in which user content was posted
        """

    let message_id: (Snowflake | None)
        """
        ID of any user message which content belongs to

        Will not exist if message was blocked by Auto Moderation or content was not part of any message.
        """

    let alert_system_message_id: (Snowflake | None)
        """
        ID of any system auto moderation messages posted as a result of this action

        Will not exist if this event does not correspond to an action with type `SEND_ALERT_MESSAGE`.
        """

    let content: String
        """
        User-generated text content

        The `MESSAGE_CONTENT` intent is required to receive this field.
        """

    let matched_keyword: (String | None)
        """
        Word or phrase configured in the rule that triggered the rule
        """

    let matched_content: (String | None)
        """
        Substring in content that triggered the rule

        The `MESSAGE_CONTENT` intent is required to receive this field.
        """

    new val create(
        guild_id': Snowflake,
        action': AutoModerationAction,
        rule_id': Snowflake,
        rule_trigger_type': AutoModerationTriggerType,
        user_id': Snowflake,
        channel_id': (Snowflake | None) = None,
        message_id': (Snowflake | None) = None,
        alert_system_message_id': (Snowflake | None) = None,
        content': String,
        matched_keyword': (String | None) = None,
        matched_content': (String | None) = None
    ) =>
        guild_id = guild_id'
        action = action'
        rule_id = rule_id'
        rule_trigger_type = rule_trigger_type'
        user_id = user_id'
        channel_id = channel_id'
        message_id = message_id'
        alert_system_message_id = alert_system_message_id'
        content = content'
        matched_keyword = matched_keyword'
        matched_content = matched_content'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var action': (AutoModerationAction | None) = None
        var rule_id': (Snowflake | None) = None
        var rule_trigger_type': (AutoModerationTriggerType | None) = None
        var user_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var alert_system_message_id': (Snowflake | None) = None
        var content': (String | None) = None
        var matched_keyword': (String | None) = None
        var matched_content': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "action" => action' = AutoModerationAction.from_json(value as json.JsonObject)?
            | "rule_id" => rule_id' = Snowflake.from_json(value)?
            | "rule_trigger_type" => rule_trigger_type' = AutoModerationTriggerTypes.from((value as I64).u8())?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "alert_system_message_id" => alert_system_message_id' = Snowflake.from_json(value)?
            | "content" => content' = value as String
            | "matched_keyword" =>
                match value | let string: String => matched_keyword' = string end
            | "matched_content" =>
                match value | let string: String => matched_content' = string end
            end
        end

        guild_id = guild_id' as Snowflake
        action = action' as AutoModerationAction
        rule_id = rule_id' as Snowflake
        rule_trigger_type = rule_trigger_type' as AutoModerationTriggerType
        user_id = user_id' as Snowflake
        channel_id = channel_id'
        message_id = message_id'
        alert_system_message_id = alert_system_message_id'
        content = content' as String
        matched_keyword = matched_keyword'
        matched_content = matched_content'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("action", action.to_json())
            .update("rule_id", rule_id.to_json())
            .update("rule_trigger_type", rule_trigger_type.value().i64())
            .update("user_id", user_id.to_json())
            .update("content", content)
            .update("matched_keyword", matched_keyword)
            .update("matched_content", matched_content)

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match message_id
        | let message_id': Snowflake => obj = obj.update("message_id", message_id'.to_json())
        end

        match alert_system_message_id
        | let alert_system_message_id': Snowflake => obj = obj.update("alert_system_message_id", alert_system_message_id'.to_json())
        end

        obj

class val ChannelInfo is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#channel-info

    Includes ephemeral data for channels in a guild. Sent in response to Request Channel Info.
    """

    let guild_id: Snowflake
        """
        The guild id
        """

    let channels: Array[ChannelInfoChannel] val
        """
        Ephemeral data for channels in the guild
        """

    new val create(guild_id': Snowflake, channels': Array[ChannelInfoChannel] val) =>
        guild_id = guild_id'
        channels = channels'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var channels': (Array[ChannelInfoChannel] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channels" => channels' = _ChannelInfoChannels(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        channels = channels' as Array[ChannelInfoChannel] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("channels", _ChannelInfoChannels.to_json(channels))

class val ChannelInfoChannel is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#channel-info-channel-info-channel-structure
    """

    let id: Snowflake
        """
        The channel id
        """

    let status: (String | None)
        """
        The voice channel status
        """

    let voice_start_time: (U64 | None)
        """
        Unix timestamp (in seconds) of when the voice session started
        """

    new val create(
        id': Snowflake,
        status': (String | None) = None,
        voice_start_time': (U64 | None) = None
    ) =>
        id = id'
        status = status'
        voice_start_time = voice_start_time'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var status': (String | None) = None
        var voice_start_time': (U64 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "status" =>
                match value | let string: String => status' = string end
            | "voice_start_time" =>
                match value | let integer: I64 => voice_start_time' = integer.u64() end
            end
        end

        id = id' as Snowflake
        status = status'
        voice_start_time = voice_start_time'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match status
        | let status': String => obj = obj.update("status", status')
        end

        match voice_start_time
        | let voice_start_time': U64 => obj = obj.update("voice_start_time", voice_start_time'.i64())
        end

        obj

primitive _ChannelInfoChannels
    fun apply(value: json.JsonValue): Array[ChannelInfoChannel] val ? =>
        """
        Decodes an array of channel infos.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[ChannelInfoChannel](array.size())
            for channel in array.values() do channels.push(ChannelInfoChannel.from_json(channel as json.JsonObject)?) end
            channels
        end

    fun to_json(channels: Array[ChannelInfoChannel] val): json.JsonArray =>
        var array = json.JsonArray
        for channel in channels.values() do array = array.push(channel.to_json()) end
        array

class val VoiceChannelStatusUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#voice-channel-status-update

    Sent when the voice channel status changes.
    """

    let id: Snowflake
        """
        The channel id
        """

    let guild_id: Snowflake
        """
        The guild id
        """

    let status: (String | None)
        """
        The new voice channel status
        """

    new val create(id': Snowflake, guild_id': Snowflake, status': (String | None)) =>
        id = id'
        guild_id = guild_id'
        status = status'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var status': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "status" =>
                match value | let string: String => status' = string end
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        status = status'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("status", status)

class val VoiceChannelStartTimeUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#voice-channel-start-time-update

    Sent when the voice channel start time changes.
    """

    let id: Snowflake
        """
        The channel id
        """

    let guild_id: Snowflake
        """
        The guild id
        """

    let voice_start_time: (U64 | None)
        """
        Unix timestamp (in seconds) of when the voice session started
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        voice_start_time': (U64 | None) = None
    ) =>
        id = id'
        guild_id = guild_id'
        voice_start_time = voice_start_time'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var voice_start_time': (U64 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "voice_start_time" =>
                match value | let integer: I64 => voice_start_time' = integer.u64() end
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        voice_start_time = voice_start_time'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())

        match voice_start_time
        | let voice_start_time': U64 => obj = obj.update("voice_start_time", voice_start_time'.i64())
        end

        obj

class val ThreadCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#thread-create

    Sent when a thread is created, relevant to the current user, or when the current user is added to a thread.

    When being added to an existing private thread, the channel includes a thread member object.
    """

    let channel: Channel
        """
        The thread that was created
        """

    let newly_created: (Bool | None)
        """
        Whether the thread was just created, as opposed to the current user having been added to it
        """

    new val create(channel': Channel, newly_created': (Bool | None) = None) =>
        channel = channel'
        newly_created = newly_created'

    new val from_json(obj: json.JsonObject) ? =>
        channel = Channel.from_json(obj)?

        var newly_created': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "newly_created" => newly_created' = value as Bool
            end
        end

        newly_created = newly_created'

    fun to_json(): json.JsonObject =>
        var obj = channel.to_json()

        match newly_created
        | let newly_created': Bool => obj = obj.update("newly_created", newly_created')
        end

        obj

class val ThreadDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#thread-delete

    Sent when a thread relevant to the current user is deleted. A subset of the channel object, containing just the `id`, `guild_id`, `parent_id`, and `type` fields.
    """

    let id: Snowflake
        """
        ID of the thread
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let parent_id: Snowflake
        """
        ID of the channel the thread was created in
        """

    let type': ChannelType
        """
        Type of the thread
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        parent_id': Snowflake,
        type'': ChannelType
    ) =>
        id = id'
        guild_id = guild_id'
        parent_id = parent_id'
        type' = type''

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var parent_id': (Snowflake | None) = None
        var type'': (ChannelType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "parent_id" => parent_id' = Snowflake.from_json(value)?
            | "type" => type'' = ChannelTypes.from((value as I64).u8())?
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        parent_id = parent_id' as Snowflake
        type' = type'' as ChannelType

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("parent_id", parent_id.to_json())
            .update("type", type'.value().i64())

class val ThreadListSync is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#thread-list-sync

    Sent when the current user gains access to a channel.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let channel_ids: (Array[Snowflake] val | None)
        """
        Parent channel IDs whose threads are being synced. If omitted, then threads were synced for the entire guild. This array may contain channel_ids that have no active threads as well, so you know to clear that data.
        """

    let threads: Array[Channel] val
        """
        All active threads in the given channels that the current user can access
        """

    let members: Array[ThreadMember] val
        """
        All thread member objects from the synced threads for the current user, indicating which threads the current user has been added to
        """

    new val create(
        guild_id': Snowflake,
        channel_ids': (Array[Snowflake] val | None) = None,
        threads': Array[Channel] val,
        members': Array[ThreadMember] val
    ) =>
        guild_id = guild_id'
        channel_ids = channel_ids'
        threads = threads'
        members = members'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var channel_ids': (Array[Snowflake] val | None) = None
        var threads': (Array[Channel] val | None) = None
        var members': (Array[ThreadMember] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_ids" => channel_ids' = _Snowflakes(value)?
            | "threads" => threads' = _Channels(value)?
            | "members" => members' = _ThreadMembers(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        channel_ids = channel_ids'
        threads = threads' as Array[Channel] val
        members = members' as Array[ThreadMember] val

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("threads", _Channels.to_json(threads))
            .update("members", _ThreadMembers.to_json(members))

        match channel_ids
        | let channel_ids': Array[Snowflake] val => obj = obj.update("channel_ids", _Snowflakes.to_json(channel_ids'))
        end

        obj

class val ThreadMemberUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#thread-member-update

    Sent when the thread member object for the current user is updated. For bots, this event largely is just a signal that you are a member of the thread.
    """

    let member: ThreadMember
        """
        The thread member that was updated
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(member': ThreadMember, guild_id': Snowflake) =>
        member = member'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        member = ThreadMember.from_json(obj)?

        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        member.to_json().update("guild_id", guild_id.to_json())

class val ThreadMembersUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#thread-members-update

    Sent when anyone is added to or removed from a thread. If the current user does not have the `GUILD_MEMBERS` intent, then this event will only be sent if the current user was added to or removed from the thread.
    """

    let id: Snowflake
        """
        ID of the thread
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let member_count: USize
        """
        Approximate number of members in the thread, capped at 50
        """

    let added_members: (Array[ThreadMember] val | None)
        """
        Users who were added to the thread

        In this gateway event, the thread member objects will also include the guild member and nullable presence objects for each added thread member.
        """

    let removed_member_ids: (Array[Snowflake] val | None)
        """
        ID of the users who were removed from the thread
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        member_count': USize,
        added_members': (Array[ThreadMember] val | None) = None,
        removed_member_ids': (Array[Snowflake] val | None) = None
    ) =>
        id = id'
        guild_id = guild_id'
        member_count = member_count'
        added_members = added_members'
        removed_member_ids = removed_member_ids'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var member_count': (USize | None) = None
        var added_members': (Array[ThreadMember] val | None) = None
        var removed_member_ids': (Array[Snowflake] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "member_count" => member_count' = (value as I64).usize()
            | "added_members" => added_members' = _ThreadMembers(value)?
            | "removed_member_ids" => removed_member_ids' = _Snowflakes(value)?
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        member_count = member_count' as USize
        added_members = added_members'
        removed_member_ids = removed_member_ids'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("member_count", member_count.i64())

        match added_members
        | let added_members': Array[ThreadMember] val => obj = obj.update("added_members", _ThreadMembers.to_json(added_members'))
        end

        match removed_member_ids
        | let removed_member_ids': Array[Snowflake] val => obj = obj.update("removed_member_ids", _Snowflakes.to_json(removed_member_ids'))
        end

        obj

class val ChannelPinsUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#channel-pins-update

    Sent when a message is pinned or unpinned in a text channel. This is not sent when a pinned message is deleted.
    """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let last_pin_timestamp: (ISO8601 | None)
        """
        Time at which the most recent pinned message was pinned
        """

    new val create(
        guild_id': (Snowflake | None) = None,
        channel_id': Snowflake,
        last_pin_timestamp': (ISO8601 | None) = None
    ) =>
        guild_id = guild_id'
        channel_id = channel_id'
        last_pin_timestamp = last_pin_timestamp'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var last_pin_timestamp': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "last_pin_timestamp" =>
                match value | let string: String => last_pin_timestamp' = string end
            end
        end

        guild_id = guild_id'
        channel_id = channel_id' as Snowflake
        last_pin_timestamp = last_pin_timestamp'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("channel_id", channel_id.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match last_pin_timestamp
        | let last_pin_timestamp': ISO8601 => obj = obj.update("last_pin_timestamp", last_pin_timestamp')
        end

        obj

class val GuildCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-create

    Sent when a user is initially connecting, to lazily load and backfill information for all unavailable guilds sent in the Ready event, when a guild becomes available again to the client, or when the current user joins a new guild.

    An unavailable guild arrives as an `UnavailableGuild` instead.

    If your bot does not have the `GUILD_PRESENCES` intent, or if the guild has over 75k members, members and presences returned in this event will only contain your bot and users in voice channels.
    """

    let guild: Guild
        """
        The guild that became available
        """

    let joined_at: ISO8601
        """
        When this guild was joined at
        """

    let large: Bool
        """
        `true` if this is considered a large guild
        """

    let unavailable: (Bool | None)
        """
        `true` if this guild is unavailable due to an outage
        """

    let member_count: USize
        """
        Total number of members in this guild
        """

    let voice_states: Array[VoiceState] val
        """
        States of members currently in voice channels; lacks the `guild_id` key
        """

    let members: Array[GuildMember] val
        """
        Users in the guild
        """

    let channels: Array[Channel] val
        """
        Channels in the guild
        """

    let threads: Array[Channel] val
        """
        All active threads in the guild that current user has permission to view
        """

    let presences: Array[Presence] val
        """
        Presences of the members in the guild, will only include non-offline members if the size is greater than `large threshold`
        """

    let stage_instances: Array[StageInstance] val
        """
        Stage instances in the guild
        """

    let guild_scheduled_events: Array[GuildScheduledEvent] val
        """
        Scheduled events in the guild
        """

    let soundboard_sounds: Array[SoundboardSound] val
        """
        Soundboard sounds in the guild
        """

    new val create(
        guild': Guild,
        joined_at': ISO8601,
        large': Bool,
        unavailable': (Bool | None) = None,
        member_count': USize,
        voice_states': Array[VoiceState] val,
        members': Array[GuildMember] val,
        channels': Array[Channel] val,
        threads': Array[Channel] val,
        presences': Array[Presence] val,
        stage_instances': Array[StageInstance] val,
        guild_scheduled_events': Array[GuildScheduledEvent] val,
        soundboard_sounds': Array[SoundboardSound] val
    ) =>
        guild = guild'
        joined_at = joined_at'
        large = large'
        unavailable = unavailable'
        member_count = member_count'
        voice_states = voice_states'
        members = members'
        channels = channels'
        threads = threads'
        presences = presences'
        stage_instances = stage_instances'
        guild_scheduled_events = guild_scheduled_events'
        soundboard_sounds = soundboard_sounds'

    new val from_json(obj: json.JsonObject) ? =>
        guild = Guild.from_json(obj)?

        var joined_at': (ISO8601 | None) = None
        var large': (Bool | None) = None
        var unavailable': (Bool | None) = None
        var member_count': (USize | None) = None
        var voice_states': (Array[VoiceState] val | None) = None
        var members': (Array[GuildMember] val | None) = None
        var channels': (Array[Channel] val | None) = None
        var threads': (Array[Channel] val | None) = None
        var presences': (Array[Presence] val | None) = None
        var stage_instances': (Array[StageInstance] val | None) = None
        var guild_scheduled_events': (Array[GuildScheduledEvent] val | None) = None
        var soundboard_sounds': (Array[SoundboardSound] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "joined_at" => joined_at' = value as String
            | "large" => large' = value as Bool
            | "unavailable" => unavailable' = value as Bool
            | "member_count" => member_count' = (value as I64).usize()
            | "voice_states" => voice_states' = _VoiceStates(value)?
            | "members" => members' = _GuildMembers(value)?
            | "channels" => channels' = _Channels(value)?
            | "threads" => threads' = _Channels(value)?
            | "presences" => presences' = _Presences(value)?
            | "stage_instances" => stage_instances' = _StageInstances(value)?
            | "guild_scheduled_events" => guild_scheduled_events' = _GuildScheduledEvents(value)?
            | "soundboard_sounds" => soundboard_sounds' = _SoundboardSounds(value)?
            end
        end

        joined_at = joined_at' as ISO8601
        large = large' as Bool
        unavailable = unavailable'
        member_count = member_count' as USize
        voice_states = voice_states' as Array[VoiceState] val
        members = members' as Array[GuildMember] val
        channels = channels' as Array[Channel] val
        threads = threads' as Array[Channel] val
        presences = presences' as Array[Presence] val
        stage_instances = stage_instances' as Array[StageInstance] val
        guild_scheduled_events = guild_scheduled_events' as Array[GuildScheduledEvent] val
        soundboard_sounds = soundboard_sounds' as Array[SoundboardSound] val

    fun to_json(): json.JsonObject =>
        var obj = guild.to_json()
            .update("joined_at", joined_at)
            .update("large", large)
            .update("member_count", member_count.i64())
            .update("voice_states", _VoiceStates.to_json(voice_states))
            .update("members", _GuildMembers.to_json(members))
            .update("channels", _Channels.to_json(channels))
            .update("threads", _Channels.to_json(threads))
            .update("presences", _Presences.to_json(presences))
            .update("stage_instances", _StageInstances.to_json(stage_instances))
            .update("guild_scheduled_events", _GuildScheduledEvents.to_json(guild_scheduled_events))
            .update("soundboard_sounds", _SoundboardSounds.to_json(soundboard_sounds))

        match unavailable
        | let unavailable': Bool => obj = obj.update("unavailable", unavailable')
        end

        obj

class val GuildAuditLogEntryCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-audit-log-entry-create

    Sent when a guild audit log entry is created. This event is only sent to bots with the `VIEW_AUDIT_LOG` permission.
    """

    let entry: AuditLogEntry
        """
        The audit log entry that was created
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(entry': AuditLogEntry, guild_id': Snowflake) =>
        entry = entry'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        entry = AuditLogEntry.from_json(obj)?

        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        entry.to_json().update("guild_id", guild_id.to_json())

class val GuildBanAdd is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-ban-add

    Sent when a user is banned from a guild. This event is only sent to bots with the `BAN_MEMBERS` or `VIEW_AUDIT_LOG` permission.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let user: User
        """
        User who was banned
        """

    new val create(guild_id': Snowflake, user': User) =>
        guild_id = guild_id'
        user = user'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        guild_id = guild_id' as Snowflake
        user = user' as User

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("user", user.to_json())

class val GuildBanRemove is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-ban-remove

    Sent when a user is unbanned from a guild. This event is only sent to bots with the `BAN_MEMBERS` or `VIEW_AUDIT_LOG` permission.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let user: User
        """
        User who was unbanned
        """

    new val create(guild_id': Snowflake, user': User) =>
        guild_id = guild_id'
        user = user'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        guild_id = guild_id' as Snowflake
        user = user' as User

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("user", user.to_json())

class val GuildEmojisUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-emojis-update

    Sent when a guild's emojis have been updated.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let emojis: Array[Emoji] val
        """
        Array of emojis
        """

    new val create(guild_id': Snowflake, emojis': Array[Emoji] val) =>
        guild_id = guild_id'
        emojis = emojis'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var emojis': (Array[Emoji] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "emojis" => emojis' = _Emojis(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        emojis = emojis' as Array[Emoji] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("emojis", _Emojis.to_json(emojis))

class val GuildStickersUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-stickers-update

    Sent when a guild's stickers have been updated.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let stickers: Array[Sticker] val
        """
        Array of stickers
        """

    new val create(guild_id': Snowflake, stickers': Array[Sticker] val) =>
        guild_id = guild_id'
        stickers = stickers'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var stickers': (Array[Sticker] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "stickers" => stickers' = _Stickers(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        stickers = stickers' as Array[Sticker] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("stickers", _Stickers.to_json(stickers))

class val GuildIntegrationsUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-integrations-update

    Sent when a guild integration is updated.
    """

    let guild_id: Snowflake
        """
        ID of the guild whose integrations were updated
        """

    new val create(guild_id': Snowflake) =>
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("guild_id", guild_id.to_json())

class val GuildMemberAdd is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-member-add

    Sent when a user joins a guild. This event may also be sent for users who are already members of the guild. The `GUILD_MEMBERS` intent is required to receive this event.
    """

    let member: GuildMember
        """
        The member that joined
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(member': GuildMember, guild_id': Snowflake) =>
        member = member'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        member = GuildMember.from_json(obj)?

        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        member.to_json().update("guild_id", guild_id.to_json())

class val GuildMemberRemove is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-member-remove

    Sent when a user is removed from a guild (leave/kick/ban). The `GUILD_MEMBERS` intent is required to receive this event.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let user: User
        """
        User who was removed
        """

    new val create(guild_id': Snowflake, user': User) =>
        guild_id = guild_id'
        user = user'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        guild_id = guild_id' as Snowflake
        user = user' as User

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("user", user.to_json())

class val GuildMemberUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-member-update

    Sent when a guild member is updated. This will also fire when the user object of a guild member changes. The `GUILD_MEMBERS` intent is required to receive this event, except for current-user updates.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let roles: Array[Snowflake] val
        """
        User role ids
        """

    let user: User
        """
        User
        """

    let nick: (String | None)
        """
        Nickname of the user in the guild
        """

    let avatar: (String | None)
        """
        Member's guild avatar hash
        """

    let banner: (String | None)
        """
        Member's guild banner hash
        """

    let joined_at: (ISO8601 | None)
        """
        When the user joined the guild
        """

    let premium_since: (ISO8601 | None)
        """
        When the user starting boosting the guild
        """

    let deaf: (Bool | None)
        """
        Whether the user is deafened in voice channels
        """

    let mute: (Bool | None)
        """
        Whether the user is muted in voice channels
        """

    let pending: (Bool | None)
        """
        Whether the user has not yet passed the guild's Membership Screening requirements
        """

    let communication_disabled_until: (ISO8601 | None)
        """
        When the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
        """

    let avatar_decoration_data: (AvatarDecorationData | None)
        """
        Data for the member's guild avatar decoration
        """

    let collectibles: (Collectibles | None)
        """
        data for the member's collectibles
        """

    new val create(
        guild_id': Snowflake,
        roles': Array[Snowflake] val,
        user': User,
        nick': (String | None) = None,
        avatar': (String | None) = None,
        banner': (String | None) = None,
        joined_at': (ISO8601 | None) = None,
        premium_since': (ISO8601 | None) = None,
        deaf': (Bool | None) = None,
        mute': (Bool | None) = None,
        pending': (Bool | None) = None,
        communication_disabled_until': (ISO8601 | None) = None,
        avatar_decoration_data': (AvatarDecorationData | None) = None,
        collectibles': (Collectibles | None) = None
    ) =>
        guild_id = guild_id'
        roles = roles'
        user = user'
        nick = nick'
        avatar = avatar'
        banner = banner'
        joined_at = joined_at'
        premium_since = premium_since'
        deaf = deaf'
        mute = mute'
        pending = pending'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'
        collectibles = collectibles'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var roles': (Array[Snowflake] val | None) = None
        var user': (User | None) = None
        var nick': (String | None) = None
        var avatar': (String | None) = None
        var banner': (String | None) = None
        var joined_at': (ISO8601 | None) = None
        var premium_since': (ISO8601 | None) = None
        var deaf': (Bool | None) = None
        var mute': (Bool | None) = None
        var pending': (Bool | None) = None
        var communication_disabled_until': (ISO8601 | None) = None
        var avatar_decoration_data': (AvatarDecorationData | None) = None
        var collectibles': (Collectibles | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "roles" => roles' = _Snowflakes(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "nick" =>
                match value | let string: String => nick' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "joined_at" =>
                match value | let string: String => joined_at' = string end
            | "premium_since" =>
                match value | let string: String => premium_since' = string end
            | "deaf" => deaf' = value as Bool
            | "mute" => mute' = value as Bool
            | "pending" => pending' = value as Bool
            | "communication_disabled_until" =>
                match value | let string: String => communication_disabled_until' = string end
            | "avatar_decoration_data" =>
                match value | let obj': json.JsonObject => avatar_decoration_data' = AvatarDecorationData.from_json(obj')? end
            | "collectibles" =>
                match value | let obj': json.JsonObject => collectibles' = Collectibles.from_json(obj')? end
            end
        end

        guild_id = guild_id' as Snowflake
        roles = roles' as Array[Snowflake] val
        user = user' as User
        nick = nick'
        avatar = avatar'
        banner = banner'
        joined_at = joined_at'
        premium_since = premium_since'
        deaf = deaf'
        mute = mute'
        pending = pending'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'
        collectibles = collectibles'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("roles", _Snowflakes.to_json(roles))
            .update("user", user.to_json())
            .update("avatar", avatar)
            .update("banner", banner)
            .update("joined_at", joined_at)

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        end

        match premium_since
        | let premium_since': ISO8601 => obj = obj.update("premium_since", premium_since')
        end

        match deaf
        | let deaf': Bool => obj = obj.update("deaf", deaf')
        end

        match mute
        | let mute': Bool => obj = obj.update("mute", mute')
        end

        match pending
        | let pending': Bool => obj = obj.update("pending", pending')
        end

        match communication_disabled_until
        | let communication_disabled_until': ISO8601 => obj = obj.update("communication_disabled_until", communication_disabled_until')
        end

        match avatar_decoration_data
        | let avatar_decoration_data': AvatarDecorationData => obj = obj.update("avatar_decoration_data", avatar_decoration_data'.to_json())
        end

        match collectibles
        | let collectibles': Collectibles => obj = obj.update("collectibles", collectibles'.to_json())
        end

        obj

class val GuildMembersChunk is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-members-chunk

    Sent in response to Request Guild Members. You can use the `chunk_index` and `chunk_count` to calculate how many chunks are left for your request.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let members: Array[GuildMember] val
        """
        Set of guild members
        """

    let chunk_index: USize
        """
        Chunk index in the expected chunks for this response (`0 <= chunk_index < chunk_count`)
        """

    let chunk_count: USize
        """
        Total number of expected chunks for this response
        """

    let not_found: (Array[Snowflake] val | None)
        """
        When passing an invalid ID to `REQUEST_GUILD_MEMBERS`, it will be returned here
        """

    let presences: (Array[Presence] val | None)
        """
        When passing `true` to `REQUEST_GUILD_MEMBERS`, presences of the returned members will be here
        """

    let nonce: (String | None)
        """
        Nonce used in the Guild Members Request
        """

    new val create(
        guild_id': Snowflake,
        members': Array[GuildMember] val,
        chunk_index': USize,
        chunk_count': USize,
        not_found': (Array[Snowflake] val | None) = None,
        presences': (Array[Presence] val | None) = None,
        nonce': (String | None) = None
    ) =>
        guild_id = guild_id'
        members = members'
        chunk_index = chunk_index'
        chunk_count = chunk_count'
        not_found = not_found'
        presences = presences'
        nonce = nonce'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var members': (Array[GuildMember] val | None) = None
        var chunk_index': (USize | None) = None
        var chunk_count': (USize | None) = None
        var not_found': (Array[Snowflake] val | None) = None
        var presences': (Array[Presence] val | None) = None
        var nonce': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "members" => members' = _GuildMembers(value)?
            | "chunk_index" => chunk_index' = (value as I64).usize()
            | "chunk_count" => chunk_count' = (value as I64).usize()
            | "not_found" => not_found' = _Snowflakes(value)?
            | "presences" => presences' = _Presences(value)?
            | "nonce" => nonce' = value as String
            end
        end

        guild_id = guild_id' as Snowflake
        members = members' as Array[GuildMember] val
        chunk_index = chunk_index' as USize
        chunk_count = chunk_count' as USize
        not_found = not_found'
        presences = presences'
        nonce = nonce'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("members", _GuildMembers.to_json(members))
            .update("chunk_index", chunk_index.i64())
            .update("chunk_count", chunk_count.i64())

        match not_found
        | let not_found': Array[Snowflake] val => obj = obj.update("not_found", _Snowflakes.to_json(not_found'))
        end

        match presences
        | let presences': Array[Presence] val => obj = obj.update("presences", _Presences.to_json(presences'))
        end

        match nonce
        | let nonce': String => obj = obj.update("nonce", nonce')
        end

        obj

class val GuildRoleCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-role-create

    Sent when a guild role is created.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let role: Role
        """
        Role that was created
        """

    new val create(guild_id': Snowflake, role': Role) =>
        guild_id = guild_id'
        role = role'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var role': (Role | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "role" => role' = Role.from_json(value as json.JsonObject)?
            end
        end

        guild_id = guild_id' as Snowflake
        role = role' as Role

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("role", role.to_json())

class val GuildRoleUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-role-update

    Sent when a guild role is updated.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let role: Role
        """
        Role that was updated
        """

    new val create(guild_id': Snowflake, role': Role) =>
        guild_id = guild_id'
        role = role'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var role': (Role | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "role" => role' = Role.from_json(value as json.JsonObject)?
            end
        end

        guild_id = guild_id' as Snowflake
        role = role' as Role

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("role", role.to_json())

class val GuildRoleDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-role-delete

    Sent when a guild role is deleted.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let role_id: Snowflake
        """
        ID of the role
        """

    new val create(guild_id': Snowflake, role_id': Snowflake) =>
        guild_id = guild_id'
        role_id = role_id'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var role_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "role_id" => role_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        role_id = role_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("role_id", role_id.to_json())

class val GuildScheduledEventUserAdd is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-scheduled-event-user-add

    Sent when a user has subscribed to a guild scheduled event.
    """

    let guild_scheduled_event_id: Snowflake
        """
        ID of the guild scheduled event
        """

    let user_id: Snowflake
        """
        ID of the user
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(
        guild_scheduled_event_id': Snowflake,
        user_id': Snowflake,
        guild_id': Snowflake
    ) =>
        guild_scheduled_event_id = guild_scheduled_event_id'
        user_id = user_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_scheduled_event_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_scheduled_event_id" => guild_scheduled_event_id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_scheduled_event_id = guild_scheduled_event_id' as Snowflake
        user_id = user_id' as Snowflake
        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_scheduled_event_id", guild_scheduled_event_id.to_json())
            .update("user_id", user_id.to_json())
            .update("guild_id", guild_id.to_json())

class val GuildScheduledEventUserRemove is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-scheduled-event-user-remove

    Sent when a user has unsubscribed from a guild scheduled event.
    """

    let guild_scheduled_event_id: Snowflake
        """
        ID of the guild scheduled event
        """

    let user_id: Snowflake
        """
        ID of the user
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(
        guild_scheduled_event_id': Snowflake,
        user_id': Snowflake,
        guild_id': Snowflake
    ) =>
        guild_scheduled_event_id = guild_scheduled_event_id'
        user_id = user_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_scheduled_event_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_scheduled_event_id" => guild_scheduled_event_id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_scheduled_event_id = guild_scheduled_event_id' as Snowflake
        user_id = user_id' as Snowflake
        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_scheduled_event_id", guild_scheduled_event_id.to_json())
            .update("user_id", user_id.to_json())
            .update("guild_id", guild_id.to_json())

class val GuildSoundboardSoundDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-soundboard-sound-delete

    Sent when a guild soundboard sound is deleted.
    """

    let sound_id: Snowflake
        """
        ID of the sound that was deleted
        """

    let guild_id: Snowflake
        """
        ID of the guild the sound was in
        """

    new val create(sound_id': Snowflake, guild_id': Snowflake) =>
        sound_id = sound_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var sound_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "sound_id" => sound_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        sound_id = sound_id' as Snowflake
        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("sound_id", sound_id.to_json())
            .update("guild_id", guild_id.to_json())

class val GuildSoundboardSoundsUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#guild-soundboard-sounds-update

    Sent when multiple guild soundboard sounds are updated.
    """

    let soundboard_sounds: Array[SoundboardSound] val
        """
        The guild's soundboard sounds
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(soundboard_sounds': Array[SoundboardSound] val, guild_id': Snowflake) =>
        soundboard_sounds = soundboard_sounds'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var soundboard_sounds': (Array[SoundboardSound] val | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "soundboard_sounds" => soundboard_sounds' = _SoundboardSounds(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        soundboard_sounds = soundboard_sounds' as Array[SoundboardSound] val
        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("soundboard_sounds", _SoundboardSounds.to_json(soundboard_sounds))
            .update("guild_id", guild_id.to_json())

class val IntegrationCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#integration-create

    Sent when an integration is created. Discord omits `user` from the integration.
    """

    let integration: Integration
        """
        The integration that was created
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(integration': Integration, guild_id': Snowflake) =>
        integration = integration'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        integration = Integration.from_json(obj)?

        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        integration.to_json().update("guild_id", guild_id.to_json())

class val IntegrationUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#integration-update

    Sent when an integration is updated. Discord omits `user` from the integration.
    """

    let integration: Integration
        """
        The integration that was updated
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(integration': Integration, guild_id': Snowflake) =>
        integration = integration'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        integration = Integration.from_json(obj)?

        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        integration.to_json().update("guild_id", guild_id.to_json())

class val IntegrationDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#integration-delete

    Sent when an integration is deleted.
    """

    let id: Snowflake
        """
        Integration ID
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let application_id: (Snowflake | None)
        """
        ID of the bot/OAuth2 application for this discord integration
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        application_id': (Snowflake | None) = None
    ) =>
        id = id'
        guild_id = guild_id'
        application_id = application_id'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        application_id = application_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())

        match application_id
        | let application_id': Snowflake => obj = obj.update("application_id", application_id'.to_json())
        end

        obj

class val InviteCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#invite-create

    Sent when a new invite to a channel is created. Only sent to bot users with the `MANAGE_CHANNELS` permission on the channel.
    """

    let channel_id: Snowflake
        """
        Channel the invite is for
        """

    let code: String
        """
        Unique invite code
        """

    let created_at: ISO8601
        """
        Time at which the invite was created
        """

    let guild_id: (Snowflake | None)
        """
        Guild of the invite
        """

    let inviter: (User | None)
        """
        User that created the invite
        """

    let max_age: USize
        """
        How long the invite is valid for (in seconds)
        """

    let max_uses: USize
        """
        Maximum number of times the invite can be used
        """

    let target_type: (InviteTargetType | None)
        """
        Type of target for this voice channel invite
        """

    let target_user: (User | None)
        """
        User whose stream to display for this voice channel stream invite
        """

    let target_application: (PartialApplication | None)
        """
        Embedded application to open for this voice channel embedded application invite
        """

    let temporary: Bool
        """
        Whether or not the invite is temporary (invited users will be kicked on disconnect unless they're assigned a role)
        """

    let uses: USize
        """
        How many times the invite has been used (always will be 0)
        """

    let expires_at: (ISO8601 | None)
        """
        the expiration date of this invite
        """

    let role_ids: (Array[Snowflake] val | None)
        """
        the role ID(s) for roles in the guild given to the users that accept this invite
        """

    new val create(
        channel_id': Snowflake,
        code': String,
        created_at': ISO8601,
        guild_id': (Snowflake | None) = None,
        inviter': (User | None) = None,
        max_age': USize,
        max_uses': USize,
        target_type': (InviteTargetType | None) = None,
        target_user': (User | None) = None,
        target_application': (PartialApplication | None) = None,
        temporary': Bool,
        uses': USize,
        expires_at': (ISO8601 | None) = None,
        role_ids': (Array[Snowflake] val | None) = None
    ) =>
        channel_id = channel_id'
        code = code'
        created_at = created_at'
        guild_id = guild_id'
        inviter = inviter'
        max_age = max_age'
        max_uses = max_uses'
        target_type = target_type'
        target_user = target_user'
        target_application = target_application'
        temporary = temporary'
        uses = uses'
        expires_at = expires_at'
        role_ids = role_ids'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var code': (String | None) = None
        var created_at': (ISO8601 | None) = None
        var guild_id': (Snowflake | None) = None
        var inviter': (User | None) = None
        var max_age': (USize | None) = None
        var max_uses': (USize | None) = None
        var target_type': (InviteTargetType | None) = None
        var target_user': (User | None) = None
        var target_application': (PartialApplication | None) = None
        var temporary': (Bool | None) = None
        var uses': (USize | None) = None
        var expires_at': (ISO8601 | None) = None
        var role_ids': (Array[Snowflake] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "code" => code' = value as String
            | "created_at" => created_at' = value as String
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "inviter" => inviter' = User.from_json(value as json.JsonObject)?
            | "max_age" => max_age' = (value as I64).usize()
            | "max_uses" => max_uses' = (value as I64).usize()
            | "target_type" => target_type' = InviteTargetTypes.from((value as I64).u8())?
            | "target_user" => target_user' = User.from_json(value as json.JsonObject)?
            | "target_application" => target_application' = PartialApplication.from_json(value as json.JsonObject)?
            | "temporary" => temporary' = value as Bool
            | "uses" => uses' = (value as I64).usize()
            | "expires_at" =>
                match value | let string: String => expires_at' = string end
            | "role_ids" => role_ids' = _Snowflakes(value)?
            end
        end

        channel_id = channel_id' as Snowflake
        code = code' as String
        created_at = created_at' as ISO8601
        guild_id = guild_id'
        inviter = inviter'
        max_age = max_age' as USize
        max_uses = max_uses' as USize
        target_type = target_type'
        target_user = target_user'
        target_application = target_application'
        temporary = temporary' as Bool
        uses = uses' as USize
        expires_at = expires_at'
        role_ids = role_ids'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("code", code)
            .update("created_at", created_at)
            .update("max_age", max_age.i64())
            .update("max_uses", max_uses.i64())
            .update("temporary", temporary)
            .update("uses", uses.i64())
            .update("expires_at", expires_at)

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match inviter
        | let inviter': User => obj = obj.update("inviter", inviter'.to_json())
        end

        match target_type
        | let target_type': InviteTargetType => obj = obj.update("target_type", target_type'.value().i64())
        end

        match target_user
        | let target_user': User => obj = obj.update("target_user", target_user'.to_json())
        end

        match target_application
        | let target_application': PartialApplication => obj = obj.update("target_application", target_application'.to_json())
        end

        match role_ids
        | let role_ids': Array[Snowflake] val => obj = obj.update("role_ids", _Snowflakes.to_json(role_ids'))
        end

        obj

class val InviteDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#invite-delete

    Sent when an invite is deleted. Only sent to bot users with the `MANAGE_CHANNELS` permission on the channel.
    """

    let channel_id: Snowflake
        """
        Channel of the invite
        """

    let guild_id: (Snowflake | None)
        """
        Guild of the invite
        """

    let code: String
        """
        Unique invite code
        """

    new val create(
        channel_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        code': String
    ) =>
        channel_id = channel_id'
        guild_id = guild_id'
        code = code'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var code': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "code" => code' = value as String
            end
        end

        channel_id = channel_id' as Snowflake
        guild_id = guild_id'
        code = code' as String

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("code", code)

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessageCreate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-create

    Sent when a message is created.

    Ephemeral messages are sent directly to the user and the bot who sent the message rather than through the guild channel, so they are tied to the `DIRECT_MESSAGES` intent and carry neither `guild_id` nor `member`.
    """

    let message: Message
        """
        The message that was created
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild the message was sent in - unless it is an ephemeral message
        """

    let member: (PartialGuildMember | None)
        """
        Member properties for this message's author. Missing for ephemeral messages and messages from webhooks
        """

    let channel_type: (ChannelType | None)
        """
        The type of channel the message was sent in
        """

    new val create(
        message': Message,
        guild_id': (Snowflake | None) = None,
        member': (PartialGuildMember | None) = None,
        channel_type': (ChannelType | None) = None
    ) =>
        message = message'
        guild_id = guild_id'
        member = member'
        channel_type = channel_type'

    new val from_json(obj: json.JsonObject) ? =>
        message = Message.from_json(obj)?

        var guild_id': (Snowflake | None) = None
        var member': (PartialGuildMember | None) = None
        var channel_type': (ChannelType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "member" => member' = PartialGuildMember.from_json(value as json.JsonObject)?
            | "channel_type" => channel_type' = ChannelTypes.from((value as I64).u8())?
            end
        end

        guild_id = guild_id'
        member = member'
        channel_type = channel_type'

    fun to_json(): json.JsonObject =>
        var obj = message.to_json()

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match member
        | let member': PartialGuildMember => obj = obj.update("member", member'.to_json())
        end

        match channel_type
        | let channel_type': ChannelType => obj = obj.update("channel_type", channel_type'.value().i64())
        end

        obj

class val MessageUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-update

    Sent when a message is updated. Carries the same extra fields as `MESSAGE_CREATE`.

    The value for `tts` will always be false in message updates.
    """

    let message: Message
        """
        The message that was updated
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild the message was sent in - unless it is an ephemeral message
        """

    let member: (PartialGuildMember | None)
        """
        Member properties for this message's author. Missing for ephemeral messages and messages from webhooks
        """

    let channel_type: (ChannelType | None)
        """
        The type of channel the message was sent in
        """

    new val create(
        message': Message,
        guild_id': (Snowflake | None) = None,
        member': (PartialGuildMember | None) = None,
        channel_type': (ChannelType | None) = None
    ) =>
        message = message'
        guild_id = guild_id'
        member = member'
        channel_type = channel_type'

    new val from_json(obj: json.JsonObject) ? =>
        message = Message.from_json(obj)?

        var guild_id': (Snowflake | None) = None
        var member': (PartialGuildMember | None) = None
        var channel_type': (ChannelType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "member" => member' = PartialGuildMember.from_json(value as json.JsonObject)?
            | "channel_type" => channel_type' = ChannelTypes.from((value as I64).u8())?
            end
        end

        guild_id = guild_id'
        member = member'
        channel_type = channel_type'

    fun to_json(): json.JsonObject =>
        var obj = message.to_json()

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match member
        | let member': PartialGuildMember => obj = obj.update("member", member'.to_json())
        end

        match channel_type
        | let channel_type': ChannelType => obj = obj.update("channel_type", channel_type'.value().i64())
        end

        obj

class val MessageDelete is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-delete

    Sent when a message is deleted.
    """

    let id: Snowflake
        """
        ID of the message
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    new val create(
        id': Snowflake,
        channel_id': Snowflake,
        guild_id': (Snowflake | None) = None
    ) =>
        id = id'
        channel_id = channel_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        channel_id = channel_id' as Snowflake
        guild_id = guild_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("channel_id", channel_id.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessageDeleteBulk is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-delete-bulk

    Sent when multiple messages are deleted at once.
    """

    let ids: Array[Snowflake] val
        """
        IDs of the messages
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    new val create(
        ids': Array[Snowflake] val,
        channel_id': Snowflake,
        guild_id': (Snowflake | None) = None
    ) =>
        ids = ids'
        channel_id = channel_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var ids': (Array[Snowflake] val | None) = None
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "ids" => ids' = _Snowflakes(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        ids = ids' as Array[Snowflake] val
        channel_id = channel_id' as Snowflake
        guild_id = guild_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("ids", _Snowflakes.to_json(ids))
            .update("channel_id", channel_id.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessageReactionAdd is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-reaction-add

    Sent when a user adds a reaction to a message.
    """

    let user_id: Snowflake
        """
        ID of the user
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let member: (GuildMember | None)
        """
        Member who reacted if this happened in a guild
        """

    let emoji: Emoji
        """
        Emoji used to react
        """

    let message_author_id: (Snowflake | None)
        """
        ID of the user who authored the message which was reacted to
        """

    let burst: Bool
        """
        true if this is a super-reaction
        """

    let burst_colors: (Array[String] val | None)
        """
        Colors used for super-reaction animation in "#rrggbb" format
        """

    let type': MessageReactionType
        """
        The type of reaction
        """

    new val create(
        user_id': Snowflake,
        channel_id': Snowflake,
        message_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        member': (GuildMember | None) = None,
        emoji': Emoji,
        message_author_id': (Snowflake | None) = None,
        burst': Bool,
        burst_colors': (Array[String] val | None) = None,
        type'': MessageReactionType
    ) =>
        user_id = user_id'
        channel_id = channel_id'
        message_id = message_id'
        guild_id = guild_id'
        member = member'
        emoji = emoji'
        message_author_id = message_author_id'
        burst = burst'
        burst_colors = burst_colors'
        type' = type''

    new val from_json(obj: json.JsonObject) ? =>
        var user_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var member': (GuildMember | None) = None
        var emoji': (Emoji | None) = None
        var message_author_id': (Snowflake | None) = None
        var burst': (Bool | None) = None
        var burst_colors': (Array[String] val | None) = None
        var type'': (MessageReactionType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "member" => member' = GuildMember.from_json(value as json.JsonObject)?
            | "emoji" => emoji' = Emoji.from_json(value as json.JsonObject)?
            | "message_author_id" => message_author_id' = Snowflake.from_json(value)?
            | "burst" => burst' = value as Bool
            | "burst_colors" => burst_colors' = _Strings(value)?
            | "type" => type'' = MessageReactionTypes.from((value as I64).u8())?
            end
        end

        user_id = user_id' as Snowflake
        channel_id = channel_id' as Snowflake
        message_id = message_id' as Snowflake
        guild_id = guild_id'
        member = member'
        emoji = emoji' as Emoji
        message_author_id = message_author_id'
        burst = burst' as Bool
        burst_colors = burst_colors'
        type' = type'' as MessageReactionType

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("user_id", user_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())
            .update("emoji", emoji.to_json())
            .update("burst", burst)
            .update("type", type'.value().i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match member
        | let member': GuildMember => obj = obj.update("member", member'.to_json())
        end

        match message_author_id
        | let message_author_id': Snowflake => obj = obj.update("message_author_id", message_author_id'.to_json())
        end

        match burst_colors
        | let burst_colors': Array[String] val => obj = obj.update("burst_colors", _Strings.to_json(burst_colors'))
        end

        obj

class val MessageReactionRemove is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-reaction-remove

    Sent when a user removes a reaction from a message.
    """

    let user_id: Snowflake
        """
        ID of the user
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let emoji: Emoji
        """
        Emoji used to react
        """

    let burst: Bool
        """
        true if this was a super-reaction
        """

    let type': MessageReactionType
        """
        The type of reaction
        """

    new val create(
        user_id': Snowflake,
        channel_id': Snowflake,
        message_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        emoji': Emoji,
        burst': Bool,
        type'': MessageReactionType
    ) =>
        user_id = user_id'
        channel_id = channel_id'
        message_id = message_id'
        guild_id = guild_id'
        emoji = emoji'
        burst = burst'
        type' = type''

    new val from_json(obj: json.JsonObject) ? =>
        var user_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var emoji': (Emoji | None) = None
        var burst': (Bool | None) = None
        var type'': (MessageReactionType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "emoji" => emoji' = Emoji.from_json(value as json.JsonObject)?
            | "burst" => burst' = value as Bool
            | "type" => type'' = MessageReactionTypes.from((value as I64).u8())?
            end
        end

        user_id = user_id' as Snowflake
        channel_id = channel_id' as Snowflake
        message_id = message_id' as Snowflake
        guild_id = guild_id'
        emoji = emoji' as Emoji
        burst = burst' as Bool
        type' = type'' as MessageReactionType

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("user_id", user_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())
            .update("emoji", emoji.to_json())
            .update("burst", burst)
            .update("type", type'.value().i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessageReactionRemoveAll is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-reaction-remove-all

    Sent when a user explicitly removes all reactions from a message.
    """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    new val create(
        channel_id': Snowflake,
        message_id': Snowflake,
        guild_id': (Snowflake | None) = None
    ) =>
        channel_id = channel_id'
        message_id = message_id'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        channel_id = channel_id' as Snowflake
        message_id = message_id' as Snowflake
        guild_id = guild_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessageReactionRemoveEmoji is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-reaction-remove-emoji

    Sent when a bot removes all instances of a given emoji from the reactions of a message.
    """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let emoji: Emoji
        """
        Emoji that was removed
        """

    new val create(
        channel_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        message_id': Snowflake,
        emoji': Emoji
    ) =>
        channel_id = channel_id'
        guild_id = guild_id'
        message_id = message_id'
        emoji = emoji'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var emoji': (Emoji | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "emoji" => emoji' = Emoji.from_json(value as json.JsonObject)?
            end
        end

        channel_id = channel_id' as Snowflake
        guild_id = guild_id'
        message_id = message_id' as Snowflake
        emoji = emoji' as Emoji

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())
            .update("emoji", emoji.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessagePollVoteAdd is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-poll-vote-add

    Sent when a user votes on a poll. If the poll allows multiple selection, one event will be sent per answer.
    """

    let user_id: Snowflake
        """
        ID of the user
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let answer_id: USize
        """
        ID of the answer
        """

    new val create(
        user_id': Snowflake,
        channel_id': Snowflake,
        message_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        answer_id': USize
    ) =>
        user_id = user_id'
        channel_id = channel_id'
        message_id = message_id'
        guild_id = guild_id'
        answer_id = answer_id'

    new val from_json(obj: json.JsonObject) ? =>
        var user_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var answer_id': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "answer_id" => answer_id' = (value as I64).usize()
            end
        end

        user_id = user_id' as Snowflake
        channel_id = channel_id' as Snowflake
        message_id = message_id' as Snowflake
        guild_id = guild_id'
        answer_id = answer_id' as USize

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("user_id", user_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())
            .update("answer_id", answer_id.i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val MessagePollVoteRemove is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#message-poll-vote-remove

    Sent when a user removes their vote on a poll. If the poll allows for multiple selections, one event will be sent per answer.
    """

    let user_id: Snowflake
        """
        ID of the user
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let message_id: Snowflake
        """
        ID of the message
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let answer_id: USize
        """
        ID of the answer
        """

    new val create(
        user_id': Snowflake,
        channel_id': Snowflake,
        message_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        answer_id': USize
    ) =>
        user_id = user_id'
        channel_id = channel_id'
        message_id = message_id'
        guild_id = guild_id'
        answer_id = answer_id'

    new val from_json(obj: json.JsonObject) ? =>
        var user_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var message_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var answer_id': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "answer_id" => answer_id' = (value as I64).usize()
            end
        end

        user_id = user_id' as Snowflake
        channel_id = channel_id' as Snowflake
        message_id = message_id' as Snowflake
        guild_id = guild_id'
        answer_id = answer_id' as USize

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("user_id", user_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("message_id", message_id.to_json())
            .update("answer_id", answer_id.i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

class val TypingStart is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#typing-start

    Sent when a user starts typing in a channel.
    """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild
        """

    let user_id: Snowflake
        """
        ID of the user
        """

    let timestamp: U64
        """
        Unix time (in seconds) of when the user started typing
        """

    let member: (GuildMember | None)
        """
        Member who started typing if this happened in a guild
        """

    new val create(
        channel_id': Snowflake,
        guild_id': (Snowflake | None) = None,
        user_id': Snowflake,
        timestamp': U64,
        member': (GuildMember | None) = None
    ) =>
        channel_id = channel_id'
        guild_id = guild_id'
        user_id = user_id'
        timestamp = timestamp'
        member = member'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var timestamp': (U64 | None) = None
        var member': (GuildMember | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "timestamp" => timestamp' = (value as I64).u64()
            | "member" => member' = GuildMember.from_json(value as json.JsonObject)?
            end
        end

        channel_id = channel_id' as Snowflake
        guild_id = guild_id'
        user_id = user_id' as Snowflake
        timestamp = timestamp' as U64
        member = member'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("user_id", user_id.to_json())
            .update("timestamp", timestamp.i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match member
        | let member': GuildMember => obj = obj.update("member", member'.to_json())
        end

        obj

class val VoiceChannelEffectSend is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#voice-channel-effect-send

    Sent when someone sends an effect, such as an emoji reaction or a soundboard sound, in a voice channel the current user is connected to.
    """

    let channel_id: Snowflake
        """
        ID of the channel the effect was sent in
        """

    let guild_id: Snowflake
        """
        ID of the guild the effect was sent in
        """

    let user_id: Snowflake
        """
        ID of the user who sent the effect
        """

    let emoji: (Emoji | None)
        """
        The emoji sent, for emoji reaction and soundboard effects
        """

    let animation_type: (VoiceChannelEffectAnimationType | None)
        """
        The type of emoji animation, for emoji reaction and soundboard effects
        """

    let animation_id: (USize | None)
        """
        The ID of the emoji animation, for emoji reaction and soundboard effects
        """

    let sound_id: (Snowflake | None)
        """
        The ID of the soundboard sound, for soundboard effects
        """

    let sound_volume: (F64 | None)
        """
        The volume of the soundboard sound, from 0 to 1, for soundboard effects
        """

    new val create(
        channel_id': Snowflake,
        guild_id': Snowflake,
        user_id': Snowflake,
        emoji': (Emoji | None) = None,
        animation_type': (VoiceChannelEffectAnimationType | None) = None,
        animation_id': (USize | None) = None,
        sound_id': (Snowflake | None) = None,
        sound_volume': (F64 | None) = None
    ) =>
        channel_id = channel_id'
        guild_id = guild_id'
        user_id = user_id'
        emoji = emoji'
        animation_type = animation_type'
        animation_id = animation_id'
        sound_id = sound_id'
        sound_volume = sound_volume'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var emoji': (Emoji | None) = None
        var animation_type': (VoiceChannelEffectAnimationType | None) = None
        var animation_id': (USize | None) = None
        var sound_id': (Snowflake | None) = None
        var sound_volume': (F64 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "emoji" =>
                match value | let obj': json.JsonObject => emoji' = Emoji.from_json(obj')? end
            | "animation_type" =>
                match value | let integer: I64 => animation_type' = VoiceChannelEffectAnimationTypes.from(integer.u8())? end
            | "animation_id" => animation_id' = (value as I64).usize()
            | "sound_id" =>
                match value
                | let string: String => sound_id' = Snowflake.from_json(string)?
                | let integer: I64 => sound_id' = Snowflake(integer.u64())
                end
            | "sound_volume" =>
                match value
                | let float: F64 => sound_volume' = float
                | let integer: I64 => sound_volume' = integer.f64()
                end
            end
        end

        channel_id = channel_id' as Snowflake
        guild_id = guild_id' as Snowflake
        user_id = user_id' as Snowflake
        emoji = emoji'
        animation_type = animation_type'
        animation_id = animation_id'
        sound_id = sound_id'
        sound_volume = sound_volume'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("user_id", user_id.to_json())

        match emoji
        | let emoji': Emoji => obj = obj.update("emoji", emoji'.to_json())
        end

        match animation_type
        | let animation_type': VoiceChannelEffectAnimationType => obj = obj.update("animation_type", animation_type'.value().i64())
        end

        match animation_id
        | let animation_id': USize => obj = obj.update("animation_id", animation_id'.i64())
        end

        match sound_id
        | let sound_id': Snowflake => obj = obj.update("sound_id", sound_id'.to_json())
        end

        match sound_volume
        | let sound_volume': F64 => obj = obj.update("sound_volume", sound_volume')
        end

        obj

trait val VoiceChannelEffectAnimationType is _Enum[VoiceChannelEffectAnimationType, U8]
    """
    https://docs.discord.com/developers/events/gateway-events#voice-channel-effect-send-animation-types
    """
primitive PremiumVoiceChannelEffectAnimationType is VoiceChannelEffectAnimationType
    """
    A fun animation, sent by a Nitro subscriber
    """

    fun value(): U8 => 0
primitive BasicVoiceChannelEffectAnimationType is VoiceChannelEffectAnimationType
    """
    The standard animation
    """

    fun value(): U8 => 1
primitive VoiceChannelEffectAnimationTypes
    fun from(value: U8): VoiceChannelEffectAnimationType ? =>
        match value
        | 0 => PremiumVoiceChannelEffectAnimationType
        | 1 => BasicVoiceChannelEffectAnimationType
        else error
        end

class val VoiceServerUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#voice-server-update

    Sent when a guild's voice server is updated. This is sent when initially connecting to voice, and when the current voice instance fails over to a new server.

    A null endpoint means that the voice server allocated has gone away and is trying to be reallocated. You should attempt to disconnect from the currently connected voice server, and not attempt to reconnect until a new voice server is allocated.
    """

    let token: String
        """
        Voice connection token
        """

    let guild_id: Snowflake
        """
        Guild this voice server update is for
        """

    let endpoint: (String | None)
        """
        Voice server host
        """

    new val create(token': String, guild_id': Snowflake, endpoint': (String | None)) =>
        token = token'
        guild_id = guild_id'
        endpoint = endpoint'

    new val from_json(obj: json.JsonObject) ? =>
        var token': (String | None) = None
        var guild_id': (Snowflake | None) = None
        var endpoint': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "token" => token' = value as String
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "endpoint" =>
                match value | let string: String => endpoint' = string end
            end
        end

        token = token' as String
        guild_id = guild_id' as Snowflake
        endpoint = endpoint'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("token", token)
            .update("guild_id", guild_id.to_json())
            .update("endpoint", endpoint)

class val WebhooksUpdate is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#webhooks-update

    Sent when a guild channel's webhook is created, updated, or deleted.
    """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let channel_id: Snowflake
        """
        ID of the channel
        """

    new val create(guild_id': Snowflake, channel_id': Snowflake) =>
        guild_id = guild_id'
        channel_id = channel_id'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        channel_id = channel_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("channel_id", channel_id.to_json())

class val SoundboardSounds is Jsonable
    """
    https://docs.discord.com/developers/events/gateway-events#soundboard-sounds

    Includes a guild's list of soundboard sounds. Sent in response to Request Soundboard Sounds.
    """

    let soundboard_sounds: Array[SoundboardSound] val
        """
        The guild's soundboard sounds
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    new val create(soundboard_sounds': Array[SoundboardSound] val, guild_id': Snowflake) =>
        soundboard_sounds = soundboard_sounds'
        guild_id = guild_id'

    new val from_json(obj: json.JsonObject) ? =>
        var soundboard_sounds': (Array[SoundboardSound] val | None) = None
        var guild_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "soundboard_sounds" => soundboard_sounds' = _SoundboardSounds(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            end
        end

        soundboard_sounds = soundboard_sounds' as Array[SoundboardSound] val
        guild_id = guild_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("soundboard_sounds", _SoundboardSounds.to_json(soundboard_sounds))
            .update("guild_id", guild_id.to_json())

type GatewayDispatchEventData is
    ( GuildApplicationCommandPermissions
    | AutoModerationRule
    | AutoModerationActionExecution
    | Channel
    | ChannelInfo
    | ChannelPinsUpdate
    | ThreadCreate
    | ThreadDelete
    | ThreadListSync
    | ThreadMemberUpdate
    | ThreadMembersUpdate
    | Entitlement
    | GuildCreate
    | Guild
    | UnavailableGuild
    | GuildAuditLogEntryCreate
    | GuildBanAdd
    | GuildBanRemove
    | GuildEmojisUpdate
    | GuildStickersUpdate
    | GuildIntegrationsUpdate
    | GuildMemberAdd
    | GuildMemberRemove
    | GuildMemberUpdate
    | GuildMembersChunk
    | GuildRoleCreate
    | GuildRoleUpdate
    | GuildRoleDelete
    | GuildScheduledEvent
    | GuildScheduledEventUserAdd
    | GuildScheduledEventUserRemove
    | SoundboardSound
    | GuildSoundboardSoundDelete
    | GuildSoundboardSoundsUpdate
    | SoundboardSounds
    | IntegrationCreate
    | IntegrationUpdate
    | IntegrationDelete
    | Interaction
    | InviteCreate
    | InviteDelete
    | MessageCreate
    | MessageUpdate
    | MessageDelete
    | MessageDeleteBulk
    | MessageReactionAdd
    | MessageReactionRemove
    | MessageReactionRemoveAll
    | MessageReactionRemoveEmoji
    | MessagePollVoteAdd
    | MessagePollVoteRemove
    | Presence
    | StageInstance
    | Subscription
    | TypingStart
    | User
    | VoiceChannelEffectSend
    | VoiceChannelStatusUpdate
    | VoiceChannelStartTimeUpdate
    | VoiceState
    | VoiceServerUpdate
    | WebhooksUpdate
    | GatewayReady
    | GatewayRateLimited
    | None )
    """
    https://docs.discord.com/developers/events/gateway-events#receive-events

    The decoded `d` of a dispatch payload. `None` is what an event that carries no data, such as `RESUMED`, decodes to.
    """

primitive GatewayDispatchEvents
    fun from(name: String, data: json.JsonValue): GatewayDispatchEventData ? =>
        """
        Decodes the `d` of a dispatch payload according to its event name `t`.
        """

        match name
        | "READY" => GatewayReady.from_json(data as json.JsonObject)?
        | "RESUMED" => None
        | "RATE_LIMITED" => GatewayRateLimited.from_json(data as json.JsonObject)?
        | "APPLICATION_COMMAND_PERMISSIONS_UPDATE" => GuildApplicationCommandPermissions.from_json(data as json.JsonObject)?
        | "AUTO_MODERATION_RULE_CREATE" => AutoModerationRule.from_json(data as json.JsonObject)?
        | "AUTO_MODERATION_RULE_UPDATE" => AutoModerationRule.from_json(data as json.JsonObject)?
        | "AUTO_MODERATION_RULE_DELETE" => AutoModerationRule.from_json(data as json.JsonObject)?
        | "AUTO_MODERATION_ACTION_EXECUTION" => AutoModerationActionExecution.from_json(data as json.JsonObject)?
        | "CHANNEL_CREATE" => Channel.from_json(data as json.JsonObject)?
        | "CHANNEL_UPDATE" => Channel.from_json(data as json.JsonObject)?
        | "CHANNEL_DELETE" => Channel.from_json(data as json.JsonObject)?
        | "CHANNEL_INFO" => ChannelInfo.from_json(data as json.JsonObject)?
        | "CHANNEL_PINS_UPDATE" => ChannelPinsUpdate.from_json(data as json.JsonObject)?
        | "THREAD_CREATE" => ThreadCreate.from_json(data as json.JsonObject)?
        | "THREAD_UPDATE" => Channel.from_json(data as json.JsonObject)?
        | "THREAD_DELETE" => ThreadDelete.from_json(data as json.JsonObject)?
        | "THREAD_LIST_SYNC" => ThreadListSync.from_json(data as json.JsonObject)?
        | "THREAD_MEMBER_UPDATE" => ThreadMemberUpdate.from_json(data as json.JsonObject)?
        | "THREAD_MEMBERS_UPDATE" => ThreadMembersUpdate.from_json(data as json.JsonObject)?
        | "ENTITLEMENT_CREATE" => Entitlement.from_json(data as json.JsonObject)?
        | "ENTITLEMENT_UPDATE" => Entitlement.from_json(data as json.JsonObject)?
        | "ENTITLEMENT_DELETE" => Entitlement.from_json(data as json.JsonObject)?
        | "GUILD_CREATE" =>
            let obj = data as json.JsonObject
            try GuildCreate.from_json(obj)? else UnavailableGuild.from_json(obj)? end
        | "GUILD_UPDATE" => Guild.from_json(data as json.JsonObject)?
        | "GUILD_DELETE" => UnavailableGuild.from_json(data as json.JsonObject)?
        | "GUILD_AUDIT_LOG_ENTRY_CREATE" => GuildAuditLogEntryCreate.from_json(data as json.JsonObject)?
        | "GUILD_BAN_ADD" => GuildBanAdd.from_json(data as json.JsonObject)?
        | "GUILD_BAN_REMOVE" => GuildBanRemove.from_json(data as json.JsonObject)?
        | "GUILD_EMOJIS_UPDATE" => GuildEmojisUpdate.from_json(data as json.JsonObject)?
        | "GUILD_STICKERS_UPDATE" => GuildStickersUpdate.from_json(data as json.JsonObject)?
        | "GUILD_INTEGRATIONS_UPDATE" => GuildIntegrationsUpdate.from_json(data as json.JsonObject)?
        | "GUILD_MEMBER_ADD" => GuildMemberAdd.from_json(data as json.JsonObject)?
        | "GUILD_MEMBER_REMOVE" => GuildMemberRemove.from_json(data as json.JsonObject)?
        | "GUILD_MEMBER_UPDATE" => GuildMemberUpdate.from_json(data as json.JsonObject)?
        | "GUILD_MEMBERS_CHUNK" => GuildMembersChunk.from_json(data as json.JsonObject)?
        | "GUILD_ROLE_CREATE" => GuildRoleCreate.from_json(data as json.JsonObject)?
        | "GUILD_ROLE_UPDATE" => GuildRoleUpdate.from_json(data as json.JsonObject)?
        | "GUILD_ROLE_DELETE" => GuildRoleDelete.from_json(data as json.JsonObject)?
        | "GUILD_SCHEDULED_EVENT_CREATE" => GuildScheduledEvent.from_json(data as json.JsonObject)?
        | "GUILD_SCHEDULED_EVENT_UPDATE" => GuildScheduledEvent.from_json(data as json.JsonObject)?
        | "GUILD_SCHEDULED_EVENT_DELETE" => GuildScheduledEvent.from_json(data as json.JsonObject)?
        | "GUILD_SCHEDULED_EVENT_USER_ADD" => GuildScheduledEventUserAdd.from_json(data as json.JsonObject)?
        | "GUILD_SCHEDULED_EVENT_USER_REMOVE" => GuildScheduledEventUserRemove.from_json(data as json.JsonObject)?
        | "GUILD_SOUNDBOARD_SOUND_CREATE" => SoundboardSound.from_json(data as json.JsonObject)?
        | "GUILD_SOUNDBOARD_SOUND_UPDATE" => SoundboardSound.from_json(data as json.JsonObject)?
        | "GUILD_SOUNDBOARD_SOUND_DELETE" => GuildSoundboardSoundDelete.from_json(data as json.JsonObject)?
        | "GUILD_SOUNDBOARD_SOUNDS_UPDATE" => GuildSoundboardSoundsUpdate.from_json(data as json.JsonObject)?
        | "SOUNDBOARD_SOUNDS" => SoundboardSounds.from_json(data as json.JsonObject)?
        | "INTEGRATION_CREATE" => IntegrationCreate.from_json(data as json.JsonObject)?
        | "INTEGRATION_UPDATE" => IntegrationUpdate.from_json(data as json.JsonObject)?
        | "INTEGRATION_DELETE" => IntegrationDelete.from_json(data as json.JsonObject)?
        | "INTERACTION_CREATE" => Interaction.from_json(data as json.JsonObject)?
        | "INVITE_CREATE" => InviteCreate.from_json(data as json.JsonObject)?
        | "INVITE_DELETE" => InviteDelete.from_json(data as json.JsonObject)?
        | "MESSAGE_CREATE" => MessageCreate.from_json(data as json.JsonObject)?
        | "MESSAGE_UPDATE" => MessageUpdate.from_json(data as json.JsonObject)?
        | "MESSAGE_DELETE" => MessageDelete.from_json(data as json.JsonObject)?
        | "MESSAGE_DELETE_BULK" => MessageDeleteBulk.from_json(data as json.JsonObject)?
        | "MESSAGE_REACTION_ADD" => MessageReactionAdd.from_json(data as json.JsonObject)?
        | "MESSAGE_REACTION_REMOVE" => MessageReactionRemove.from_json(data as json.JsonObject)?
        | "MESSAGE_REACTION_REMOVE_ALL" => MessageReactionRemoveAll.from_json(data as json.JsonObject)?
        | "MESSAGE_REACTION_REMOVE_EMOJI" => MessageReactionRemoveEmoji.from_json(data as json.JsonObject)?
        | "MESSAGE_POLL_VOTE_ADD" => MessagePollVoteAdd.from_json(data as json.JsonObject)?
        | "MESSAGE_POLL_VOTE_REMOVE" => MessagePollVoteRemove.from_json(data as json.JsonObject)?
        | "PRESENCE_UPDATE" => Presence.from_json(data as json.JsonObject)?
        | "STAGE_INSTANCE_CREATE" => StageInstance.from_json(data as json.JsonObject)?
        | "STAGE_INSTANCE_UPDATE" => StageInstance.from_json(data as json.JsonObject)?
        | "STAGE_INSTANCE_DELETE" => StageInstance.from_json(data as json.JsonObject)?
        | "SUBSCRIPTION_CREATE" => Subscription.from_json(data as json.JsonObject)?
        | "SUBSCRIPTION_UPDATE" => Subscription.from_json(data as json.JsonObject)?
        | "SUBSCRIPTION_DELETE" => Subscription.from_json(data as json.JsonObject)?
        | "TYPING_START" => TypingStart.from_json(data as json.JsonObject)?
        | "USER_UPDATE" => User.from_json(data as json.JsonObject)?
        | "VOICE_CHANNEL_EFFECT_SEND" => VoiceChannelEffectSend.from_json(data as json.JsonObject)?
        | "VOICE_CHANNEL_STATUS_UPDATE" => VoiceChannelStatusUpdate.from_json(data as json.JsonObject)?
        | "VOICE_CHANNEL_START_TIME_UPDATE" => VoiceChannelStartTimeUpdate.from_json(data as json.JsonObject)?
        | "VOICE_STATE_UPDATE" => VoiceState.from_json(data as json.JsonObject)?
        | "VOICE_SERVER_UPDATE" => VoiceServerUpdate.from_json(data as json.JsonObject)?
        | "WEBHOOKS_UPDATE" => WebhooksUpdate.from_json(data as json.JsonObject)?
        else error
        end
