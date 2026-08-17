use cli = "cli"
use data = "../../discord/data"
use files = "files"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (
            let token: String,
            let guild_id: data.Snowflake,
            let name: String,
            let path: String
        ) =
            try
                (
                    cli.EnvVars(env.vars)("DISCORD_TOKEN")?,
                    data.Snowflake(env.args(1)?.u64()?),
                    env.args(2)?,
                    env.args(3)?
                )
            else
                env.err.print(
                    "usage: DISCORD_TOKEN=<bot-token> guild_stickers "
                    + "<guild-id> <name> <png-path>"
                )
                env.exitcode(1)
                return
            end

        let out = env.out
        let err = env.err

        let upload =
            try
                _Upload(env.root, path)?
            else
                err.print("could not read " + path)
                env.exitcode(1)
                return
            end

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

        routes.create_guild_sticker(
            guild_id,
            data.CreateGuildStickerParams(
                where
                    name' = name,
                    description' = "uploaded by the discord.pony example",
                    tags' = "pony"
            ),
            upload,
            {(sticker: data.Sticker)(out, routes, guild_id) =>
                out.print("uploaded sticker " + sticker.id.string())

                routes.get_guild_stickers(
                    guild_id,
                    {(stickers: Array[data.Sticker] val)(out) =>
                        out.print(
                            stickers.size().string()
                            + " sticker(s) in this guild"
                        )

                        for sticker' in stickers.values() do
                            out.print(
                                "  " + sticker'.name + " -> " + sticker'.tags
                            )
                        end
                    }
                )
            },
            "showing off the sticker routes"
        )

primitive _Upload
    fun apply(auth: AmbientAuth, path: String): rest.FileUpload ? =>
        """
        Unlike an emoji, a sticker is sent as a `multipart/form-data` upload
        alongside the json body, so the raw bytes go over the wire as they are.
        """

        let file =
            match files.OpenFile(files.FilePath(files.FileAuth(auth), path))
            | let opened: files.File => opened
            else
                error
            end

        let bytes: Array[U8] val = file.read(file.size())
        let filename =
            try
                path.substring(path.rfind("/")? + 1)
            else
                path
            end

        rest.FileUpload(filename, bytes, "image/png")
