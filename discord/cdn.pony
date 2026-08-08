use "./data"

trait val ImageFormat is _Enum[ImageFormat, String]
    fun extension(): String => "." + value()
primitive ImageFormatJPEG is ImageFormat
    fun value(): String => "jpeg"
primitive ImageFormatPNG is ImageFormat
    fun value(): String => "png"
primitive ImageFormatWEBP is ImageFormat
    fun value(): String => "webp"
primitive ImageFormatGIF is ImageFormat
    fun value(): String => "gif"
primitive ImageFormatLottie is ImageFormat
    fun value(): String => "json"

type ImageSize is (USize | None)
    """
    The width and height to serve an image at, which must be a power of two
    between 16 and 4096. `None` serves the image at its original size.
    """

primitive CDN
    fun emoji(
        id: Snowflake,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/emojis/" + id.string() + format.extension() + _CDNQuery(
            size, animated
        )

    fun guild_icon(
        id: Snowflake,
        icon: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/icons/" + id.string() + "/" + icon + format.extension() + _CDNQuery(
            size, animated
        )

    fun guild_splash(
        id: Snowflake,
        splash: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/splashes/" + id.string() + "/" + splash + format.extension()
        + _CDNQuery(size)

    fun guild_discovery_splash(
        id: Snowflake,
        splash: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/discovery-splashes/" + id.string() + "/" + splash + format.extension()
        + _CDNQuery(size)

    fun guild_banner(
        id: Snowflake,
        banner: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/banners/" + id.string() + "/" + banner + format.extension()
        + _CDNQuery(size, animated)

    fun user_banner(
        id: Snowflake,
        banner: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/banners/" + id.string() + "/" + banner + format.extension()
        + _CDNQuery(size, animated)

    fun default_user_avatar(
        index: Snowflake,
        size: ImageSize = CDNDefaults.size()
    ): String =>
        """
        `index` is `(user_id >> 22) % 6` for users on the new username system,
        or `discriminator % 5` for legacy accounts. Only available as a PNG.
        """
        "/embed/avatars/" + index.string() + ImageFormatPNG.extension()
        + _CDNQuery(size)

    fun user_avatar(
        id: Snowflake,
        avatar: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/avatars/" + id.string() + "/" + avatar + format.extension()
        + _CDNQuery(size, animated)

    fun member_avatar(
        guild_id: Snowflake,
        user_id: Snowflake,
        avatar: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/guilds/" + guild_id.string() + "/users/" + user_id.string()
        + "/avatars/" + avatar + format.extension() + _CDNQuery(size, animated)

    fun avatar_decoration(
        asset: String,
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/avatar-decoration-presets/" + asset + ImageFormatPNG.extension()
        + _CDNQuery(size)

    fun application_icon(
        id: Snowflake,
        icon: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/app-icons/" + id.string() + "/" + icon + format.extension()
        + _CDNQuery(size)

    fun application_cover(
        id: Snowflake,
        cover: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/app-icons/" + id.string() + "/" + cover + format.extension()
        + _CDNQuery(size)

    fun application_asset(
        id: Snowflake,
        asset_id: Snowflake,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/app-assets/" + id.string() + "/" + asset_id.string()
        + format.extension() + _CDNQuery(size)

    fun achievement_icon(
        application_id: Snowflake,
        achievement_id: Snowflake,
        icon: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/app-assets/" + application_id.string() + "/achievements/"
        + achievement_id.string() + "/icons/" + icon + format.extension()
        + _CDNQuery(size)

    fun store_page_asset(
        application_id: Snowflake,
        asset_id: Snowflake,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/app-assets/" + application_id.string() + "/store/" + asset_id.string()
        + format.extension() + _CDNQuery(size)

    fun sticker_pack_banner(
        asset_id: Snowflake,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        // Served from the Discord store application, whose id is a fixed
        // constant.
        store_page_asset(CDNDefaults.discord_store_id(), asset_id, format, size)

    fun team_icon(
        id: Snowflake,
        icon: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/team-icons/" + id.string() + "/" + icon + format.extension()
        + _CDNQuery(size)

    fun sticker(
        id: Snowflake,
        format: (ImageFormatPNG | ImageFormatLottie | ImageFormatGIF),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        """
        GIF stickers are served from `https://media.discordapp.net` rather than
        `base_url()`.
        """
        "/stickers/" + id.string() + format.extension() + _CDNQuery(size)

    fun role_icon(
        id: Snowflake,
        icon: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/role-icons/" + id.string() + "/" + icon + format.extension()
        + _CDNQuery(size)

    fun scheduled_event_cover(
        id: Snowflake,
        cover: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/guild-events/" + id.string() + "/" + cover + format.extension()
        + _CDNQuery(size)

    fun member_banner(
        guild_id: Snowflake,
        user_id: Snowflake,
        banner: String,
        format: (
            ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF
        ),
        size: ImageSize = CDNDefaults.size(),
        animated: Bool = CDNDefaults.animated()
    ): String =>
        "/guilds/" + guild_id.string() + "/users/" + user_id.string()
        + "/banners/" + banner + format.extension() + _CDNQuery(size, animated)

    fun tag_badge(
        guild_id: Snowflake,
        badge: String,
        format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP),
        size: ImageSize = CDNDefaults.size()
    ): String =>
        "/guild-tag-badges/" + guild_id.string() + "/" + badge
        + format.extension() + _CDNQuery(size)

    fun soundboard_sound(id: Snowflake): String =>
        """
        Soundboard sounds are served as MP3 or Ogg rather than as an image, and
        so take neither a format nor a size.
        """
        "/soundboard-sounds/" + id.string()

primitive CDNConstants
    fun base_url(): String => "https://cdn.discordapp.com"

primitive _CDNQuery
    fun apply(size: ImageSize, animated: Bool = false): String =>
        """
        Builds the query string shared by the image endpoints, omitting the
        parameters left at their defaults.
        """

        var query = ""
        match size | let size': USize => query = "?size=" + size'.string() end
        if animated then
            query =
                query + (
                    if query.size() == 0 then "?" else "&" end
                ) + "animated=true"
        end
        query

primitive CDNDefaults
    fun size(): ImageSize => None

    fun animated(): Bool =>
        """
        Whether to serve the animated variant of an asset whose hash begins with
        `a_`. Only meaningful in combination with `ImageFormatWEBP`, since
        `ImageFormatGIF` is animated already.
        """

        false

    fun discord_store_id(): Snowflake =>
        recover Snowflake(710982414301790216) end
