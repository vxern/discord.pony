use collections = "collections"
use json = "json"

class val Application
    """
    https://docs.discord.com/developers/resources/application#application-object-application-structure

    Applications (or “apps”) are containers for developer platform features, and can be installed to Discord servers and/or user accounts.
    """

    let id: Snowflake
        """
        ID of the app
        """

    let name: String
        """
        Name of the app
        """

    let icon: (String | None)
        """
        Icon hash of the app
        """

    let description: String
        """
        Description of the app
        """

    let rpc_origins: (Array[String] val | None)
        """
        List of RPC origin URLs, if RPC is enabled
        """

    let bot_public: Bool
        """
        When false, only the app owner can add the app to guilds
        """

    let bot_require_code_grant: Bool
        """
        When true, the app’s bot will only join upon completion of the full OAuth2 code grant flow
        """

    // TODO(vxern): Add `bot` (partial user object; partial user object for the bot user associated with the app) once `User` supports JSON conversion.

    let terms_of_service_url: (String | None)
        """
        URL of the app’s Terms of Service
        """

    let privacy_policy_url: (String | None)
        """
        URL of the app’s Privacy Policy
        """

    // TODO(vxern): Add `owner` (partial user object; partial user object for the owner of the app) once `User` supports JSON conversion.

    let verify_key: String
        """
        Hex encoded key for verification in interactions and the GameSDK’s GetTicket
        """

    // TODO(vxern): Add `team` (team object; if the app belongs to a team, this will be a list of the members of that team) once `Team` is implemented.

    let guild_id: (Snowflake | None)
        """
        Guild associated with the app. For example, a developer support server.
        """

    // TODO(vxern): Add `guild` (partial guild object; partial object of the associated guild) once `Guild` is implemented.

    let primary_sku_id: (Snowflake | None)
        """
        If this app is a game sold on Discord, this field will be the id of the “Game SKU” that is created, if exists
        """

    let slug: (String | None)
        """
        If this app is a game sold on Discord, this field will be the URL slug that links to the store page
        """

    let cover_image: (String | None)
        """
        App’s default rich presence invite cover image hash
        """

    let flags: (Array[ApplicationFlag] val | None)
        """
        App’s public flags

        Decoded from `flags_new` where present, falling back to the legacy `flags` field otherwise.
        """

    let approximate_guild_count: (USize | None)
        """
        Approximate count of guilds the app has been added to
        """

    let approximate_user_install_count: (USize | None)
        """
        Approximate count of users that have installed the app (authorized with application.commands as a scope)
        """

    let approximate_user_authorization_count: (USize | None)
        """
        Approximate count of users that have OAuth2 authorizations for the app
        """

    let redirect_uris: (Array[String] val | None)
        """
        Array of redirect URIs for the app
        """

    let interactions_endpoint_url: (String | None)
        """
        Interactions endpoint URL for the app
        """

    let role_connections_verification_url: (String | None)
        """
        Role connection verification URL for the app
        """

    let event_webhooks_url: (String | None)
        """
        Event webhooks URL for the app to receive webhook events
        """

    let event_webhooks_status: (ApplicationEventWebhookStatus | None)
        """
        If webhook events are enabled for the app. 1 (default) means disabled, 2 means enabled, and 3 means disabled by Discord
        """

    let event_webhooks_types: (Array[String] val | None)
        """
        List of Webhook event types the app subscribes to
        """

    let tags: (Array[String] val | None)
        """
        List of tags describing the content and functionality of the app. Max of 5 tags.
        """

    let install_params: (InstallParams | None)
        """
        Settings for the app’s default in-app authorization link, if enabled
        """

    let integration_types_config: (collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration] | None)
        """
        Default scopes and permissions for each supported installation context. Value for each key is an integration type configuration object
        """

    let custom_install_url: (String | None)
        """
        Default custom authorization URL for the app, if enabled
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var icon': (String | None) = None
        var description': (String | None) = None
        var rpc_origins': (Array[String] val | None) = None
        var bot_public': (Bool | None) = None
        var bot_require_code_grant': (Bool | None) = None
        var terms_of_service_url': (String | None) = None
        var privacy_policy_url': (String | None) = None
        var verify_key': (String | None) = None
        var guild_id': (Snowflake | None) = None
        var primary_sku_id': (Snowflake | None) = None
        var slug': (String | None) = None
        var cover_image': (String | None) = None
        var flags': (U64 | None) = None
        var flags_new': (U64 | None) = None
        var approximate_guild_count': (USize | None) = None
        var approximate_user_install_count': (USize | None) = None
        var approximate_user_authorization_count': (USize | None) = None
        var redirect_uris': (Array[String] val | None) = None
        var interactions_endpoint_url': (String | None) = None
        var role_connections_verification_url': (String | None) = None
        var event_webhooks_url': (String | None) = None
        var event_webhooks_status': (ApplicationEventWebhookStatus | None) = None
        var event_webhooks_types': (Array[String] val | None) = None
        var tags': (Array[String] val | None) = None
        var install_params': (InstallParams | None) = None
        var integration_types_config': (collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration] | None) = None
        var custom_install_url': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "icon" =>
                match value | let s: String => icon' = s end
            | "description" => description' = value as String
            | "rpc_origins" => rpc_origins' = _Strings(value)?
            | "bot_public" => bot_public' = value as Bool
            | "bot_require_code_grant" => bot_require_code_grant' = value as Bool
            | "terms_of_service_url" => terms_of_service_url' = value as String
            | "privacy_policy_url" => privacy_policy_url' = value as String
            | "verify_key" => verify_key' = value as String
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "primary_sku_id" => primary_sku_id' = Snowflake.from_json(value)?
            | "slug" => slug' = value as String
            | "cover_image" => cover_image' = value as String
            | "flags" => flags' = (value as I64).u64()
            | "flags_new" => flags_new' = (value as String).u64()?
            | "approximate_guild_count" => approximate_guild_count' = (value as I64).usize()
            | "approximate_user_install_count" => approximate_user_install_count' = (value as I64).usize()
            | "approximate_user_authorization_count" => approximate_user_authorization_count' = (value as I64).usize()
            | "redirect_uris" => redirect_uris' = _Strings(value)?
            | "interactions_endpoint_url" =>
                match value | let s: String => interactions_endpoint_url' = s end
            | "role_connections_verification_url" =>
                match value | let s: String => role_connections_verification_url' = s end
            | "event_webhooks_url" =>
                match value | let s: String => event_webhooks_url' = s end
            | "event_webhooks_status" => event_webhooks_status' = ApplicationEventWebhookStatuses.from((value as I64).u8())?
            | "event_webhooks_types" => event_webhooks_types' = _Strings(value)?
            | "tags" => tags' = _Strings(value)?
            | "install_params" => install_params' = InstallParams.from_json(value as json.JsonObject)?
            | "integration_types_config" => integration_types_config' = _IntegrationTypesConfiguration(value)?
            | "custom_install_url" => custom_install_url' = value as String
            end
        end

        id = id' as Snowflake
        name = name' as String
        icon = icon'
        description = description' as String
        rpc_origins = rpc_origins'
        bot_public = bot_public' as Bool
        bot_require_code_grant = bot_require_code_grant' as Bool
        terms_of_service_url = terms_of_service_url'
        privacy_policy_url = privacy_policy_url'
        verify_key = verify_key' as String
        guild_id = guild_id'
        primary_sku_id = primary_sku_id'
        slug = slug'
        cover_image = cover_image'
        flags =
            match (flags_new', flags')
            | (let bits: U64, _) => _ApplicationFlags(bits)
            | (None, let bits: U64) => _ApplicationFlags(bits)
            end
        approximate_guild_count = approximate_guild_count'
        approximate_user_install_count = approximate_user_install_count'
        approximate_user_authorization_count = approximate_user_authorization_count'
        redirect_uris = redirect_uris'
        interactions_endpoint_url = interactions_endpoint_url'
        role_connections_verification_url = role_connections_verification_url'
        event_webhooks_url = event_webhooks_url'
        event_webhooks_status = event_webhooks_status'
        event_webhooks_types = event_webhooks_types'
        tags = tags'
        install_params = install_params'
        integration_types_config = integration_types_config'
        custom_install_url = custom_install_url'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("icon", icon)
            .update("description", description)
            .update("bot_public", bot_public)
            .update("bot_require_code_grant", bot_require_code_grant)
            .update("verify_key", verify_key)

        match rpc_origins
        | let s: Array[String] val => obj = obj.update("rpc_origins", _Strings.to_json(s))
        end

        match terms_of_service_url
        | let s: String => obj = obj.update("terms_of_service_url", s)
        end

        match privacy_policy_url
        | let s: String => obj = obj.update("privacy_policy_url", s)
        end

        match guild_id
        | let s: Snowflake => obj = obj.update("guild_id", s.to_json())
        end

        match primary_sku_id
        | let s: Snowflake => obj = obj.update("primary_sku_id", s.to_json())
        end

        match slug
        | let s: String => obj = obj.update("slug", s)
        end

        match cover_image
        | let s: String => obj = obj.update("cover_image", s)
        end

        // `flags_new` is for response serialization only; requests that accept flag values are expected to use `flags`.
        match flags
        | let f: Array[ApplicationFlag] val => obj = obj.update("flags", _ApplicationFlags.to_json(f))
        end

        match approximate_guild_count
        | let n: USize => obj = obj.update("approximate_guild_count", n.i64())
        end

        match approximate_user_install_count
        | let n: USize => obj = obj.update("approximate_user_install_count", n.i64())
        end

        match approximate_user_authorization_count
        | let n: USize => obj = obj.update("approximate_user_authorization_count", n.i64())
        end

        match redirect_uris
        | let s: Array[String] val => obj = obj.update("redirect_uris", _Strings.to_json(s))
        end

        match interactions_endpoint_url
        | let s: String => obj = obj.update("interactions_endpoint_url", s)
        end

        match role_connections_verification_url
        | let s: String => obj = obj.update("role_connections_verification_url", s)
        end

        match event_webhooks_url
        | let s: String => obj = obj.update("event_webhooks_url", s)
        end

        match event_webhooks_status
        | let s: ApplicationEventWebhookStatus => obj = obj.update("event_webhooks_status", s.value().i64())
        end

        match event_webhooks_types
        | let s: Array[String] val => obj = obj.update("event_webhooks_types", _Strings.to_json(s))
        end

        match tags
        | let s: Array[String] val => obj = obj.update("tags", _Strings.to_json(s))
        end

        match install_params
        | let p: InstallParams => obj = obj.update("install_params", p.to_json())
        end

        match integration_types_config
        | let m: collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration] box =>
            obj = obj.update("integration_types_config", _IntegrationTypesConfiguration.to_json(m))
        end

        match custom_install_url
        | let s: String => obj = obj.update("custom_install_url", s)
        end

        obj

trait val ApplicationIntegrationType is (collections.Hashable & Equatable[ApplicationIntegrationType])
    """
    https://docs.discord.com/developers/resources/application#application-object-application-integration-types

    Where an app can be installed, also called its supported installation contexts.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ApplicationIntegrationType): Bool => value() == that.value()
primitive GuildInstallApplicationIntegrationType is ApplicationIntegrationType
    """
    App is installable to servers
    """

    fun value(): U8 => 0
primitive UserInstallApplicationIntegrationType is ApplicationIntegrationType
    """
    App is installable to users
    """

    fun value(): U8 => 1
primitive ApplicationIntegrationTypes
    fun from(v: U8): ApplicationIntegrationType ? =>
        match v
        | 0 => GuildInstallApplicationIntegrationType
        | 1 => UserInstallApplicationIntegrationType
        else error
        end

class val ApplicationIntegrationTypeConfiguration
    """
    https://docs.discord.com/developers/resources/application#application-object-application-integration-type-configuration-object
    """

    let oauth2_install_params: (InstallParams | None)
        """
        Install params for each installation context’s default in-app authorization link
        """

    new val from_json(obj: json.JsonObject) ? =>
        var oauth2_install_params': (InstallParams | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "oauth2_install_params" => oauth2_install_params' = InstallParams.from_json(value as json.JsonObject)?
            end
        end

        oauth2_install_params = oauth2_install_params'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match oauth2_install_params
        | let p: InstallParams => obj = obj.update("oauth2_install_params", p.to_json())
        end

        obj

primitive _IntegrationTypesConfiguration
    fun apply(value: json.JsonValue): (collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration] | None) ? =>
        """
        Decodes a dictionary keyed by application integration type.
        """

        match value
        | let obj: json.JsonObject =>
            let map = collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration](obj.size())
            for (key, value') in obj.pairs() do
                map(ApplicationIntegrationTypes.from(key.u8()?)?) = ApplicationIntegrationTypeConfiguration.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[ApplicationIntegrationType, ApplicationIntegrationTypeConfiguration] box): json.JsonObject =>
        var obj = json.JsonObject
        for (type', configuration) in map.pairs() do obj = obj.update(type'.value().string(), configuration.to_json()) end
        obj

trait val ApplicationEventWebhookStatus is (collections.Hashable & Equatable[ApplicationEventWebhookStatus])
    """
    https://docs.discord.com/developers/resources/application#application-object-application-event-webhook-status

    Status indicating whether event webhooks are enabled or disabled for an application
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ApplicationEventWebhookStatus): Bool => value() == that.value()
primitive DisabledApplicationEventWebhookStatus is ApplicationEventWebhookStatus
    """
    Webhook events are disabled by developer
    """

    fun value(): U8 => 1
primitive EnabledApplicationEventWebhookStatus is ApplicationEventWebhookStatus
    """
    Webhook events are enabled by developer
    """

    fun value(): U8 => 2
primitive DisabledByDiscordApplicationEventWebhookStatus is ApplicationEventWebhookStatus
    """
    Webhook events are disabled by Discord, usually due to inactivity
    """

    fun value(): U8 => 3
primitive ApplicationEventWebhookStatuses
    fun from(v: U8): ApplicationEventWebhookStatus ? =>
        match v
        | 1 => DisabledApplicationEventWebhookStatus
        | 2 => EnabledApplicationEventWebhookStatus
        | 3 => DisabledByDiscordApplicationEventWebhookStatus
        else error
        end

trait val ApplicationFlag is (collections.Hashable & Equatable[ApplicationFlag])
    """
    https://docs.discord.com/developers/resources/application#application-object-application-flags

    The flags field is serialized as a number; however, this number will not grow beyond 31 bits. New flag bits beyond bit 30 will only appear in flags_new, a string-serialized integer containing the full set of flag bits. Existing integrations consuming flags are not impacted. flags_new is for response serialization only — requests that accept flag values should continue to use the original flags field.
    """

    fun value(): U8
        """
        Represents the bit-shift value. Unshift by this value to get the flag.
        """

    fun hash(): USize => value().hash()

    fun eq(that: ApplicationFlag): Bool => value() == that.value()
primitive ApplicationAutoModerationRuleCreateBadgeApplicationFlag is ApplicationFlag
    """
    Indicates if an app uses the Auto Moderation API
    """

    fun value(): U8 => 6
primitive GatewayPresenceApplicationFlag is ApplicationFlag
    """
    Intent required for bots in 100 or more servers to receive presence_update events
    """

    fun value(): U8 => 12
primitive GatewayPresenceLimitedApplicationFlag is ApplicationFlag
    """
    Intent required for bots in under 100 servers to receive presence_update events, found on the Bot page in your app’s settings
    """

    fun value(): U8 => 13
primitive GatewayGuildMembersApplicationFlag is ApplicationFlag
    """
    Intent required for bots in 100 or more servers to receive member-related events like guild_member_add
    """

    fun value(): U8 => 14
primitive GatewayGuildMembersLimitedApplicationFlag is ApplicationFlag
    """
    Intent required for bots in under 100 servers to receive member-related events like guild_member_add, found on the Bot page in your app’s settings
    """

    fun value(): U8 => 15
primitive VerificationPendingGuildLimitApplicationFlag is ApplicationFlag
    """
    Indicates unusual growth of an app that prevents verification
    """

    fun value(): U8 => 16
primitive EmbeddedApplicationFlag is ApplicationFlag
    """
    Indicates if an app is embedded within the Discord client (currently unavailable publicly)
    """

    fun value(): U8 => 17
primitive GatewayMessageContentApplicationFlag is ApplicationFlag
    """
    Intent required for bots in 100 or more servers to receive message content
    """

    fun value(): U8 => 18
primitive GatewayMessageContentLimitedApplicationFlag is ApplicationFlag
    """
    Intent required for bots in under 100 servers to receive message content, found on the Bot page in your app’s settings
    """

    fun value(): U8 => 19
primitive ApplicationCommandBadgeApplicationFlag is ApplicationFlag
    """
    Indicates if an app has registered global application commands
    """

    fun value(): U8 => 23
primitive ApplicationFlags
    fun from(v: U8): ApplicationFlag ? =>
        match v
        | 6 => ApplicationAutoModerationRuleCreateBadgeApplicationFlag
        | 12 => GatewayPresenceApplicationFlag
        | 13 => GatewayPresenceLimitedApplicationFlag
        | 14 => GatewayGuildMembersApplicationFlag
        | 15 => GatewayGuildMembersLimitedApplicationFlag
        | 16 => VerificationPendingGuildLimitApplicationFlag
        | 17 => EmbeddedApplicationFlag
        | 18 => GatewayMessageContentApplicationFlag
        | 19 => GatewayMessageContentLimitedApplicationFlag
        | 23 => ApplicationCommandBadgeApplicationFlag
        else error
        end

primitive _ApplicationFlags
    fun apply(bits: U64): Array[ApplicationFlag] val =>
        recover val
            let flags = Array[ApplicationFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(ApplicationFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[ApplicationFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

class val InstallParams
    """
    https://docs.discord.com/developers/resources/application#install-params-object-install-params-structure
    """

    let scopes: Array[String] val
        """
        Scopes to add the application to the server with
        """

    // TODO(vxern): Represent as permission flags once `Permission` is implemented.
    let permissions: String
        """
        Permissions to request for the bot role
        """

    new val from_json(obj: json.JsonObject) ? =>
        var scopes': (Array[String] val | None) = None
        var permissions': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "scopes" => scopes' = _Strings(value)?
            | "permissions" => permissions' = value as String
            end
        end

        scopes = scopes' as Array[String] val
        permissions = permissions' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("scopes", _Strings.to_json(scopes))
            .update("permissions", permissions)

primitive _Strings
    fun apply(value: json.JsonValue): Array[String] val ? =>
        """
        Decodes an array of strings.
        """

        let array = value as json.JsonArray
        recover val
            let strings = Array[String](array.size())
            for string in array.values() do strings.push(string as String) end
            strings
        end

    fun to_json(strings: Array[String] val): json.JsonArray =>
        var array = json.JsonArray
        for string in strings.values() do array = array.push(string) end
        array
