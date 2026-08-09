use courier = "courier"
use time = "time"

class val _RateLimit
    let limit: (USize | None)
    let remaining: USize
    let reset_s: (F64 | None)
    let reset_after_s: F64
    let bucket: (String | None)

    new val from_headers(headers: courier.Headers val) ? =>
        var limit': (USize | None) = None
        var remaining': (USize | None) = None
        var reset_s': (F64 | None) = None
        var reset_after_s': (F64 | None) = None
        var retry_after_s': (F64 | None) = None
        var bucket': (String | None) = None

        for (key, value) in headers.values() do
            match key
            | "x-ratelimit-limit" => limit' = value.usize()?
            | "x-ratelimit-remaining" => remaining' = value.usize()?
            | "x-ratelimit-reset" => reset_s' = value.f64()?
            | "x-ratelimit-reset-after" => reset_after_s' = value.f64()?
            | "x-ratelimit-bucket" => bucket' = value
            | "retry-after" => retry_after_s' = value.f64()?
            end
        end

        // A global rate limit only sends `X-RateLimit-Retry-After`, so a
        // response is worth something as long as it tells us either how much is
        // left or how long to wait for.
        if (remaining' is None) and (reset_after_s' is None) and (
            retry_after_s' is None
        ) then
            error
        end

        limit = limit'
        bucket = bucket'
        remaining = try remaining' as USize else 0 end
        reset_s = reset_s'
        reset_after_s =
            match (reset_after_s', retry_after_s')
            | (let seconds: F64, _) => seconds
            | (_, let seconds: F64) => seconds
            else
                0
            end

    fun is_newer_than(other: (_RateLimit | None)): Bool =>
        let held =
            match other
            | let held': _RateLimit => held'
            else
                return true
            end

        match (reset_s, held.reset_s)
        | (let mine: F64, let theirs: F64) =>
            if mine != theirs then
                mine > theirs
            else
                remaining < held.remaining
            end
        else
            (reset_after_s < held.reset_after_s)
                or (remaining < held.remaining)
                or (
                    (reset_after_s > held.reset_after_s)
                        and (remaining > held.remaining)
                )
        end

class _RateLimitWindow
    let max_count: USize
    let duration_ns: U64

    embed _sent_at: Array[U64]
    var _sends: USize = 0

    new create(max_count': USize, duration_ms': USize) =>
        max_count = max_count'
        duration_ns = time.Nanos.from_millis(duration_ms'.u64())
        _sent_at = Array[U64].init(0, max_count')

    fun blocked_until(now: U64): (U64 | None) =>
        if _sends < max_count then return None end

        let frees_at =
            try _sent_at(_sends % max_count)? + duration_ns else return None end
        if frees_at > now then frees_at end

    fun ref spend(now: U64) =>
        try _sent_at(_sends % max_count)? = now end
        _sends = _sends + 1

primitive _IsGlobalRateLimit
    fun apply(headers: courier.Headers val): Bool =>
        match headers.get(_RateLimitConstants.scope_header_name())
        | let scope: String => return scope == "global"
        end

        match headers.get(_RateLimitConstants.global_header_name())
        | let global: String => return global == "true"
        end

        headers.get(_RateLimitConstants.bucket_header_name()) is None

primitive _IsRetriable
    fun apply(status: U16): Bool =>
        """
        The statuses Discord hands back for a hiccup on their side, rather
        than for anything wrong with the request.
        """

        match status
        | 500 | 502 | 503 | 504 => true
        else
            false
        end

primitive _RateLimitConstants
    fun windows(): Array[_RateLimitWindow] =>
        """
        How many requests the API takes, and in what span of time.

        Going over the Cloudflare limit results in an hour-long ban, so it's
        extremely key we don't exceed that.
        """

        [
            // Discord: 50 a second
            _RateLimitWindow(50, 1000)
            // Cloudflare: 10,000 in 10 minutes (~16.7 requests per second)
            _RateLimitWindow(10_000, 10 * 60 * 1000)
        ]

    fun global_header_name(): String => "X-RateLimit-Global".lower()

    fun scope_header_name(): String => "X-RateLimit-Scope".lower()

    fun bucket_header_name(): String => "X-RateLimit-Bucket".lower()

    fun minimum_pause_s(): F64 =>
        """
        The least time the global bucket sits out a 429, however short a wait
        the response asks for.
        """

        1

    fun minimum_rest_s(): F64 =>
        """
        The least time a bucket sits out before probing again once it has run
        out of slots.

        Without a floor, a bucket whose rate limit headers could not be read
        rests for no time at all, so a 429 that names no wait sends it straight
        back for another one.
        """

        1

    fun blind_pause_s(): F64 =>
        """
        How long the global bucket sits out a 429 that names no wait at all.

        Long enough not to walk straight back into a Cloudflare ban, short
        enough that taking a route's limit for a global one is not costly.
        """

        60
