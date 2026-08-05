use json = "json"

class val VoiceState is Jsonable
    """
    https://docs.discord.com/developers/resources/voice#voice-state-object-voice-state-structure

    Used to represent a user's voice connection status.
    """

    let guild_id: (Snowflake | None)
        """
        the guild id this voice state is for
        """

    let channel_id: (Snowflake | None)
        """
        the channel id this user is connected to
        """

    let user_id: Snowflake
        """
        the user id this voice state is for
        """

    let member: (GuildMember | None)
        """
        the guild member this voice state is for
        """

    let session_id: String
        """
        the session id for this voice state
        """

    let deaf: Bool
        """
        whether this user is deafened by the server
        """

    let mute: Bool
        """
        whether this user is muted by the server
        """

    let self_deaf: Bool
        """
        whether this user is locally deafened
        """

    let self_mute: Bool
        """
        whether this user is locally muted
        """

    let self_stream: (Bool | None)
        """
        whether this user is streaming using "Go Live"
        """

    let self_video: Bool
        """
        whether this user's camera is enabled
        """

    let suppress: Bool
        """
        whether this user's permission to speak is denied
        """

    let request_to_speak_timestamp: (ISO8601 | None)
        """
        the time at which the user requested to speak
        """

    new val create(
        guild_id': (Snowflake | None) = None,
        channel_id': (Snowflake | None) = None,
        user_id': Snowflake,
        member': (GuildMember | None) = None,
        session_id': String,
        deaf': Bool,
        mute': Bool,
        self_deaf': Bool,
        self_mute': Bool,
        self_stream': (Bool | None) = None,
        self_video': Bool,
        suppress': Bool,
        request_to_speak_timestamp': (ISO8601 | None) = None
    ) =>
        guild_id = guild_id'
        channel_id = channel_id'
        user_id = user_id'
        member = member'
        session_id = session_id'
        deaf = deaf'
        mute = mute'
        self_deaf = self_deaf'
        self_mute = self_mute'
        self_stream = self_stream'
        self_video = self_video'
        suppress = suppress'
        request_to_speak_timestamp = request_to_speak_timestamp'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var member': (GuildMember | None) = None
        var session_id': (String | None) = None
        var deaf': (Bool | None) = None
        var mute': (Bool | None) = None
        var self_deaf': (Bool | None) = None
        var self_mute': (Bool | None) = None
        var self_stream': (Bool | None) = None
        var self_video': (Bool | None) = None
        var suppress': (Bool | None) = None
        var request_to_speak_timestamp': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" =>
                match value | let string: String => channel_id' = Snowflake.from_json(string)? end
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "member" => member' = GuildMember.from_json(value as json.JsonObject)?
            | "session_id" => session_id' = value as String
            | "deaf" => deaf' = value as Bool
            | "mute" => mute' = value as Bool
            | "self_deaf" => self_deaf' = value as Bool
            | "self_mute" => self_mute' = value as Bool
            | "self_stream" => self_stream' = value as Bool
            | "self_video" => self_video' = value as Bool
            | "suppress" => suppress' = value as Bool
            | "request_to_speak_timestamp" =>
                match value | let string: String => request_to_speak_timestamp' = string end
            end
        end

        guild_id = guild_id'
        channel_id = channel_id'
        user_id = user_id' as Snowflake
        member = member'
        session_id = session_id' as String
        deaf = deaf' as Bool
        mute = mute' as Bool
        self_deaf = self_deaf' as Bool
        self_mute = self_mute' as Bool
        self_stream = self_stream'
        self_video = self_video' as Bool
        suppress = suppress' as Bool
        request_to_speak_timestamp = request_to_speak_timestamp'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("channel_id", match channel_id | let channel_id': Snowflake => channel_id'.to_json() end)
            .update("user_id", user_id.to_json())
            .update("session_id", session_id)
            .update("deaf", deaf)
            .update("mute", mute)
            .update("self_deaf", self_deaf)
            .update("self_mute", self_mute)
            .update("self_video", self_video)
            .update("suppress", suppress)
            .update("request_to_speak_timestamp", request_to_speak_timestamp)

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match member
        | let member': GuildMember => obj = obj.update("member", member'.to_json())
        end

        match self_stream
        | let self_stream': Bool => obj = obj.update("self_stream", self_stream')
        end

        obj

class val VoiceRegion is Jsonable
    """
    https://docs.discord.com/developers/resources/voice#voice-region-object-voice-region-structure
    """

    let id: String
        """
        unique ID for the region
        """

    let name: String
        """
        name of the region
        """

    let optimal: Bool
        """
        true for a single server that is closest to the current user's client
        """

    let deprecated: Bool
        """
        whether this is a deprecated voice region (avoid switching to these)
        """

    let custom: Bool
        """
        whether this is a custom voice region (used for events/etc)
        """

    new val create(
        id': String,
        name': String,
        optimal': Bool,
        deprecated': Bool,
        custom': Bool
    ) =>
        id = id'
        name = name'
        optimal = optimal'
        deprecated = deprecated'
        custom = custom'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (String | None) = None
        var name': (String | None) = None
        var optimal': (Bool | None) = None
        var deprecated': (Bool | None) = None
        var custom': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = value as String
            | "name" => name' = value as String
            | "optimal" => optimal' = value as Bool
            | "deprecated" => deprecated' = value as Bool
            | "custom" => custom' = value as Bool
            end
        end

        id = id' as String
        name = name' as String
        optimal = optimal' as Bool
        deprecated = deprecated' as Bool
        custom = custom' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id)
            .update("name", name)
            .update("optimal", optimal)
            .update("deprecated", deprecated)
            .update("custom", custom)

primitive _VoiceRegions
    fun apply(value: json.JsonValue): Array[VoiceRegion] val ? =>
        """
        Decodes an array of voice regions.
        """

        let array = value as json.JsonArray
        recover val
            let regions = Array[VoiceRegion](array.size())
            for region in array.values() do regions.push(VoiceRegion.from_json(region as json.JsonObject)?) end
            regions
        end

    fun to_json(regions: Array[VoiceRegion] val): json.JsonArray =>
        var array = json.JsonArray
        for region in regions.values() do array = array.push(region.to_json()) end
        array

class val UpdateCurrentUserVoiceStateParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/voice#modify-current-user-voice-state-json-params

    There are currently several caveats for this endpoint:

    - `channel_id` must currently point to a stage channel.
    - current user must already have joined `channel_id`.
    - You must have the `MUTE_MEMBERS` permission to unsuppress yourself. You can always suppress yourself.
    - You must have the `REQUEST_TO_SPEAK` permission to request to speak. You can always clear your own request to speak.
    - You are able to set `request_to_speak_timestamp` to any present or future time.
    """

    let channel_id: (Snowflake | None)
        """
        the id of the channel the user is currently in
        """

    let suppress: (Bool | None)
        """
        toggles the user's suppress state
        """

    let request_to_speak_timestamp: Nullable[ISO8601]
        """
        sets the user's request to speak
        """

    new val create(
        channel_id': (Snowflake | None) = None,
        suppress': (Bool | None) = None,
        request_to_speak_timestamp': Nullable[ISO8601] = None
    ) =>
        channel_id = channel_id'
        suppress = suppress'
        request_to_speak_timestamp = request_to_speak_timestamp'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match suppress
        | let suppress': Bool => obj = obj.update("suppress", suppress')
        end

        match request_to_speak_timestamp
        | let request_to_speak_timestamp': ISO8601 => obj = obj.update("request_to_speak_timestamp", request_to_speak_timestamp')
        | Null => obj = obj.update("request_to_speak_timestamp", None)
        end

        obj

class val UpdateUserVoiceStateParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/voice#modify-user-voice-state-json-params

    There are currently several caveats for this endpoint:

    - `channel_id` must currently point to a stage channel.
    - User must already have joined `channel_id`.
    - You must have the `MUTE_MEMBERS` permission.
    - When unsuppressed, non-bot users will have their `request_to_speak_timestamp` set to the current time. Bot users will not.
    - When suppressed, the user will have their `request_to_speak_timestamp` removed.
    """

    let channel_id: (Snowflake | None)
        """
        the id of the channel the user is currently in
        """

    let suppress: (Bool | None)
        """
        toggles the user's suppress state
        """

    new val create(channel_id': (Snowflake | None) = None, suppress': (Bool | None) = None) =>
        channel_id = channel_id'
        suppress = suppress'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match suppress
        | let suppress': Bool => obj = obj.update("suppress", suppress')
        end

        obj

trait val VoiceOpcode is _Enum[VoiceOpcode, U16]
    """
    Our voice gateways have their own set of opcodes and close codes.
    """
primitive VoiceOpcodeIdentify is VoiceOpcode
    """
    Sent by: Client

    Begin a voice websocket connection.
    """

    fun value(): U16 => 0
primitive VoiceOpcodeSelectProtocol is VoiceOpcode
    """
    Sent by: Client

    Select the voice protocol.
    """

    fun value(): U16 => 1
primitive VoiceOpcodeReady is VoiceOpcode
    """
    Sent by: Server

    Complete the websocket handshake.
    """

    fun value(): U16 => 2
primitive VoiceOpcodeHeartbeat is VoiceOpcode
    """
    Sent by: Client

    Keep the websocket connection alive.
    """

    fun value(): U16 => 3
primitive VoiceOpcodeSessionDescription is VoiceOpcode
    """
    Sent by: Server

    Describe the session.
    """

    fun value(): U16 => 4
primitive VoiceOpcodeSpeaking is VoiceOpcode
    """
    Sent by: Client and Server

    Indicate which users are speaking.
    """

    fun value(): U16 => 5
primitive VoiceOpcodeHeartbeatACK is VoiceOpcode
    """
    Sent by: Server

    Sent to acknowledge a received client heartbeat.
    """

    fun value(): U16 => 6
primitive VoiceOpcodeResume is VoiceOpcode
    """
    Sent by: Client

    Resume a connection.
    """

    fun value(): U16 => 7
primitive VoiceOpcodeHello is VoiceOpcode
    """
    Sent by: Server

    Time to wait between sending heartbeats in milliseconds.
    """

    fun value(): U16 => 8
primitive VoiceOpcodeResumed is VoiceOpcode
    """
    Sent by: Server

    Acknowledge a successful session resume.
    """

    fun value(): U16 => 9
primitive VoiceOpcodeClientsConnect is VoiceOpcode
    """
    Sent by: Server

    One or more clients have connected to the voice channel
    """

    fun value(): U16 => 11
primitive VoiceOpcodeClientDisconnect is VoiceOpcode
    """
    Sent by: Server

    A client has disconnected from the voice channel
    """

    fun value(): U16 => 13
primitive VoiceOpcodeDAVEPrepareTransition is VoiceOpcode
    """
    Sent by: Server

    A downgrade from the DAVE protocol is upcoming
    """

    fun value(): U16 => 21
primitive VoiceOpcodeDAVEExecuteTransition is VoiceOpcode
    """
    Sent by: Server

    Execute a previously announced protocol transition
    """

    fun value(): U16 => 22
primitive VoiceOpcodeDAVETransitionReady is VoiceOpcode
    """
    Sent by: Client

    Acknowledge readiness previously announced transition
    """

    fun value(): U16 => 23
primitive VoiceOpcodeDAVEPrepareEpoch is VoiceOpcode
    """
    Sent by: Server

    A DAVE protocol version or group change is upcoming	
    """

    fun value(): U16 => 24
primitive VoiceOpcodeDAVEMLSExternalSender is VoiceOpcode
    """
    Sent by: Server

    Credential and public key for MLS external sender
    """

    fun value(): U16 => 25
primitive VoiceOpcodeDAVEMLSKeyPackage is VoiceOpcode
    """
    Sent by: Client

    MLS Key Package for pending group member
    """

    fun value(): U16 => 26
primitive VoiceOpcodeDAVEMLSProposals is VoiceOpcode
    """
    Sent by: Server

    MLS Proposals to be appended or revoked
    """

    fun value(): U16 => 27
primitive VoiceOpcodeDAVEMLSCommitWelcome is VoiceOpcode
    """
    Sent by: Client

    MLS Commit with optional MLS Welcome messages
    """

    fun value(): U16 => 28
primitive VoiceOpcodeDAVEMLSAnnounceCommitTransition is VoiceOpcode
    """
    Sent by: Server

    MLS Commit to be processed for upcoming transition
    """

    fun value(): U16 => 29
primitive VoiceOpcodeDAVEMLSWelcome is VoiceOpcode
    """
    Sent by: Server

    MLS Welcome to group for upcoming transition
    """

    fun value(): U16 => 30
primitive VoiceOpcodeDAVEMLSInvalidCommitWelcome is VoiceOpcode
    """
    Sent by: Client

    Flag invalid commit or welcome, request re-add
    """

    fun value(): U16 => 31

trait val VoiceCloseEventCode is _Enum[VoiceCloseEventCode, U16]
    fun reconnect(): Bool
primitive VoiceCloseEventCodeUnknownOpcode is VoiceCloseEventCode
    """
    You sent an invalid opcode.
    """

    fun value(): U16 => 4001
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeFailedToDecodePayload is VoiceCloseEventCode
    """
    You sent an invalid payload in your identifying to the Gateway.
    """

    fun value(): U16 => 4002
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeNotAuthenticated is VoiceCloseEventCode
    """
    You sent a payload before identifying with the Gateway.
    """

    fun value(): U16 => 4003
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeAuthenticationFailed is VoiceCloseEventCode
    """
    The token you sent in your identify payload is incorrect.
    """

    fun value(): U16 => 4004
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeAlreadyAuthenticated is VoiceCloseEventCode
    """
    You sent more than one identify payload. Stahp.
    """

    fun value(): U16 => 4005
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeSessionNoLongerValid is VoiceCloseEventCode
    """
    Your session is no longer valid.
    """

    fun value(): U16 => 4006
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeSessionTimeout is VoiceCloseEventCode
    """
    Your session has timed out.
    """

    fun value(): U16 => 4009
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeServerNotFound is VoiceCloseEventCode
    """
    We can’t find the server you’re trying to connect to.
    """

    fun value(): U16 => 4011
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeUnknownProtocol is VoiceCloseEventCode
    """
    We didn’t recognize the protocol you sent.
    """

    fun value(): U16 => 4012
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeDisconnected is VoiceCloseEventCode
    """
    Disconnect individual client (you were kicked, the main gateway session was dropped, etc.). Should not reconnect.
    """

    fun value(): U16 => 4014
    fun reconnect(): Bool => false
primitive VoiceCloseEventCodeVoiceServerCrashed is VoiceCloseEventCode
    """
    The server crashed. Our bad! Try resuming.
    """

    fun value(): U16 => 4015
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeUnknownEncryptionMode is VoiceCloseEventCode
    """
    We didn’t recognize your encryption.
    """

    fun value(): U16 => 4016
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeE2EEDAVEProtocolRequired is VoiceCloseEventCode
    """
    This channel requires a client supporting E2EE via the DAVE Protocol
    """

    fun value(): U16 => 4017
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeBadRequest is VoiceCloseEventCode
    """
    You sent a malformed request
    """

    fun value(): U16 => 4020
    fun reconnect(): Bool => true
primitive VoiceCloseEventCodeDisconnectedRateLimited is VoiceCloseEventCode
    """
    Disconnect due to rate limit exceeded. Should not reconnect.
    """

    fun value(): U16 => 4021
    fun reconnect(): Bool => false
primitive VoiceCloseEventCodeDisconnectedCallTerminated is VoiceCloseEventCode
    """
    Disconnect all clients due to call terminated (channel deleted, voice server changed, etc.). Should not reconnect.
    """

    fun value(): U16 => 4022
    fun reconnect(): Bool => false
