use data = "../../discord/data"
use discord = "../../discord"
use gateway = "../../discord/gateway"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let channel_id: data.Snowflake) =
            try
                (env.args(1)?, data.Snowflake(env.args(2)?.u64()?))
            else
                env.err.print("usage: polls <bot-token> <channel-id>")
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
                        [
                            as data.GatewayIntent:
                            data.GatewayIntentGuilds
                            data.GatewayIntentGuildMessagePolls
                        ]
                    end
                )
            )
        let routes = bot.rest.routes

        bot.gateway.events.on_ready(
            {(ready: data.GatewayReady)(out, routes, channel_id) =>
                routes.create_message(
                    channel_id,
                    data.CreateMessageParams(
                        where
                            poll' =
                                data.PollParams(
                                    where
                                        question' =
                                            data.PollMedia(
                                                where
                                                    text' =
                                                        "which is the best ml?"
                                            ),
                                        answers' = _Answers(),
                                        duration' = 24,
                                        allow_multiselect' = true
                                )
                    ),
                    {(message: data.Message)(out) =>
                        out.print("poll posted as " + message.id.string())
                    }
                )
            }
        )

        bot.gateway.events.on_message_poll_vote_add(
            {(vote: data.MessagePollVoteAdd)(out, routes) =>
                out.print(
                    "user " + vote.user_id.string() + " voted for answer "
                    + vote.answer_id.string()
                )

                routes.get_answer_voters(
                    vote.channel_id,
                    vote.message_id,
                    data.Snowflake(vote.answer_id.u64()),
                    data.GetAnswerVotersParams(where limit' = 100),
                    {(voters: Array[data.User] val)(out) =>
                        out.print(
                            voters.size().string()
                            + " voter(s) on that answer so far"
                        )
                    }
                )
            }
        )

        bot.gateway.events.on_message_poll_vote_remove(
            {(vote: data.MessagePollVoteRemove)(out) =>
                out.print(
                    "user " + vote.user_id.string() + " took back their vote "
                    + "for answer " + vote.answer_id.string()
                )
            }
        )

primitive _Answers
    fun apply(): Array[data.PollAnswerParams] val =>
        """
        Answers are numbered by Discord in the order they are sent, starting at
        one, and that number is what a vote event carries back.
        """

        recover val
            [
                data.PollAnswerParams(
                    data.PollMedia(
                        where
                            text' = "ocaml",
                            emoji' = data.Emoji(where name' = "🐫")
                    )
                )
                data.PollAnswerParams(
                    data.PollMedia(
                        where
                            text' = "standard ml",
                            emoji' = data.Emoji(where name' = "📜")
                    )
                )
                data.PollAnswerParams(
                    data.PollMedia(where text' = "f#")
                )
            ]
        end
