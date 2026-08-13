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
                env.err.print("usage: select_menus <bot-token> <guild-id>")
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
                            name' = "menus",
                            description' = "show off every kind of select menu"
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(out, routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "menus" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = "take your pick",
                                    components' = _Menus()
                            )
                        ),
                        {() => None}
                    )
                | let component: data.MessageComponentData =>
                    let picked =
                        match component.values
                        | let values: Array[String] val => ", ".join(
                            values.values()
                        )
                        else
                            "nothing"
                        end

                    out.print(component.custom_id + " -> " + picked)

                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = component.custom_id + " -> "
                                        + picked,
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

primitive _Menus
    fun apply(): Array[data.Component] val =>
        recover val
            [
                as data.Component:
                data.ActionRowComponent(
                    where
                        components' =
                            recover val
                                [
                                    as data.ActionRowChildComponent:
                                    data.StringSelectComponent(
                                        where
                                            custom_id' = "flavour",
                                            placeholder' = "pick up to two",
                                            min_values' = 1,
                                            max_values' = 2,
                                            options' =
                                                recover val
                                                    [
                                                        data.SelectOption(
                                                            where
                                                                label' =
                                                                    "vanilla",
                                                                value' =
                                                                    "vanilla",
                                                                description' =
                                                                    "the safe one"
                                                        )
                                                        data.SelectOption(
                                                            where
                                                                label' =
                                                                    "pistachio",
                                                                value' =
                                                                    "pistachio",
                                                                emoji' =
                                                                    data.Emoji(
                                                                        where
                                                                            name'
                                                                                =
                                                                                "🥜"
                                                                    ),
                                                                default' = true
                                                        )
                                                    ]
                                                end
                                    )
                                ]
                            end
                )
                data.ActionRowComponent(
                    where
                        components' =
                            recover val
                                [
                                    as data.ActionRowChildComponent:
                                    data.UserSelectComponent(
                                        where
                                            custom_id' = "who",
                                            placeholder' = "pick a person"
                                    )
                                ]
                            end
                )
                data.ActionRowComponent(
                    where
                        components' =
                            recover val
                                [
                                    as data.ActionRowChildComponent:
                                    data.ChannelSelectComponent(
                                        where
                                            custom_id' = "where",
                                            placeholder' = "pick a text channel",
                                            channel_types' =
                                                recover val
                                                    [
                                                        as data.ChannelType:
                                                        data.GuildTextChannelType
                                                    ]
                                                end
                                    )
                                ]
                            end
                )
            ]
        end
