use cli = "cli"
use data = "../../discord/data"
use discord = "../../discord"
use gateway = "../../discord/gateway"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        let token =
            try
                cli.EnvVars(env.vars)("DISCORD_TOKEN")?
            else
                env.err.print("usage: DISCORD_TOKEN=<bot-token> user_apps")
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
            {(ready: data.GatewayReady)(routes) =>
                routes.create_global_application_command(
                    ready.application.id,
                    data.CreateGlobalApplicationCommandParams(
                        where
                            name' = "whereami",
                            description' = "report where this command was run",
                            integration_types' =
                                recover val
                                    [
                                        as data.ApplicationIntegrationType:
                                        data.GuildInstallApplicationIntegrationType
                                        data.UserInstallApplicationIntegrationType
                                    ]
                                end,
                            contexts' =
                                recover val
                                    [
                                        as data.InteractionContextType:
                                        data.GuildInteractionContextType
                                        data.BotDMInteractionContextType
                                        data.PrivateChannelInteractionContextType
                                    ]
                                end
                    ),
                    {(command: data.ApplicationCommand) => None}
                )
            }
        )

        bot.gateway.events.on_interaction_create(
            {(interaction: data.Interaction)(routes) =>
                match interaction.data
                | let command: data.ApplicationCommandData
                if command.name == "whereami" =>
                    routes.create_interaction_response(
                        interaction.id,
                        interaction.token,
                        data.CreateInteractionResponseParams(
                            data.ChannelMessageWithSourceInteractionCallbackType,
                            data.InteractionCallbackMessageParams(
                                where
                                    content' = _Where(interaction),
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

primitive _Where
    fun apply(interaction: data.Interaction): String =>
        """
        A user-installed command runs anywhere its installer can see, including
        guilds the bot is not a member of, so `context` is what says where a
        given invocation actually landed.
        """

        let context =
            match interaction.context
            | data.GuildInteractionContextType => "in a guild"
            | data.BotDMInteractionContextType => "in a dm with me"
            | data.PrivateChannelInteractionContextType =>
                "in someone else's dm or group dm"
            else
                "somewhere discord did not name"
            end

        context + ", authorised by " + _Owners(interaction)

primitive _Owners
    fun apply(interaction: data.Interaction): String =>
        """
        `authorizing_integration_owners` names the guild that installed the app
        under the guild key, and the user that installed it under the user key.
        """

        let owners = interaction.authorizing_integration_owners

        let guild =
            try
                "guild " + owners(data.GuildInstallApplicationIntegrationType)?
                    .string()
            else
                "no guild"
            end

        let user =
            try
                "user " + owners(data.UserInstallApplicationIntegrationType)?
                    .string()
            else
                "no user"
            end

        guild + " and " + user
