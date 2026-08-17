use cli = "cli"
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
                    "usage: DISCORD_TOKEN=<bot-token> buttons <guild-id>"
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
            {(ready: data.GatewayReady)(routes, guild_id) =>
                routes.create_guild_application_command(
                    ready.application.id,
                    guild_id,
                    data.CreateGuildApplicationCommandParams(
                        where
                            name' = "buttons",
                            description' = "show off a row of buttons"
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(out, routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "buttons" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = "pick one",
                                    components' = _Buttons(false)
                            )
                        ),
                        {() => None}
                    )
                | let component: data.MessageComponentData =>
                    out.print("pressed " + component.custom_id)

                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.UpdateMessageInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = "you picked "
                                        + component.custom_id,
                                    components' = _Buttons(true)
                            )
                        ),
                        {() => None}
                    )
                end
            }
        )

primitive _Buttons
    fun apply(disabled: Bool): Array[data.Component] val =>
        recover val
            [
                as data.Component:
                data.ActionRowComponent(
                    where
                        components' =
                            recover val
                                [
                                    as data.ActionRowChildComponent:
                                    data.ButtonComponent(
                                        where
                                            style' = data.PrimaryButtonStyle,
                                            label' = "yes",
                                            custom_id' = "yes",
                                            disabled' = disabled
                                    )
                                    data.ButtonComponent(
                                        where
                                            style' = data.DangerButtonStyle,
                                            label' = "no",
                                            emoji' =
                                                data.Emoji(where name' = "🙅"),
                                            custom_id' = "no",
                                            disabled' = disabled
                                    )
                                    data.ButtonComponent(
                                        where
                                            style' = data.LinkButtonStyle,
                                            label' = "docs",
                                            url' =
                                                "https://docs.discord.com/developers/components/reference"
                                    )
                                ]
                            end
                )
            ]
        end
