use collections = "collections"
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
                env.err.print("usage: context_menus <bot-token> <guild-id>")
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
                routes.bulk_overwrite_guild_application_commands(
                    ready.application.id,
                    guild_id,
                    data.BulkOverwriteGuildApplicationCommandsParams(
                        recover val
                            [
                                data.CreateGuildApplicationCommandParams(
                                    where
                                        name' = "Account age",
                                        type'' =
                                            data.UserApplicationCommandType
                                )
                                data.CreateGuildApplicationCommandParams(
                                    where
                                        name' = "Count characters",
                                        type'' =
                                            data.MessageApplicationCommandType
                                )
                            ]
                        end
                    ),
                    {(commands: Array[data.ApplicationCommand] val) => None}
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

                let target =
                    match command.target_id
                    | let target': data.Snowflake => target'
                    else
                        return
                    end

                let resolved =
                    match command.resolved
                    | let resolved': data.ResolvedData => resolved'
                    else
                        return
                    end

                let content =
                    match command.type'
                    | data.UserApplicationCommandType =>
                        _Targets.user(resolved, target)
                    | data.MessageApplicationCommandType =>
                        _Targets.message(resolved, target)
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
            }
        )

primitive _Targets
    fun user(resolved: data.ResolvedData, id: data.Snowflake): String =>
        try
            let target = (resolved.users as collections.Map[
                data.Snowflake, data.User
            ] val)(id)?

            target.username + " joined discord at "
                + id.timestamp().string() + "ms"
        else
            "that user was not resolved"
        end

    fun message(resolved: data.ResolvedData, id: data.Snowflake): String =>
        try
            let target = (resolved.messages as collections.Map[
                data.Snowflake, data.Message
            ] val)(id)?

            target.content.size().string() + " character(s)"
        else
            "that message was not resolved"
        end
