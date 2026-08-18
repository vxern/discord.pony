use collections = "collections"
use time = "time"

trait val _Enum[
    A: _Enum[A, V] val, V: (collections.Hashable val & Equatable[V] val)
] is (collections.Hashable & Equatable[A])
    fun value(): V

    fun hash(): USize => value().hash()

    fun eq(that: A): Bool => value() == that.value()

primitive _PathSegment
    """
    Percent-encodes every byte of a path segment that falls outside the RFC 3986
    unreserved set (`ALPHA`, `DIGIT`, `-`, `.`, `_`, `~`).
    """

    fun apply(segment: String val): String val =>
        recover val
            let encoded = String(segment.size())

            for byte in segment.values() do
                if _unreserved(byte) then
                    encoded.push(byte)
                else
                    encoded.push('%')
                    encoded.push(_hex(byte >> 4))
                    encoded.push(_hex(byte and 0x0f))
                end
            end

            encoded
        end

    fun _unreserved(byte: U8): Bool =>
        ((byte >= 'a') and (byte <= 'z'))
            or ((byte >= 'A') and (byte <= 'Z'))
            or ((byte >= '0') and (byte <= '9'))
            or (byte == '-')
            or (byte == '.')
            or (byte == '_')
            or (byte == '~')

    fun _hex(nibble: U8): U8 =>
        if nibble < 10 then '0' + nibble else 'A' + (nibble - 10) end
