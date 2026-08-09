use collections = "collections"
use time = "time"

trait val _Enum[
    A: _Enum[A, V] val, V: (collections.Hashable val & Equatable[V] val)
] is (collections.Hashable & Equatable[A])
    fun value(): V

    fun hash(): USize => value().hash()

    fun eq(that: A): Bool => value() == that.value()

type _RequestQuery is Array[(String, String)] val
    """
    Query parameters to append to a route, or `None` for a route called without
    any.
    """

type _RequestBody is (String | _Multipart)
    """
    A serialised request body, or `None` for a route called without one.
    """

primitive _WithFiles
    fun apply(
        payload: String,
        files: (Array[FileUpload] val | None)
    ): _RequestBody =>
        match files
        | let files': Array[FileUpload] val if files'.size() > 0 =>
            _Multipart.payload(payload, files')
        else
            payload
        end

primitive _WithQueryParam
    """
    Appends a parameter a route sets itself, rather than one the caller chose.
    """

    fun apply(query: _RequestQuery, name: String, value: Bool): _RequestQuery =>
        recover val
            let query' = Array[(String, String)](query.size() + 1)
            for parameter in query.values() do query'.push(parameter) end
            query'.push((name, value.string()))
            query'
        end

    fun only(name: String, value: Bool): _RequestQuery =>
        recover val
            let query = Array[(String, String)](1)
            query.push((name, value.string()))
            query
        end

class _Queue[A: Any #send]
    embed _queue: collections.List[A] = collections.List[A]

    fun size(): USize => _queue.size()

    fun ref enqueue(item: A): None => _queue.push(consume item)

    fun ref enqueue_at_beginning(item: A): None => _queue.unshift(consume item)

    fun ref dequeue(): A^ ? => _queue.shift()?

    fun ref clear(): None => _queue.clear()

class iso _Elapsed is time.TimerNotify
    """
    Runs `action` when the timer elapses, again on every later tick if
    `repeat'` is set.
    """

    let _action: {()} val
    let _repeat: Bool

    new iso create(action: {()} val, repeat': Bool = false) =>
        _action = action
        _repeat = repeat'

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _action()
        _repeat

primitive _Backoff
    fun apply(attempts: USize, jitter: F64): U64 =>
        let exponent =
            (attempts - 1).min(RestConstants.max_backoff_exponent())
        let delay_ms =
            RestConstants.base_backoff_ms() * (U64(1) << exponent.u64())

        time.Nanos.from_millis((delay_ms.f64() * (0.5 + jitter)).u64())
