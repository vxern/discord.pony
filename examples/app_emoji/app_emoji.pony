use base64 = "encode/base64"
use data = "../../discord/data"
use files = "files"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        (let token: String, let name: String, let path: String) =
            try
                (env.args(1)?, env.args(2)?, env.args(3)?)
            else
                env.err.print("usage: app_emoji <bot-token> <name> <png-path>")
                env.exitcode(1)
                return
            end

        let out = env.out
        let err = env.err

        let image =
            try
                _Image(env.root, path)?
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

        routes.get_application(
            {(application: data.Application)(out, routes, name, image) =>
                let application_id = application.id

                routes.create_application_emoji(
                    application_id,
                    data.CreateApplicationEmojiParams(name, image),
                    {(emoji: data.Emoji)(out, routes, application_id) =>
                        out.print(
                            "uploaded "
                            + match emoji.id
                                | let id: data.Snowflake => id.string()
                                else
                                    "an emoji with no id"
                                end
                        )

                        routes.get_application_emojis(
                            application_id,
                            {(emojis: Array[data.Emoji] val)(out) =>
                                out.print(
                                    emojis.size().string()
                                    + " emoji(s) owned by this app"
                                )

                                for emoji' in emojis.values() do
                                    match emoji'.name
                                    | let name': String => out.print("  " + name')
                                    end
                                end
                            }
                        )
                    }
                )
            }
        )

primitive _Image
    fun apply(auth: AmbientAuth, path: String): data.ImageData ? =>
        """
        Discord takes an image inline, as a base64 data uri, rather than as a
        multipart upload. App emoji are capped at 256 KiB.
        """

        let file =
            match files.OpenFile(files.FilePath(files.FileAuth(auth), path))
            | let opened: files.File => opened
            else
                error
            end

        let bytes = file.read(file.size())

        "data:image/png;base64," + base64.Base64.encode(consume bytes)
