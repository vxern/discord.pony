use json = "json"

class val Emoji is Jsonable
    """
    https://docs.discord.com/developers/resources/emoji#emoji-object

    Premium Emoji

        Roles with the integration_id tag being the guild’s guild_subscription
        integration are considered subscription roles. An emoji cannot have both
        subscription roles and non-subscription roles. Emojis with subscription
        roles are considered premium emoji, and count toward a separate limit of
        25. Emojis cannot be converted between normal and premium after
        creation.

    Emoji Formats

        Emoji can be uploaded as JPEG, PNG, GIF, WebP, and AVIF formats. All
        emoji (regardless of original format) can be served as WebP. We highly
        recommend that developers use the .webp extension when fetching emoji so
        they’re rendered as WebP for maximum performance and compatibility. The
        Discord client uses WebP for all emoji displayed in-app.

        Still WebP emoji can be requested using the .webp file extension. For
        animated WebP emoji, use the .webp extension with the ?animated=true
        query parameter.

    Application-Owned Emoji

        An application can own up to 2000 emojis that can only be used by that
        app. App emojis can be managed using the API with a bot token, or using
        the app’s settings in the portal. The USE_EXTERNAL_EMOJIS permission is
        not required to use app emojis. The user field of an app emoji object
        represents the team member that uploaded the emoji from the app’s
        settings, or the bot user if uploaded using the API.
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

    let user: (User | None)
        """
        user that created this emoji
        """

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
        whether this emoji can be used, may be false due to loss of Server
        Boosts
        """

    new val create(
        id': (Snowflake | None) = None,
        name': (String | None) = None,
        roles': (Array[Snowflake] val | None) = None,
        user': (User | None) = None,
        require_colons': (Bool | None) = None,
        managed': (Bool | None) = None,
        animated': (Bool | None) = None,
        available': (Bool | None) = None
    ) =>
        id = id'
        name = name'
        roles = roles'
        user = user'
        require_colons = require_colons'
        managed = managed'
        animated = animated'
        available = available'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var roles': (Array[Snowflake] val | None) = None
        var user': (User | None) = None
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
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "require_colons" => require_colons' = value as Bool
            | "managed" => managed' = value as Bool
            | "animated" => animated' = value as Bool
            | "available" => available' = value as Bool
            end
        end

        id = id'
        name = name'
        roles = roles'
        user = user'
        require_colons = require_colons'
        managed = managed'
        animated = animated'
        available = available'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", match id | let s: Snowflake => s.to_json() end)
            .update("name", name)

        match roles
        | let r: Array[Snowflake] val =>
            obj = obj.update("roles", _Snowflakes.to_json(r))
        end

        match user
        | let u: User => obj = obj.update("user", u.to_json())
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

primitive _Emojis
    fun apply(value: json.JsonValue): Array[Emoji] val ? =>
        """
        Decodes an array of emojis.
        """

        let array = value as json.JsonArray
        recover val
            let emojis = Array[Emoji](array.size())
            for emoji in array.values() do
                emojis.push(Emoji.from_json(emoji as json.JsonObject)?)
            end
            emojis
        end

    fun to_json(emojis: Array[Emoji] val): json.JsonArray =>
        var array = json.JsonArray
        for emoji in emojis.values() do array = array.push(emoji.to_json()) end
        array

class val CreateGuildEmojiParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/emoji#create-guild-emoji-json-params

    Emojis and animated emojis have a maximum file size of 256 KiB.
    """

    let name: String
        """
        name of the emoji
        """

    let image: ImageData
        """
        the 128x128 emoji image
        """

    let roles: Array[Snowflake] val
        """
        roles allowed to use this emoji
        """

    new val create(
        name': String,
        image': ImageData,
        roles': Array[Snowflake] val
    ) =>
        name = name'
        image = image'
        roles = roles'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("name", name)
            .update("image", image)
            .update("roles", _Snowflakes.to_json(roles))

class val UpdateGuildEmojiParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/emoji#modify-guild-emoji-json-params

    All parameters to this endpoint are optional.
    """

    let name: (String | None)
        """
        name of the emoji
        """

    let roles: Nullable[Array[Snowflake] val]
        """
        roles allowed to use this emoji
        """

    new val create(
        name': (String | None) = None,
        roles': Nullable[Array[Snowflake] val] = None
    ) =>
        name = name'
        roles = roles'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match roles
        | let roles': Array[Snowflake] val =>
            obj = obj.update("roles", _Snowflakes.to_json(roles'))
        | Null => obj = obj.update("roles", None)
        end

        obj

class val CreateApplicationEmojiParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/emoji#create-application-emoji-json-params

    Emojis and animated emojis have a maximum file size of 256 KiB.
    """

    let name: String
        """
        name of the emoji
        """

    let image: ImageData
        """
        the 128x128 emoji image
        """

    new val create(name': String, image': ImageData) =>
        name = name'
        image = image'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("name", name)
            .update("image", image)

class val UpdateApplicationEmojiParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/emoji#modify-application-emoji-json-params
    """

    let name: String
        """
        name of the emoji
        """

    new val create(name': String) =>
        name = name'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("name", name)
