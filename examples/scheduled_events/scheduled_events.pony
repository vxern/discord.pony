use data = "../../discord/data"
use rest = "../../discord/rest"
use time = "time"

actor Main
    new create(env: Env) =>
        (let token: String, let guild_id: data.Snowflake) =
            try
                (env.args(1)?, data.Snowflake(env.args(2)?.u64()?))
            else
                env.err.print("usage: scheduled_events <bot-token> <guild-id>")
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
                            {(error': rest.RestError)(err) =>
                                err.print(error'.string())
                            }
                )
            )
        let routes = client.routes

        (let starts_at: data.ISO8601, let ends_at: data.ISO8601) =
            try
                (_In(24)?, _In(26)?)
            else
                err.print("could not format the timestamps")
                env.exitcode(1)
                return
            end

        routes.create_guild_scheduled_event(
            guild_id,
            data.CreateGuildScheduledEventParams(
                where
                    name' = "pony meetup",
                    description' = "two hours of talking about capabilities",
                    privacy_level' =
                        data.GuildOnlyGuildScheduledEventPrivacyLevel,
                    entity_type' = data.ExternalGuildScheduledEventEntityType,
                    scheduled_start_time' = starts_at,
                    scheduled_end_time' = ends_at,
                    entity_metadata' =
                        data.GuildScheduledEventEntityMetadata(
                            where location' = "https://example.invalid/meetup"
                        ),
                    recurrence_rule' =
                        data.GuildScheduledEventRecurrenceRule(
                            where
                                start' = starts_at,
                                frequency' =
                                    data.WeeklyGuildScheduledEventRecurrenceRuleFrequency,
                                interval' = 1,
                                by_weekday' =
                                    recover val
                                        [
                                            as data.GuildScheduledEventRecurrenceRuleWeekday:
                                            data.WednesdayGuildScheduledEventRecurrenceRuleWeekday
                                        ]
                                    end
                        )
            ),
            {(event: data.GuildScheduledEvent)(out, routes, guild_id) =>
                out.print("created event " + event.id.string())

                routes.get_guild_scheduled_events(
                    guild_id,
                    data.GetGuildScheduledEventsParams(
                        where with_user_count' = true
                    ),
                    {(events: Array[data.GuildScheduledEvent] val)(out) =>
                        out.print(events.size().string() + " event(s) upcoming")

                        for event' in events.values() do
                            out.print(
                                "  " + event'.name + " at "
                                + event'.scheduled_start_time
                            )
                        end
                    }
                )
            },
            "showing off the scheduled event routes"
        )

primitive _In
    fun apply(hours: I64): data.ISO8601 ? =>
        time.PosixDate(time.Time.seconds() + (hours * 3600))
            .format("%Y-%m-%dT%H:%M:%S+00:00")?
