use discord = "../../discord"

actor Main
    new create(env: Env) =>
        (let token: String, let channel_id: discord.Snowflake, let content: String) =
            try
                (env.args(1)?, discord.Snowflake(env.args(2)?.u64()?), env.args(3)?)
            else
                env.err.print("usage: send_message <bot-token> <channel-id> <content>")
                env.exitcode(1)
                return
            end

        let bot = discord.Bot(env, discord.RestOptions(token))

        bot.rest.routes.create_message(
            channel_id,
            discord.CreateMessageParams(where content' = content),
            { (message: discord.Message) => env.out.print("sent " + message.id.string()) }
        )
