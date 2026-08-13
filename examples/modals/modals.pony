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
                env.err.print("usage: modals <bot-token> <guild-id>")
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
                            name' = "feedback",
                            description' = "open a form and tell us how it went"
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "feedback" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ModalInteractionCallbackType,
                            data.InteractionCallbackModalParams(
                                "feedback",
                                "How did it go?",
                                _Form()
                            )
                        ),
                        {() => None}
                    )
                | let submission: data.ModalSubmitData =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = "thanks!\n\n"
                                        + _Answers(submission),
                                    flags' =
                                        recover val
                                            [
                                                as data.MessageFlag:
                                                data.EphemeralMessageFlag
                                            ]
                                        end
                            )
                        ),
                        {() => None}
                    )
                end
            }
        )

primitive _Form
    fun apply(): Array[data.Component] val =>
        """
        A modal holds label components, each wrapping one input. Action rows
        around text inputs still work, but Discord has deprecated them.
        """

        recover val
            [
                as data.Component:
                data.LabelComponent(
                    where
                        label' = "Headline",
                        description' = "one line, please",
                        component' =
                            data.TextInputComponent(
                                where
                                    custom_id' = "headline",
                                    style' = data.ShortTextInputStyle,
                                    max_length' = 100,
                                    required' = true,
                                    placeholder' = "it went..."
                            )
                )
                data.LabelComponent(
                    where
                        label' = "Details",
                        component' =
                            data.TextInputComponent(
                                where
                                    custom_id' = "details",
                                    style' = data.ParagraphTextInputStyle,
                                    max_length' = 1000,
                                    required' = false
                            )
                )
            ]
        end

primitive _Answers
    fun apply(submission: data.ModalSubmitData): String =>
        """
        A submitted modal comes back with the same shape it was sent in, with
        each input carrying whatever the user put into it.
        """

        let lines = recover val
            let lines' = Array[String]

            for component in submission.components.values() do
                match component
                | let label: data.LabelComponent =>
                    match label.component
                    | let input: data.TextInputComponent =>
                        let answer =
                            match input.value
                            | let value: String => value
                            else
                                "(blank)"
                            end

                        lines'.push(input.custom_id + ": " + answer)
                    end
                end
            end

            lines'
        end

        "\n".join(lines.values())
