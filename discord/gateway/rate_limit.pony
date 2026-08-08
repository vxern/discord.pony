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

    fun recent(now: U64): Array[U64] =>
        let kept = Array[U64](max_count)
        let held = _sends.min(max_count)

        var index = _sends - held

        while index < _sends do
            try
                let at = _sent_at(index % max_count)?
                if (at + duration_ns) > now then kept.push(at) end
            end

            index = index + 1
        end

        kept

    fun ref replay(timestamps: Array[U64] box) =>
        for at in timestamps.values() do spend(at) end

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

    fun identify_window(max_concurrency: USize = 1): _RateLimitWindow =>
        _RateLimitWindow(max_concurrency.max(1), 5 * 1000)

    fun heartbeat_window(reserve: USize): _RateLimitWindow =>
        _RateLimitWindow(reserve, 60 * 1000)

    fun heartbeat_reserve(interval_ms: U64 = 0): USize =>
        if interval_ms == 0 then return 5 end

        let per_window = ((60 * 1000) + (interval_ms - 1)) / interval_ms

        (per_window * 2).usize().min(20)
