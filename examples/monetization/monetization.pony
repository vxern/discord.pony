use data = "../../discord/data"
use rest = "../../discord/rest"

actor Main
    new create(env: Env) =>
        let token =
            try
                env.args(1)?
            else
                env.err.print("usage: monetization <bot-token>")
                env.exitcode(1)
                return
            end

        let out = env.out
        let err = env.err
        let client =
            rest.Rest(
                env,
                rest.RestOptions(
                    where
                        token' = token,
                        on_error' =
                            {(error': rest.RestError)(err) =>
                                err.print(error'.string())
                            }
                )
            )
        let routes = client.routes

        routes.get_application(
            {(application: data.Application)(out, routes) =>
                let application_id = application.id

                routes.get_skus(
                    application_id,
                    {(skus: Array[data.SKU] val)(out, routes, application_id) =>
                        out.print(skus.size().string() + " sku(s) on sale")

                        for sku in skus.values() do
                            out.print(
                                "  " + sku.name + " (" + sku.id.string() + ") "
                                + _Kind(sku)
                            )
                        end

                        routes.get_entitlements(
                            application_id,
                            data.GetEntitlementsParams(
                                where limit' = 100, exclude_ended' = true
                            ),
                            {(entitlements: Array[data.Entitlement] val)(out) =>
                                out.print(
                                    entitlements.size().string()
                                    + " live entitlement(s)"
                                )

                                for entitlement in entitlements.values() do
                                    out.print(
                                        "  sku " + entitlement.sku_id.string()
                                        + " -> " + _Owner(entitlement)
                                    )
                                end
                            }
                        )
                    }
                )
            }
        )

primitive _Kind
    fun apply(sku: data.SKU): String =>
        """
        A one-off purchase arrives as a `DURABLE` or `CONSUMABLE` sku, and a
        recurring one as a `SUBSCRIPTION` inside a `SUBSCRIPTION_GROUP`.
        """

        match sku.type'
        | data.DurableSKUType => "one-off, kept forever"
        | data.ConsumableSKUType => "one-off, consumed on use"
        | data.SubscriptionSKUType => "recurring"
        | data.SubscriptionGroupSKUType => "a group holding a recurring sku"
        else
            "of a kind this library does not name yet"
        end

primitive _Owner
    fun apply(entitlement: data.Entitlement): String =>
        """
        An entitlement is granted either to a user or to a whole guild, never to
        both, so exactly one of the two ids is set.
        """

        match entitlement.user_id
        | let user_id: data.Snowflake => return "user " + user_id.string()
        end

        match entitlement.guild_id
        | let guild_id: data.Snowflake => return "guild " + guild_id.string()
        end

        "nobody"
