use collections = "collections"
use json = "json"
use time = "time"

type ISO8601 is String

type _Enum[A: Equatable[A] #read] is (collections.Hashable & Equatable[A])

class Queue[A: Any #send]
    embed _queue: collections.List[A] = collections.List[A]

    fun size(): USize => _queue.size()

    fun ref enqueue(item: A): None => _queue.push(consume item)

    fun ref enqueue_at_beginning(item: A): None => _queue.unshift(consume item)

    fun ref dequeue(): A^ ? => _queue.shift()?

    fun ref clear(): None => _queue.clear()

trait val ToJsonable is Stringable
    fun to_json(): json.JsonObject

    fun string(): String iso^ => to_json().pretty_print()

trait val FromJsonable
    new val from_json(obj: json.JsonObject) ?

trait val ToJsonableArray is Stringable
    fun to_json(): json.JsonArray

    fun string(): String iso^ => to_json().pretty_print()

trait val Jsonable is (ToJsonable & FromJsonable)

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
