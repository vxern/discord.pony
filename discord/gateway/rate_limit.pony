use "../data"
use time = "time"

class _RateLimitWindow
    let max_count: USize
    let duration_ns: U64

    embed _sent_at: Array[U64]
    var _sends: USize = 0

    new create(max_count': USize, duration_ms': USize) =>
        max_count = max_count'
        duration_ns = time.Nanos.from_millis(duration_ms'.u64())
        _sent_at = Array[U64].init(0, max_count')

    fun blocked_until(now: U64, reserved: USize = 0): (U64 | None) =>
        let capacity = max_count - reserved.min(max_count)
        if capacity == 0 then return now + duration_ns end
        if _sends < capacity then return None end

        let frees_at =
            try
                _sent_at((_sends - capacity) % max_count)? + duration_ns
            else
                return None
            end

        if frees_at > now then frees_at end

    fun ref spend(now: U64) =>
        try _sent_at(_sends % max_count)? = now end
        _sends = _sends + 1

primitive _IsPresenceUpdate
    fun apply(event: GatewaySendableEvent): Bool =>
        match event.opcode()
        | GatewayOpcodePresenceUpdate => true
        else
            false
        end

primitive _IsIdentify
    fun apply(event: GatewaySendableEvent): Bool =>
        match event.opcode()
        | GatewayOpcodeIdentify => true
        else
            false
        end

primitive _RateLimitConstants
    fun command_window(): _RateLimitWindow => _RateLimitWindow(120, 60 * 1000)

    fun presence_window(): _RateLimitWindow => _RateLimitWindow(5, 20 * 1000)

    fun identify_window(): _RateLimitWindow => _RateLimitWindow(1, 5 * 1000)

    fun heartbeat_reserve(): USize => 5
