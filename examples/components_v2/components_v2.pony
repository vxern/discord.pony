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
                    "usage: DISCORD_TOKEN=<bot-token> components_v2 <guild-id>"
                )
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
                            name' = "showcase",
                            description' = "lay a message out with components v2"
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "showcase" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    components' = _Showcase(),
                                    flags' =
                                        recover val
                                            [
                                                as data.MessageFlag:
                                                data.IsComponentsV2MessageFlag
                                            ]
                                        end
                            )
                        ),
                        {() => None}
                    )
                end
            }
        )

primitive _Showcase
    fun apply(): Array[data.Component] val =>
        """
        With `IS_COMPONENTS_V2` set, a message carries no `content` and no
        `embeds`: everything it shows is a component, laid out top to bottom.
        """

        recover val
            [
                as data.Component:
                data.ContainerComponent(
                    where
                        accent_color' = 0x5865F2,
                        components' =
                            recover val
                                [
                                    as data.ContainerChildComponent:
                                    data.SectionComponent(
                                        where
                                            components' =
                                                recover val
                                                    [
                                                        data.TextDisplayComponent(
                                                            where
                                                                content' =
                                                                    "## discord.pony\nA complete, documented and battle-tested Pony library for working with Discord's API."
                                                        )
                                                    ]
                                                end,
                                            accessory' =
                                                data.ThumbnailComponent(
                                                    where
                                                        media' =
                                                            data.UnfurledMediaItem(
                                                                "https://avatars.githubusercontent.com/u/12655483"
                                                            ),
                                                        description' =
                                                            "the pony logo"
                                                )
                                    )
                                    data.SeparatorComponent(
                                        where
                                            divider' = true,
                                            spacing' =
                                                data.LargeSeparatorSpacingSize
                                    )
                                    data.TextDisplayComponent(
                                        where
                                            content' =
                                                "-# rendered entirely out of components"
                                    )
                                    data.ActionRowComponent(
                                        where
                                            components' =
                                                recover val
                                                    [
                                                        as data.ActionRowChildComponent:
                                                        data.ButtonComponent(
                                                            where
                                                                style' =
                                                                    data.LinkButtonStyle,
                                                                label' =
                                                                    "source",
                                                                url' =
                                                                    "https://github.com/vxern/discord.pony"
                                                        )
                                                    ]
                                                end
                                    )
                                ]
                            end
                )
            ]
        end
