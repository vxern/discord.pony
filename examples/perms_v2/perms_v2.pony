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
                env.err.print("usage: perms_v2 <bot-token> <guild-id>")
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
                let application_id = ready.application.id

                routes.create_guild_application_command(
                    application_id,
                    guild_id,
                    data.CreateGuildApplicationCommandParams(
                        where
                            name' = "purge",
                            description' = "delete the last few messages",
                            default_member_permissions' =
                                recover val
                                    [
                                        as data.Permission:
                                        data.ManageMessagesPermission
                                        data.ManageGuildPermission
                                    ]
                                end
                    ),
                    {(command: data.ApplicationCommand)
                        (out, routes, guild_id, application_id) =>
                        out.print(
                            "registered " + command.name + " gated behind "
                            + _Names(command.default_member_permissions)
                        )

                        routes.get_guild_application_command_permissions(
                            application_id,
                            guild_id,
                            {(all: Array[data.GuildApplicationCommandPermissions] val)
                                (out) =>
                                out.print(
                                    all.size().string()
                                    + " command(s) in this guild carry an "
                                    + "override"
                                )

                                for permissions in all.values() do
                                    for
                                        permission in permissions
                                            .permissions
                                            .values()
                                    do
                                        out.print(
                                            "  " + permissions.id.string()
                                            + ": " + permission.id.string()
                                            + " -> "
                                            + permission.permission.string()
                                        )
                                    end
                                end
                            }
                        )
                    }
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "purge" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' =
                                        "discord let you through, so you hold "
                                        + "every permission this command asks "
                                        + "for",
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

primitive _Names
    fun apply(permissions: data.Nullable[Array[data.Permission] val]): String =>
        """
        `default_member_permissions` set to `Null` hides a command from everyone
        but administrators; left unset, the command is open to all.
        """

        match permissions
        | let permissions': Array[data.Permission] val =>
            let names = recover val
                let names' = Array[String](permissions'.size())
                for permission in permissions'.values() do
                    names'.push(permission.value().string())
                end
                names'
            end

            "bit(s) " + ", ".join(names.values())
        | data.Null => "administrators only"
        else
            "nothing"
        end
