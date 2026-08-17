use collections = "collections"
use time = "time"

primitive _GatewayWanted
    fun apply(
        name: String,
        subscriptions: (collections.Set[String] val | None)
    ): Bool =>
        if (name == "READY") or (name == "RESUMED") then return true end

        match subscriptions
        | let names: collections.Set[String] val => names.contains(name)
        else
            true
        end

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

class iso _Elapsed is time.TimerNotify
    let _action: {()} val
    let _repeat: Bool

    new iso create(action: {()} val, repeat': Bool = false) =>
        _action = action
        _repeat = repeat'

    fun ref apply(timer: time.Timer, count: U64): Bool =>
        _action()
        _repeat
