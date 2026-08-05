use data = "data"

primitive Formatting
    """
    Discord utilizes a subset of markdown for rendering message content on its clients, while also adding some custom functionality to enable things like mentioning users and channels.
    """

    fun user(id: data.Snowflake): String => "<@" + id.string() + ">"
        """
        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.

        Example: <@80351110224678912>
        """

    fun member(id: data.Snowflake): String => "<@!" + id.string() + ">"
        """
        Deprecated: Discord no longer distinguishes `<@!id>` from `<@id>`.
        Use `user` instead.

        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.

        Example: <@!80351110224678912>
        """

    fun channel(id: data.Snowflake): String => "<#" + id.string() + ">"
        """
        Example: <#103735883630395392>
        """

    fun role(id: data.Snowflake): String => "<@&" + id.string() + ">"
        """
        Using the markdown for users or roles will mention the target(s), and notify them depending on the sender’s permissions as well as the value of the allowed_mentions field when creating a message.
        
        Example: <@&165511591545143296>
        """

    fun slash_command(command: String, id: data.Snowflake): String => "</" + command + ":" + id.string() + ">"
        """
        Example: </airhorn:816437322781949972>

        Example: </foo bar:123456789012345678>

        Example: </foo group bar:123456789012345678>
        """

    fun emoji(name: String, id: data.Snowflake): String => "<:" + name + ":" + id.string() + ">"
        """
        Standard emoji are currently rendered using Twemoji for Desktop and Android while iOS devices use Apple’s native emoji set.

        Example: <:mmLol:216154654256398347>
        """

    fun animated_emoji(name: String, id: data.Snowflake): String => "<a:" + name + ":" + id.string() + ">"
        """
        Example: <a:b1nzy:392938283556143104>
        """

    fun timestamp(timestamp_s: U64, style: TimestampStyle val = FormattingDefaults.timestamp_style()): String => "<t:" + timestamp_s.string() + ":" + style.value() + ">"
        """
        Timestamps are expressed in seconds and display the given timestamp in the user’s timezone and locale.

        Example: <t:1618953630:d>
        """

    fun guild_navigation(id: data.Snowflake, type': GuildNavigationType val): String => "<" + id.string() + ":" + type'.value() + ">"

primitive FormattingDefaults
    fun timestamp_style(): TimestampStyle val => TimestampStyleLongDateShortTime

trait val TimestampStyle is _Enum[TimestampStyle, String]
primitive TimestampStyleShortTime is TimestampStyle
    """
    Example: 16:20
    """

    fun value(): String => "t"
primitive TimestampStyleMediumTime is TimestampStyle
    """
    Example: 16:20:30
    """

    fun value(): String => "T"
primitive TimestampStyleShortDate is TimestampStyle
    """

    Example: 20/04/2021
    """

    fun value(): String => "d"
primitive TimestampStyleLongDate is TimestampStyle
    """
    Example: April 20, 2021
    """

    fun value(): String => "D"
primitive TimestampStyleLongDateShortTime is TimestampStyle
    """
    Example: April 20, 2021 at 16:20
    """

    fun value(): String => "f"
primitive TimestampStyleFullDateShortTime is TimestampStyle
    """
    Example: Tuesday, April 20, 2021 at 16:20
    """

    fun value(): String => "F"
primitive TimestampStyleShortDateShortTime is TimestampStyle
    """
    Example: 20/04/2021, 16:20
    """

    fun value(): String => "s"
primitive TimestampStyleShortDateMediumTime is TimestampStyle
    """
    Example: 20/04/2021, 16:20:30
    """

    fun value(): String => "S"
primitive TimestampStyleRelativeTime is TimestampStyle
    """
    Example: 4 years ago
    """

    fun value(): String => "R"

trait val GuildNavigationType is _Enum[GuildNavigationType, String]
primitive GuildNavigationTypeChannelAndRoles is GuildNavigationType
    """
    Channel & Roles tab with Onboarding prompts
    """

    fun value(): String => "customize"
primitive GuildNavigationTypeBrowseChannels is GuildNavigationType
    """
    Browse Channels tab
    """

    fun value(): String => "browse"
primitive GuildNavigationTypeServerGuide is GuildNavigationType
    """
    Server Guide tab
    """

    fun value(): String => "guide"
primitive GuildNavigationTypeLinkedRoles is GuildNavigationType
    """
    Linked Roles tab
    """

    fun value(): String => "linked-roles"
class GuildNavigationTypeLinkedRolesWithId is GuildNavigationType
    """
    Specific linked role, opening the connection modal on click (the second id is the role id)
    """
    let id: data.Snowflake

    new apply(id': data.Snowflake) => id = id'

    fun value(): String => "linked-roles:" + id.string()
