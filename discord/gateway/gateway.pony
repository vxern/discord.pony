use "../data"
use "debug"
use rest = "../rest"
use files = "files"
use random = "random"
use time = "time"
use lori = "lori"
use mare = "mare"
use json = "json"
use ssl = "ssl/net"

class Gateway
    let api: GatewayApi
    let events: Events

    new create(env: Env, options: GatewayOptions, routes: rest.Routes) =>
        api = GatewayApi(env, options, routes)
        events = Events(api)
        api._listen(events)

    fun dispose() => api.dispose()

actor GatewayApi
    let _connection: _GatewayConnection

    new create(env: Env, options: GatewayOptions, routes: rest.Routes) =>
        _connection = _GatewayConnection(env, options, routes)

    be send_message(event: GatewaySendableEvent) =>
        _connection._send_message(event)

    be _listen(events: Events) =>
        _connection._listen(events)

    be dispose() => _connection.dispose()

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
        properties': IdentifyConnectionProperties =
            GatewayDefaults.properties(),
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

    fun max_receive_message_size_bytes(): USize => 4_194_304

    fun max_receive_nesting_depth(): USize => 64

    fun min_heartbeat_interval_ms(): U64 => 1_000

    fun max_queued_events(): USize => 1_000

    fun base_backoff_ms(): U64 => 2_000

    fun max_backoff_exponent(): USize => 5

    fun connect_timeout_ms(): U64 => 30_000

    fun hello_timeout_ms(): U64 => 20_000

    fun ready_timeout_ms(): U64 => 60_000

    fun close_timeout_ms(): U64 => 10_000

    fun session_limit_timeout_ms(): U64 => 10_000

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
        let finish: ISize =
            try url.find("/", start)? else url.size().isize() end

        url.substring(start, finish)

primitive _GatewayFailure
    fun reason(reason': lori.ConnectionFailureReason): String =>
        match reason'
        | lori.ConnectionFailedDNS => "could not resolve the gateway host"
        | lori.ConnectionFailedTCP => "could not connect to the gateway"
        | lori.ConnectionFailedSSL =>
            "the TLS handshake with the gateway failed"
        | lori.ConnectionFailedTimeout =>
            "the connection to the gateway timed out"
        | lori.ConnectionFailedTimerError =>
            "the connection timer could not be created"
        end

actor _GatewayConnection is mare.WebSocketClientActor
    let options: GatewayOptions
    let _auth: lori.TCPConnectAuth
    let _ssl_context: (ssl.SSLContext val | None)
    let _timers: time.Timers = time.Timers
    let _rand: random.Rand
    let _bucket: _GatewayBucket
    let _routes: rest.Routes

    var _ws: mare.WebSocketClient = mare.WebSocketClient.none()
    var _events: (Events | None) = None
    var _open: Bool = false
    var _sequence_number: (USize | None) = None
    var _session_id: (String | None) = None
    var _resume_url: (String | None) = None
    var _heartbeat: (_GatewayHeartbeat | None) = None
    var _reconnect_attempts: USize = 0
    var _connect_scheduled: Bool = false
    var _watchdog_generation: USize = 0
    var _watchdog_armed: Bool = false
    var _fatal: Bool = false
    var _limit_check_generation: USize = 0
    var _disposed: Bool = false

    new create(env: Env, options': GatewayOptions, routes: rest.Routes) =>
        options = options'
        _routes = routes
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

        _bucket = _GatewayBucket(this, _timers)

        Debug.out(
            "[gateway] starting up on api v" + options.version.value().string()
            + " with " + options.intents.size().string() + " intent(s)"
        )

        match options.shard
        | (let id: USize, let count: USize) =>
            Debug.out(
                "[gateway] this is shard " + id.string() + " of "
                + count.string()
            )
        end

        if _ssl_context is None then
            Debug.out(
                "[gateway] could not build an SSL context from "
                + options.ca_certificates_path
            )
        end

    fun ref _websocket(): mare.WebSocketClient => _ws

    fun ref _connect() =>
        if _disposed then
            Debug.out(
                "[gateway] not connecting: the connection was disposed of"
            )
            return
        end

        if _fatal then
            Debug.out("[gateway] not connecting: the gateway gave up")
            return
        end

        match _resume_url
        | let url': String =>
            Debug.out(
                "[gateway] a session is in hand, resuming through " + url'
            )
            _dial(url')
        else
            Debug.out(
                "[gateway] no session in hand, so checking the session start "
                + "limit"
            )

            _check_session_limits()
        end

    fun ref _check_session_limits() =>
        _limit_check_generation = _limit_check_generation + 1

        let generation = _limit_check_generation
        let self: _GatewayConnection tag = this

        _routes.get_gateway_bot(
            { (info: GatewayBotInfo) => self._session_limits(generation, info) }
        )

        _timers(
            time.Timer(
                _OnceElapsed(
                    {() => self._session_limits_timed_out(generation)}
                ),
                time.Nanos.from_millis(
                    GatewayConstants.session_limit_timeout_ms()
                )
            )
        )

    fun ref _dial(url: String) =>
        let context =
            match _ssl_context
            | let context': ssl.SSLContext val => context'
            else
                Debug.out("[gateway] giving up: there is no SSL context")
                options.on_error(
                    GatewayError("could not create an SSL context")
                )
                return
            end

        let headers: Array[(String val, String val)] val =
            [("User-Agent", options.user_agent)]

        Debug.out(
            "[gateway] dialling " + _GatewayUrl.host(url) + ":"
            + GatewayConstants.port() + options.path()
        )

        _open = false
        _bucket.close()
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
                max_message_size' =
                    GatewayConstants.max_receive_message_size_bytes()
            )
        )

        _arm_watchdog(
            "the connection to open",
            GatewayConstants.connect_timeout_ms()
        )

    fun ref on_open(response: mare.UpgradeResponse val) =>
        Debug.out("[gateway] the websocket upgrade went through")

        _arm_watchdog("a hello", GatewayConstants.hello_timeout_ms())

    fun ref on_text_message(text: String val) =>
        Debug.out("[gateway] <- " + text.size().string() + " bytes")

        if
            not _GatewayNesting.within(
                text,
                GatewayConstants.max_receive_nesting_depth()
            )
        then
            Debug.out(
                "[gateway] dropping a message that nests deeper than "
                + GatewayConstants.max_receive_nesting_depth().string()
                + " levels"
            )
            options.on_error(
                GatewayError(
                    "an incoming message of " + text.size().string()
                    + " bytes nests deeper than the gateway reads, so it was "
                    + "dropped unparsed"
                )
            )

            return
        end

        let payload =
        try
            match json.JsonParser.parse(text)
            | let parsed: json.JsonObject =>
                GatewayEventPayload.from_json(parsed)?
            else
                Debug.out(
                    "[gateway] dropping a message that is not a JSON object"
                )
                return
            end
        else
            Debug.out(
                "[gateway] dropping a message that could not be read: " + text
            )
            return
        end

        match payload.s
        | let s: USize =>
            _sequence_number = s
            Debug.out("[gateway] the sequence number is now " + s.string())
        end

        match payload.op
        | GatewayOpcodeHello =>
            if _open then
                Debug.out(
                    "[gateway] ignoring a second hello on a connection that is "
                    + "already open"
                )
                return
            end

            try
                let hello =
                    GatewayHello.from_json(payload.d as json.JsonObject)?
                let asked = hello.heartbeat_interval.u64()
                let interval =
                    asked.max(GatewayConstants.min_heartbeat_interval_ms())

                if interval != asked then
                    Debug.out(
                        "[gateway] the gateway asked for a heartbeat every "
                        + asked.string() + "ms, which is too often, so holding "
                        + "it to " + interval.string() + "ms"
                    )
                end

                Debug.out(
                    "[gateway] hello: heartbeat every " + interval.string()
                    + "ms"
                )

                _open = true
                _bucket.set_heartbeat_interval(interval)
                _start_heartbeat(interval)
                _identify_or_resume()
                _arm_watchdog(
                    "a ready or a resumed",
                    GatewayConstants.ready_timeout_ms()
                )
            else
                Debug.out(
                    "[gateway] the hello could not be read, so no heartbeat "
                    + "was started"
                )
            end
        | GatewayOpcodeHeartbeat =>
            Debug.out("[gateway] the gateway asked for a heartbeat right away")

            match _heartbeat
            | let heartbeat: _GatewayHeartbeat => heartbeat._beat_now()
            else
                Debug.out(
                    "[gateway] ...but there is no heartbeat running to ask"
                )
            end
        | GatewayOpcodeHeartbeatACK =>
            Debug.out("[gateway] the heartbeat was acknowledged")

            match _heartbeat
            | let heartbeat: _GatewayHeartbeat => heartbeat._acknowledge()
            else
                Debug.out(
                    "[gateway] ...but there is no heartbeat running to "
                    + "acknowledge"
                )
            end
        | GatewayOpcodeReconnect =>
            Debug.out("[gateway] the gateway asked us to reconnect")
            _reconnect(true)
        | GatewayOpcodeInvalidSession =>
            let resumable = try payload.d as Bool else false end

            Debug.out(
                "[gateway] the session was invalidated and is "
                + (if resumable then "resumable" else "not resumable" end)
            )

            _reconnect(resumable)
        | GatewayOpcodeDispatch =>
            let name =
                try
                    payload.t as String
                else
                    Debug.out(
                        "[gateway] dropping a dispatch that carries no event "
                        + "name"
                    )
                    return
                end

            let event =
                try
                    GatewayDispatchEvents.from(name, payload.d)?
                else
                    Debug.out(
                        "[gateway] dropping " + name
                        + ": its data could not be read"
                    )
                    return
                end

            _on_dispatch(name, event)
        else
            Debug.out(
                "[gateway] nothing to do for opcode "
                + payload.op.value().string()
            )
        end

    fun ref on_throttled() =>
        Debug.out(
            "[gateway] the connection is backed up, so holding off on sends"
        )
        _bucket.throttle()

    fun ref on_unthrottled() =>
        Debug.out(
            "[gateway] the connection has caught up, so sends can go out again"
        )
        _bucket.unthrottle()

    fun ref on_connection_failure(reason: lori.ConnectionFailureReason) =>
        Debug.out(
            "[gateway] the connection failed: " + _GatewayFailure.reason(reason)
        )
        _disarm_watchdog()
        options.on_error(GatewayError(_GatewayFailure.reason(reason)))
        _schedule_connect()

    fun ref on_handshake_failure(err: mare.ClientHandshakeError) =>
        Debug.out("[gateway] the handshake failed: " + err.string())
        _disarm_watchdog()
        options.on_error(
            GatewayError("the gateway handshake failed: " + err.string())
        )
        _schedule_connect()

    fun ref on_closed(status: mare.CloseStatus, reason: String val) =>
        Debug.out(
            "[gateway] the websocket closed with " + status.code().string()
            + " (" + status.string() + "): " + reason
        )

        _open = false
        _disarm_watchdog()
        _bucket.close()
        _stop_heartbeat()

        let code =
            try
                GatewayCloseEventCodes.from(status.code())?
            else
                Debug.out(
                    "[gateway] " + status.code().string()
                    + " is not a Discord close code, so reconnecting on spec"
                )
                _schedule_connect()
                return
            end

        if not code.reconnect() then
            Debug.out(
                "[gateway] close code " + code.value().string()
                + " cannot be recovered from, so staying down"
            )
            options.on_error(
                GatewayError(
                    "the gateway closed the connection: " + status.string()
                )
            )
            return
        end

        match code
        | GatewayCloseEventCodeInvalidSequence
        | GatewayCloseEventCodeSessionTimedOut =>
            Debug.out("[gateway] the session is past saving, dropping it")
            _forget_session()
        end

        _schedule_connect()

    be _listen(events: Events) =>
        Debug.out("[gateway] the event dispatcher is now attached")

        let first = _events is None
        _events = events

        if first then _connect() end

    be _send_message(event: GatewaySendableEvent) =>
        Debug.out(
            "[gateway] handing opcode " + event.opcode().value().string()
            + " to the bucket"
        )
        _bucket.enqueue(event)

    be _send_heartbeat() =>
        if not _open then
            Debug.out(
                "[gateway] skipping a heartbeat: the connection is not open"
            )
            return
        end

        match _sequence_number
        | let s: USize =>
            Debug.out("[gateway] heartbeating at sequence " + s.string())
        else
            Debug.out("[gateway] heartbeating with no sequence number yet")
        end

        _bucket.heartbeat(GatewayHeartbeatEvent(_sequence_number))

    be _raw_send(event: GatewaySendableEvent) =>
        _send(event)

    be _session_limits(generation: USize, info: GatewayBotInfo) =>
        if _disposed or _fatal then return end

        if generation != _limit_check_generation then
            Debug.out("[gateway] ignoring a stale session start limit")
            return
        end

        _limit_check_generation = _limit_check_generation + 1

        let limit = info.session_start_limit

        Debug.out(
            "[gateway] " + limit.remaining.string() + " of "
            + limit.total.string() + " session start(s) left, "
            + limit.max_concurrency.string() + " identify(s) per 5s, "
            + info.shards.string() + " shard(s) recommended"
        )

        _bucket.set_identify_concurrency(limit.max_concurrency)

        if info.shards > 1 then
            options.on_error(
                GatewayError(
                    "discord recommends " + info.shards.string()
                    + " shards, but only one connection is running"
                )
            )
        end

        if limit.remaining == 0 then
            Debug.out(
                "[gateway] the session start limit is spent, waiting "
                + limit.reset_after.string() + "ms for it to reset"
            )
            options.on_error(
                GatewayError(
                    "the session start limit of " + limit.total.string()
                    + " is spent, so waiting " + limit.reset_after.string()
                    + "ms for it to reset"
                )
            )
            _schedule_connect(limit.reset_after)
            return
        end

        _dial(GatewayConstants.base_url())

    be _session_limits_timed_out(generation: USize) =>
        if _disposed or _fatal then return end

        if generation != _limit_check_generation then return end

        _limit_check_generation = _limit_check_generation + 1

        Debug.out(
            "[gateway] the session start limit did not come back in time, "
            + "so connecting anyway"
        )
        options.on_error(
            GatewayError(
                "the session start limit could not be read, so connecting "
                + "anyway"
            )
        )

        _dial(GatewayConstants.base_url())

    be _queue_overflowed(cap: USize) =>
        Debug.out(
            "[gateway] the send queue hit " + cap.string()
            + " events, so the oldest are being dropped"
        )
        options.on_error(
            GatewayError(
                "the gateway send queue is full at " + cap.string()
                + " events, so the oldest are being dropped"
            )
        )

    be _queue_recovered(dropped: USize) =>
        Debug.out(
            "[gateway] the send queue has caught up after dropping "
            + dropped.string() + " event(s)"
        )
        options.on_error(
            GatewayError(
                "the gateway send queue has caught up, having dropped "
                + dropped.string() + " event(s)"
            )
        )

    be _heartbeat_dropped(reserve: USize) =>
        Debug.out(
            "[gateway] a heartbeat was dropped to keep inside the command "
            + "budget"
        )
        options.on_error(
            GatewayError(
                "a heartbeat was dropped: " + reserve.string()
                + " have already gone out inside the command window"
            )
        )

    be _heartbeat_timed_out() =>
        Debug.out(
            "[gateway] a heartbeat went unacknowledged, so the connection is "
            + "stale"
        )
        _reconnect(true)

    be _reconnect_now() =>
        Debug.out("[gateway] the backoff has elapsed, reconnecting now")
        _connect_scheduled = false
        _connect()

    be _watchdog_expired(generation: USize, stage: String) =>
        if _disposed then return end

        if generation != _watchdog_generation then
            Debug.out(
                "[gateway] ignoring a stale watchdog for " + stage
            )
            return
        end

        Debug.out(
            "[gateway] gave up waiting for " + stage + ", dropping the socket"
        )

        _watchdog_armed = false
        _open = false
        options.on_error(
            GatewayError("the gateway timed out waiting for " + stage)
        )

        _bucket.close()
        _stop_heartbeat()
        _connection().hard_close()
        _schedule_connect()

    be dispose() =>
        if _disposed then return end

        Debug.out("[gateway] disposing of the connection")

        _disposed = true
        _disarm_watchdog()
        _bucket.dispose()
        _stop_heartbeat()
        _timers.dispose()

        if _open then
            _open = false
            _ws.close(mare.CloseNormal)
        end

    fun ref _send(event: GatewaySendableEvent) =>
        let text: String val = event.payload().to_json().print()
        let limit = GatewayConstants.max_send_message_size_bytes()

        if text.size() > limit then
            Debug.out(
                "[gateway] opcode " + event.opcode().value().string() + " is "
                + text.size().string() + " bytes, over the " + limit.string()
                + " byte limit, so dropping it"
            )
            options.on_error(
                GatewayError(
                    "an outgoing payload of " + text.size().string()
                    + " bytes is over the gateway limit of " + limit.string()
                    + " bytes"
                )
            )

            match event.opcode()
            | GatewayOpcodeIdentify =>
                _give_up("the identify is too big to ever go out")
            | GatewayOpcodeResume =>
                Debug.out(
                    "[gateway] the resume is too big, so starting a fresh "
                    + "session"
                )
                _reconnect(false)
            end

            return
        end

        Debug.out(
            "[gateway] -> opcode " + event.opcode().value().string() + ", "
            + text.size().string() + " bytes"
        )

        _ws.send_text(text)

    fun ref _give_up(reason: String) =>
        Debug.out("[gateway] giving up: " + reason)

        _fatal = true
        _open = false
        _disarm_watchdog()
        _bucket.close()
        _stop_heartbeat()
        _connection().hard_close()

    fun ref _identify_or_resume() =>
        match (_session_id, _sequence_number)
        | (let session_id: String, let sequence_number: USize) =>
            Debug.out(
                "[gateway] resuming session " + session_id + " from sequence "
                + sequence_number.string()
            )
            _bucket.handshake(
                GatewayResumeEvent(options.token, session_id, sequence_number)
            )
        else
            Debug.out("[gateway] identifying as a new session")
            _bucket.handshake(
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

            Debug.out(
                "[gateway] ready as " + ready.user.username + " on session "
                + ready.session_id + ", resumable through "
                + ready.resume_gateway_url
            )
        end

        if (name == "READY") or (name == "RESUMED") then
            Debug.out(
                "[gateway] the connection is settled, resetting the backoff"
            )
            _reconnect_attempts = 0
            _disarm_watchdog()
        end

        match _events
        | let events: Events => events._dispatch(name, event)
        else
            Debug.out(
                "[gateway] dropping " + name + ": nothing is listening yet"
            )
        end

    fun ref _reconnect(resume: Bool) =>
        if _disposed then
            Debug.out(
                "[gateway] not reconnecting: the connection was disposed of"
            )
            return
        end

        Debug.out(
            "[gateway] reconnecting, "
            + (
                if resume then
                    "keeping the session"
                else
                    "dropping the session"
                end
            )
        )

        if not resume then
            _forget_session()
        end

        _bucket.close()
        _stop_heartbeat()

        if resume then
            Debug.out(
                "[gateway] dropping the socket instead of closing it, so that "
                + "the gateway holds the session open to resume into"
            )
            _open = false
            _connection().hard_close()
            _schedule_connect()
        elseif _open then
            _open = false
            _ws.close(mare.CloseGoingAway, "reconnecting")
            _arm_watchdog(
                "the close handshake",
                GatewayConstants.close_timeout_ms()
            )
        else
            Debug.out(
                "[gateway] there is no open websocket to close, so dropping "
                + "the socket"
            )
            _connection().hard_close()
            _schedule_connect()
        end

    fun ref _forget_session() =>
        Debug.out("[gateway] forgetting the session, the id and the resume url")

        _session_id = None
        _sequence_number = None
        _resume_url = None

    fun ref _schedule_connect(delay_ms: (U64 | None) = None) =>
        if _disposed then
            Debug.out(
                "[gateway] not scheduling a connect: the connection was "
                + "disposed of"
            )
            return
        end

        if _fatal then
            Debug.out("[gateway] not scheduling a connect: the gateway gave up")
            return
        end

        if _connect_scheduled then
            Debug.out("[gateway] a connect is already scheduled, leaving it be")
            return
        end

        _connect_scheduled = true

        let delay =
            match delay_ms
            | let ms: U64 =>
                Debug.out(
                    "[gateway] the next connect is held back by " + ms.string()
                    + "ms"
                )
                time.Nanos.from_millis(ms)
            else
                _reconnect_attempts = _reconnect_attempts + 1
                let backoff = _backoff()
                Debug.out(
                    "[gateway] attempt " + _reconnect_attempts.string()
                    + " goes out in " + (backoff / 1_000_000).string() + "ms"
                )
                backoff
            end

        let self: _GatewayConnection tag = this
        _timers(
            time.Timer(
                _OnceElapsed({() => self._reconnect_now()}),
                delay
            )
        )

    fun ref _arm_watchdog(stage: String, timeout_ms: U64) =>
        if _disposed then return end

        _watchdog_generation = _watchdog_generation + 1
        _watchdog_armed = true

        let generation = _watchdog_generation

        Debug.out(
            "[gateway] watching for " + stage + ", giving it "
            + timeout_ms.string() + "ms"
        )

        let self: _GatewayConnection tag = this
        _timers(
            time.Timer(
                _OnceElapsed({() => self._watchdog_expired(generation, stage)}),
                time.Nanos.from_millis(timeout_ms)
            )
        )

    fun ref _disarm_watchdog() =>
        if not _watchdog_armed then return end

        Debug.out("[gateway] the watchdog is standing down")

        _watchdog_generation = _watchdog_generation + 1
        _watchdog_armed = false

    fun ref _backoff(): U64 =>
        let exponent =
            (_reconnect_attempts - 1).min(
                GatewayConstants.max_backoff_exponent()
            )
        let delay_ms =
            GatewayConstants.base_backoff_ms() * (U64(1) << exponent.u64())

        time.Nanos.from_millis((delay_ms.f64() * (0.5 + _rand.real())).u64())

    fun ref _start_heartbeat(interval_ms: U64) =>
        _stop_heartbeat()

        Debug.out(
            "[gateway] starting a heartbeat every " + interval_ms.string()
            + "ms"
        )

        let self: _GatewayConnection tag = this
        _heartbeat = _GatewayHeartbeat(self, _timers, interval_ms)

    fun ref _stop_heartbeat() =>
        match _heartbeat
        | let heartbeat: _GatewayHeartbeat =>
            Debug.out("[gateway] stopping the heartbeat")
            heartbeat.dispose()
        end

        _heartbeat = None

actor _GatewayHeartbeat
    let _connection: _GatewayConnection
    let _timers: time.Timers
    let _interval_ns: U64
    let _timer: time.Timer tag

    var _awaiting_since: (U64 | None) = None
    var _last_beat_at: U64 = 0
    var _disposed: Bool = false

    new create(
        connection: _GatewayConnection,
        timers: time.Timers,
        interval_ms: U64
    ) =>
        _connection = connection
        _timers = timers
        _interval_ns = time.Nanos.from_millis(interval_ms)

        (let seconds, let nanoseconds) = time.Time.now()
        let rand = random.Rand(seconds.u64(), nanoseconds.u64())
        let initial_delay = (_interval_ns.f64() * rand.real()).u64()

        Debug.out(
            "[gateway] the first heartbeat is jittered to "
            + (initial_delay / 1_000_000).string() + "ms from now"
        )

        let self: _GatewayHeartbeat tag = this
        let timer = time.Timer(
            _RepeatedlyElapsed({() => self._beat()}),
            initial_delay,
            _interval_ns
        )
        _timer = timer
        _timers(consume timer)

    be _beat() =>
        if _disposed then
            Debug.out(
                "[gateway] skipping a beat: the heartbeat was disposed of"
            )
            return
        end

        match _awaiting_since
        | let since: U64 =>
            let outstanding = time.Time.nanos() - since

            if outstanding >= _interval_ns then
                Debug.out(
                    "[gateway] the heartbeat sent "
                    + (outstanding / 1_000_000).string()
                    + "ms ago was never acknowledged"
                )
                _connection._heartbeat_timed_out()
                _dispose()
                return
            end
        end

        _send()

    be _beat_now() =>
        if _disposed then
            Debug.out(
                "[gateway] skipping an out-of-band beat: the heartbeat was "
                + "disposed of"
            )
            return
        end

        let since = time.Time.nanos() - _last_beat_at

        if since < _interval_ns then
            Debug.out(
                "[gateway] ignoring an out-of-band beat: one went out "
                + (since / 1_000_000).string() + "ms ago"
            )
            return
        end

        Debug.out("[gateway] beating out of band")

        _send()

    be _acknowledge() => _awaiting_since = None

    be dispose() => _dispose()

    fun ref _send() =>
        let now = time.Time.nanos()

        if _awaiting_since is None then _awaiting_since = now end

        _last_beat_at = now
        _connection._send_heartbeat()

    fun ref _dispose() =>
        if _disposed then return end

        Debug.out("[gateway] disposing of the heartbeat")

        _disposed = true
        _timers.cancel(_timer)
