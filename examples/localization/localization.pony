use cli = "cli"
use collections = "collections"
use data = "../../discord/data"
use discord = "../../discord"
use gateway = "../../discord/gateway"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let guild_id: data.Snowflake) =
            try
                (
                    cli.EnvVars(env.vars)("DISCORD_TOKEN")?,
                    data.Snowflake(env.args(1)?.u64()?)
                )
            else
                env.err.print(
                    "usage: DISCORD_TOKEN=<bot-token> localization <guild-id>"
                )
                env.exitcode(1)
                return
            end

        let out = env.out
        let bot =
            discord.Bot(
                env,
                rest.RestOptions(token),
                gateway.GatewayOptions(
                    token,
                    recover val
                        [as data.GatewayIntent: data.GatewayIntentGuilds]
                    end
                )
            )
        let routes = bot.rest.routes

        bot.gateway.events.on_ready(
            {(ready: data.GatewayReady)(out, routes, guild_id) =>
                routes.create_guild_application_command(
                    ready.application.id,
                    guild_id,
                    data.CreateGuildApplicationCommandParams(
                        where
                            name' = "greet",
                            name_localizations' =
                                _Names(
                                    where
                                        polish = "przywitaj",
                                        german = "gruesse",
                                        japanese = "あいさつ"
                                ),
                            description' = "say hello",
                            description_localizations' =
                                _Names(
                                    where
                                        polish = "powiedz cześć",
                                        german = "sag hallo",
                                        japanese = "こんにちはと言う"
                                )
                    ),
                    {(command: data.ApplicationCommand)(out) =>
                        out.print("registered " + command.name)
                    }
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "greet" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where content' = _Greeting(interaction.locale)
                            )
                        ),
                        {() => None}
                    )
                end
            }
        )

primitive _Names
    fun apply(
        polish: String,
        german: String,
        japanese: String
    ): collections.Map[data.Locale, String] val =>
        """
        Discord falls back to the unlocalised `name` for any locale left out of
        the dictionary, so a partial set is fine.
        """

        recover val
            let names = collections.Map[data.Locale, String](3)
            names(data.LocalePolish) = polish
            names(data.LocaleGerman) = german
            names(data.LocaleJapanese) = japanese
            names
        end

primitive _Greeting
    fun apply(locale: (data.Locale | None)): String =>
        """
        `locale` is the language the invoking user has their client set to, and
        `guild_locale` is the guild's own. Neither is guaranteed to be present.
        """

        match locale
        | data.LocalePolish => "cześć!"
        | data.LocaleGerman => "hallo!"
        | data.LocaleJapanese => "こんにちは!"
        else
            "hello!"
        end
