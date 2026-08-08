use collections = "collections"
use time = "time"

class _Queue[A: Any #send]
    embed _queue: collections.List[A] = collections.List[A]

    fun size(): USize => _queue.size()

    fun ref enqueue(item: A): None => _queue.push(consume item)

    fun ref enqueue_at_beginning(item: A): None => _queue.unshift(consume item)

    fun ref dequeue(): A^ ? => _queue.shift()?

    fun ref clear(): None => _queue.clear()

primitive _GatewayNesting
    fun within(text: String, limit: USize): Bool =>
        var depth: USize = 0
        var in_string = false
        var escaped = false

        for byte in text.values() do
            if escaped then
                escaped = false
                continue
            end

            if in_string then
                match byte
                | '\\' => escaped = true
                | '"' => in_string = false
                end

                continue
            end

            match byte
            | '"' => in_string = true
            | '[' | '{' =>
                depth = depth + 1
                if depth > limit then return false end
            | ']' | '}' => if depth > 0 then depth = depth - 1 end
            end
        end

        true

class iso _OnceElapsed is time.TimerNotify
    let _action: {()} val

    new iso create(action: {()} val) =>
        _action = action

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _action()
        false

class iso _RepeatedlyElapsed is time.TimerNotify
    let _action: {()} val

    new iso create(action: {()} val) =>
        _action = action

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _action()
        true
