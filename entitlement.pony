use collections = "collections"
use json = "json"

class val Entitlement
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
