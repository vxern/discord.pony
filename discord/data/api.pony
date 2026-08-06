trait val ApiVersion is _Enum[ApiVersion, U8]
    fun id(): String => "v" + value().string()
primitive ApiVersion6 is ApiVersion
    fun value(): U8 => 6
primitive ApiVersion7 is ApiVersion
    fun value(): U8 => 7
primitive ApiVersion8 is ApiVersion
    fun value(): U8 => 8
primitive ApiVersion9 is ApiVersion
    fun value(): U8 => 9
primitive ApiVersion10 is ApiVersion
    fun value(): U8 => 10