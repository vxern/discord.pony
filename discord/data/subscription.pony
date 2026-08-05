use collections = "collections"
use json = "json"

class val Subscription is Jsonable
    """
    https://docs.discord.com/developers/resources/subscription#subscription-object-subscription-structure

    Subscriptions in Discord represent a user making recurring payments for at least one SKU over an ongoing period. Successful payments grant the user access to entitlements associated with the SKU.

    Subscription Statuses

        Active Subscription: A subscription that is scheduled to renew at the end of the current period.

        Ending Subscription: A subscription that will not renew at the end of the current period. The subscription will remain active until the end of the current period.

        Inactive Subscription: A subscription that has ended. The user no longer has access to the entitlements associated with the SKU.
    """

    let id: Snowflake
        """
        ID of the subscription
        """

    let user_id: Snowflake
        """
        ID of the user who is subscribed
        """

    let sku_ids: Array[Snowflake] val
        """
        List of SKUs subscribed to
        """

    let entitlement_ids: Array[Snowflake] val
        """
        List of entitlements granted for this subscription
        """

    let renewal_sku_ids: (Array[Snowflake] val | None)
        """
        List of SKUs that this user will be subscribed to at renewal
        """

    let current_period_start: ISO8601
        """
        Start of the current subscription period
        """

    let current_period_end: ISO8601
        """
        End of the current subscription period
        """

    let status: SubscriptionStatus
        """
        Current status of the subscription
        """

    let canceled_at: (ISO8601 | None)
        """
        When the subscription was canceled
        """

    let country: (String | None)
        """
        ISO3166-1 alpha-2 country code of the payment source used to purchase the subscription. Missing unless queried with a private OAuth scope.
        """

    new val create(
        id': Snowflake,
        user_id': Snowflake,
        sku_ids': Array[Snowflake] val,
        entitlement_ids': Array[Snowflake] val,
        renewal_sku_ids': (Array[Snowflake] val | None) = None,
        current_period_start': ISO8601,
        current_period_end': ISO8601,
        status': SubscriptionStatus,
        canceled_at': (ISO8601 | None) = None,
        country': (String | None) = None
    ) =>
        id = id'
        user_id = user_id'
        sku_ids = sku_ids'
        entitlement_ids = entitlement_ids'
        renewal_sku_ids = renewal_sku_ids'
        current_period_start = current_period_start'
        current_period_end = current_period_end'
        status = status'
        canceled_at = canceled_at'
        country = country'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var sku_ids': (Array[Snowflake] val | None) = None
        var entitlement_ids': (Array[Snowflake] val | None) = None
        var renewal_sku_ids': (Array[Snowflake] val | None) = None
        var current_period_start': (ISO8601 | None) = None
        var current_period_end': (ISO8601 | None) = None
        var status': (SubscriptionStatus | None) = None
        var canceled_at': (ISO8601 | None) = None
        var country': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "sku_ids" => sku_ids' = _Snowflakes(value)?
            | "entitlement_ids" => entitlement_ids' = _Snowflakes(value)?
            | "renewal_sku_ids" =>
                match value | let array: json.JsonArray => renewal_sku_ids' = _Snowflakes(array)? end
            | "current_period_start" => current_period_start' = value as String
            | "current_period_end" => current_period_end' = value as String
            | "status" => status' = SubscriptionStatuses.from((value as I64).u8())?
            | "canceled_at" =>
                match value | let string: String => canceled_at' = string end
            | "country" => country' = value as String
            end
        end

        id = id' as Snowflake
        user_id = user_id' as Snowflake
        sku_ids = sku_ids' as Array[Snowflake] val
        entitlement_ids = entitlement_ids' as Array[Snowflake] val
        renewal_sku_ids = renewal_sku_ids'
        current_period_start = current_period_start' as ISO8601
        current_period_end = current_period_end' as ISO8601
        status = status' as SubscriptionStatus
        canceled_at = canceled_at'
        country = country'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("user_id", user_id.to_json())
            .update("sku_ids", _Snowflakes.to_json(sku_ids))
            .update("entitlement_ids", _Snowflakes.to_json(entitlement_ids))
            .update("renewal_sku_ids", match renewal_sku_ids | let renewal_sku_ids': Array[Snowflake] val => _Snowflakes.to_json(renewal_sku_ids') end)
            .update("current_period_start", current_period_start)
            .update("current_period_end", current_period_end)
            .update("status", status.value().i64())
            .update("canceled_at", canceled_at)

        match country
        | let country': String => obj = obj.update("country", country')
        end

        obj

primitive _Subscriptions
    fun apply(value: json.JsonValue): Array[Subscription] val ? =>
        """
        Decodes an array of subscriptions.
        """

        let array = value as json.JsonArray
        recover val
            let subscriptions = Array[Subscription](array.size())
            for subscription in array.values() do subscriptions.push(Subscription.from_json(subscription as json.JsonObject)?) end
            subscriptions
        end

    fun to_json(subscriptions: Array[Subscription] val): json.JsonArray =>
        var array = json.JsonArray
        for subscription in subscriptions.values() do array = array.push(subscription.to_json()) end
        array

trait val SubscriptionStatus is _Enum[SubscriptionStatus]
    """
    https://docs.discord.com/developers/resources/subscription#subscription-statuses

    Subscription status should not be used to grant perks. Use entitlements as an indication of whether a user should have access to a specific SKU. See our guide on Implementing App Subscriptions for more information.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SubscriptionStatus): Bool => value() == that.value()
primitive ActiveSubscriptionStatus is SubscriptionStatus
    """
    Subscription is active and scheduled to renew.
    """

    fun value(): U8 => 0
primitive EndingSubscriptionStatus is SubscriptionStatus
    """
    Subscription is active but will not renew.
    """

    fun value(): U8 => 1
primitive InactiveSubscriptionStatus is SubscriptionStatus
    """
    Subscription is inactive and not being charged.
    """

    fun value(): U8 => 2
primitive SubscriptionStatuses
    fun from(value: U8): SubscriptionStatus ? =>
        match value
        | 0 => ActiveSubscriptionStatus
        | 1 => EndingSubscriptionStatus
        | 2 => InactiveSubscriptionStatus
        else error
        end

class val GetSKUSubscriptionsParams
    """
    https://docs.discord.com/developers/resources/subscription#list-sku-subscriptions-query-string-params
    """

    let before: (Snowflake | None)
        """
        List subscriptions before this ID
        """

    let after: (Snowflake | None)
        """
        List subscriptions after this ID
        """

    let limit: (USize | None)
        """
        Number of results to return (1-100), defaults to 50
        """

    let user_id: (Snowflake | None)
        """
        User ID for which to return subscriptions. Required except for OAuth queries.
        """

    new val create(
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None,
        limit': (USize | None) = None,
        user_id': (Snowflake | None) = None
    ) =>
        before = before'
        after = after'
        limit = limit'
        user_id = user_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        match user_id
        | let user_id': Snowflake => query.push(("user_id", user_id'.string()))
        end

        consume query
