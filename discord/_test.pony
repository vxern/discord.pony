use "pony_test"
use json = "json"
use data = "./data"

actor Main is TestList
    new create(env: Env) => PonyTest(env, this)

    new make() => None

    fun tag tests(test: PonyTest) =>
        test(_TestFormattingMentions)
        test(_TestFormattingCommandsAndEmoji)
        test(_TestFormattingTimestamp)
        test(_TestFormattingGuildNavigation)
        test(_TestPermissionRoundTrip)

class iso _TestFormattingMentions is UnitTest
    fun name(): String => "formatting/mentions"

    fun apply(h: TestHelper) =>
        let id = data.Snowflake(80351110224678912)
        h.assert_eq[String]("<@80351110224678912>", Formatting.user(id))
        h.assert_eq[String]("<@!80351110224678912>", Formatting.member(id))
        h.assert_eq[String]("<#80351110224678912>", Formatting.channel(id))
        h.assert_eq[String]("<@&80351110224678912>", Formatting.role(id))

class iso _TestFormattingCommandsAndEmoji is UnitTest
    fun name(): String => "formatting/commands_and_emoji"

    fun apply(h: TestHelper) =>
        let id = data.Snowflake(816437322781949972)
        h.assert_eq[String](
            "</airhorn:816437322781949972>",
            Formatting.slash_command("airhorn", id)
        )
        h.assert_eq[String](
            "</foo bar:816437322781949972>",
            Formatting.slash_command("foo bar", id)
        )
        h.assert_eq[String](
            "<:mmLol:816437322781949972>",
            Formatting.emoji("mmLol", id)
        )
        h.assert_eq[String](
            "<a:b1nzy:816437322781949972>",
            Formatting.animated_emoji("b1nzy", id)
        )

class iso _TestFormattingTimestamp is UnitTest
    fun name(): String => "formatting/timestamp"

    fun apply(h: TestHelper) =>
        h.assert_eq[String](
            "<t:1618953630:f>",
            Formatting.timestamp(1618953630)
        )
        h.assert_eq[String](
            "<t:1618953630:d>",
            Formatting.timestamp(1618953630, TimestampStyleShortDate)
        )

class iso _TestFormattingGuildNavigation is UnitTest
    fun name(): String => "formatting/guild_navigation"

    fun apply(h: TestHelper) =>
        let id = data.Snowflake(103735883630395392)
        h.assert_eq[String](
            "<103735883630395392:browse>",
            Formatting.guild_navigation(id, GuildNavigationTypeBrowseChannels)
        )
        h.assert_eq[String](
            "<103735883630395392:linked-roles:103735883630395392>",
            Formatting.guild_navigation(
                id,
                GuildNavigationTypeLinkedRolesWithId(id)
            )
        )

class iso _TestPermissionRoundTrip is UnitTest
    fun name(): String => "data/permission_round_trip"

    fun apply(h: TestHelper) ? =>
        let bit_sets =
            [
                "0"
                "8"
                "140737488355328"
                "9223372036854775808"
                "18446744073709551615"
            ]

        for bits in bit_sets.values() do
            let overwrite =
                data.PermissionOverwrite.from_json(
                    json.JsonObject
                        .update("id", "80351110224678912")
                        .update("type", I64(0))
                        .update("allow", bits)
                        .update("deny", bits)
                )?
            let obj = overwrite.to_json()
            h.assert_eq[String](bits, obj("allow")? as String)
            h.assert_eq[String](bits, obj("deny")? as String)
        end
