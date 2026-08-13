use data = "../../discord/data"
use rest = "../../discord/rest"
use time = "time"

actor Main
    new create(env: Env) =>
        (
            let token: String,
            let guild_id: data.Snowflake,
            let user_id: data.Snowflake,
            let minutes: I64
        ) =
            try
                (
                    env.args(1)?,
                    data.Snowflake(env.args(2)?.u64()?),
                    data.Snowflake(env.args(3)?.u64()?),
                    env.args(4)?.i64()?
                )
            else
                env.err.print(
                    "usage: timeouts <bot-token> <guild-id> <user-id> "
                    + "<minutes, or 0 to lift>"
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
                            {(error': rest.RestError)(err) =>
                                err.print(error'.string())
                            }
                )
            )

        let deadline =
            if minutes == 0 then
                data.Null
            else
                try
                    _Until(minutes)?
                else
                    err.print("could not format the timestamp")
                    env.exitcode(1)
                    return
                end
            end

        client.routes.update_guild_member(
            guild_id,
            user_id,
            data.UpdateGuildMemberParams(
                where communication_disabled_until' = deadline
            ),
            {(member: data.GuildMember)(out) =>
                match member.communication_disabled_until
                | let at: data.ISO8601 => out.print("timed out until " + at)
                else
                    out.print("timeout lifted")
                end
            },
            "showing off the timeout route"
        )

primitive _Until
    fun apply(minutes: I64): data.ISO8601 ? =>
        """
        A timeout is an absolute UTC instant on the member, capped by Discord at
        28 days out. Passing `Null` instead clears it.
        """

        time.PosixDate(time.Time.seconds() + (minutes * 60))
            .format("%Y-%m-%dT%H:%M:%S+00:00")?
