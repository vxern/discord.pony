use collections = "collections"
use time = "time"

type _Enum[A: Equatable[A] #read] is (collections.Hashable & Equatable[A])

type _RequestQuery is Array[(String, String)] val
    """
    Query parameters to append to a route, or `None` for a route called without any.
    """

type _RequestBody is String
    """
    A serialised request body, or `None` for a route called without one.
    """

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
