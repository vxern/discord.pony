use data = "../../discord/data"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (
            let token: String,
            let guild_id: data.Snowflake,
            let alert_channel_id: data.Snowflake
        ) =
            try
                (
                    env.args(1)?,
                    data.Snowflake(env.args(2)?.u64()?),
                    data.Snowflake(env.args(3)?.u64()?)
                )
            else
                env.err.print(
                    "usage: automod <bot-token> <guild-id> <alert-channel-id>"
                )
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

        routes.create_auto_moderation_rule(
            guild_id,
            data.CreateAutoModerationRuleParams(
                where
                    name' = "no link spam",
                    event_type' = data.MessageSendAutoModerationEventType,
                    trigger_type' = data.KeywordAutoModerationTriggerType,
                    enabled' = true,
                    trigger_metadata' =
                        data.AutoModerationTriggerMetadata(
                            where
                                keyword_filter' =
                                    recover val
                                        ["*free nitro*"; "*steamcommunity*"]
                                    end,
                                regex_patterns' =
                                    recover val
                                        ["discord\\.gg/[a-zA-Z0-9]+"]
                                    end,
                                allow_list' =
                                    recover val ["discord.gg/pony"] end
                        ),
                    actions' =
                        recover val
                            [
                                data.AutoModerationAction(
                                    where
                                        type'' =
                                            data.BlockMessageAutoModerationActionType,
                                        metadata' =
                                            data.AutoModerationActionMetadata(
                                                where
                                                    custom_message' =
                                                        "that link is not welcome here"
                                            )
                                )
                                data.AutoModerationAction(
                                    where
                                        type'' =
                                            data.SendAlertMessageAutoModerationActionType,
                                        metadata' =
                                            data.AutoModerationActionMetadata(
                                                where
                                                    channel_id' =
                                                        alert_channel_id
                                            )
                                )
                                data.AutoModerationAction(
                                    where
                                        type'' =
                                            data.TimeoutAutoModerationActionType,
                                        metadata' =
                                            data.AutoModerationActionMetadata(
                                                where duration_seconds' = 600
                                            )
                                )
                            ]
                        end
            ),
            {(rule: data.AutoModerationRule)(out, routes, guild_id) =>
                out.print("created rule " + rule.id.string())

                routes.get_auto_moderation_rules(
                    guild_id,
                    {(rules: Array[data.AutoModerationRule] val)(out) =>
                        out.print(rules.size().string() + " rule(s) in place")

                        for rule' in rules.values() do
                            out.print(
                                "  " + rule'.name + " -> "
                                + rule'.actions.size().string() + " action(s)"
                            )
                        end
                    }
                )
            },
            "showing off the auto moderation routes"
        )
