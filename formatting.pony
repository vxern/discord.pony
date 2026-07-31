trait TimestampStyle
    fun value(): String
primitive TimestampStyleShortTime is TimestampStyle
    fun value(): String => "t"
primitive TimestampStyleMediumTime is TimestampStyle
    fun value(): String => "T"
primitive TimestampStyleShortDate is TimestampStyle
    fun value(): String => "d"
primitive TimestampStyleLongDate is TimestampStyle
    fun value(): String => "D"
primitive TimestampStyleLongDateShortTime is TimestampStyle
    fun value(): String => "f"
primitive TimestampStyleFullDateShortTime is TimestampStyle
    fun value(): String => "F"
primitive TimestampStyleShortDateShortTime is TimestampStyle
    fun value(): String => "s"
primitive TimestampStyleShortDateMediumTime is TimestampStyle
    fun value(): String => "S"
primitive TimestampStyleRelativeTime is TimestampStyle
    fun value(): String => "R"

trait GuildNavigationType
    fun value(): String
primitive GuildNavigationTypeChannelAndRoles is GuildNavigationType
    fun value(): String => "customize"
primitive GuildNavigationTypeBrowseChannels is GuildNavigationType
    fun value(): String => "browse"
primitive GuildNavigationTypeServerGuide is GuildNavigationType
    fun value(): String => "guide"
primitive GuildNavigationTypeLinkedRoles is GuildNavigationType
    fun value(): String => "linked-roles"
class GuildNavigationTypeLinkedRolesWithId is GuildNavigationType
    let id: U64

    new apply(id': U64) => id = id'

    fun value(): String => "linked-roles:" + id.string()

primitive Formatting
    fun user(id: U64): String => "<@" + id.string() + ">"

    """
    Deprecated: Discord no longer distinguishes `<@!id>` from `<@id>`.
    Use `user` instead.
    """
    fun member(id: U64): String => "<@!" + id.string() + ">"

    fun channel(id: U64): String => "<#" + id.string() + ">"

    fun role(id: U64): String => "<@&" + id.string() + ">"

    fun slash_command(command: String, id: U64): String => "</" + command + ":" + id.string() + ">"

    fun emoji(name: String, id: U64): String => "<:" + name + ":" + id.string() + ">"

    fun animated_emoji(name: String, id: U64): String => "<a:" + name + ":" + id.string() + ">"

    fun timestamp(timestamp_ms: U64, style: TimestampStyle val = FormattingDefaults.timestamp_style()): String => "<t:" + timestamp_ms.string() + ":" + style.value() + ">"

    fun guild_navigation(id: U64, type': GuildNavigationType val): String => "<" + id.string() + ":" + type'.value() + ">"

primitive FormattingDefaults
    fun timestamp_style(): TimestampStyle val => TimestampStyleLongDateShortTime
