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

type _RequestBody is String
    """
    A serialised request body, or `None` for a route called without one.
    """

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

class Queue[A: Any #send]
    embed _queue: collections.List[A] = collections.List[A]

    fun size(): USize => _queue.size()

    fun ref enqueue(item: A): None => _queue.push(consume item)

    fun ref enqueue_at_beginning(item: A): None => _queue.unshift(consume item)

    fun ref dequeue(): A^ ? => _queue.shift()?

    fun ref clear(): None => _queue.clear()

class iso _OnceElapsed is time.TimerNotify
    """
    Runs `action` when the timer elapses, and does not run again.
    """

    let _action: {()} val

    new iso create(action: {()} val) =>
        _action = action

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _action()
        false
