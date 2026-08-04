use collections = "collections"
use json = "json"

class val Sticker is Jsonable
    """
    https://docs.discord.com/developers/resources/sticker#sticker-object-sticker-structure

    Represents a sticker that can be sent in messages.
    """

    let id: Snowflake
        """
        id of the sticker
        """

    let pack_id: (Snowflake | None)
        """
        for standard stickers, id of the pack the sticker is from
        """

    let name: String
        """
        name of the sticker
        """

    let description: (String | None)
        """
        description of the sticker
        """

    let tags: String
        """
        autocomplete/suggestion tags for the sticker (max 200 characters)

        A comma separated list of keywords. This is the only field required for guild stickers, and Discord will use the name as the value.
        """

    let type': StickerType
        """
        type of sticker
        """

    let format_type: StickerFormatType
        """
        type of sticker format
        """

    let available: (Bool | None)
        """
        whether this guild sticker can be used, may be false due to loss of Server Boosts
        """

    let guild_id: (Snowflake | None)
        """
        id of the guild that owns this sticker
        """

    let user: (User | None)
        """
        the user that uploaded the guild sticker
        """

    let sort_value: (USize | None)
        """
        the standard sticker's sort order within its pack
        """

    new val create(
        id': Snowflake,
        pack_id': (Snowflake | None) = None,
        name': String,
        description': (String | None) = None,
        tags': String,
        type'': StickerType,
        format_type': StickerFormatType,
        available': (Bool | None) = None,
        guild_id': (Snowflake | None) = None,
        user': (User | None) = None,
        sort_value': (USize | None) = None
    ) =>
        id = id'
        pack_id = pack_id'
        name = name'
        description = description'
        tags = tags'
        type' = type''
        format_type = format_type'
        available = available'
        guild_id = guild_id'
        user = user'
        sort_value = sort_value'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var pack_id': (Snowflake | None) = None
        var name': (String | None) = None
        var description': (String | None) = None
        var tags': (String | None) = None
        var type'': (StickerType | None) = None
        var format_type': (StickerFormatType | None) = None
        var available': (Bool | None) = None
        var guild_id': (Snowflake | None) = None
        var user': (User | None) = None
        var sort_value': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "pack_id" => pack_id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "description" =>
                match value | let string: String => description' = string end
            | "tags" => tags' = value as String
            | "type" => type'' = StickerTypes.from((value as I64).u8())?
            | "format_type" => format_type' = StickerFormatTypes.from((value as I64).u8())?
            | "available" => available' = value as Bool
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "sort_value" => sort_value' = (value as I64).usize()
            end
        end

        id = id' as Snowflake
        pack_id = pack_id'
        name = name' as String
        description = description'
        tags = tags' as String
        type' = type'' as StickerType
        format_type = format_type' as StickerFormatType
        available = available'
        guild_id = guild_id'
        user = user'
        sort_value = sort_value'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("description", description)
            .update("tags", tags)
            .update("type", type'.value().i64())
            .update("format_type", format_type.value().i64())

        match pack_id
        | let pack_id': Snowflake => obj = obj.update("pack_id", pack_id'.to_json())
        end

        match available
        | let available': Bool => obj = obj.update("available", available')
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match sort_value
        | let sort_value': USize => obj = obj.update("sort_value", sort_value'.i64())
        end

        obj

primitive _Stickers
    fun apply(value: json.JsonValue): Array[Sticker] val ? =>
        """
        Decodes an array of stickers.
        """

        let array = value as json.JsonArray
        recover val
            let stickers = Array[Sticker](array.size())
            for sticker in array.values() do stickers.push(Sticker.from_json(sticker as json.JsonObject)?) end
            stickers
        end

    fun to_json(stickers: Array[Sticker] val): json.JsonArray =>
        var array = json.JsonArray
        for sticker in stickers.values() do array = array.push(sticker.to_json()) end
        array

trait val StickerType is (collections.Hashable & Equatable[StickerType])
    """
    https://docs.discord.com/developers/resources/sticker#sticker-object-sticker-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: StickerType): Bool => value() == that.value()
primitive StandardStickerType is StickerType
    """
    an official sticker in a pack
    """

    fun value(): U8 => 1
primitive GuildStickerType is StickerType
    """
    a sticker uploaded to a guild for the guild's members
    """

    fun value(): U8 => 2
primitive StickerTypes
    fun from(value: U8): StickerType ? =>
        match value
        | 1 => StandardStickerType
        | 2 => GuildStickerType
        else error
        end

trait val StickerFormatType is (collections.Hashable & Equatable[StickerFormatType])
    """
    https://docs.discord.com/developers/resources/sticker#sticker-object-sticker-format-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: StickerFormatType): Bool => value() == that.value()
primitive PNGStickerFormatType is StickerFormatType
    fun value(): U8 => 1
primitive APNGStickerFormatType is StickerFormatType
    fun value(): U8 => 2
primitive LottieStickerFormatType is StickerFormatType
    fun value(): U8 => 3
primitive GIFStickerFormatType is StickerFormatType
    fun value(): U8 => 4
primitive StickerFormatTypes
    fun from(value: U8): StickerFormatType ? =>
        match value
        | 1 => PNGStickerFormatType
        | 2 => APNGStickerFormatType
        | 3 => LottieStickerFormatType
        | 4 => GIFStickerFormatType
        else error
        end

class val StickerItem is Jsonable
    """
    https://docs.discord.com/developers/resources/sticker#sticker-item-object-sticker-item-structure

    The smallest amount of data required to render a sticker. A partial sticker object.
    """

    let id: Snowflake
        """
        id of the sticker
        """

    let name: String
        """
        name of the sticker
        """

    let format_type: StickerFormatType
        """
        type of sticker format
        """

    new val create(id': Snowflake, name': String, format_type': StickerFormatType) =>
        id = id'
        name = name'
        format_type = format_type'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var format_type': (StickerFormatType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "format_type" => format_type' = StickerFormatTypes.from((value as I64).u8())?
            end
        end

        id = id' as Snowflake
        name = name' as String
        format_type = format_type' as StickerFormatType

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("format_type", format_type.value().i64())

class val StickerPack is Jsonable
    """
    https://docs.discord.com/developers/resources/sticker#sticker-pack-object-sticker-pack-structure

    Represents a pack of standard stickers.
    """

    let id: Snowflake
        """
        id of the sticker pack
        """

    let stickers: Array[Sticker] val
        """
        the stickers in the pack
        """

    let name: String
        """
        name of the sticker pack
        """

    let sku_id: Snowflake
        """
        id of the pack's SKU
        """

    let cover_sticker_id: (Snowflake | None)
        """
        id of a sticker in the pack which is shown as the pack's icon
        """

    let description: String
        """
        description of the sticker pack
        """

    let banner_asset_id: (Snowflake | None)
        """
        id of the sticker pack's banner image
        """

    new val create(
        id': Snowflake,
        stickers': Array[Sticker] val,
        name': String,
        sku_id': Snowflake,
        cover_sticker_id': (Snowflake | None) = None,
        description': String,
        banner_asset_id': (Snowflake | None) = None
    ) =>
        id = id'
        stickers = stickers'
        name = name'
        sku_id = sku_id'
        cover_sticker_id = cover_sticker_id'
        description = description'
        banner_asset_id = banner_asset_id'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var stickers': (Array[Sticker] val | None) = None
        var name': (String | None) = None
        var sku_id': (Snowflake | None) = None
        var cover_sticker_id': (Snowflake | None) = None
        var description': (String | None) = None
        var banner_asset_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "stickers" => stickers' = _Stickers(value)?
            | "name" => name' = value as String
            | "sku_id" => sku_id' = Snowflake.from_json(value)?
            | "cover_sticker_id" => cover_sticker_id' = Snowflake.from_json(value)?
            | "description" => description' = value as String
            | "banner_asset_id" => banner_asset_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        stickers = stickers' as Array[Sticker] val
        name = name' as String
        sku_id = sku_id' as Snowflake
        cover_sticker_id = cover_sticker_id'
        description = description' as String
        banner_asset_id = banner_asset_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("stickers", _Stickers.to_json(stickers))
            .update("name", name)
            .update("sku_id", sku_id.to_json())
            .update("description", description)

        match cover_sticker_id
        | let cover_sticker_id': Snowflake => obj = obj.update("cover_sticker_id", cover_sticker_id'.to_json())
        end

        match banner_asset_id
        | let banner_asset_id': Snowflake => obj = obj.update("banner_asset_id", banner_asset_id'.to_json())
        end

        obj

primitive _StickerItems
    fun apply(value: json.JsonValue): Array[StickerItem] val ? =>
        """
        Decodes an array of sticker items.
        """

        let array = value as json.JsonArray
        recover val
            let items = Array[StickerItem](array.size())
            for item in array.values() do items.push(StickerItem.from_json(item as json.JsonObject)?) end
            items
        end

    fun to_json(items: Array[StickerItem] val): json.JsonArray =>
        var array = json.JsonArray
        for item in items.values() do array = array.push(item.to_json()) end
        array

class val CreateGuildStickerParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/sticker#create-guild-sticker-form-params

    Every guild has five free sticker slots by default, and each Boost level will grant access to more slots.

    Lottie stickers can only be uploaded on guilds that have either the `VERIFIED` and/or the `PARTNERED` guild feature.

    Uploaded stickers are constrained to 5 seconds in length for animated stickers, and 320 x 320 pixels.

    This endpoint is a `multipart/form-data` endpoint: the sticker `file` itself is uploaded as a separate part alongside the fields serialised here.
    """

    let name: String
        """
        name of the sticker (2-30 characters)
        """

    let description: String
        """
        description of the sticker (empty or 2-100 characters)
        """

    let tags: String
        """
        autocomplete/suggestion tags for the sticker (max 200 characters)
        """

    new val create(name': String, description': String, tags': String) =>
        name = name'
        description = description'
        tags = tags'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("name", name)
            .update("description", description)
            .update("tags", tags)

class val UpdateGuildStickerParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/sticker#modify-guild-sticker-json-params

    All parameters to this endpoint are optional.
    """

    let name: (String | None)
        """
        name of the sticker (2-30 characters)
        """

    let description: Nullable[String]
        """
        description of the sticker (2-100 characters)
        """

    let tags: (String | None)
        """
        autocomplete/suggestion tags for the sticker (max 200 characters)
        """

    new val create(
        name': (String | None) = None,
        description': Nullable[String] = None,
        tags': (String | None) = None
    ) =>
        name = name'
        description = description'
        tags = tags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match description
        | let description': String => obj = obj.update("description", description')
        | Null => obj = obj.update("description", None)
        end

        match tags
        | let tags': String => obj = obj.update("tags", tags')
        end

        obj
