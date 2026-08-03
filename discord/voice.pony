use collections = "collections"
use json = "json"

trait val VoiceOpcode is (collections.Hashable & Equatable[VoiceOpcode])
    """
    Our voice gateways have their own set of opcodes and close codes.
    """

    fun value(): U16
    fun hash(): USize => value().hash()
    fun eq(that: VoiceOpcode): Bool => value() == that.value()
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

trait val VoiceCloseEventCode is (collections.Hashable & Equatable[VoiceCloseEventCode])
    fun value(): U16
    fun reconnect(): Bool
    fun hash(): USize => value().hash()
    fun eq(that: VoiceCloseEventCode): Bool => value() == that.value()
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
