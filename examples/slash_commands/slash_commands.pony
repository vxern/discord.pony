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
                    "usage: DISCORD_TOKEN=<bot-token> slash_commands "
                    + "<guild-id>"
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
                routes.bulk_overwrite_guild_application_commands(
                    ready.application.id,
                    guild_id,
                    data.BulkOverwriteGuildApplicationCommandsParams(
                        recover val
                            [
                                data.CreateGuildApplicationCommandParams(
                                    where
                                        name' = "ping",
                                        description' =
                                            "check that the bot is alive"
                                )
                                data.CreateGuildApplicationCommandParams(
                                    where
                                        name' = "echo",
                                        description' = "say something back",
                                        options' =
                                            recover val
                                                [
                                                    data.ApplicationCommandOption(
                                                        where
                                                            type'' =
                                                                data.StringApplicationCommandOptionType,
                                                            name' = "text",
                                                            description' =
                                                                "what to say back",
                                                            required' = true,
                                                            max_length' = 200
                                                    )
                                                ]
                                            end
                                )
                            ]
                        end
                    ),
                    {(commands: Array[data.ApplicationCommand] val)(out) =>
                        out.print(
                            "registered " + commands.size().string()
                            + " command(s)"
                        )
                    }
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(out, routes) =>
                let command =
                    match interaction.data
                    | let command': data.ApplicationCommandData => command'
                    else
                        return
                    end

                let content =
                    match command.name
                    | "ping" => "pong"
                    | "echo" => _Options.string(command, "text")
                    else
                        return
                    end

                routes.create_interaction_response(
                    interaction.id,
                    interaction.token,
                    data.CreateInteractionResponseParams(
                        data.ChannelMessageWithSourceInteractionCallbackType,
                        data.InteractionCallbackMessageParams(
                            where
                                content' = content,
                                allowed_mentions' = data.AllowedMentions.none()
                        )
                    ),
                    {()(out) => out.print("responded")}
                )
            }
        )

primitive _Options
    fun string(command: data.ApplicationCommandData, name: String): String =>
        match command.options
        | let options: Array[data.ApplicationCommandInteractionDataOption] val =>
            for option in options.values() do
                if option.name == name then
                    match option.value
                    | let value: String => return value
                    end
                end
            end
        end

        ""
