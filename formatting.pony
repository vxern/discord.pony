primitive Formatting
    """
    Discord utilizes a subset of markdown for rendering message content on its clients, while also adding some custom functionality to enable things like mentioning users and channels.
    """

    fun user(id: U64): String => "<@" + id.string() + ">"
        """
        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.

        Example: <@80351110224678912>
        """

    fun member(id: U64): String => "<@!" + id.string() + ">"
        """
        Deprecated: Discord no longer distinguishes `<@!id>` from `<@id>`.
        Use `user` instead.

        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.

        Example: <@!80351110224678912>
        """

    fun channel(id: U64): String => "<#" + id.string() + ">"
        """
        Example: <#103735883630395392>
        """

    fun role(id: U64): String => "<@&" + id.string() + ">"
        """
        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.
        
        Example: <@&165511591545143296>
        """

    fun slash_command(command: String, id: U64): String => "</" + command + ":" + id.string() + ">"
        """
        Example: </airhorn:816437322781949972>

        Example: </foo bar:123456789012345678>

        Example: </foo group bar:123456789012345678>
        """

    fun emoji(name: String, id: U64): String => "<:" + name + ":" + id.string() + ">"
        """
        Standard emoji are currently rendered using Twemoji for Desktop and Android while iOS devices use Apple’s native emoji set.

        Example: <:mmLol:216154654256398347>
        """

    fun animated_emoji(name: String, id: U64): String => "<a:" + name + ":" + id.string() + ">"
        """
        Example: <a:b1nzy:392938283556143104>
        """

    fun timestamp(timestamp_s: U64, style: TimestampStyle val = FormattingDefaults.timestamp_style()): String => "<t:" + timestamp_s.string() + ":" + style.value() + ">"
        """
        Example: <t:1618953630:d>
        """

    fun guild_navigation(id: U64, type': GuildNavigationType val): String => "<" + id.string() + ":" + type'.value() + ">"

primitive FormattingDefaults
    fun timestamp_style(): TimestampStyle val => TimestampStyleLongDateShortTime

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
