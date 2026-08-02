use courier = "courier"
use collections = "collections"

class Queue[A: Any #send]
    embed _queue: collections.List[A] = collections.List[A]

    fun size(): USize => _queue.size()

    fun ref enqueue(item: A): None => _queue.push(consume item)

    fun ref enqueue_at_beginning(item: A): None => _queue.unshift(consume item)

    fun ref dequeue(): A^ ? => _queue.shift()?

interface tag ResponseReceiver
    be on_response_received(response: courier.HTTPResponse)

actor Bucket is ResponseReceiver
    let _rest: Rest
    let _id: String
    embed _queue: Queue[courier.HTTPRequest] = Queue[courier.HTTPRequest]

    var _rate_limit: (RateLimit | None) = None
    var _requests_in_flight: USize = 0
    var _requests_remaining: USize = 1
    
    new create(rest: Rest, id: String) =>
        _rest = rest
        _id = id

    be enqueue(request: courier.HTTPRequest) =>
        _queue.enqueue(request)
        _drain()

    be _drain() =>
        while (_requests_remaining > 0) and (_queue.size() > 0) do
            try
                let request = _queue.dequeue()?

                _requests_in_flight = _requests_in_flight + 1
                _requests_remaining = _requests_remaining - 1

                _rest.send_request(request, this)
            else
                break
            end
        end
    
    be on_response_received(response: courier.HTTPResponse) =>
        _requests_in_flight = _requests_in_flight - 1

        // Not every response carries rate limit headers, which is fine.
        // In that case, we just default to the standard rate limit.
        try
            let rate_limit = RateLimit.from_headers(response.headers)?
            if rate_limit.is_newer_than(_rate_limit) then
                _rate_limit = rate_limit
                _requests_remaining = rate_limit.remaining - _requests_in_flight.min(rate_limit.remaining)
            end
        end
        
        // TODO(vxern): Send the response back in a callback.

        _drain()

class val RateLimit
    let limit: USize
    let remaining: USize
    let reset_s: F64
    let reset_after_s: F64
    let bucket: String

    new val from_headers(headers: courier.Headers val) ? =>
        var limit': (USize | None) = None
        var remaining': (USize | None) = None
        var reset_s': (F64 | None) = None
        var reset_after_s': (F64 | None) = None
        var bucket': (String | None) = None
        
        for (key, value) in headers.values() do
            match key
            | RateLimitConstants.limit_header_name() => limit' = value.usize()?
            | RateLimitConstants.remaining_header_name() => remaining' = value.usize()?
            | RateLimitConstants.reset_header_name() => reset_s' = value.f64()?
            | RateLimitConstants.reset_after_header_name() => reset_after_s' = value.f64()?
            | RateLimitConstants.bucket_header_name() => bucket' = value
            end
        end

        limit = limit' as USize
        remaining = remaining' as USize
        reset_s = reset_s' as F64
        reset_after_s = reset_after_s' as F64
        bucket = bucket' as String
    
    fun is_newer_than(other: (RateLimit | None)): Bool =>
        match other
        | let other': RateLimit =>
            (reset_s > other'.reset_s)
            or (reset_after_s < other'.reset_after_s)
            or (remaining < other'.remaining)
        else
            true
        end

primitive RateLimitConstants
    fun global_rate_limit_max_count(): USize =>
        """
        How many requests can be made to the API.
        """

        50

    fun global_rate_limit_window_ms(): USize =>
        """
        What window of time the requests can be made to the API in.
        """

        1000 // 1 second

    fun cloudflare_rate_limit_max_count(): USize =>
        """
        How many requests can be made via Cloudflare's proxy.
        """

        10_000

    fun cloudflare_rate_limit_window_ms(): USize =>
        """
        What window of time the requests can be made via Cloudflare's proxy in.
        """

        10 * 60 * 1000 // 10 minutes

    fun limit_header_name(): String => "X-RateLimit-Limit".lower()

    fun remaining_header_name(): String => "X-RateLimit-Remaining".lower()

    fun reset_header_name(): String => "X-RateLimit-Reset".lower()

    fun reset_after_header_name(): String => "X-RateLimit-Reset-After".lower()

    fun bucket_header_name(): String => "X-RateLimit-Bucket".lower()

    fun global_header_name(): String => "X-RateLimit-Global".lower()

    fun scope_header_name(): String => "X-RateLimit-Scope".lower()
