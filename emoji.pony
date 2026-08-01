use json = "json"

class val Emoji
    """
    https://docs.discord.com/developers/resources/emoji#emoji-object

    Premium Emoji

        Roles with the integration_id tag being the guild’s guild_subscription integration are considered subscription roles. An emoji cannot have both subscription roles and non-subscription roles. Emojis with subscription roles are considered premium emoji, and count toward a separate limit of 25. Emojis cannot be converted between normal and premium after creation.

    Emoji Formats

        Emoji can be uploaded as JPEG, PNG, GIF, WebP, and AVIF formats. All emoji (regardless of original format) can be served as WebP. We highly recommend that developers use the .webp extension when fetching emoji so they’re rendered as WebP for maximum performance and compatibility. The Discord client uses WebP for all emoji displayed in-app.

        Still WebP emoji can be requested using the .webp file extension. For animated WebP emoji, use the .webp extension with the ?animated=true query parameter.

    Application-Owned Emoji

        An application can own up to 2000 emojis that can only be used by that app. App emojis can be managed using the API with a bot token, or using the app’s settings in the portal. The USE_EXTERNAL_EMOJIS permission is not required to use app emojis. The user field of an app emoji object represents the team member that uploaded the emoji from the app’s settings, or the bot user if uploaded using the API.
    """

    let id: (Snowflake | None)
        """
        emoji id, null for standard (unicode) emoji
        """

    let name: (String | None)
        """
        emoji name, null only in reaction emoji objects
        """

    let roles: (Array[Snowflake] val | None)
        """
        roles allowed to use this emoji
        """

    // TODO(vxern): Restore `user` (user object; the user that created this emoji) once `User` supports JSON conversion.

    let require_colons: (Bool | None)
        """
        whether this emoji must be wrapped in colons
        """

    let managed: (Bool | None)
        """
        whether this emoji is managed
        """

    let animated: (Bool | None)
        """
        whether this emoji is animated
        """

    let available: (Bool | None)
        """
        whether this emoji can be used, may be false due to loss of Server Boosts
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var roles': (Array[Snowflake] val | None) = None
        var require_colons': (Bool | None) = None
        var managed': (Bool | None) = None
        var animated': (Bool | None) = None
        var available': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" =>
                match value | let s: String => id' = Snowflake.from_json(s)? end
            | "name" =>
                match value | let s: String => name' = s end
            | "roles" => roles' = _Snowflakes(value)?
            | "require_colons" => require_colons' = value as Bool
            | "managed" => managed' = value as Bool
            | "animated" => animated' = value as Bool
            | "available" => available' = value as Bool
            end
        end

        id = id'
        name = name'
        roles = roles'
        require_colons = require_colons'
        managed = managed'
        animated = animated'
        available = available'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", match id | let s: Snowflake => s.to_json() end)
            .update("name", name)

        match roles
        | let r: Array[Snowflake] val => obj = obj.update("roles", _Snowflakes.to_json(r))
        end

        match require_colons
        | let b: Bool => obj = obj.update("require_colons", b)
        end

        match managed
        | let b: Bool => obj = obj.update("managed", b)
        end

        match animated
        | let b: Bool => obj = obj.update("animated", b)
        end

        match available
        | let b: Bool => obj = obj.update("available", b)
        end

        obj
