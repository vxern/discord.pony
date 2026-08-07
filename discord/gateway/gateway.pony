use "../data"
use files = "files"
use random = "random"
use time = "time"
use lori = "lori"
use mare = "mare"
use json = "json"
use ssl = "ssl/net"

// TODO(vxern): (Maybe) add RPC error codes
// TODO(vxern): (Maybe) add RPC close event codes

class Gateway
    let api: GatewayApi
    let events: Events

    new create(env: Env, options: GatewayOptions) =>
        api = GatewayApi(env, options)
        events = Events(api)

    fun dispose() => api.dispose()

actor GatewayApi
    let _connection: _GatewayConnection

    new create(env: Env, options: GatewayOptions) =>
        _connection = _GatewayConnection(env, options)

    be send_message(event: GatewaySendableEvent) =>
        _connection._send_message(event)

    be dispose() => _connection.dispose()

actor Events
    let _api: GatewayApi

    new create(api: GatewayApi) =>
        _api = api

    be request_guild_members(event: GatewayRequestGuildMembersEvent) =>
        _api.send_message(event)

    be request_soundboard_sounds(event: GatewayRequestSoundboardSoundsEvent) =>
        _api.send_message(event)

    be request_channel_info(event: GatewayRequestChannelInfoEvent) =>
        _api.send_message(event)

    be update_voice_state(event: GatewayVoiceStateUpdateEvent) =>
        _api.send_message(event)

    be update_presence(event: GatewayPresenceUpdateEvent) =>
        _api.send_message(event)

class val GatewayError
    let reason: String

    new val create(reason': String) =>
        reason = reason'

    fun string(): String => reason

type GatewayErrorHandler is {(GatewayError)} val

class val GatewayOptions
    let token: String
    let intents: Array[GatewayIntent] val
    let properties: IdentifyConnectionProperties
    let version: ApiVersion val
    let user_agent: String
    let ca_certificates_path: String
    let large_threshold: (USize | None)
    let shard: ((USize, USize) | None)
    let presence: (GatewayPresenceUpdate | None)
    let on_error: GatewayErrorHandler

    new val create(
        token': String,
        intents': Array[GatewayIntent] val,
        properties': IdentifyConnectionProperties = GatewayDefaults.properties(),
        version': ApiVersion val = GatewayDefaults.version(),
        user_agent': String = GatewayDefaults.user_agent(),
        ca_certificates_path': String = GatewayDefaults.ca_certificates_path(),
        large_threshold': (USize | None) = None,
        shard': ((USize, USize) | None) = None,
        presence': (GatewayPresenceUpdate | None) = None,
        on_error': GatewayErrorHandler = GatewayDefaults.on_error()
    ) =>
        token = token'
        intents = intents'
        properties = properties'
        version = version'
        user_agent = user_agent'
        ca_certificates_path = ca_certificates_path'
        large_threshold = large_threshold'
        shard = shard'
        presence = presence'
        on_error = on_error'

    fun path(): String =>
        "/?v=" + version.value().string() + "&encoding=json"

primitive GatewayConstants
    fun base_url(): String => "wss://gateway.discord.gg"

    fun port(): String => "443"

    fun max_send_message_size_bytes(): USize => 4096

    fun max_receive_message_size_bytes(): USize => 16_777_216

    fun base_backoff_ms(): U64 => 2_000

    fun max_backoff_exponent(): USize => 5

primitive GatewayDefaults
    fun version(): ApiVersion val => ApiVersion10

    fun user_agent(): String =>
        "discord.pony (https://github.com/vxern/discord.pony, 1.0.0)"

    fun properties(): IdentifyConnectionProperties =>
        let os =
            ifdef osx then
                "macos"
            elseif windows then
                "windows"
            else
                "linux"
            end

        IdentifyConnectionProperties(os, "discord.pony", "discord.pony")

    fun ca_certificates_path(): String =>
        ifdef osx then
            "/etc/ssl/cert.pem"
        else
            "/etc/ssl/certs/ca-certificates.crt"
        end

    fun on_error(): GatewayErrorHandler => { (error': GatewayError) => None }

primitive _GatewayUrl
    fun host(url: String): String =>
        let start: ISize = try url.find("://")? + 3 else 0 end
        let finish: ISize = try url.find("/", start)? else url.size().isize() end

        url.substring(start, finish)

primitive _GatewayFailure
    fun reason(reason': lori.ConnectionFailureReason): String =>
        match reason'
        | lori.ConnectionFailedDNS => "could not resolve the gateway host"
        | lori.ConnectionFailedTCP => "could not connect to the gateway"
        | lori.ConnectionFailedSSL => "the TLS handshake with the gateway failed"
        | lori.ConnectionFailedTimeout => "the connection to the gateway timed out"
        | lori.ConnectionFailedTimerError => "the connection timer could not be created"
        end

actor _GatewayConnection is mare.WebSocketClientActor
    let options: GatewayOptions
    let _auth: lori.TCPConnectAuth
    let _ssl_context: (ssl.SSLContext val | None)
    let _timers: time.Timers = time.Timers
    let _rand: random.Rand

    var _ws: mare.WebSocketClient = mare.WebSocketClient.none()
    var _open: Bool = false
    var _sequence_number: (USize | None) = None
    var _session_id: (String | None) = None
    var _resume_url: (String | None) = None
    var _heartbeat: (_GatewayHeartbeat | None) = None
    var _reconnect_attempts: USize = 0
    var _connect_scheduled: Bool = false
    var _disposed: Bool = false

    new create(env: Env, options': GatewayOptions) =>
        options = options'
        _auth = lori.TCPConnectAuth(env.root)
        _ssl_context =
            try
                recover val
                    ssl.SSLContext
                    .> set_client_verify(true)
                    .> set_authority(
                        files.FilePath(
                            files.FileAuth(env.root),
                            options'.ca_certificates_path
                        )
                    )?
                end
            end

        (let seconds, let nanoseconds) = time.Time.now()
        _rand = random.Rand(seconds.u64(), nanoseconds.u64())

        _connect()

    fun ref _websocket(): mare.WebSocketClient => _ws

    fun ref _connect() =>
        if _disposed then return end

        let context =
            match _ssl_context
            | let context': ssl.SSLContext val => context'
            else
                options.on_error(GatewayError("could not create an SSL context"))
                return
            end

        let url =
            match _resume_url
            | let url': String => url'
            else
                GatewayConstants.base_url()
            end

        let headers: Array[(String val, String val)] val =
            [("User-Agent", options.user_agent)]

        _open = false
        _ws = mare.WebSocketClient.ssl(
            _auth,
            context,
            _GatewayUrl.host(url),
            GatewayConstants.port(),
            "",
            this,
            mare.WebSocketClientConfig(
                where
                path' = options.path(),
                headers' = headers,
                max_message_size' = GatewayConstants.max_receive_message_size_bytes()
            )
        )

    fun ref on_open(response: mare.UpgradeResponse val) => None
        // TODO(vxern): Start draining bucket.

    fun ref on_text_message(text: String val) =>
        let payload =
        try
            match json.JsonParser.parse(text)
            | let parsed: json.JsonObject => GatewayEventPayload.from_json(parsed)?
            else return
            end
        else return
        end

        match payload.s
        | let s: USize => _sequence_number = s
        end

        match payload.op
        | GatewayOpcodeHello =>
            try
                let hello = GatewayHello.from_json(payload.d as json.JsonObject)?

                _open = true
                _start_heartbeat(hello.heartbeat_interval.u64())
                _identify_or_resume()
            end
        | GatewayOpcodeHeartbeat =>
            match _heartbeat
            | let heartbeat: _GatewayHeartbeat => heartbeat._beat_now()
            end
        | GatewayOpcodeHeartbeatACK =>
            match _heartbeat
            | let heartbeat: _GatewayHeartbeat => heartbeat._acknowledge()
            end
        | GatewayOpcodeReconnect => _reconnect(true)
        | GatewayOpcodeInvalidSession =>
            _reconnect(try payload.d as Bool else false end)
        | GatewayOpcodeDispatch =>
            let name = try payload.t as String else return end
            let event = try GatewayDispatchEvents.from(name, payload.d)? else return end
            _on_dispatch(name, event)
        end

    fun ref on_connection_failure(reason: lori.ConnectionFailureReason) =>
        options.on_error(GatewayError(_GatewayFailure.reason(reason)))
        _schedule_connect()

    fun ref on_handshake_failure(err: mare.ClientHandshakeError) =>
        options.on_error(
            GatewayError("the gateway handshake failed: " + err.string())
        )
        _schedule_connect()

    fun ref on_closed(status: mare.CloseStatus, reason: String val) =>
        _open = false
        _stop_heartbeat()

        let code =
            try
                GatewayCloseEventCodes.from(status.code())?
            else
                _schedule_connect()
                return
            end

        if not code.reconnect() then
            options.on_error(
                GatewayError("the gateway closed the connection: " + status.string())
            )
            return
        end

        match code
        | GatewayCloseEventCodeInvalidSequence
        | GatewayCloseEventCodeSessionTimedOut =>
            _forget_session()
        end

        _schedule_connect()

    be _send_message(event: GatewaySendableEvent) =>
        _send(event)

    be _send_heartbeat() =>
        _send(GatewayHeartbeatEvent(_sequence_number))

    be _heartbeat_timed_out() =>
        _reconnect(true)

    be _reconnect_now() =>
        _connect_scheduled = false
        _connect()

    be dispose() =>
        if _disposed then return end

        _disposed = true
        _stop_heartbeat()
        _timers.dispose()

        if _open then
            _open = false
            _ws.close(mare.CloseNormal)
        end

    fun ref _send(event: GatewaySendableEvent) =>
        _ws.send_text(event.payload().to_json().print())

    fun ref _identify_or_resume() =>
        match (_session_id, _sequence_number)
        | (let session_id: String, let sequence_number: USize) =>
            _send(GatewayResumeEvent(options.token, session_id, sequence_number))
        else
            _send(
                GatewayIdentifyEvent(
                    options.token,
                    options.properties
                    where
                    large_threshold' = options.large_threshold,
                    shard' = options.shard,
                    presence' = options.presence,
                    intents' = options.intents
                )
            )
        end

    fun ref _on_dispatch(name: String, event: GatewayDispatchEventData) =>
        match event
        | let ready: GatewayReady =>
            _session_id = ready.session_id
            _resume_url = ready.resume_gateway_url
        end

        if (name == "READY") or (name == "RESUMED") then
            _reconnect_attempts = 0
        end

    fun ref _reconnect(resume: Bool) =>
        if _disposed then return end

        if not resume then
            _forget_session()
        end

        _stop_heartbeat()

        if _open then
            _open = false
            _ws.close(mare.CloseGoingAway, "reconnecting")
        else
            _schedule_connect()
        end

    fun ref _forget_session() =>
        _session_id = None
        _sequence_number = None
        _resume_url = None

    fun ref _schedule_connect() =>
        if _disposed or _connect_scheduled then return end

        _connect_scheduled = true
        _reconnect_attempts = _reconnect_attempts + 1

        let self: _GatewayConnection tag = this
        _timers(
            time.Timer(
                _OnceElapsed({() => self._reconnect_now()}),
                _backoff()
            )
        )

    fun ref _backoff(): U64 =>
        let exponent =
            (_reconnect_attempts - 1).min(GatewayConstants.max_backoff_exponent())
        let delay_ms =
            GatewayConstants.base_backoff_ms() * (U64(1) << exponent.u64())

        time.Nanos.from_millis((delay_ms.f64() * (0.5 + _rand.real())).u64())

    fun ref _start_heartbeat(interval_ms: U64) =>
        _stop_heartbeat()

        let self: _GatewayConnection tag = this
        _heartbeat = _GatewayHeartbeat(self, interval_ms)

    fun ref _stop_heartbeat() =>
        match _heartbeat
        | let heartbeat: _GatewayHeartbeat => heartbeat.dispose()
        end

        _heartbeat = None

actor _GatewayHeartbeat
    let _connection: _GatewayConnection
    let _interval_ms: U64
    let _timers: time.Timers = time.Timers

    var _acknowledged: Bool = true
    var _disposed: Bool = false

    new create(connection: _GatewayConnection, interval_ms: U64) =>
        _connection = connection
        _interval_ms = interval_ms

        let interval = time.Nanos.from_millis(_interval_ms)

        (let seconds, let nanoseconds) = time.Time.now()
        let rand = random.Rand(seconds.u64(), nanoseconds.u64())
        let initial_delay = (interval.f64() * rand.real()).u64()

        let self: _GatewayHeartbeat tag = this
        _timers(
            time.Timer(
                _RepeatedlyElapsed({() => self._beat()}),
                initial_delay,
                interval
            )
        )

    be _beat() =>
        if _disposed then return end

        if not _acknowledged then
            _connection._heartbeat_timed_out()
            _dispose()
            return
        end

        _acknowledged = false
        _connection._send_heartbeat()

    be _beat_now() =>
        if _disposed then return end

        _acknowledged = false
        _connection._send_heartbeat()

    be _acknowledge() => _acknowledged = true

    be dispose() => _dispose()

    fun ref _dispose() =>
        if _disposed then return end

        _disposed = true
        _timers.dispose()
