use json = "json"

class val GuildTemplate
    """
    https://docs.discord.com/developers/resources/guild-template#guild-template-object-guild-template-structure

    Represents a code that when used, creates a guild based on a snapshot of an existing guild.
    """

    let code: String
        """
        the template code (unique ID)
        """

    let name: String
        """
        template name
        """

    let description: (String | None)
        """
        the description for the template
        """

    let usage_count: USize
        """
        number of times this template has been used
        """

    let creator_id: Snowflake
        """
        the ID of the user who created the template
        """

    let creator: User
        """
        the user who created the template
        """

    let created_at: ISO8601
        """
        when this template was created
        """

    let updated_at: ISO8601
        """
        when this template was last synced to the source guild
        """

    let source_guild_id: Snowflake
        """
        the ID of the guild this template is based on
        """

    let serialized_source_guild: json.JsonObject
        """
        the guild snapshot this template contains

        The snapshot is a partial guild whose placeholder IDs are given as integers rather than as the strings a `Snowflake` decodes from, so it is left undecoded.
        """

    let is_dirty: (Bool | None)
        """
        whether the template has unsynced changes
        """

    new val from_json(obj: json.JsonObject) ? =>
        var code': (String | None) = None
        var name': (String | None) = None
        var description': (String | None) = None
        var usage_count': (USize | None) = None
        var creator_id': (Snowflake | None) = None
        var creator': (User | None) = None
        var created_at': (ISO8601 | None) = None
        var updated_at': (ISO8601 | None) = None
        var source_guild_id': (Snowflake | None) = None
        var serialized_source_guild': (json.JsonObject | None) = None
        var is_dirty': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "code" => code' = value as String
            | "name" => name' = value as String
            | "description" =>
                match value | let string: String => description' = string end
            | "usage_count" => usage_count' = (value as I64).usize()
            | "creator_id" => creator_id' = Snowflake.from_json(value)?
            | "creator" => creator' = User.from_json(value as json.JsonObject)?
            | "created_at" => created_at' = value as String
            | "updated_at" => updated_at' = value as String
            | "source_guild_id" => source_guild_id' = Snowflake.from_json(value)?
            | "serialized_source_guild" => serialized_source_guild' = value as json.JsonObject
            | "is_dirty" =>
                match value | let bool: Bool => is_dirty' = bool end
            end
        end

        code = code' as String
        name = name' as String
        description = description'
        usage_count = usage_count' as USize
        creator_id = creator_id' as Snowflake
        creator = creator' as User
        created_at = created_at' as ISO8601
        updated_at = updated_at' as ISO8601
        source_guild_id = source_guild_id' as Snowflake
        serialized_source_guild = serialized_source_guild' as json.JsonObject
        is_dirty = is_dirty'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("code", code)
            .update("name", name)
            .update("description", description)
            .update("usage_count", usage_count.i64())
            .update("creator_id", creator_id.to_json())
            .update("creator", creator.to_json())
            .update("created_at", created_at)
            .update("updated_at", updated_at)
            .update("source_guild_id", source_guild_id.to_json())
            .update("serialized_source_guild", serialized_source_guild)

        match is_dirty
        | let is_dirty': Bool => obj = obj.update("is_dirty", is_dirty')
        end

        obj
