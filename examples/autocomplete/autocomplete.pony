use data = "../../discord/data"
use discord = "../../discord"
use gateway = "../../discord/gateway"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let guild_id: data.Snowflake) =
            try
                (env.args(1)?, data.Snowflake(env.args(2)?.u64()?))
            else
                env.err.print("usage: autocomplete <bot-token> <guild-id>")
                env.exitcode(1)
                return
            end

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
            {(ready: data.GatewayReady)(routes, guild_id) =>
                routes.create_guild_application_command(
                    ready.application.id,
                    guild_id,
                    data.CreateGuildApplicationCommandParams(
                        where
                            name' = "language",
                            description' = "look up a programming language",
                            options' =
                                recover val
                                    [
                                        data.ApplicationCommandOption(
                                            where
                                                type'' =
                                                    data.StringApplicationCommandOptionType,
                                                name' = "name",
                                                description' =
                                                    "start typing to search",
                                                required' = true,
                                                autocomplete' = true
                                        )
                                    ]
                                end
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                let command =
                    match interaction.data
                    | let command': data.ApplicationCommandData => command'
                    else
                        return
                    end

                match interaction.type'
                | data.ApplicationCommandAutocompleteInteractionType =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ApplicationCommandAutocompleteResultInteractionCallbackType,
                            data.InteractionCallbackAutocompleteParams(
                                _Languages.matching(_Focused(command))
                            )
                        ),
                        {() => None}
                    )
                | data.ApplicationCommandInteractionType =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = "you chose "
                                        + _Focused.chosen(command)
                            )
                        ),
                        {() => None}
                    )
                end
            }
        )

primitive _Focused
    fun apply(command: data.ApplicationCommandData): String =>
        """
        The text typed so far into whichever option Discord marked as focused.
        """

        match command.options
        | let options: Array[data.ApplicationCommandInteractionDataOption] val =>
            for option in options.values() do
                match option.focused
                | let focused: Bool if focused =>
                    match option.value
                    | let value: String => return value
                    end
                end
            end
        end

        ""

    fun chosen(command: data.ApplicationCommandData): String =>
        match command.options
        | let options: Array[data.ApplicationCommandInteractionDataOption] val =>
            for option in options.values() do
                match option.value
                | let value: String => return value
                end
            end
        end

        ""

primitive _Languages
    fun all(): Array[String] val =>
        recover val
            ["pony"; "rust"; "erlang"; "elixir"; "ocaml"; "zig"; "nim"]
        end

    fun matching(
        prefix: String
    ): Array[data.ApplicationCommandOptionChoice] val =>
        """
        Discord shows at most 25 choices, and does no filtering of its own.
        """

        let lowered: String val = prefix.lower()

        recover val
            let choices = Array[data.ApplicationCommandOptionChoice](25)

            for language in all().values() do
                if choices.size() == 25 then break end

                if language.at(lowered, 0) then
                    choices.push(
                        data.ApplicationCommandOptionChoice(language, language)
                    )
                end
            end

            choices
        end
