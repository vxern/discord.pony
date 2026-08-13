use data = "../../discord/data"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let guild_id: data.Snowflake) =
            try
                (env.args(1)?, data.Snowflake(env.args(2)?.u64()?))
            else
                env.err.print("usage: forums <bot-token> <guild-id>")
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

        routes.create_guild_channel(
            guild_id,
            data.CreateGuildChannelParams(
                where
                    name' = "help",
                    type'' = data.GuildForumChannelType,
                    topic' = "ask questions here, one post per question",
                    default_sort_order' = data.LatestActivitySortOrderType,
                    default_forum_layout' = data.ListViewForumLayoutType,
                    default_reaction_emoji' =
                        data.DefaultReaction(where emoji_name' = "👍"),
                    available_tags' =
                        recover val
                            [
                                data.ForumTagParams(
                                    where name' = "unanswered"
                                )
                                data.ForumTagParams(
                                    where
                                        name' = "answered",
                                        emoji_name' = "✅"
                                )
                                data.ForumTagParams(
                                    where
                                        name' = "announcement",
                                        moderated' = true
                                )
                            ]
                        end
            ),
            {(forum: data.Channel)(out, routes) =>
                out.print("created forum " + forum.id.string())

                routes.start_thread_in_forum_or_media_channel(
                    forum.id,
                    data.StartThreadInForumOrMediaChannelParams(
                        where
                            name' = "how do i read a forum post?",
                            applied_tags' = _Tags(forum, "unanswered"),
                            auto_archive_duration' = 4320,
                            message' =
                                data.ForumThreadMessageParams(
                                    where
                                        content' =
                                            "a forum post is a thread, and its "
                                            + "opening message is the one sent "
                                            + "here"
                                )
                    ),
                    {(post: data.Channel)(out) =>
                        out.print("opened post " + post.id.string())
                    },
                    "showing off the forum routes"
                )
            },
            "showing off the forum routes"
        )

primitive _Tags
    fun apply(forum: data.Channel, name: String): Array[data.Snowflake] val =>
        """
        Tag ids are minted by Discord when the channel is created, so a post can
        only be tagged once the channel has come back.
        """

        recover val
            let ids = Array[data.Snowflake](1)

            match forum.available_tags
            | let tags: Array[data.ForumTag] val =>
                for tag in tags.values() do
                    if tag.name == name then ids.push(tag.id) end
                end
            end

            ids
        end
