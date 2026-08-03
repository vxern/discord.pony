use discord = "../discord"

actor Main
    new create(env: Env) =>
        let token = try env.args(1)? else
            env.err.print("usage: connecting <bot-token>")
            env.exitcode(1)
            return
        end

        let bot = discord.Bot(env, token)

        bot.rest.routes.get_application(
            { (application: discord.Message) => env.out.print("sent " + message.id.string()) }
        )
