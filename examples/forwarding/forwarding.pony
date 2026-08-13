use data = "../../discord/data"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (
            let token: String,
            let from_channel_id: data.Snowflake,
            let message_id: data.Snowflake,
            let to_channel_id: data.Snowflake
        ) =
            try
                (
                    env.args(1)?,
                    data.Snowflake(env.args(2)?.u64()?),
                    data.Snowflake(env.args(3)?.u64()?),
                    data.Snowflake(env.args(4)?.u64()?)
                )
            else
                env.err.print(
                    "usage: forwarding <bot-token> <from-channel-id> "
                    + "<message-id> <to-channel-id>"
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

        client.routes.create_message(
            to_channel_id,
            data.CreateMessageParams(
                where
                    content' = "look at this",
                    message_reference' =
                        data.MessageReference(
                            where
                                type'' = data.ForwardMessageReferenceType,
                                message_id' = message_id,
                                channel_id' = from_channel_id
                        )
            ),
            {(message: data.Message)(out) =>
                out.print("forwarded as " + message.id.string())
                out.print(_Snapshot(message))
            }
        )

primitive _Snapshot
    fun apply(message: data.Message): String =>
        """
        A forward carries no content of its own. What it shows is a snapshot of
        the message it points at, frozen at the moment it was forwarded, and a
        reply would carry `referenced_message` in its place.
        """

        match message.message_snapshots
        | let snapshots: Array[data.MessageSnapshot] val =>
            try
                let forwarded = snapshots(0)?

                "it snapshots " + forwarded.content.size().string()
                    + " character(s) and "
                    + forwarded.attachments.size().string() + " attachment(s)"
            else
                "it snapshots nothing"
            end
        else
            "discord sent back no snapshot"
        end
