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
primitive ApiVersions
    fun from(value: U8): ApiVersion ? =>
        match value
        | 6 => ApiVersion6
        | 7 => ApiVersion7
        | 8 => ApiVersion8
        | 9 => ApiVersion9
        | 10 => ApiVersion10
        else error
        end
