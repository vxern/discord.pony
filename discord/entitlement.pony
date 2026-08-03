use collections = "collections"
use json = "json"

class val Entitlement is Jsonable
    """
    https://docs.discord.com/developers/resources/entitlement#entitlement-object-entitlement-structure

    Entitlements in Discord represent that a user or guild has access to a premium offering in your application.

    Entitlements are created when a user purchases a SKU, when a developer gifts a SKU, or when a subscription is renewed. They are deleted when a subscription is cancelled or when a gift is revoked.
    """

    let id: Snowflake
        """
        ID of the entitlement
        """

    let sku_id: Snowflake
        """
        ID of the SKU
        """

    let application_id: Snowflake
        """
        ID of the parent application
        """

    let user_id: (Snowflake | None)
        """
        ID of the user that is granted access to the entitlement's sku
        """

    let type': EntitlementType
        """
        Type of entitlement
        """

    let deleted: Bool
        """
        Entitlement was deleted
        """

    let starts_at: (ISO8601 | None)
        """
        Start date at which the entitlement is valid.

        Not present when using test entitlements.
        """

    let ends_at: (ISO8601 | None)
        """
        Date at which the entitlement is no longer valid.

        Not present when using test entitlements, or when receiving an entitlement for a permanent one-time purchase.
        """

    let guild_id: (Snowflake | None)
        """
        ID of the guild that is granted access to the entitlement's sku
        """

    let consumed: (Bool | None)
        """
        For consumable items, whether or not the entitlement has been consumed
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var sku_id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var type'': (EntitlementType | None) = None
        var deleted': (Bool | None) = None
        var starts_at': (ISO8601 | None) = None
        var ends_at': (ISO8601 | None) = None
        var guild_id': (Snowflake | None) = None
        var consumed': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "sku_id" => sku_id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "type" => type'' = EntitlementTypes.from((value as I64).u8())?
            | "deleted" => deleted' = value as Bool
            | "starts_at" =>
                match value | let string: String => starts_at' = string end
            | "ends_at" =>
                match value | let string: String => ends_at' = string end
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "consumed" => consumed' = value as Bool
            end
        end

        id = id' as Snowflake
        sku_id = sku_id' as Snowflake
        application_id = application_id' as Snowflake
        user_id = user_id'
        type' = type'' as EntitlementType
        deleted = deleted' as Bool
        starts_at = starts_at'
        ends_at = ends_at'
        guild_id = guild_id'
        consumed = consumed'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("sku_id", sku_id.to_json())
            .update("application_id", application_id.to_json())
            .update("type", type'.value().i64())
            .update("deleted", deleted)

        match user_id
        | let user_id': Snowflake => obj = obj.update("user_id", user_id'.to_json())
        end

        match starts_at
        | let starts_at': ISO8601 => obj = obj.update("starts_at", starts_at')
        end

        match ends_at
        | let ends_at': ISO8601 => obj = obj.update("ends_at", ends_at')
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match consumed
        | let consumed': Bool => obj = obj.update("consumed", consumed')
        end

        obj

trait val EntitlementType is (collections.Hashable & Equatable[EntitlementType])
    """
    https://docs.discord.com/developers/resources/entitlement#entitlement-object-entitlement-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: EntitlementType): Bool => value() == that.value()
primitive PurchaseEntitlementType is EntitlementType
    """
    Entitlement was purchased by user
    """

    fun value(): U8 => 1
primitive PremiumSubscriptionEntitlementType is EntitlementType
    """
    Entitlement for Discord Nitro subscription
    """

    fun value(): U8 => 2
primitive DeveloperGiftEntitlementType is EntitlementType
    """
    Entitlement was gifted by developer
    """

    fun value(): U8 => 3
primitive TestModePurchaseEntitlementType is EntitlementType
    """
    Entitlement was purchased by a dev in application test mode
    """

    fun value(): U8 => 4
primitive FreePurchaseEntitlementType is EntitlementType
    """
    Entitlement was granted when the SKU was free
    """

    fun value(): U8 => 5
primitive UserGiftEntitlementType is EntitlementType
    """
    Entitlement was gifted by another user
    """

    fun value(): U8 => 6
primitive PremiumPurchaseEntitlementType is EntitlementType
    """
    Entitlement was claimed by user for free as a Nitro Subscriber
    """

    fun value(): U8 => 7
primitive ApplicationSubscriptionEntitlementType is EntitlementType
    """
    Entitlement was purchased as an app subscription
    """

    fun value(): U8 => 8
primitive EntitlementTypes
    fun from(value: U8): EntitlementType ? =>
        match value
        | 1 => PurchaseEntitlementType
        | 2 => PremiumSubscriptionEntitlementType
        | 3 => DeveloperGiftEntitlementType
        | 4 => TestModePurchaseEntitlementType
        | 5 => FreePurchaseEntitlementType
        | 6 => UserGiftEntitlementType
        | 7 => PremiumPurchaseEntitlementType
        | 8 => ApplicationSubscriptionEntitlementType
        else error
        end

primitive _Entitlements
    fun apply(value: json.JsonValue): Array[Entitlement] val ? =>
        """
        Decodes an array of entitlements.
        """

        let array = value as json.JsonArray
        recover val
            let entitlements = Array[Entitlement](array.size())
            for entitlement in array.values() do entitlements.push(Entitlement.from_json(entitlement as json.JsonObject)?) end
            entitlements
        end

    fun to_json(entitlements: Array[Entitlement] val): json.JsonArray =>
        var array = json.JsonArray
        for entitlement in entitlements.values() do array = array.push(entitlement.to_json()) end
        array

class val GetEntitlementsParams
    """
    https://docs.discord.com/developers/resources/entitlement#list-entitlements-query-string-params
    """

    let user_id: (Snowflake | None)
        """
        User ID to look up entitlements for
        """

    let sku_ids: (Array[Snowflake] val | None)
        """
        Optional list of SKU IDs to check entitlements for
        """

    let before: (Snowflake | None)
        """
        Retrieve entitlements before this entitlement ID
        """

    let after: (Snowflake | None)
        """
        Retrieve entitlements after this entitlement ID
        """

    let limit: (USize | None)
        """
        Number of entitlements to return, 1-100, default 100
        """

    let guild_id: (Snowflake | None)
        """
        Guild ID to look up entitlements for
        """

    let exclude_ended: (Bool | None)
        """
        Whether or not ended entitlements should be omitted. Defaults to false, ended entitlements are included by default.
        """

    let exclude_deleted: (Bool | None)
        """
        Whether or not deleted entitlements should be omitted. Defaults to true, deleted entitlements are not included by default.
        """

    new val create(
        user_id': (Snowflake | None) = None,
        sku_ids': (Array[Snowflake] val | None) = None,
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None,
        limit': (USize | None) = None,
        guild_id': (Snowflake | None) = None,
        exclude_ended': (Bool | None) = None,
        exclude_deleted': (Bool | None) = None
    ) =>
        user_id = user_id'
        sku_ids = sku_ids'
        before = before'
        after = after'
        limit = limit'
        guild_id = guild_id'
        exclude_ended = exclude_ended'
        exclude_deleted = exclude_deleted'

    fun to_query(): RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match user_id
        | let user_id': Snowflake => query.push(("user_id", user_id'.string()))
        end

        match sku_ids
        | let sku_ids': Array[Snowflake] val => query.push(("sku_ids", _CommaSeparated(sku_ids')))
        end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        match guild_id
        | let guild_id': Snowflake => query.push(("guild_id", guild_id'.string()))
        end

        match exclude_ended
        | let exclude_ended': Bool => query.push(("exclude_ended", exclude_ended'.string()))
        end

        match exclude_deleted
        | let exclude_deleted': Bool => query.push(("exclude_deleted", exclude_deleted'.string()))
        end

        consume query

class val CreateTestEntitlementParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/entitlement#create-test-entitlement-json-params
    """

    let sku_id: Snowflake
        """
        ID of the SKU to grant the entitlement to
        """

    let owner_id: Snowflake
        """
        ID of the guild or user to grant the entitlement to
        """

    let owner_type: TestEntitlementOwnerType
        """
        `1` for a guild subscription, `2` for a user subscription
        """

    new val create(sku_id': Snowflake, owner_id': Snowflake, owner_type': TestEntitlementOwnerType) =>
        sku_id = sku_id'
        owner_id = owner_id'
        owner_type = owner_type'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("sku_id", sku_id.to_json())
            .update("owner_id", owner_id.to_json())
            .update("owner_type", owner_type.value().i64())

trait val TestEntitlementOwnerType is (collections.Hashable & Equatable[TestEntitlementOwnerType])
    """
    https://docs.discord.com/developers/resources/entitlement#create-test-entitlement

    Whether a test entitlement is granted to a guild or to a user.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: TestEntitlementOwnerType): Bool => value() == that.value()
primitive GuildSubscriptionTestEntitlementOwnerType is TestEntitlementOwnerType
    """
    A guild subscription
    """

    fun value(): U8 => 1
primitive UserSubscriptionTestEntitlementOwnerType is TestEntitlementOwnerType
    """
    A user subscription
    """

    fun value(): U8 => 2
primitive TestEntitlementOwnerTypes
    fun from(value: U8): TestEntitlementOwnerType ? =>
        match value
        | 1 => GuildSubscriptionTestEntitlementOwnerType
        | 2 => UserSubscriptionTestEntitlementOwnerType
        else error
        end
