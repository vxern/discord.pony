use collections = "collections"
use json = "json"

class val SKU is Jsonable
    """
    https://docs.discord.com/developers/resources/sku#sku-object-sku-structure

    SKUs (stock-keeping units) in Discord represent premium offerings that can be made available to your application's users or guilds.

    For subscriptions, SKUs will have a type of either SUBSCRIPTION represented by type: 5 or SUBSCRIPTION_GROUP represented by type: 6. For any current implementations, you will want to use the SKU defined by type: 5. A SUBSCRIPTION_GROUP is automatically created for each SUBSCRIPTION SKU and are not used at this time.
    """

    let id: Snowflake
        """
        ID of SKU
        """

    let type': SKUType
        """
        Type of SKU
        """

    let application_id: Snowflake
        """
        ID of the parent application
        """

    let name: String
        """
        Customer-facing name of your premium offering
        """

    let slug: String
        """
        System-generated URL slug based on the SKU's name
        """

    let flags: Array[SKUFlag] val
        """
        SKU flags combined as a bitfield
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (SKUType | None) = None
        var application_id': (Snowflake | None) = None
        var name': (String | None) = None
        var slug': (String | None) = None
        var flags': (Array[SKUFlag] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = SKUTypes.from((value as I64).u8())?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "slug" => slug' = value as String
            | "flags" => flags' = _SKUFlags((value as I64).u64())
            end
        end

        id = id' as Snowflake
        type' = type'' as SKUType
        application_id = application_id' as Snowflake
        name = name' as String
        slug = slug' as String
        flags = flags' as Array[SKUFlag] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("application_id", application_id.to_json())
            .update("name", name)
            .update("slug", slug)
            .update("flags", _SKUFlags.to_json(flags))

primitive _SKUs
    fun apply(value: json.JsonValue): Array[SKU] val ? =>
        """
        Decodes an array of SKUs.
        """

        let array = value as json.JsonArray
        recover val
            let skus = Array[SKU](array.size())
            for sku in array.values() do skus.push(SKU.from_json(sku as json.JsonObject)?) end
            skus
        end

    fun to_json(skus: Array[SKU] val): json.JsonArray =>
        var array = json.JsonArray
        for sku in skus.values() do array = array.push(sku.to_json()) end
        array

trait val SKUType is (collections.Hashable & Equatable[SKUType])
    """
    https://docs.discord.com/developers/resources/sku#sku-object-sku-types

    For subscriptions, there are two types of access levels you can offer to users:

        Guild Subscriptions: A subscription purchased by a user and applied to a single server. Everyone in that server gets your premium benefits.

        User Subscriptions: A subscription purchased by a user for themselves. They get access to your premium benefits in every server.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SKUType): Bool => value() == that.value()
primitive DurableSKUType is SKUType
    """
    Durable one-time purchase
    """

    fun value(): U8 => 2
primitive ConsumableSKUType is SKUType
    """
    Consumable one-time purchase
    """

    fun value(): U8 => 3
primitive SubscriptionSKUType is SKUType
    """
    Represents a recurring subscription
    """

    fun value(): U8 => 5
primitive SubscriptionGroupSKUType is SKUType
    """
    System-generated group for each SUBSCRIPTION SKU created
    """

    fun value(): U8 => 6
primitive SKUTypes
    fun from(value: U8): SKUType ? =>
        match value
        | 2 => DurableSKUType
        | 3 => ConsumableSKUType
        | 5 => SubscriptionSKUType
        | 6 => SubscriptionGroupSKUType
        else error
        end

trait val SKUFlag is (collections.Hashable & Equatable[SKUFlag])
    """
    https://docs.discord.com/developers/resources/sku#sku-object-sku-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SKUFlag): Bool => value() == that.value()
primitive AvailableSKUFlag is SKUFlag
    """
    SKU is available for purchase
    """

    fun value(): U8 => 2
primitive GuildSubscriptionSKUFlag is SKUFlag
    """
    Recurring SKU that can be purchased by a user and applied to a single server. Grants access to every user in that server.
    """

    fun value(): U8 => 7
primitive UserSubscriptionSKUFlag is SKUFlag
    """
    Recurring SKU purchased by a user for themselves. Grants access to the purchasing user in every server.
    """

    fun value(): U8 => 8
primitive SKUFlags
    fun from(value: U8): SKUFlag ? =>
        match value
        | 2 => AvailableSKUFlag
        | 7 => GuildSubscriptionSKUFlag
        | 8 => UserSubscriptionSKUFlag
        else error
        end

primitive _SKUFlags
    fun apply(bits: U64): Array[SKUFlag] val =>
        recover val
            let flags = Array[SKUFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(SKUFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[SKUFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()
