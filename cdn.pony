use collections = "collections"

trait val ImageFormat is (collections.Hashable & Equatable[ImageFormat])
    fun value(): String

    fun extension(): String => "." + value()
    fun hash(): USize => value().hash()
    fun eq(that: ImageFormat): Bool => value() == that.value()
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

primitive CDN
    fun base_url(): String => "https://cdn.discordapp.com"

    fun emoji(id: U64, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/emojis/" + id.string() + format.extension()

    fun guild_icon(id: U64, icon: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/icons/" + id.string() + "/" + icon + format.extension()

    fun guild_splash(id: U64, splash: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/splashes/" + id.string() + "/" + splash + format.extension()

    fun guild_discovery_splash(id: U64, splash: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/discovery-splashes/" + id.string() + "/" + splash + format.extension()

    fun guild_banner(id: U64, banner: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/banners/" + id.string() + "/" + banner + format.extension()

    fun user_banner(id: U64, banner: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/banners/" + id.string() + "/" + banner + format.extension()

    fun default_user_avatar(index: U64): String =>
        """
        `index` is `(user_id >> 22) % 6` for users on the new username system, or
        `discriminator % 5` for legacy accounts. Only available as a PNG.
        """
        "/embed/avatars/" + index.string() + ImageFormatPNG.extension()

    fun user_avatar(id: U64, avatar: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/avatars/" + id.string() + "/" + avatar + format.extension()

    fun member_avatar(guild_id: U64, user_id: U64, avatar: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/guilds/" + guild_id.string() + "/users/" + user_id.string() + "/avatars/" + avatar + format.extension()

    fun avatar_decoration(asset: String): String => "/avatar-decoration-presets/" + asset + ImageFormatPNG.extension()

    fun application_icon(id: U64, icon: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/app-icons/" + id.string() + "/" + icon + format.extension()

    fun application_cover(id: U64, cover: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/app-icons/" + id.string() + "/" + cover + format.extension()

    fun application_asset(id: U64, asset_id: U64, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/app-assets/" + id.string() + "/" + asset_id.string() + format.extension()

    fun achievement_icon(application_id: U64, achievement_id: U64, icon: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/app-assets/" + application_id.string() + "/achievements/" + achievement_id.string() + "/icons/" + icon + format.extension()

    fun store_page_asset(application_id: U64, asset_id: U64, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/app-assets/" + application_id.string() + "/store/" + asset_id.string() + format.extension()

    fun sticker_pack_banner(asset_id: U64, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String =>
        // Served from the Discord store application, whose id is a fixed constant.
        store_page_asset(discord_store_id(), asset_id, format)

    fun team_icon(id: U64, icon: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/team-icons/" + id.string() + "/" + icon + format.extension()

    fun sticker(id: U64, format: (ImageFormatPNG | ImageFormatLottie | ImageFormatGIF)): String =>
        """
        GIF stickers are served from `https://media.discordapp.net` rather than
        `base_url()`.
        """
        "/stickers/" + id.string() + format.extension()

    fun role_icon(id: U64, icon: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/role-icons/" + id.string() + "/" + icon + format.extension()

    fun scheduled_event_cover(id: U64, cover: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/guild-events/" + id.string() + "/" + cover + format.extension()

    fun member_banner(guild_id: U64, user_id: U64, banner: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP | ImageFormatGIF)): String => "/guilds/" + guild_id.string() + "/users/" + user_id.string() + "/banners/" + banner + format.extension()

    fun tag_badge(guild_id: U64, badge: String, format: (ImageFormatPNG | ImageFormatJPEG | ImageFormatWEBP)): String => "/guild-tag-badges/" + guild_id.string() + "/" + badge + format.extension()

    fun discord_store_id(): U64 => 710982414301790216
