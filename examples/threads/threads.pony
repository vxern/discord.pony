use data = "../../discord/data"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let channel_id: data.Snowflake) =
            try
                (env.args(1)?, data.Snowflake(env.args(2)?.u64()?))
            else
                env.err.print("usage: threads <bot-token> <channel-id>")
                env.exitcode(1)
                return
            end

        let out = env.out
        let err = env.err
        let client =
            rest.Rest(
                env,
                rest.RestOptions(
                    where
                        token' = token,
                        on_error' =
                            {(error: rest.RestError)(err) =>
                                err.print(error.string())
                            }
                )
            )
        let routes = client.routes

        routes.start_thread_without_message(
            channel_id,
            data.StartThreadWithoutMessageParams(
                where
                    name' = "a thread about threads",
                    type'' = data.PublicThreadChannelType,
                    auto_archive_duration' = 1440,
                    rate_limit_per_user' = 5
            ),
            {(thread: data.Channel)(out, routes, channel_id) =>
                out.print("opened thread " + thread.id.string())

                routes.create_message(
                    thread.id,
                    data.CreateMessageParams(
                        where content' = "first post in the new thread"
                    ),
                    {(message: data.Message)(out, routes, channel_id) =>
                        out.print("posted " + message.id.string())

                        routes.get_public_archived_threads(
                            channel_id,
                            data.GetPublicArchivedThreadsParams(
                                where limit' = 10
                            ),
                            {(page: data.ArchivedThreads)(out) =>
                                out.print(
                                    page.threads.size().string()
                                    + " archived thread(s), more to fetch: "
                                    + page.has_more.string()
                                )

                                for archived in page.threads.values() do
                                    out.print(
                                        "  "
                                        + match archived.name
                                            | let name: String => name
                                            else
                                                archived.id.string()
                                            end
                                    )
                                end
                            }
                        )
                    }
                )
            },
            "showing off the thread routes"
        )
