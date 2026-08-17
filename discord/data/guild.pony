use collections = "collections"
use json = "json"

class val Guild is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-object-guild-structure

    Guilds in Discord represent an isolated collection of users and channels,
    and are often referred to as "servers" in the UI.
    """

    let id: Snowflake
        """
        guild id
        """

    let name: String
        """
        guild name (2-100 characters, excluding trailing and leading whitespace)
        """

    let icon: (String | None)
        """
        icon hash
        """

    let icon_hash: (String | None)
        """
        icon hash, returned when in the template object
        """

    let splash: (String | None)
        """
        splash hash
        """

    let discovery_splash: (String | None)
        """
        discovery splash hash; only present for guilds with the "DISCOVERABLE"
        feature
        """

    let owner: (Bool | None)
        """
        true if the user is the owner of the guild
        """

    let owner_id: Snowflake
        """
        id of owner
        """

    let permissions: (Array[Permission] val | None)
        """
        total permissions for the user in the guild (excludes overwrites and
        implicit permissions)
        """

    let afk_channel_id: (Snowflake | None)
        """
        id of afk channel
        """

    let afk_timeout: USize
        """
        afk timeout in seconds
        """

    let widget_enabled: (Bool | None)
        """
        true if the server widget is enabled
        """

    let widget_channel_id: (Snowflake | None)
        """
        the channel id that the widget will generate an invite to, or null if
        set to no invite
        """

    let verification_level: VerificationLevel
        """
        verification level required for the guild
        """

    let default_message_notifications: DefaultMessageNotificationLevel
        """
        default message notifications level
        """

    let explicit_content_filter: ExplicitContentFilterLevel
        """
        explicit content filter level
        """

    let roles: Array[Role] val
        """
        roles in the guild
        """

    let emojis: Array[Emoji] val
        """
        custom guild emojis
        """

    let features: Array[String] val
        """
        enabled guild features

        Features are left as strings rather than decoded into an enum because
        Discord adds new feature flags without notice, and an unrecognised one
        would otherwise fail the decode of the whole guild.
        """

    let mfa_level: MFALevel
        """
        required MFA level for the guild
        """

    let application_id: (Snowflake | None)
        """
        application id of the guild creator if it is bot-created
        """

    let system_channel_id: (Snowflake | None)
        """
        the id of the channel where guild notices such as welcome messages and
        boost events are posted
        """

    let system_channel_flags: Array[SystemChannelFlag] val
        """
        system channel flags
        """

    let rules_channel_id: (Snowflake | None)
        """
        the id of the channel where Community guilds can display rules and/or
        guidelines
        """

    let max_presences: (USize | None)
        """
        the maximum number of presences for the guild (null is always returned,
        apart from the largest of guilds)
        """

    let max_members: (USize | None)
        """
        the maximum number of members for the guild
        """

    let vanity_url_code: (String | None)
        """
        the vanity url code for the guild
        """

    let description: (String | None)
        """
        the description of a guild
        """

    let banner: (String | None)
        """
        banner hash
        """

    let premium_tier: PremiumTier
        """
        premium tier (Server Boost level)
        """

    let premium_subscription_count: (USize | None)
        """
        the number of boosts this guild currently has
        """

    let preferred_locale: Locale
        """
        the preferred locale of a Community guild; used in server discovery and
        notices from Discord, and sent in interactions; defaults to "en-US"
        """

    let public_updates_channel_id: (Snowflake | None)
        """
        the id of the channel where admins and moderators of Community guilds
        receive notices from Discord
        """

    let max_video_channel_users: (USize | None)
        """
        the maximum amount of users in a video channel
        """

    let max_stage_video_channel_users: (USize | None)
        """
        the maximum amount of users in a stage video channel
        """

    let approximate_member_count: (USize | None)
        """
        approximate number of members in this guild, returned from the GET
        /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
        """

    let approximate_presence_count: (USize | None)
        """
        approximate number of non-offline members in this guild, returned from
        the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is
        true
        """

    let welcome_screen: (WelcomeScreen | None)
        """
        the welcome screen of a Community guild, shown to new members, returned
        in an Invite's guild object
        """

    let nsfw_level: GuildNSFWLevel
        """
        guild NSFW level
        """

    let stickers: (Array[Sticker] val | None)
        """
        custom guild stickers
        """

    let premium_progress_bar_enabled: Bool
        """
        whether the guild has the boost progress bar enabled
        """

    let safety_alerts_channel_id: (Snowflake | None)
        """
        the id of the channel where admins and moderators of Community guilds
        receive safety alerts from Discord
        """

    let incidents_data: (IncidentsData | None)
        """
        the incidents data for this guild
        """

    new val create(
        id': Snowflake,
        name': String,
        icon': (String | None) = None,
        icon_hash': (String | None) = None,
        splash': (String | None) = None,
        discovery_splash': (String | None) = None,
        owner': (Bool | None) = None,
        owner_id': Snowflake,
        permissions': (Array[Permission] val | None) = None,
        afk_channel_id': (Snowflake | None) = None,
        afk_timeout': USize,
        widget_enabled': (Bool | None) = None,
        widget_channel_id': (Snowflake | None) = None,
        verification_level': VerificationLevel,
        default_message_notifications': DefaultMessageNotificationLevel,
        explicit_content_filter': ExplicitContentFilterLevel,
        roles': Array[Role] val,
        emojis': Array[Emoji] val,
        features': Array[String] val,
        mfa_level': MFALevel,
        application_id': (Snowflake | None) = None,
        system_channel_id': (Snowflake | None) = None,
        system_channel_flags': Array[SystemChannelFlag] val,
        rules_channel_id': (Snowflake | None) = None,
        max_presences': (USize | None) = None,
        max_members': (USize | None) = None,
        vanity_url_code': (String | None) = None,
        description': (String | None) = None,
        banner': (String | None) = None,
        premium_tier': PremiumTier,
        premium_subscription_count': (USize | None) = None,
        preferred_locale': Locale,
        public_updates_channel_id': (Snowflake | None) = None,
        max_video_channel_users': (USize | None) = None,
        max_stage_video_channel_users': (USize | None) = None,
        approximate_member_count': (USize | None) = None,
        approximate_presence_count': (USize | None) = None,
        welcome_screen': (WelcomeScreen | None) = None,
        nsfw_level': GuildNSFWLevel,
        stickers': (Array[Sticker] val | None) = None,
        premium_progress_bar_enabled': Bool,
        safety_alerts_channel_id': (Snowflake | None) = None,
        incidents_data': (IncidentsData | None) = None
    ) =>
        id = id'
        name = name'
        icon = icon'
        icon_hash = icon_hash'
        splash = splash'
        discovery_splash = discovery_splash'
        owner = owner'
        owner_id = owner_id'
        permissions = permissions'
        afk_channel_id = afk_channel_id'
        afk_timeout = afk_timeout'
        widget_enabled = widget_enabled'
        widget_channel_id = widget_channel_id'
        verification_level = verification_level'
        default_message_notifications = default_message_notifications'
        explicit_content_filter = explicit_content_filter'
        roles = roles'
        emojis = emojis'
        features = features'
        mfa_level = mfa_level'
        application_id = application_id'
        system_channel_id = system_channel_id'
        system_channel_flags = system_channel_flags'
        rules_channel_id = rules_channel_id'
        max_presences = max_presences'
        max_members = max_members'
        vanity_url_code = vanity_url_code'
        description = description'
        banner = banner'
        premium_tier = premium_tier'
        premium_subscription_count = premium_subscription_count'
        preferred_locale = preferred_locale'
        public_updates_channel_id = public_updates_channel_id'
        max_video_channel_users = max_video_channel_users'
        max_stage_video_channel_users = max_stage_video_channel_users'
        approximate_member_count = approximate_member_count'
        approximate_presence_count = approximate_presence_count'
        welcome_screen = welcome_screen'
        nsfw_level = nsfw_level'
        stickers = stickers'
        premium_progress_bar_enabled = premium_progress_bar_enabled'
        safety_alerts_channel_id = safety_alerts_channel_id'
        incidents_data = incidents_data'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var icon': (String | None) = None
        var icon_hash': (String | None) = None
        var splash': (String | None) = None
        var discovery_splash': (String | None) = None
        var owner': (Bool | None) = None
        var owner_id': (Snowflake | None) = None
        var permissions': (Array[Permission] val | None) = None
        var afk_channel_id': (Snowflake | None) = None
        var afk_timeout': (USize | None) = None
        var widget_enabled': (Bool | None) = None
        var widget_channel_id': (Snowflake | None) = None
        var verification_level': (VerificationLevel | None) = None
        var default_message_notifications': (
            DefaultMessageNotificationLevel | None
        ) =
            None
        var explicit_content_filter': (ExplicitContentFilterLevel | None) = None
        var roles': (Array[Role] val | None) = None
        var emojis': (Array[Emoji] val | None) = None
        var features': (Array[String] val | None) = None
        var mfa_level': (MFALevel | None) = None
        var application_id': (Snowflake | None) = None
        var system_channel_id': (Snowflake | None) = None
        var system_channel_flags': (Array[SystemChannelFlag] val | None) = None
        var rules_channel_id': (Snowflake | None) = None
        var max_presences': (USize | None) = None
        var max_members': (USize | None) = None
        var vanity_url_code': (String | None) = None
        var description': (String | None) = None
        var banner': (String | None) = None
        var premium_tier': (PremiumTier | None) = None
        var premium_subscription_count': (USize | None) = None
        var preferred_locale': (Locale | None) = None
        var public_updates_channel_id': (Snowflake | None) = None
        var max_video_channel_users': (USize | None) = None
        var max_stage_video_channel_users': (USize | None) = None
        var approximate_member_count': (USize | None) = None
        var approximate_presence_count': (USize | None) = None
        var welcome_screen': (WelcomeScreen | None) = None
        var nsfw_level': (GuildNSFWLevel | None) = None
        var stickers': (Array[Sticker] val | None) = None
        var premium_progress_bar_enabled': (Bool | None) = None
        var safety_alerts_channel_id': (Snowflake | None) = None
        var incidents_data': (IncidentsData | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "icon" =>
                match value | let string: String => icon' = string end
            | "icon_hash" =>
                match value | let string: String => icon_hash' = string end
            | "splash" =>
                match value | let string: String => splash' = string end
            | "discovery_splash" =>
                match value
                | let string: String => discovery_splash' = string
                end
            | "owner" => owner' = value as Bool
            | "owner_id" => owner_id' = Snowflake.from_json(value)?
            | "permissions" => permissions' = _Permissions(value)?
            | "afk_channel_id" =>
                match value
                | let string: String =>
                    afk_channel_id' = Snowflake.from_json(string)?
                end
            | "afk_timeout" => afk_timeout' = (value as I64).usize()
            | "widget_enabled" => widget_enabled' = value as Bool
            | "widget_channel_id" =>
                match value
                | let string: String =>
                    widget_channel_id' = Snowflake.from_json(string)?
                end
            | "verification_level" =>
                verification_level' =
                    VerificationLevels.from((value as I64).u8())?
            | "default_message_notifications" =>
                default_message_notifications' =
                    DefaultMessageNotificationLevels.from((value as I64).u8())?
            | "explicit_content_filter" =>
                explicit_content_filter' =
                    ExplicitContentFilterLevels.from((value as I64).u8())?
            | "roles" => roles' = _Roles(value)?
            | "emojis" => emojis' = _Emojis(value)?
            | "features" => features' = _Strings(value)?
            | "mfa_level" => mfa_level' = MFALevels.from((value as I64).u8())?
            | "application_id" =>
                match value
                | let string: String =>
                    application_id' = Snowflake.from_json(string)?
                end
            | "system_channel_id" =>
                match value
                | let string: String =>
                    system_channel_id' = Snowflake.from_json(string)?
                end
            | "system_channel_flags" =>
                system_channel_flags' =
                    _SystemChannelFlags((value as I64).u64())
            | "rules_channel_id" =>
                match value
                | let string: String =>
                    rules_channel_id' = Snowflake.from_json(string)?
                end
            | "max_presences" =>
                match value
                | let integer: I64 => max_presences' = integer.usize()
                end
            | "max_members" => max_members' = (value as I64).usize()
            | "vanity_url_code" =>
                match value
                | let string: String => vanity_url_code' = string
                end
            | "description" =>
                match value | let string: String => description' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "premium_tier" =>
                premium_tier' = PremiumTiers.from((value as I64).u8())?
            | "premium_subscription_count" =>
                premium_subscription_count' = (value as I64).usize()
            | "preferred_locale" =>
                preferred_locale' = Locales.from(value as String)?
            | "public_updates_channel_id" =>
                match value
                | let string: String =>
                    public_updates_channel_id' = Snowflake.from_json(string)?
                end
            | "max_video_channel_users" =>
                max_video_channel_users' = (value as I64).usize()
            | "max_stage_video_channel_users" =>
                max_stage_video_channel_users' = (value as I64).usize()
            | "approximate_member_count" =>
                approximate_member_count' = (value as I64).usize()
            | "approximate_presence_count" =>
                approximate_presence_count' = (value as I64).usize()
            | "welcome_screen" =>
                welcome_screen' =
                    WelcomeScreen.from_json(value as json.JsonObject)?
            | "nsfw_level" =>
                nsfw_level' = GuildNSFWLevels.from((value as I64).u8())?
            | "stickers" => stickers' = _Stickers(value)?
            | "premium_progress_bar_enabled" =>
                premium_progress_bar_enabled' = value as Bool
            | "safety_alerts_channel_id" =>
                match value
                | let string: String =>
                    safety_alerts_channel_id' = Snowflake.from_json(string)?
                end
            | "incidents_data" =>
                match value
                | let obj': json.JsonObject =>
                    incidents_data' = IncidentsData.from_json(obj')
                end
            end
        end

        id = id' as Snowflake
        name = name' as String
        icon = icon'
        icon_hash = icon_hash'
        splash = splash'
        discovery_splash = discovery_splash'
        owner = owner'
        owner_id = owner_id' as Snowflake
        permissions = permissions'
        afk_channel_id = afk_channel_id'
        afk_timeout = afk_timeout' as USize
        widget_enabled = widget_enabled'
        widget_channel_id = widget_channel_id'
        verification_level = verification_level' as VerificationLevel
        default_message_notifications =
            default_message_notifications' as DefaultMessageNotificationLevel
        explicit_content_filter =
            explicit_content_filter' as ExplicitContentFilterLevel
        roles = roles' as Array[Role] val
        emojis = emojis' as Array[Emoji] val
        features = features' as Array[String] val
        mfa_level = mfa_level' as MFALevel
        application_id = application_id'
        system_channel_id = system_channel_id'
        system_channel_flags =
            system_channel_flags' as Array[SystemChannelFlag] val
        rules_channel_id = rules_channel_id'
        max_presences = max_presences'
        max_members = max_members'
        vanity_url_code = vanity_url_code'
        description = description'
        banner = banner'
        premium_tier = premium_tier' as PremiumTier
        premium_subscription_count = premium_subscription_count'
        preferred_locale = preferred_locale' as Locale
        public_updates_channel_id = public_updates_channel_id'
        max_video_channel_users = max_video_channel_users'
        max_stage_video_channel_users = max_stage_video_channel_users'
        approximate_member_count = approximate_member_count'
        approximate_presence_count = approximate_presence_count'
        welcome_screen = welcome_screen'
        nsfw_level = nsfw_level' as GuildNSFWLevel
        stickers = stickers'
        premium_progress_bar_enabled = premium_progress_bar_enabled' as Bool
        safety_alerts_channel_id = safety_alerts_channel_id'
        incidents_data = incidents_data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("icon", icon)
            .update("splash", splash)
            .update("discovery_splash", discovery_splash)
            .update("owner_id", owner_id.to_json())
            .update(
                "afk_channel_id",
                match afk_channel_id
                | let afk_channel_id': Snowflake => afk_channel_id'.to_json()
                end
            )
            .update("afk_timeout", afk_timeout.i64())
            .update("verification_level", verification_level.value().i64())
            .update(
                "default_message_notifications",
                default_message_notifications.value().i64()
            )
            .update(
                "explicit_content_filter", explicit_content_filter.value().i64()
            )
            .update("roles", _Roles.to_json(roles))
            .update("emojis", _Emojis.to_json(emojis))
            .update("features", _Strings.to_json(features))
            .update("mfa_level", mfa_level.value().i64())
            .update(
                "application_id",
                match application_id
                | let application_id': Snowflake => application_id'.to_json()
                end
            )
            .update(
                "system_channel_id",
                match system_channel_id
                | let system_channel_id': Snowflake =>
                    system_channel_id'.to_json()
                end
            )
            .update(
                "system_channel_flags",
                _SystemChannelFlags.to_json(system_channel_flags)
            )
            .update(
                "rules_channel_id",
                match rules_channel_id
                | let rules_channel_id': Snowflake =>
                    rules_channel_id'.to_json()
                end
            )
            .update("vanity_url_code", vanity_url_code)
            .update("description", description)
            .update("banner", banner)
            .update("premium_tier", premium_tier.value().i64())
            .update("preferred_locale", preferred_locale.value())
            .update(
                "public_updates_channel_id",
                match public_updates_channel_id
                | let public_updates_channel_id': Snowflake =>
                    public_updates_channel_id'.to_json()
                end
            )
            .update("nsfw_level", nsfw_level.value().i64())
            .update(
                "premium_progress_bar_enabled", premium_progress_bar_enabled
            )
            .update(
                "safety_alerts_channel_id",
                match safety_alerts_channel_id
                | let safety_alerts_channel_id': Snowflake =>
                    safety_alerts_channel_id'.to_json()
                end
            )
            .update(
                "incidents_data",
                match incidents_data
                | let incidents_data': IncidentsData =>
                    incidents_data'.to_json()
                end
            )

        match icon_hash
        | let icon_hash': String => obj = obj.update("icon_hash", icon_hash')
        end

        match owner
        | let owner': Bool => obj = obj.update("owner", owner')
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match widget_enabled
        | let widget_enabled': Bool =>
            obj = obj.update("widget_enabled", widget_enabled')
        end

        match widget_channel_id
        | let widget_channel_id': Snowflake =>
            obj = obj.update("widget_channel_id", widget_channel_id'.to_json())
        end

        match max_presences
        | let max_presences': USize =>
            obj = obj.update("max_presences", max_presences'.i64())
        end

        match max_members
        | let max_members': USize =>
            obj = obj.update("max_members", max_members'.i64())
        end

        match premium_subscription_count
        | let premium_subscription_count': USize =>
            obj =
                obj.update(
                    "premium_subscription_count",
                    premium_subscription_count'.i64()
                )
        end

        match max_video_channel_users
        | let max_video_channel_users': USize =>
            obj =
                obj.update(
                    "max_video_channel_users", max_video_channel_users'.i64()
                )
        end

        match max_stage_video_channel_users
        | let max_stage_video_channel_users': USize =>
            obj =
                obj.update(
                    "max_stage_video_channel_users",
                    max_stage_video_channel_users'.i64()
                )
        end

        match approximate_member_count
        | let approximate_member_count': USize =>
            obj =
                obj.update(
                    "approximate_member_count", approximate_member_count'.i64()
                )
        end

        match approximate_presence_count
        | let approximate_presence_count': USize =>
            obj =
                obj.update(
                    "approximate_presence_count",
                    approximate_presence_count'.i64()
                )
        end

        match welcome_screen
        | let welcome_screen': WelcomeScreen =>
            obj = obj.update("welcome_screen", welcome_screen'.to_json())
        end

        match stickers
        | let stickers': Array[Sticker] val =>
            obj = obj.update("stickers", _Stickers.to_json(stickers'))
        end

        obj

primitive _Guilds
    fun apply(value: json.JsonValue): Array[Guild] val ? =>
        """
        Decodes an array of guilds.
        """

        let array = value as json.JsonArray
        recover val
            let guilds = Array[Guild](array.size())
            for guild in array.values() do
                guilds.push(Guild.from_json(guild as json.JsonObject)?)
            end
            guilds
        end

    fun to_json(guilds: Array[Guild] val): json.JsonArray =>
        var array = json.JsonArray
        for guild in guilds.values() do array = array.push(guild.to_json()) end
        array

class val PartialGuild is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-object-guild-structure

    A guild Discord sent as a *partial* object: the same structure as `Guild`,
    but carrying only some of its fields. Invites, webhooks, interactions and
    applications all embed guilds this way, and none of them agree on which
    fields they include, so every field here but `id` is optional.

    The fields mean exactly what their `Guild` counterparts do, and are
    documented there. `Guild` is what a route hands back when it promises a
    whole guild; this is what it hands back when it promises a piece of one. A
    field Discord omits is indistinguishable from a field Discord sent as
    `null`.
    """

    let id: Snowflake
    let name: (String | None)
    let icon: (String | None)
    let icon_hash: (String | None)
    let splash: (String | None)
    let discovery_splash: (String | None)
    let owner: (Bool | None)
    let owner_id: (Snowflake | None)
    let permissions: (Array[Permission] val | None)
    let afk_channel_id: (Snowflake | None)
    let afk_timeout: (USize | None)
    let widget_enabled: (Bool | None)
    let widget_channel_id: (Snowflake | None)
    let verification_level: (VerificationLevel | None)
    let default_message_notifications: (DefaultMessageNotificationLevel | None)
    let explicit_content_filter: (ExplicitContentFilterLevel | None)
    let roles: (Array[Role] val | None)
    let emojis: (Array[Emoji] val | None)
    let features: (Array[String] val | None)
    let mfa_level: (MFALevel | None)
    let application_id: (Snowflake | None)
    let system_channel_id: (Snowflake | None)
    let system_channel_flags: (Array[SystemChannelFlag] val | None)
    let rules_channel_id: (Snowflake | None)
    let max_presences: (USize | None)
    let max_members: (USize | None)
    let vanity_url_code: (String | None)
    let description: (String | None)
    let banner: (String | None)
    let premium_tier: (PremiumTier | None)
    let premium_subscription_count: (USize | None)
    let preferred_locale: (Locale | None)
    let public_updates_channel_id: (Snowflake | None)
    let max_video_channel_users: (USize | None)
    let max_stage_video_channel_users: (USize | None)
    let approximate_member_count: (USize | None)
    let approximate_presence_count: (USize | None)
    let welcome_screen: (WelcomeScreen | None)
    let nsfw_level: (GuildNSFWLevel | None)
    let stickers: (Array[Sticker] val | None)
    let premium_progress_bar_enabled: (Bool | None)
    let safety_alerts_channel_id: (Snowflake | None)
    let incidents_data: (IncidentsData | None)

    new val create(
        id': Snowflake,
        name': (String | None) = None,
        icon': (String | None) = None,
        icon_hash': (String | None) = None,
        splash': (String | None) = None,
        discovery_splash': (String | None) = None,
        owner': (Bool | None) = None,
        owner_id': (Snowflake | None) = None,
        permissions': (Array[Permission] val | None) = None,
        afk_channel_id': (Snowflake | None) = None,
        afk_timeout': (USize | None) = None,
        widget_enabled': (Bool | None) = None,
        widget_channel_id': (Snowflake | None) = None,
        verification_level': (VerificationLevel | None) = None,
        default_message_notifications': (
            DefaultMessageNotificationLevel | None
        ) =
            None,
        explicit_content_filter': (ExplicitContentFilterLevel | None) = None,
        roles': (Array[Role] val | None) = None,
        emojis': (Array[Emoji] val | None) = None,
        features': (Array[String] val | None) = None,
        mfa_level': (MFALevel | None) = None,
        application_id': (Snowflake | None) = None,
        system_channel_id': (Snowflake | None) = None,
        system_channel_flags': (Array[SystemChannelFlag] val | None) = None,
        rules_channel_id': (Snowflake | None) = None,
        max_presences': (USize | None) = None,
        max_members': (USize | None) = None,
        vanity_url_code': (String | None) = None,
        description': (String | None) = None,
        banner': (String | None) = None,
        premium_tier': (PremiumTier | None) = None,
        premium_subscription_count': (USize | None) = None,
        preferred_locale': (Locale | None) = None,
        public_updates_channel_id': (Snowflake | None) = None,
        max_video_channel_users': (USize | None) = None,
        max_stage_video_channel_users': (USize | None) = None,
        approximate_member_count': (USize | None) = None,
        approximate_presence_count': (USize | None) = None,
        welcome_screen': (WelcomeScreen | None) = None,
        nsfw_level': (GuildNSFWLevel | None) = None,
        stickers': (Array[Sticker] val | None) = None,
        premium_progress_bar_enabled': (Bool | None) = None,
        safety_alerts_channel_id': (Snowflake | None) = None,
        incidents_data': (IncidentsData | None) = None
    ) =>
        id = id'
        name = name'
        icon = icon'
        icon_hash = icon_hash'
        splash = splash'
        discovery_splash = discovery_splash'
        owner = owner'
        owner_id = owner_id'
        permissions = permissions'
        afk_channel_id = afk_channel_id'
        afk_timeout = afk_timeout'
        widget_enabled = widget_enabled'
        widget_channel_id = widget_channel_id'
        verification_level = verification_level'
        default_message_notifications = default_message_notifications'
        explicit_content_filter = explicit_content_filter'
        roles = roles'
        emojis = emojis'
        features = features'
        mfa_level = mfa_level'
        application_id = application_id'
        system_channel_id = system_channel_id'
        system_channel_flags = system_channel_flags'
        rules_channel_id = rules_channel_id'
        max_presences = max_presences'
        max_members = max_members'
        vanity_url_code = vanity_url_code'
        description = description'
        banner = banner'
        premium_tier = premium_tier'
        premium_subscription_count = premium_subscription_count'
        preferred_locale = preferred_locale'
        public_updates_channel_id = public_updates_channel_id'
        max_video_channel_users = max_video_channel_users'
        max_stage_video_channel_users = max_stage_video_channel_users'
        approximate_member_count = approximate_member_count'
        approximate_presence_count = approximate_presence_count'
        welcome_screen = welcome_screen'
        nsfw_level = nsfw_level'
        stickers = stickers'
        premium_progress_bar_enabled = premium_progress_bar_enabled'
        safety_alerts_channel_id = safety_alerts_channel_id'
        incidents_data = incidents_data'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var icon': (String | None) = None
        var icon_hash': (String | None) = None
        var splash': (String | None) = None
        var discovery_splash': (String | None) = None
        var owner': (Bool | None) = None
        var owner_id': (Snowflake | None) = None
        var permissions': (Array[Permission] val | None) = None
        var afk_channel_id': (Snowflake | None) = None
        var afk_timeout': (USize | None) = None
        var widget_enabled': (Bool | None) = None
        var widget_channel_id': (Snowflake | None) = None
        var verification_level': (VerificationLevel | None) = None
        var default_message_notifications': (
            DefaultMessageNotificationLevel | None
        ) =
            None
        var explicit_content_filter': (ExplicitContentFilterLevel | None) = None
        var roles': (Array[Role] val | None) = None
        var emojis': (Array[Emoji] val | None) = None
        var features': (Array[String] val | None) = None
        var mfa_level': (MFALevel | None) = None
        var application_id': (Snowflake | None) = None
        var system_channel_id': (Snowflake | None) = None
        var system_channel_flags': (Array[SystemChannelFlag] val | None) = None
        var rules_channel_id': (Snowflake | None) = None
        var max_presences': (USize | None) = None
        var max_members': (USize | None) = None
        var vanity_url_code': (String | None) = None
        var description': (String | None) = None
        var banner': (String | None) = None
        var premium_tier': (PremiumTier | None) = None
        var premium_subscription_count': (USize | None) = None
        var preferred_locale': (Locale | None) = None
        var public_updates_channel_id': (Snowflake | None) = None
        var max_video_channel_users': (USize | None) = None
        var max_stage_video_channel_users': (USize | None) = None
        var approximate_member_count': (USize | None) = None
        var approximate_presence_count': (USize | None) = None
        var welcome_screen': (WelcomeScreen | None) = None
        var nsfw_level': (GuildNSFWLevel | None) = None
        var stickers': (Array[Sticker] val | None) = None
        var premium_progress_bar_enabled': (Bool | None) = None
        var safety_alerts_channel_id': (Snowflake | None) = None
        var incidents_data': (IncidentsData | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" =>
                match value | let string: String => name' = string end
            | "icon" =>
                match value | let string: String => icon' = string end
            | "icon_hash" =>
                match value | let string: String => icon_hash' = string end
            | "splash" =>
                match value | let string: String => splash' = string end
            | "discovery_splash" =>
                match value
                | let string: String => discovery_splash' = string
                end
            | "owner" => owner' = value as Bool
            | "owner_id" => owner_id' = Snowflake.from_json(value)?
            | "permissions" => permissions' = _Permissions(value)?
            | "afk_channel_id" =>
                match value
                | let string: String =>
                    afk_channel_id' = Snowflake.from_json(string)?
                end
            | "afk_timeout" => afk_timeout' = (value as I64).usize()
            | "widget_enabled" => widget_enabled' = value as Bool
            | "widget_channel_id" =>
                match value
                | let string: String =>
                    widget_channel_id' = Snowflake.from_json(string)?
                end
            | "verification_level" =>
                verification_level' =
                    VerificationLevels.from((value as I64).u8())?
            | "default_message_notifications" =>
                default_message_notifications' =
                    DefaultMessageNotificationLevels.from((value as I64).u8())?
            | "explicit_content_filter" =>
                explicit_content_filter' =
                    ExplicitContentFilterLevels.from((value as I64).u8())?
            | "roles" => roles' = _Roles(value)?
            | "emojis" => emojis' = _Emojis(value)?
            | "features" => features' = _Strings(value)?
            | "mfa_level" => mfa_level' = MFALevels.from((value as I64).u8())?
            | "application_id" =>
                match value
                | let string: String =>
                    application_id' = Snowflake.from_json(string)?
                end
            | "system_channel_id" =>
                match value
                | let string: String =>
                    system_channel_id' = Snowflake.from_json(string)?
                end
            | "system_channel_flags" =>
                system_channel_flags' =
                    _SystemChannelFlags((value as I64).u64())
            | "rules_channel_id" =>
                match value
                | let string: String =>
                    rules_channel_id' = Snowflake.from_json(string)?
                end
            | "max_presences" =>
                match value
                | let integer: I64 => max_presences' = integer.usize()
                end
            | "max_members" => max_members' = (value as I64).usize()
            | "vanity_url_code" =>
                match value
                | let string: String => vanity_url_code' = string
                end
            | "description" =>
                match value | let string: String => description' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "premium_tier" =>
                premium_tier' = PremiumTiers.from((value as I64).u8())?
            | "premium_subscription_count" =>
                premium_subscription_count' = (value as I64).usize()
            | "preferred_locale" =>
                preferred_locale' = Locales.from(value as String)?
            | "public_updates_channel_id" =>
                match value
                | let string: String =>
                    public_updates_channel_id' = Snowflake.from_json(string)?
                end
            | "max_video_channel_users" =>
                max_video_channel_users' = (value as I64).usize()
            | "max_stage_video_channel_users" =>
                max_stage_video_channel_users' = (value as I64).usize()
            | "approximate_member_count" =>
                approximate_member_count' = (value as I64).usize()
            | "approximate_presence_count" =>
                approximate_presence_count' = (value as I64).usize()
            | "welcome_screen" =>
                welcome_screen' =
                    WelcomeScreen.from_json(value as json.JsonObject)?
            | "nsfw_level" =>
                nsfw_level' = GuildNSFWLevels.from((value as I64).u8())?
            | "stickers" => stickers' = _Stickers(value)?
            | "premium_progress_bar_enabled" =>
                premium_progress_bar_enabled' = value as Bool
            | "safety_alerts_channel_id" =>
                match value
                | let string: String =>
                    safety_alerts_channel_id' = Snowflake.from_json(string)?
                end
            | "incidents_data" =>
                match value
                | let obj': json.JsonObject =>
                    incidents_data' = IncidentsData.from_json(obj')
                end
            end
        end

        id = id' as Snowflake
        name = name'
        icon = icon'
        icon_hash = icon_hash'
        splash = splash'
        discovery_splash = discovery_splash'
        owner = owner'
        owner_id = owner_id'
        permissions = permissions'
        afk_channel_id = afk_channel_id'
        afk_timeout = afk_timeout'
        widget_enabled = widget_enabled'
        widget_channel_id = widget_channel_id'
        verification_level = verification_level'
        default_message_notifications = default_message_notifications'
        explicit_content_filter = explicit_content_filter'
        roles = roles'
        emojis = emojis'
        features = features'
        mfa_level = mfa_level'
        application_id = application_id'
        system_channel_id = system_channel_id'
        system_channel_flags = system_channel_flags'
        rules_channel_id = rules_channel_id'
        max_presences = max_presences'
        max_members = max_members'
        vanity_url_code = vanity_url_code'
        description = description'
        banner = banner'
        premium_tier = premium_tier'
        premium_subscription_count = premium_subscription_count'
        preferred_locale = preferred_locale'
        public_updates_channel_id = public_updates_channel_id'
        max_video_channel_users = max_video_channel_users'
        max_stage_video_channel_users = max_stage_video_channel_users'
        approximate_member_count = approximate_member_count'
        approximate_presence_count = approximate_presence_count'
        welcome_screen = welcome_screen'
        nsfw_level = nsfw_level'
        stickers = stickers'
        premium_progress_bar_enabled = premium_progress_bar_enabled'
        safety_alerts_channel_id = safety_alerts_channel_id'
        incidents_data = incidents_data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match icon
        | let icon': String => obj = obj.update("icon", icon')
        end

        match icon_hash
        | let icon_hash': String => obj = obj.update("icon_hash", icon_hash')
        end

        match splash
        | let splash': String => obj = obj.update("splash", splash')
        end

        match discovery_splash
        | let discovery_splash': String =>
            obj = obj.update("discovery_splash", discovery_splash')
        end

        match owner
        | let owner': Bool => obj = obj.update("owner", owner')
        end

        match owner_id
        | let owner_id': Snowflake =>
            obj = obj.update("owner_id", owner_id'.to_json())
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match afk_channel_id
        | let afk_channel_id': Snowflake =>
            obj = obj.update("afk_channel_id", afk_channel_id'.to_json())
        end

        match afk_timeout
        | let afk_timeout': USize =>
            obj = obj.update("afk_timeout", afk_timeout'.i64())
        end

        match widget_enabled
        | let widget_enabled': Bool =>
            obj = obj.update("widget_enabled", widget_enabled')
        end

        match widget_channel_id
        | let widget_channel_id': Snowflake =>
            obj = obj.update("widget_channel_id", widget_channel_id'.to_json())
        end

        match verification_level
        | let verification_level': VerificationLevel =>
            obj =
                obj.update(
                    "verification_level", verification_level'.value().i64()
                )
        end

        match default_message_notifications
        | let default_message_notifications': DefaultMessageNotificationLevel =>
            obj =
                obj.update(
                    "default_message_notifications",
                    default_message_notifications'.value().i64()
                )
        end

        match explicit_content_filter
        | let explicit_content_filter': ExplicitContentFilterLevel =>
            obj =
                obj.update(
                    "explicit_content_filter",
                    explicit_content_filter'.value().i64()
                )
        end

        match roles
        | let roles': Array[Role] val =>
            obj = obj.update("roles", _Roles.to_json(roles'))
        end

        match emojis
        | let emojis': Array[Emoji] val =>
            obj = obj.update("emojis", _Emojis.to_json(emojis'))
        end

        match features
        | let features': Array[String] val =>
            obj = obj.update("features", _Strings.to_json(features'))
        end

        match mfa_level
        | let mfa_level': MFALevel =>
            obj = obj.update("mfa_level", mfa_level'.value().i64())
        end

        match application_id
        | let application_id': Snowflake =>
            obj = obj.update("application_id", application_id'.to_json())
        end

        match system_channel_id
        | let system_channel_id': Snowflake =>
            obj = obj.update("system_channel_id", system_channel_id'.to_json())
        end

        match system_channel_flags
        | let system_channel_flags': Array[SystemChannelFlag] val =>
            obj =
                obj.update(
                    "system_channel_flags",
                    _SystemChannelFlags.to_json(system_channel_flags')
                )
        end

        match rules_channel_id
        | let rules_channel_id': Snowflake =>
            obj = obj.update("rules_channel_id", rules_channel_id'.to_json())
        end

        match max_presences
        | let max_presences': USize =>
            obj = obj.update("max_presences", max_presences'.i64())
        end

        match max_members
        | let max_members': USize =>
            obj = obj.update("max_members", max_members'.i64())
        end

        match vanity_url_code
        | let vanity_url_code': String =>
            obj = obj.update("vanity_url_code", vanity_url_code')
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        end

        match banner
        | let banner': String => obj = obj.update("banner", banner')
        end

        match premium_tier
        | let premium_tier': PremiumTier =>
            obj = obj.update("premium_tier", premium_tier'.value().i64())
        end

        match premium_subscription_count
        | let premium_subscription_count': USize =>
            obj =
                obj.update(
                    "premium_subscription_count",
                    premium_subscription_count'.i64()
                )
        end

        match preferred_locale
        | let preferred_locale': Locale =>
            obj = obj.update("preferred_locale", preferred_locale'.value())
        end

        match public_updates_channel_id
        | let public_updates_channel_id': Snowflake =>
            obj =
                obj.update(
                    "public_updates_channel_id",
                    public_updates_channel_id'.to_json()
                )
        end

        match max_video_channel_users
        | let max_video_channel_users': USize =>
            obj =
                obj.update(
                    "max_video_channel_users", max_video_channel_users'.i64()
                )
        end

        match max_stage_video_channel_users
        | let max_stage_video_channel_users': USize =>
            obj =
                obj.update(
                    "max_stage_video_channel_users",
                    max_stage_video_channel_users'.i64()
                )
        end

        match approximate_member_count
        | let approximate_member_count': USize =>
            obj =
                obj.update(
                    "approximate_member_count", approximate_member_count'.i64()
                )
        end

        match approximate_presence_count
        | let approximate_presence_count': USize =>
            obj =
                obj.update(
                    "approximate_presence_count",
                    approximate_presence_count'.i64()
                )
        end

        match welcome_screen
        | let welcome_screen': WelcomeScreen =>
            obj = obj.update("welcome_screen", welcome_screen'.to_json())
        end

        match nsfw_level
        | let nsfw_level': GuildNSFWLevel =>
            obj = obj.update("nsfw_level", nsfw_level'.value().i64())
        end

        match stickers
        | let stickers': Array[Sticker] val =>
            obj = obj.update("stickers", _Stickers.to_json(stickers'))
        end

        match premium_progress_bar_enabled
        | let premium_progress_bar_enabled': Bool =>
            obj =
                obj.update(
                    "premium_progress_bar_enabled",
                    premium_progress_bar_enabled'
                )
        end

        match safety_alerts_channel_id
        | let safety_alerts_channel_id': Snowflake =>
            obj =
                obj.update(
                    "safety_alerts_channel_id",
                    safety_alerts_channel_id'.to_json()
                )
        end

        match incidents_data
        | let incidents_data': IncidentsData =>
            obj = obj.update("incidents_data", incidents_data'.to_json())
        end

        obj

primitive _PartialGuilds
    fun apply(value: json.JsonValue): Array[PartialGuild] val ? =>
        """
        Decodes an array of partial guilds.
        """

        let array = value as json.JsonArray
        recover val
            let guilds = Array[PartialGuild](array.size())
            for guild in array.values() do
                guilds.push(PartialGuild.from_json(guild as json.JsonObject)?)
            end
            guilds
        end

    fun to_json(guilds: Array[PartialGuild] val): json.JsonArray =>
        var array = json.JsonArray
        for guild in guilds.values() do array = array.push(guild.to_json()) end
        array

class val UnavailableGuild is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#unavailable-guild-object

    A partial guild object. Represents an Offline Guild, or a Guild whose
    information has not been provided through `GUILD_CREATE` events during the
    Gateway connect.
    """

    let id: Snowflake
        """
        guild id
        """

    let unavailable: (Bool | None)
        """
        `true` if this guild is unavailable due to an outage

        A `GUILD_DELETE` without this field set means the user was removed from
        the guild.
        """

    new val create(id': Snowflake, unavailable': (Bool | None) = None) =>
        id = id'
        unavailable = unavailable'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var unavailable': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "unavailable" => unavailable' = value as Bool
            end
        end

        id = id' as Snowflake
        unavailable = unavailable'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match unavailable
        | let unavailable': Bool =>
            obj = obj.update("unavailable", unavailable')
        end

        obj

primitive _UnavailableGuilds
    fun apply(value: json.JsonValue): Array[UnavailableGuild] val ? =>
        """
        Decodes an array of unavailable guilds.
        """

        let array = value as json.JsonArray
        recover val
            let guilds = Array[UnavailableGuild](array.size())
            for guild in array.values() do
                guilds.push(
                    UnavailableGuild.from_json(guild as json.JsonObject)?
                )
            end
            guilds
        end

    fun to_json(guilds: Array[UnavailableGuild] val): json.JsonArray =>
        var array = json.JsonArray
        for guild in guilds.values() do array = array.push(guild.to_json()) end
        array

trait val DefaultMessageNotificationLevel is _Enum[
    DefaultMessageNotificationLevel, U8
]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-default-message-notification-level
    """
primitive AllMessagesDefaultMessageNotificationLevel is
    DefaultMessageNotificationLevel
    """
    members will receive notifications for all messages by default
    """

    fun value(): U8 => 0
primitive OnlyMentionsDefaultMessageNotificationLevel is
    DefaultMessageNotificationLevel
    """
    members will receive notifications only for messages that @mention them by
    default
    """

    fun value(): U8 => 1
primitive DefaultMessageNotificationLevels
    fun from(value: U8): DefaultMessageNotificationLevel ? =>
        match value
        | 0 => AllMessagesDefaultMessageNotificationLevel
        | 1 => OnlyMentionsDefaultMessageNotificationLevel
        else error
        end

trait val ExplicitContentFilterLevel is _Enum[ExplicitContentFilterLevel, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-explicit-content-filter-level
    """
primitive DisabledExplicitContentFilterLevel is ExplicitContentFilterLevel
    """
    media content will not be scanned
    """

    fun value(): U8 => 0
primitive MembersWithoutRolesExplicitContentFilterLevel is
    ExplicitContentFilterLevel
    """
    media content sent by members without roles will be scanned
    """

    fun value(): U8 => 1
primitive AllMembersExplicitContentFilterLevel is ExplicitContentFilterLevel
    """
    media content sent by all members will be scanned
    """

    fun value(): U8 => 2
primitive ExplicitContentFilterLevels
    fun from(value: U8): ExplicitContentFilterLevel ? =>
        match value
        | 0 => DisabledExplicitContentFilterLevel
        | 1 => MembersWithoutRolesExplicitContentFilterLevel
        | 2 => AllMembersExplicitContentFilterLevel
        else error
        end

trait val MFALevel is _Enum[MFALevel, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-mfa-level
    """
primitive NoneMFALevel is MFALevel
    """
    guild has no MFA/2FA requirement for moderation actions
    """

    fun value(): U8 => 0
primitive ElevatedMFALevel is MFALevel
    """
    guild has a 2FA requirement for moderation actions
    """

    fun value(): U8 => 1
primitive MFALevels
    fun from(value: U8): MFALevel ? =>
        match value
        | 0 => NoneMFALevel
        | 1 => ElevatedMFALevel
        else error
        end

trait val VerificationLevel is _Enum[VerificationLevel, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-verification-level
    """
primitive NoneVerificationLevel is VerificationLevel
    """
    unrestricted
    """

    fun value(): U8 => 0
primitive LowVerificationLevel is VerificationLevel
    """
    must have verified email on account
    """

    fun value(): U8 => 1
primitive MediumVerificationLevel is VerificationLevel
    """
    must be registered on Discord for longer than 5 minutes
    """

    fun value(): U8 => 2
primitive HighVerificationLevel is VerificationLevel
    """
    must be a member of the server for longer than 10 minutes
    """

    fun value(): U8 => 3
primitive VeryHighVerificationLevel is VerificationLevel
    """
    must have a verified phone number
    """

    fun value(): U8 => 4
primitive VerificationLevels
    fun from(value: U8): VerificationLevel ? =>
        match value
        | 0 => NoneVerificationLevel
        | 1 => LowVerificationLevel
        | 2 => MediumVerificationLevel
        | 3 => HighVerificationLevel
        | 4 => VeryHighVerificationLevel
        else error
        end

trait val GuildNSFWLevel is _Enum[GuildNSFWLevel, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-guild-nsfw-level
    """
primitive DefaultGuildNSFWLevel is GuildNSFWLevel
    fun value(): U8 => 0
primitive ExplicitGuildNSFWLevel is GuildNSFWLevel
    fun value(): U8 => 1
primitive SafeGuildNSFWLevel is GuildNSFWLevel
    fun value(): U8 => 2
primitive AgeRestrictedGuildNSFWLevel is GuildNSFWLevel
    fun value(): U8 => 3
primitive GuildNSFWLevels
    fun from(value: U8): GuildNSFWLevel ? =>
        match value
        | 0 => DefaultGuildNSFWLevel
        | 1 => ExplicitGuildNSFWLevel
        | 2 => SafeGuildNSFWLevel
        | 3 => AgeRestrictedGuildNSFWLevel
        else error
        end

trait val PremiumTier is _Enum[PremiumTier, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-premium-tier
    """
primitive NonePremiumTier is PremiumTier
    """
    guild has not unlocked any Server Boost perks
    """

    fun value(): U8 => 0
primitive Tier1PremiumTier is PremiumTier
    """
    guild has unlocked Server Boost level 1 perks
    """

    fun value(): U8 => 1
primitive Tier2PremiumTier is PremiumTier
    """
    guild has unlocked Server Boost level 2 perks
    """

    fun value(): U8 => 2
primitive Tier3PremiumTier is PremiumTier
    """
    guild has unlocked Server Boost level 3 perks
    """

    fun value(): U8 => 3
primitive PremiumTiers
    fun from(value: U8): PremiumTier ? =>
        match value
        | 0 => NonePremiumTier
        | 1 => Tier1PremiumTier
        | 2 => Tier2PremiumTier
        | 3 => Tier3PremiumTier
        else error
        end

trait val SystemChannelFlag is _Enum[SystemChannelFlag, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-object-system-channel-flags
    """
primitive SuppressJoinNotificationsSystemChannelFlag is SystemChannelFlag
    """
    Suppress member join notifications
    """

    fun value(): U8 => 0
primitive SuppressPremiumSubscriptionsSystemChannelFlag is SystemChannelFlag
    """
    Suppress server boost notifications
    """

    fun value(): U8 => 1
primitive SuppressGuildReminderNotificationsSystemChannelFlag is
    SystemChannelFlag
    """
    Suppress server setup tips
    """

    fun value(): U8 => 2
primitive SuppressJoinNotificationRepliesSystemChannelFlag is SystemChannelFlag
    """
    Hide member join sticker reply buttons
    """

    fun value(): U8 => 3
primitive SuppressRoleSubscriptionPurchaseNotificationsSystemChannelFlag is
    SystemChannelFlag
    """
    Suppress role subscription purchase and renewal notifications
    """

    fun value(): U8 => 4
primitive SuppressRoleSubscriptionPurchaseNotificationRepliesSystemChannelFlag
    is SystemChannelFlag
    """
    Hide role subscription sticker reply buttons
    """

    fun value(): U8 => 5
class val UnknownSystemChannelFlag is SystemChannelFlag
    let _value: U8

    new val create(value': U8) =>
        _value = value'

    fun value(): U8 => _value
primitive SystemChannelFlags
    fun from(value: U8): SystemChannelFlag ? =>
        match value
        | 0 => SuppressJoinNotificationsSystemChannelFlag
        | 1 => SuppressPremiumSubscriptionsSystemChannelFlag
        | 2 => SuppressGuildReminderNotificationsSystemChannelFlag
        | 3 => SuppressJoinNotificationRepliesSystemChannelFlag
        | 4 => SuppressRoleSubscriptionPurchaseNotificationsSystemChannelFlag
        | 5 =>
            SuppressRoleSubscriptionPurchaseNotificationRepliesSystemChannelFlag
        else error
        end

primitive _SystemChannelFlags
    fun apply(bits: U64): Array[SystemChannelFlag] val =>
        recover val
            let flags = Array[SystemChannelFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    flags.push(
                        try
                            SystemChannelFlags.from(shift)?
                        else
                            UnknownSystemChannelFlag(shift)
                        end
                    )
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[SystemChannelFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do
            bits = bits or (U64(1) << flag.value().u64())
        end
        bits.i64()

class val GuildPreview is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-preview-object-guild-preview-structure
    """

    let id: Snowflake
        """
        guild id
        """

    let name: String
        """
        guild name (2-100 characters)
        """

    let icon: (String | None)
        """
        icon hash
        """

    let splash: (String | None)
        """
        splash hash
        """

    let discovery_splash: (String | None)
        """
        discovery splash hash
        """

    let emojis: Array[Emoji] val
        """
        custom guild emojis
        """

    let features: Array[String] val
        """
        enabled guild features
        """

    let approximate_member_count: USize
        """
        approximate number of members in this guild
        """

    let approximate_presence_count: USize
        """
        approximate number of online members in this guild
        """

    let description: (String | None)
        """
        the description for the guild
        """

    let stickers: Array[Sticker] val
        """
        custom guild stickers
        """

    new val create(
        id': Snowflake,
        name': String,
        icon': (String | None) = None,
        splash': (String | None) = None,
        discovery_splash': (String | None) = None,
        emojis': Array[Emoji] val,
        features': Array[String] val,
        approximate_member_count': USize,
        approximate_presence_count': USize,
        description': (String | None) = None,
        stickers': Array[Sticker] val
    ) =>
        id = id'
        name = name'
        icon = icon'
        splash = splash'
        discovery_splash = discovery_splash'
        emojis = emojis'
        features = features'
        approximate_member_count = approximate_member_count'
        approximate_presence_count = approximate_presence_count'
        description = description'
        stickers = stickers'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var icon': (String | None) = None
        var splash': (String | None) = None
        var discovery_splash': (String | None) = None
        var emojis': (Array[Emoji] val | None) = None
        var features': (Array[String] val | None) = None
        var approximate_member_count': (USize | None) = None
        var approximate_presence_count': (USize | None) = None
        var description': (String | None) = None
        var stickers': (Array[Sticker] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "icon" =>
                match value | let string: String => icon' = string end
            | "splash" =>
                match value | let string: String => splash' = string end
            | "discovery_splash" =>
                match value
                | let string: String => discovery_splash' = string
                end
            | "emojis" => emojis' = _Emojis(value)?
            | "features" => features' = _Strings(value)?
            | "approximate_member_count" =>
                approximate_member_count' = (value as I64).usize()
            | "approximate_presence_count" =>
                approximate_presence_count' = (value as I64).usize()
            | "description" =>
                match value | let string: String => description' = string end
            | "stickers" => stickers' = _Stickers(value)?
            end
        end

        id = id' as Snowflake
        name = name' as String
        icon = icon'
        splash = splash'
        discovery_splash = discovery_splash'
        emojis = emojis' as Array[Emoji] val
        features = features' as Array[String] val
        approximate_member_count = approximate_member_count' as USize
        approximate_presence_count = approximate_presence_count' as USize
        description = description'
        stickers = stickers' as Array[Sticker] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("icon", icon)
            .update("splash", splash)
            .update("discovery_splash", discovery_splash)
            .update("emojis", _Emojis.to_json(emojis))
            .update("features", _Strings.to_json(features))
            .update("approximate_member_count", approximate_member_count.i64())
            .update(
                "approximate_presence_count", approximate_presence_count.i64()
            )
            .update("description", description)
            .update("stickers", _Stickers.to_json(stickers))

class val GuildWidgetSettings is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-widget-settings-object-guild-widget-settings-structure
    """

    let enabled: Bool
        """
        whether the widget is enabled
        """

    let channel_id: (Snowflake | None)
        """
        the widget channel id
        """

    new val create(enabled': Bool, channel_id': (Snowflake | None) = None) =>
        enabled = enabled'
        channel_id = channel_id'

    new val from_json(obj: json.JsonObject) ? =>
        var enabled': (Bool | None) = None
        var channel_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "enabled" => enabled' = value as Bool
            | "channel_id" =>
                match value
                | let string: String =>
                    channel_id' = Snowflake.from_json(string)?
                end
            end
        end

        enabled = enabled' as Bool
        channel_id = channel_id'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("enabled", enabled)
            .update(
                "channel_id",
                match channel_id
                | let channel_id': Snowflake => channel_id'.to_json()
                end
            )

class val GuildWidget is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-widget-object-guild-widget-structure
    """

    let id: Snowflake
        """
        guild id
        """

    let name: String
        """
        guild name (2-100 characters)
        """

    let instant_invite: (String | None)
        """
        instant invite for the guilds specified widget invite channel
        """

    let channels: Array[PartialChannel] val
        """
        voice and stage channels which are accessible by @everyone

        These are partial channel objects: the widget carries only `id`, `name`
        and `position`.
        """

    let members: Array[User] val
        """
        special widget user objects that includes users presence (Limit 100)

        These are anonymised: the `id`, `discriminator` and `avatar` fields are
        placeholders. They also carry `status` and `avatar_url` fields that
        `User` does not model, so those are dropped on decode.
        """

    let presence_count: USize
        """
        number of online members in this guild
        """

    new val create(
        id': Snowflake,
        name': String,
        instant_invite': (String | None) = None,
        channels': Array[PartialChannel] val,
        members': Array[User] val,
        presence_count': USize
    ) =>
        id = id'
        name = name'
        instant_invite = instant_invite'
        channels = channels'
        members = members'
        presence_count = presence_count'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var instant_invite': (String | None) = None
        var channels': (Array[PartialChannel] val | None) = None
        var members': (Array[User] val | None) = None
        var presence_count': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "instant_invite" =>
                match value | let string: String => instant_invite' = string end
            | "channels" => channels' = _PartialChannels(value)?
            | "members" => members' = _Users(value)?
            | "presence_count" => presence_count' = (value as I64).usize()
            end
        end

        id = id' as Snowflake
        name = name' as String
        instant_invite = instant_invite'
        channels = channels' as Array[PartialChannel] val
        members = members' as Array[User] val
        presence_count = presence_count' as USize

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("instant_invite", instant_invite)
            .update("channels", _PartialChannels.to_json(channels))
            .update("members", _Users.to_json(members))
            .update("presence_count", presence_count.i64())

class val GuildMember is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-member-object-guild-member-structure

    The field `user` won't be included in the member object attached to
    MESSAGE_CREATE and MESSAGE_UPDATE gateway events.

    In GUILD_ events, `pending` will always be included as true or false. In non
    `GUILD_` events which can only be triggered by non-`pending` users,
    `pending` will not be included.
    """

    let user: (User | None)
        """
        the user this guild member represents
        """

    let nick: (String | None)
        """
        this user's guild nickname
        """

    let avatar: (String | None)
        """
        the member's guild avatar hash
        """

    let banner: (String | None)
        """
        the member's guild banner hash
        """

    let roles: Array[Snowflake] val
        """
        array of role object ids
        """

    let joined_at: ISO8601
        """
        when the user joined the guild
        """

    let premium_since: (ISO8601 | None)
        """
        when the user started boosting the guild
        """

    let deaf: Bool
        """
        whether the user is deafened in voice channels
        """

    let mute: Bool
        """
        whether the user is muted in voice channels
        """

    let flags: Array[GuildMemberFlag] val
        """
        guild member flags represented as a bit set, defaults to 0
        """

    let pending: (Bool | None)
        """
        whether the user has not yet passed the guild's Membership Screening
        requirements
        """

    let permissions: (Array[Permission] val | None)
        """
        total permissions of the member in the channel, including overwrites,
        returned when in the interaction object
        """

    let communication_disabled_until: (ISO8601 | None)
        """
        when the user's timeout will expire and the user will be able to
        communicate in the guild again, null or a time in the past if the user
        is not timed out
        """

    let avatar_decoration_data: (AvatarDecorationData | None)
        """
        data for the member's guild avatar decoration
        """

    new val create(
        user': (User | None) = None,
        nick': (String | None) = None,
        avatar': (String | None) = None,
        banner': (String | None) = None,
        roles': Array[Snowflake] val,
        joined_at': ISO8601,
        premium_since': (ISO8601 | None) = None,
        deaf': Bool,
        mute': Bool,
        flags': Array[GuildMemberFlag] val,
        pending': (Bool | None) = None,
        permissions': (Array[Permission] val | None) = None,
        communication_disabled_until': (ISO8601 | None) = None,
        avatar_decoration_data': (AvatarDecorationData | None) = None
    ) =>
        user = user'
        nick = nick'
        avatar = avatar'
        banner = banner'
        roles = roles'
        joined_at = joined_at'
        premium_since = premium_since'
        deaf = deaf'
        mute = mute'
        flags = flags'
        pending = pending'
        permissions = permissions'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'

    new val from_json(obj: json.JsonObject) ? =>
        var user': (User | None) = None
        var nick': (String | None) = None
        var avatar': (String | None) = None
        var banner': (String | None) = None
        var roles': (Array[Snowflake] val | None) = None
        var joined_at': (ISO8601 | None) = None
        var premium_since': (ISO8601 | None) = None
        var deaf': (Bool | None) = None
        var mute': (Bool | None) = None
        var flags': (Array[GuildMemberFlag] val | None) = None
        var pending': (Bool | None) = None
        var permissions': (Array[Permission] val | None) = None
        var communication_disabled_until': (ISO8601 | None) = None
        var avatar_decoration_data': (AvatarDecorationData | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "nick" =>
                match value | let string: String => nick' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "roles" => roles' = _Snowflakes(value)?
            | "joined_at" => joined_at' = value as String
            | "premium_since" =>
                match value | let string: String => premium_since' = string end
            | "deaf" => deaf' = value as Bool
            | "mute" => mute' = value as Bool
            | "flags" => flags' = _GuildMemberFlags((value as I64).u64())
            | "pending" => pending' = value as Bool
            | "permissions" => permissions' = _Permissions(value)?
            | "communication_disabled_until" =>
                match value
                | let string: String => communication_disabled_until' = string
                end
            | "avatar_decoration_data" =>
                match value
                | let obj': json.JsonObject =>
                    avatar_decoration_data' =
                        AvatarDecorationData.from_json(obj')?
                end
            end
        end

        user = user'
        nick = nick'
        avatar = avatar'
        banner = banner'
        roles = roles' as Array[Snowflake] val
        joined_at = joined_at' as ISO8601
        premium_since = premium_since'
        deaf = deaf' as Bool
        mute = mute' as Bool
        flags = flags' as Array[GuildMemberFlag] val
        pending = pending'
        permissions = permissions'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("roles", _Snowflakes.to_json(roles))
            .update("joined_at", joined_at)
            .update("deaf", deaf)
            .update("mute", mute)
            .update("flags", _GuildMemberFlags.to_json(flags))

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        end

        match avatar
        | let avatar': String => obj = obj.update("avatar", avatar')
        end

        match banner
        | let banner': String => obj = obj.update("banner", banner')
        end

        match premium_since
        | let premium_since': ISO8601 =>
            obj = obj.update("premium_since", premium_since')
        end

        match pending
        | let pending': Bool => obj = obj.update("pending", pending')
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match communication_disabled_until
        | let communication_disabled_until': ISO8601 =>
            obj =
                obj.update(
                    "communication_disabled_until",
                    communication_disabled_until'
                )
        end

        match avatar_decoration_data
        | let avatar_decoration_data': AvatarDecorationData =>
            obj =
                obj.update(
                    "avatar_decoration_data", avatar_decoration_data'.to_json()
                )
        end

        obj

primitive _GuildMembers
    fun apply(value: json.JsonValue): Array[GuildMember] val ? =>
        """
        Decodes an array of guild members.
        """

        let array = value as json.JsonArray
        recover val
            let members = Array[GuildMember](array.size())
            for member in array.values() do
                members.push(GuildMember.from_json(member as json.JsonObject)?)
            end
            members
        end

    fun to_json(members: Array[GuildMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do
            array = array.push(member.to_json())
        end
        array

class val PartialGuildMember is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-member-object-guild-member-structure

    A guild member Discord sent as a *partial* object: the same structure as
    `GuildMember`, but carrying only some of its fields. Interaction resolved
    data omits `user`, `deaf` and `mute`; message interactions and invite stage
    instances trim their own sets. A guild member has no id of its own — it is
    identified by the `user` it wraps, or by the key it is filed under — so
    every field here is optional.

    The fields mean exactly what their `GuildMember` counterparts do, and are
    documented there. A field Discord omits is indistinguishable from a field
    Discord sent as `null`.
    """

    let user: (User | None)
    let nick: (String | None)
    let avatar: (String | None)
    let banner: (String | None)
    let roles: (Array[Snowflake] val | None)
    let joined_at: (ISO8601 | None)
    let premium_since: (ISO8601 | None)
    let deaf: (Bool | None)
    let mute: (Bool | None)
    let flags: (Array[GuildMemberFlag] val | None)
    let pending: (Bool | None)
    let permissions: (Array[Permission] val | None)
    let communication_disabled_until: (ISO8601 | None)
    let avatar_decoration_data: (AvatarDecorationData | None)

    new val create(
        user': (User | None) = None,
        nick': (String | None) = None,
        avatar': (String | None) = None,
        banner': (String | None) = None,
        roles': (Array[Snowflake] val | None) = None,
        joined_at': (ISO8601 | None) = None,
        premium_since': (ISO8601 | None) = None,
        deaf': (Bool | None) = None,
        mute': (Bool | None) = None,
        flags': (Array[GuildMemberFlag] val | None) = None,
        pending': (Bool | None) = None,
        permissions': (Array[Permission] val | None) = None,
        communication_disabled_until': (ISO8601 | None) = None,
        avatar_decoration_data': (AvatarDecorationData | None) = None
    ) =>
        user = user'
        nick = nick'
        avatar = avatar'
        banner = banner'
        roles = roles'
        joined_at = joined_at'
        premium_since = premium_since'
        deaf = deaf'
        mute = mute'
        flags = flags'
        pending = pending'
        permissions = permissions'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'

    new val from_json(obj: json.JsonObject) ? =>
        var user': (User | None) = None
        var nick': (String | None) = None
        var avatar': (String | None) = None
        var banner': (String | None) = None
        var roles': (Array[Snowflake] val | None) = None
        var joined_at': (ISO8601 | None) = None
        var premium_since': (ISO8601 | None) = None
        var deaf': (Bool | None) = None
        var mute': (Bool | None) = None
        var flags': (Array[GuildMemberFlag] val | None) = None
        var pending': (Bool | None) = None
        var permissions': (Array[Permission] val | None) = None
        var communication_disabled_until': (ISO8601 | None) = None
        var avatar_decoration_data': (AvatarDecorationData | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "nick" =>
                match value | let string: String => nick' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "roles" => roles' = _Snowflakes(value)?
            | "joined_at" => joined_at' = value as String
            | "premium_since" =>
                match value | let string: String => premium_since' = string end
            | "deaf" => deaf' = value as Bool
            | "mute" => mute' = value as Bool
            | "flags" => flags' = _GuildMemberFlags((value as I64).u64())
            | "pending" => pending' = value as Bool
            | "permissions" => permissions' = _Permissions(value)?
            | "communication_disabled_until" =>
                match value
                | let string: String => communication_disabled_until' = string
                end
            | "avatar_decoration_data" =>
                match value
                | let obj': json.JsonObject =>
                    avatar_decoration_data' =
                        AvatarDecorationData.from_json(obj')?
                end
            end
        end

        user = user'
        nick = nick'
        avatar = avatar'
        banner = banner'
        roles = roles'
        joined_at = joined_at'
        premium_since = premium_since'
        deaf = deaf'
        mute = mute'
        flags = flags'
        pending = pending'
        permissions = permissions'
        communication_disabled_until = communication_disabled_until'
        avatar_decoration_data = avatar_decoration_data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        end

        match avatar
        | let avatar': String => obj = obj.update("avatar", avatar')
        end

        match banner
        | let banner': String => obj = obj.update("banner", banner')
        end

        match roles
        | let roles': Array[Snowflake] val =>
            obj = obj.update("roles", _Snowflakes.to_json(roles'))
        end

        match joined_at
        | let joined_at': ISO8601 => obj = obj.update("joined_at", joined_at')
        end

        match premium_since
        | let premium_since': ISO8601 =>
            obj = obj.update("premium_since", premium_since')
        end

        match deaf
        | let deaf': Bool => obj = obj.update("deaf", deaf')
        end

        match mute
        | let mute': Bool => obj = obj.update("mute", mute')
        end

        match flags
        | let flags': Array[GuildMemberFlag] val =>
            obj = obj.update("flags", _GuildMemberFlags.to_json(flags'))
        end

        match pending
        | let pending': Bool => obj = obj.update("pending", pending')
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match communication_disabled_until
        | let communication_disabled_until': ISO8601 =>
            obj =
                obj.update(
                    "communication_disabled_until",
                    communication_disabled_until'
                )
        end

        match avatar_decoration_data
        | let avatar_decoration_data': AvatarDecorationData =>
            obj =
                obj.update(
                    "avatar_decoration_data", avatar_decoration_data'.to_json()
                )
        end

        obj

primitive _PartialGuildMembers
    fun apply(value: json.JsonValue): Array[PartialGuildMember] val ? =>
        """
        Decodes an array of partial guild members.
        """

        let array = value as json.JsonArray
        recover val
            let members = Array[PartialGuildMember](array.size())
            for member in array.values() do
                members.push(
                    PartialGuildMember.from_json(member as json.JsonObject)?
                )
            end
            members
        end

    fun to_json(members: Array[PartialGuildMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do
            array = array.push(member.to_json())
        end
        array

trait val GuildMemberFlag is _Enum[GuildMemberFlag, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-member-object-guild-member-flags
    """
primitive DidRejoinGuildMemberFlag is GuildMemberFlag
    """
    Member has left and rejoined the guild
    """

    fun value(): U8 => 0
primitive CompletedOnboardingGuildMemberFlag is GuildMemberFlag
    """
    Member has completed onboarding
    """

    fun value(): U8 => 1
primitive BypassesVerificationGuildMemberFlag is GuildMemberFlag
    """
    Member is exempt from guild verification requirements
    """

    fun value(): U8 => 2
primitive StartedOnboardingGuildMemberFlag is GuildMemberFlag
    """
    Member has started onboarding
    """

    fun value(): U8 => 3
primitive IsGuestGuildMemberFlag is GuildMemberFlag
    """
    Member is a guest and can only access the voice channel they were invited to
    """

    fun value(): U8 => 4
primitive StartedHomeActionsGuildMemberFlag is GuildMemberFlag
    """
    Member has started Server Guide new member actions
    """

    fun value(): U8 => 5
primitive CompletedHomeActionsGuildMemberFlag is GuildMemberFlag
    """
    Member has completed Server Guide new member actions
    """

    fun value(): U8 => 6
primitive AutomodQuarantinedUsernameGuildMemberFlag is GuildMemberFlag
    """
    Member's username, display name, or nickname is blocked by AutoMod
    """

    fun value(): U8 => 7
primitive DMSettingsUpsellAcknowledgedGuildMemberFlag is GuildMemberFlag
    """
    Member has dismissed the DM settings upsell
    """

    fun value(): U8 => 9
class val UnknownGuildMemberFlag is GuildMemberFlag
    let _value: U8

    new val create(value': U8) =>
        _value = value'

    fun value(): U8 => _value
primitive GuildMemberFlags
    fun from(value: U8): GuildMemberFlag ? =>
        match value
        | 0 => DidRejoinGuildMemberFlag
        | 1 => CompletedOnboardingGuildMemberFlag
        | 2 => BypassesVerificationGuildMemberFlag
        | 3 => StartedOnboardingGuildMemberFlag
        | 4 => IsGuestGuildMemberFlag
        | 5 => StartedHomeActionsGuildMemberFlag
        | 6 => CompletedHomeActionsGuildMemberFlag
        | 7 => AutomodQuarantinedUsernameGuildMemberFlag
        | 9 => DMSettingsUpsellAcknowledgedGuildMemberFlag
        else error
        end

primitive _GuildMemberFlags
    fun apply(bits: U64): Array[GuildMemberFlag] val =>
        recover val
            let flags = Array[GuildMemberFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    flags.push(
                        try
                            GuildMemberFlags.from(shift)?
                        else
                            UnknownGuildMemberFlag(shift)
                        end
                    )
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[GuildMemberFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do
            bits = bits or (U64(1) << flag.value().u64())
        end
        bits.i64()

class val Integration is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#integration-object-integration-structure

    These fields are not provided for discord bot integrations.
    """

    let id: Snowflake
        """
        integration id
        """

    let name: String
        """
        integration name
        """

    let type': String
        """
        integration type (twitch, youtube, discord, or guild_subscription)
        """

    let enabled: Bool
        """
        is this integration enabled
        """

    let syncing: (Bool | None)
        """
        is this integration syncing
        """

    let role_id: (Snowflake | None)
        """
        id that this integration uses for "subscribers"
        """

    let enable_emoticons: (Bool | None)
        """
        whether emoticons should be synced for this integration (twitch only
        currently)
        """

    let expire_behavior: (IntegrationExpireBehavior | None)
        """
        the behavior of expiring subscribers
        """

    let expire_grace_period: (USize | None)
        """
        the grace period (days) before expiring subscribers
        """

    let user: (User | None)
        """
        user for this integration
        """

    let account: IntegrationAccount
        """
        integration account information
        """

    let synced_at: (ISO8601 | None)
        """
        when this integration was last synced
        """

    let subscriber_count: (USize | None)
        """
        how many subscribers this integration has
        """

    let revoked: (Bool | None)
        """
        has this integration been revoked
        """

    let application: (IntegrationApplication | None)
        """
        The bot/OAuth2 application for discord integrations
        """

    let scopes: (Array[String] val | None)
        """
        the scopes the application has been authorized for
        """

    new val create(
        id': Snowflake,
        name': String,
        type'': String,
        enabled': Bool,
        syncing': (Bool | None) = None,
        role_id': (Snowflake | None) = None,
        enable_emoticons': (Bool | None) = None,
        expire_behavior': (IntegrationExpireBehavior | None) = None,
        expire_grace_period': (USize | None) = None,
        user': (User | None) = None,
        account': IntegrationAccount,
        synced_at': (ISO8601 | None) = None,
        subscriber_count': (USize | None) = None,
        revoked': (Bool | None) = None,
        application': (IntegrationApplication | None) = None,
        scopes': (Array[String] val | None) = None
    ) =>
        id = id'
        name = name'
        type' = type''
        enabled = enabled'
        syncing = syncing'
        role_id = role_id'
        enable_emoticons = enable_emoticons'
        expire_behavior = expire_behavior'
        expire_grace_period = expire_grace_period'
        user = user'
        account = account'
        synced_at = synced_at'
        subscriber_count = subscriber_count'
        revoked = revoked'
        application = application'
        scopes = scopes'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var type'': (String | None) = None
        var enabled': (Bool | None) = None
        var syncing': (Bool | None) = None
        var role_id': (Snowflake | None) = None
        var enable_emoticons': (Bool | None) = None
        var expire_behavior': (IntegrationExpireBehavior | None) = None
        var expire_grace_period': (USize | None) = None
        var user': (User | None) = None
        var account': (IntegrationAccount | None) = None
        var synced_at': (ISO8601 | None) = None
        var subscriber_count': (USize | None) = None
        var revoked': (Bool | None) = None
        var application': (IntegrationApplication | None) = None
        var scopes': (Array[String] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "type" => type'' = value as String
            | "enabled" => enabled' = value as Bool
            | "syncing" => syncing' = value as Bool
            | "role_id" => role_id' = Snowflake.from_json(value)?
            | "enable_emoticons" => enable_emoticons' = value as Bool
            | "expire_behavior" =>
                expire_behavior' =
                    IntegrationExpireBehaviors.from((value as I64).u8())?
            | "expire_grace_period" =>
                expire_grace_period' = (value as I64).usize()
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "account" =>
                account' =
                    IntegrationAccount.from_json(value as json.JsonObject)?
            | "synced_at" => synced_at' = value as String
            | "subscriber_count" => subscriber_count' = (value as I64).usize()
            | "revoked" => revoked' = value as Bool
            | "application" =>
                application' =
                    IntegrationApplication.from_json(value as json.JsonObject)?
            | "scopes" => scopes' = _Strings(value)?
            end
        end

        id = id' as Snowflake
        name = name' as String
        type' = type'' as String
        enabled = enabled' as Bool
        syncing = syncing'
        role_id = role_id'
        enable_emoticons = enable_emoticons'
        expire_behavior = expire_behavior'
        expire_grace_period = expire_grace_period'
        user = user'
        account = account' as IntegrationAccount
        synced_at = synced_at'
        subscriber_count = subscriber_count'
        revoked = revoked'
        application = application'
        scopes = scopes'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("type", type')
            .update("enabled", enabled)
            .update("account", account.to_json())

        match syncing
        | let syncing': Bool => obj = obj.update("syncing", syncing')
        end

        match role_id
        | let role_id': Snowflake =>
            obj = obj.update("role_id", role_id'.to_json())
        end

        match enable_emoticons
        | let enable_emoticons': Bool =>
            obj = obj.update("enable_emoticons", enable_emoticons')
        end

        match expire_behavior
        | let expire_behavior': IntegrationExpireBehavior =>
            obj = obj.update("expire_behavior", expire_behavior'.value().i64())
        end

        match expire_grace_period
        | let expire_grace_period': USize =>
            obj = obj.update("expire_grace_period", expire_grace_period'.i64())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match synced_at
        | let synced_at': ISO8601 => obj = obj.update("synced_at", synced_at')
        end

        match subscriber_count
        | let subscriber_count': USize =>
            obj = obj.update("subscriber_count", subscriber_count'.i64())
        end

        match revoked
        | let revoked': Bool => obj = obj.update("revoked", revoked')
        end

        match application
        | let application': IntegrationApplication =>
            obj = obj.update("application", application'.to_json())
        end

        match scopes
        | let scopes': Array[String] val =>
            obj = obj.update("scopes", _Strings.to_json(scopes'))
        end

        obj

primitive _Integrations
    fun apply(value: json.JsonValue): Array[Integration] val ? =>
        """
        Decodes an array of integrations.
        """

        let array = value as json.JsonArray
        recover val
            let integrations = Array[Integration](array.size())
            for integration in array.values() do
                integrations.push(
                    Integration.from_json(integration as json.JsonObject)?
                )
            end
            integrations
        end

    fun to_json(integrations: Array[Integration] val): json.JsonArray =>
        var array = json.JsonArray
        for integration in integrations.values() do
            array = array.push(integration.to_json())
        end
        array

class val PartialIntegration is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#integration-object-integration-structure

    An integration Discord sent as a *partial* object: the same structure as
    `Integration`, but carrying only some of its fields. An audit log sends only
    `id`, `name`, `type` and `account`, so every field here but `id` is
    optional.

    The fields mean exactly what their `Integration` counterparts do, and are
    documented there. A field Discord omits is indistinguishable from a field
    Discord sent as `null`.
    """

    let id: Snowflake
    let name: (String | None)
    let type': (String | None)
    let enabled: (Bool | None)
    let syncing: (Bool | None)
    let role_id: (Snowflake | None)
    let enable_emoticons: (Bool | None)
    let expire_behavior: (IntegrationExpireBehavior | None)
    let expire_grace_period: (USize | None)
    let user: (User | None)
    let account: (IntegrationAccount | None)
    let synced_at: (ISO8601 | None)
    let subscriber_count: (USize | None)
    let revoked: (Bool | None)
    let application: (IntegrationApplication | None)
    let scopes: (Array[String] val | None)

    new val create(
        id': Snowflake,
        name': (String | None) = None,
        type'': (String | None) = None,
        enabled': (Bool | None) = None,
        syncing': (Bool | None) = None,
        role_id': (Snowflake | None) = None,
        enable_emoticons': (Bool | None) = None,
        expire_behavior': (IntegrationExpireBehavior | None) = None,
        expire_grace_period': (USize | None) = None,
        user': (User | None) = None,
        account': (IntegrationAccount | None) = None,
        synced_at': (ISO8601 | None) = None,
        subscriber_count': (USize | None) = None,
        revoked': (Bool | None) = None,
        application': (IntegrationApplication | None) = None,
        scopes': (Array[String] val | None) = None
    ) =>
        id = id'
        name = name'
        type' = type''
        enabled = enabled'
        syncing = syncing'
        role_id = role_id'
        enable_emoticons = enable_emoticons'
        expire_behavior = expire_behavior'
        expire_grace_period = expire_grace_period'
        user = user'
        account = account'
        synced_at = synced_at'
        subscriber_count = subscriber_count'
        revoked = revoked'
        application = application'
        scopes = scopes'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var type'': (String | None) = None
        var enabled': (Bool | None) = None
        var syncing': (Bool | None) = None
        var role_id': (Snowflake | None) = None
        var enable_emoticons': (Bool | None) = None
        var expire_behavior': (IntegrationExpireBehavior | None) = None
        var expire_grace_period': (USize | None) = None
        var user': (User | None) = None
        var account': (IntegrationAccount | None) = None
        var synced_at': (ISO8601 | None) = None
        var subscriber_count': (USize | None) = None
        var revoked': (Bool | None) = None
        var application': (IntegrationApplication | None) = None
        var scopes': (Array[String] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "type" => type'' = value as String
            | "enabled" => enabled' = value as Bool
            | "syncing" => syncing' = value as Bool
            | "role_id" => role_id' = Snowflake.from_json(value)?
            | "enable_emoticons" => enable_emoticons' = value as Bool
            | "expire_behavior" =>
                expire_behavior' =
                    IntegrationExpireBehaviors.from((value as I64).u8())?
            | "expire_grace_period" =>
                expire_grace_period' = (value as I64).usize()
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "account" =>
                account' =
                    IntegrationAccount.from_json(value as json.JsonObject)?
            | "synced_at" => synced_at' = value as String
            | "subscriber_count" => subscriber_count' = (value as I64).usize()
            | "revoked" => revoked' = value as Bool
            | "application" =>
                application' =
                    IntegrationApplication.from_json(value as json.JsonObject)?
            | "scopes" => scopes' = _Strings(value)?
            end
        end

        id = id' as Snowflake
        name = name'
        type' = type''
        enabled = enabled'
        syncing = syncing'
        role_id = role_id'
        enable_emoticons = enable_emoticons'
        expire_behavior = expire_behavior'
        expire_grace_period = expire_grace_period'
        user = user'
        account = account'
        synced_at = synced_at'
        subscriber_count = subscriber_count'
        revoked = revoked'
        application = application'
        scopes = scopes'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match type'
        | let type'': String => obj = obj.update("type", type'')
        end

        match enabled
        | let enabled': Bool => obj = obj.update("enabled", enabled')
        end

        match syncing
        | let syncing': Bool => obj = obj.update("syncing", syncing')
        end

        match role_id
        | let role_id': Snowflake =>
            obj = obj.update("role_id", role_id'.to_json())
        end

        match enable_emoticons
        | let enable_emoticons': Bool =>
            obj = obj.update("enable_emoticons", enable_emoticons')
        end

        match expire_behavior
        | let expire_behavior': IntegrationExpireBehavior =>
            obj = obj.update("expire_behavior", expire_behavior'.value().i64())
        end

        match expire_grace_period
        | let expire_grace_period': USize =>
            obj = obj.update("expire_grace_period", expire_grace_period'.i64())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match account
        | let account': IntegrationAccount =>
            obj = obj.update("account", account'.to_json())
        end

        match synced_at
        | let synced_at': ISO8601 => obj = obj.update("synced_at", synced_at')
        end

        match subscriber_count
        | let subscriber_count': USize =>
            obj = obj.update("subscriber_count", subscriber_count'.i64())
        end

        match revoked
        | let revoked': Bool => obj = obj.update("revoked", revoked')
        end

        match application
        | let application': IntegrationApplication =>
            obj = obj.update("application", application'.to_json())
        end

        match scopes
        | let scopes': Array[String] val =>
            obj = obj.update("scopes", _Strings.to_json(scopes'))
        end

        obj

primitive _PartialIntegrations
    fun apply(value: json.JsonValue): Array[PartialIntegration] val ? =>
        """
        Decodes an array of partial integrations.
        """

        let array = value as json.JsonArray
        recover val
            let integrations = Array[PartialIntegration](array.size())
            for integration in array.values() do
                integrations.push(
                    PartialIntegration.from_json(
                        integration as json.JsonObject
                    )?
                )
            end
            integrations
        end

    fun to_json(integrations: Array[PartialIntegration] val): json.JsonArray =>
        var array = json.JsonArray
        for integration in integrations.values() do
            array = array.push(integration.to_json())
        end
        array

trait val IntegrationExpireBehavior is _Enum[IntegrationExpireBehavior, U8]
    """
    https://docs.discord.com/developers/resources/guild#integration-object-integration-expire-behaviors
    """
primitive RemoveRoleIntegrationExpireBehavior is IntegrationExpireBehavior
    fun value(): U8 => 0
primitive KickIntegrationExpireBehavior is IntegrationExpireBehavior
    fun value(): U8 => 1
primitive IntegrationExpireBehaviors
    fun from(value: U8): IntegrationExpireBehavior ? =>
        match value
        | 0 => RemoveRoleIntegrationExpireBehavior
        | 1 => KickIntegrationExpireBehavior
        else error
        end

class val IntegrationAccount is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#integration-account-object-integration-account-structure
    """

    let id: String
        """
        id of the account
        """

    let name: String
        """
        name of the account
        """

    new val create(id': String, name': String) =>
        id = id'
        name = name'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (String | None) = None
        var name': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = value as String
            | "name" => name' = value as String
            end
        end

        id = id' as String
        name = name' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id)
            .update("name", name)

class val IntegrationApplication is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#integration-application-object-integration-application-structure
    """

    let id: Snowflake
        """
        the id of the app
        """

    let name: String
        """
        the name of the app
        """

    let icon: (String | None)
        """
        the icon hash of the app
        """

    let description: String
        """
        the description of the app
        """

    let bot: (User | None)
        """
        the bot associated with this application
        """

    new val create(
        id': Snowflake,
        name': String,
        icon': (String | None) = None,
        description': String,
        bot': (User | None) = None
    ) =>
        id = id'
        name = name'
        icon = icon'
        description = description'
        bot = bot'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var icon': (String | None) = None
        var description': (String | None) = None
        var bot': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "icon" =>
                match value | let string: String => icon' = string end
            | "description" => description' = value as String
            | "bot" => bot' = User.from_json(value as json.JsonObject)?
            end
        end

        id = id' as Snowflake
        name = name' as String
        icon = icon'
        description = description' as String
        bot = bot'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("icon", icon)
            .update("description", description)

        match bot
        | let bot': User => obj = obj.update("bot", bot'.to_json())
        end

        obj

class val Ban is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#ban-object-ban-structure
    """

    let reason: (String | None)
        """
        the reason for the ban
        """

    let user: User
        """
        the banned user
        """

    new val create(reason': (String | None) = None, user': User) =>
        reason = reason'
        user = user'

    new val from_json(obj: json.JsonObject) ? =>
        var reason': (String | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "reason" =>
                match value | let string: String => reason' = string end
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        reason = reason'
        user = user' as User

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("reason", reason)
            .update("user", user.to_json())

primitive _Bans
    fun apply(value: json.JsonValue): Array[Ban] val ? =>
        """
        Decodes an array of bans.
        """

        let array = value as json.JsonArray
        recover val
            let bans = Array[Ban](array.size())
            for ban in array.values() do
                bans.push(Ban.from_json(ban as json.JsonObject)?)
            end
            bans
        end

    fun to_json(bans: Array[Ban] val): json.JsonArray =>
        var array = json.JsonArray
        for ban in bans.values() do array = array.push(ban.to_json()) end
        array

class val WelcomeScreen is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#welcome-screen-object-welcome-screen-structure
    """

    let description: (String | None)
        """
        the server description shown in the welcome screen
        """

    let welcome_channels: Array[WelcomeScreenChannel] val
        """
        the channels shown in the welcome screen, up to 5
        """

    new val create(
        description': (String | None) = None,
        welcome_channels': Array[WelcomeScreenChannel] val
    ) =>
        description = description'
        welcome_channels = welcome_channels'

    new val from_json(obj: json.JsonObject) ? =>
        var description': (String | None) = None
        var welcome_channels': (Array[WelcomeScreenChannel] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "description" =>
                match value | let string: String => description' = string end
            | "welcome_channels" =>
                welcome_channels' = _WelcomeScreenChannels(value)?
            end
        end

        description = description'
        welcome_channels = welcome_channels' as Array[WelcomeScreenChannel] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("description", description)
            .update(
                "welcome_channels",
                _WelcomeScreenChannels.to_json(welcome_channels)
            )

class val WelcomeScreenChannel is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#welcome-screen-object-welcome-screen-channel-structure
    """

    let channel_id: Snowflake
        """
        the channel's id
        """

    let description: String
        """
        the description shown for the channel
        """

    let emoji_id: (Snowflake | None)
        """
        the emoji id, if the emoji is custom
        """

    let emoji_name: (String | None)
        """
        the emoji name if custom, the unicode character if standard, or null if
        no emoji is set
        """

    new val create(
        channel_id': Snowflake,
        description': String,
        emoji_id': (Snowflake | None) = None,
        emoji_name': (String | None) = None
    ) =>
        channel_id = channel_id'
        description = description'
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var description': (String | None) = None
        var emoji_id': (Snowflake | None) = None
        var emoji_name': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "description" => description' = value as String
            | "emoji_id" =>
                match value
                | let string: String => emoji_id' = Snowflake.from_json(string)?
                end
            | "emoji_name" =>
                match value | let string: String => emoji_name' = string end
            end
        end

        channel_id = channel_id' as Snowflake
        description = description' as String
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("description", description)
            .update(
                "emoji_id",
                match emoji_id
                | let emoji_id': Snowflake => emoji_id'.to_json()
                end
            )
            .update("emoji_name", emoji_name)

primitive _WelcomeScreenChannels
    fun apply(value: json.JsonValue): Array[WelcomeScreenChannel] val ? =>
        """
        Decodes an array of welcome screen channels.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[WelcomeScreenChannel](array.size())
            for channel in array.values() do
                channels.push(
                    WelcomeScreenChannel.from_json(channel as json.JsonObject)?
                )
            end
            channels
        end

    fun to_json(channels: Array[WelcomeScreenChannel] val): json.JsonArray =>
        var array = json.JsonArray
        for channel in channels.values() do
            array = array.push(channel.to_json())
        end
        array

class val GuildOnboarding is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-guild-onboarding-structure

    Represents the Onboarding flow for a guild.
    """

    let guild_id: Snowflake
        """
        ID of the guild this onboarding is part of
        """

    let prompts: Array[OnboardingPrompt] val
        """
        Prompts shown during onboarding and in customize community
        """

    let default_channel_ids: Array[Snowflake] val
        """
        Channel IDs that members get opted into automatically
        """

    let enabled: Bool
        """
        Whether onboarding is enabled in the guild
        """

    let mode: OnboardingMode
        """
        Current mode of onboarding
        """

    new val create(
        guild_id': Snowflake,
        prompts': Array[OnboardingPrompt] val,
        default_channel_ids': Array[Snowflake] val,
        enabled': Bool,
        mode': OnboardingMode
    ) =>
        guild_id = guild_id'
        prompts = prompts'
        default_channel_ids = default_channel_ids'
        enabled = enabled'
        mode = mode'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var prompts': (Array[OnboardingPrompt] val | None) = None
        var default_channel_ids': (Array[Snowflake] val | None) = None
        var enabled': (Bool | None) = None
        var mode': (OnboardingMode | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "prompts" => prompts' = _OnboardingPrompts(value)?
            | "default_channel_ids" =>
                default_channel_ids' = _Snowflakes(value)?
            | "enabled" => enabled' = value as Bool
            | "mode" => mode' = OnboardingModes.from((value as I64).u8())?
            end
        end

        guild_id = guild_id' as Snowflake
        prompts = prompts' as Array[OnboardingPrompt] val
        default_channel_ids = default_channel_ids' as Array[Snowflake] val
        enabled = enabled' as Bool
        mode = mode' as OnboardingMode

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("guild_id", guild_id.to_json())
            .update("prompts", _OnboardingPrompts.to_json(prompts))
            .update(
                "default_channel_ids", _Snowflakes.to_json(default_channel_ids)
            )
            .update("enabled", enabled)
            .update("mode", mode.value().i64())

trait val OnboardingMode is _Enum[OnboardingMode, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-onboarding-mode

    Defines the criteria used to satisfy Onboarding constraints that are
    required for enabling.
    """
primitive DefaultOnboardingMode is OnboardingMode
    """
    Counts only Default Channels towards constraints
    """

    fun value(): U8 => 0
primitive AdvancedOnboardingMode is OnboardingMode
    """
    Counts Default Channels and Questions towards constraints
    """

    fun value(): U8 => 1
primitive OnboardingModes
    fun from(value: U8): OnboardingMode ? =>
        match value
        | 0 => DefaultOnboardingMode
        | 1 => AdvancedOnboardingMode
        else error
        end

class val OnboardingPrompt is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-onboarding-prompt-structure
    """

    let id: Snowflake
        """
        ID of the prompt
        """

    let type': OnboardingPromptType
        """
        Type of prompt
        """

    let options: Array[OnboardingPromptOption] val
        """
        Options available within the prompt
        """

    let title: String
        """
        Title of the prompt
        """

    let single_select: Bool
        """
        Indicates whether users are limited to selecting one option for the
        prompt
        """

    let required: Bool
        """
        Indicates whether the prompt is required before a user completes the
        onboarding flow
        """

    let in_onboarding: Bool
        """
        Indicates whether the prompt is present in the onboarding flow. If
        false, the prompt will only appear in the Channels & Roles tab
        """

    new val create(
        id': Snowflake,
        type'': OnboardingPromptType,
        options': Array[OnboardingPromptOption] val,
        title': String,
        single_select': Bool,
        required': Bool,
        in_onboarding': Bool
    ) =>
        id = id'
        type' = type''
        options = options'
        title = title'
        single_select = single_select'
        required = required'
        in_onboarding = in_onboarding'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (OnboardingPromptType | None) = None
        var options': (Array[OnboardingPromptOption] val | None) = None
        var title': (String | None) = None
        var single_select': (Bool | None) = None
        var required': (Bool | None) = None
        var in_onboarding': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" =>
                type'' = OnboardingPromptTypes.from((value as I64).u8())?
            | "options" => options' = _OnboardingPromptOptions(value)?
            | "title" => title' = value as String
            | "single_select" => single_select' = value as Bool
            | "required" => required' = value as Bool
            | "in_onboarding" => in_onboarding' = value as Bool
            end
        end

        id = id' as Snowflake
        type' = type'' as OnboardingPromptType
        options = options' as Array[OnboardingPromptOption] val
        title = title' as String
        single_select = single_select' as Bool
        required = required' as Bool
        in_onboarding = in_onboarding' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("options", _OnboardingPromptOptions.to_json(options))
            .update("title", title)
            .update("single_select", single_select)
            .update("required", required)
            .update("in_onboarding", in_onboarding)

primitive _OnboardingPrompts
    fun apply(value: json.JsonValue): Array[OnboardingPrompt] val ? =>
        """
        Decodes an array of onboarding prompts.
        """

        let array = value as json.JsonArray
        recover val
            let prompts = Array[OnboardingPrompt](array.size())
            for prompt in array.values() do
                prompts.push(
                    OnboardingPrompt.from_json(prompt as json.JsonObject)?
                )
            end
            prompts
        end

    fun to_json(prompts: Array[OnboardingPrompt] val): json.JsonArray =>
        var array = json.JsonArray
        for prompt in prompts.values() do
            array = array.push(prompt.to_json())
        end
        array

trait val OnboardingPromptType is _Enum[OnboardingPromptType, U8]
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-prompt-types
    """
primitive MultipleChoiceOnboardingPromptType is OnboardingPromptType
    fun value(): U8 => 0
primitive DropdownOnboardingPromptType is OnboardingPromptType
    fun value(): U8 => 1
primitive OnboardingPromptTypes
    fun from(value: U8): OnboardingPromptType ? =>
        match value
        | 0 => MultipleChoiceOnboardingPromptType
        | 1 => DropdownOnboardingPromptType
        else error
        end

class val OnboardingPromptOption is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-prompt-option-structure
    """

    let id: Snowflake
        """
        ID of the prompt option
        """

    let channel_ids: Array[Snowflake] val
        """
        IDs for channels a member is added to when the option is selected
        """

    let role_ids: Array[Snowflake] val
        """
        IDs for roles assigned to a member when the option is selected
        """

    let emoji: (Emoji | None)
        """
        Emoji of the option

        When creating or updating a prompt option, `emoji_id`, `emoji_name`, and
        `emoji_animated` should be used instead of this field.
        """

    let emoji_id: (Snowflake | None)
        """
        Emoji ID of the option
        """

    let emoji_name: (String | None)
        """
        Emoji name of the option
        """

    let emoji_animated: (Bool | None)
        """
        Whether the emoji is animated
        """

    let title: String
        """
        Title of the option
        """

    let description: (String | None)
        """
        Description of the option
        """

    new val create(
        id': Snowflake,
        channel_ids': Array[Snowflake] val,
        role_ids': Array[Snowflake] val,
        emoji': (Emoji | None) = None,
        emoji_id': (Snowflake | None) = None,
        emoji_name': (String | None) = None,
        emoji_animated': (Bool | None) = None,
        title': String,
        description': (String | None) = None
    ) =>
        id = id'
        channel_ids = channel_ids'
        role_ids = role_ids'
        emoji = emoji'
        emoji_id = emoji_id'
        emoji_name = emoji_name'
        emoji_animated = emoji_animated'
        title = title'
        description = description'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var channel_ids': (Array[Snowflake] val | None) = None
        var role_ids': (Array[Snowflake] val | None) = None
        var emoji': (Emoji | None) = None
        var emoji_id': (Snowflake | None) = None
        var emoji_name': (String | None) = None
        var emoji_animated': (Bool | None) = None
        var title': (String | None) = None
        var description': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "channel_ids" => channel_ids' = _Snowflakes(value)?
            | "role_ids" => role_ids' = _Snowflakes(value)?
            | "emoji" => emoji' = Emoji.from_json(value as json.JsonObject)?
            | "emoji_id" => emoji_id' = Snowflake.from_json(value)?
            | "emoji_name" => emoji_name' = value as String
            | "emoji_animated" => emoji_animated' = value as Bool
            | "title" => title' = value as String
            | "description" =>
                match value | let string: String => description' = string end
            end
        end

        id = id' as Snowflake
        channel_ids = channel_ids' as Array[Snowflake] val
        role_ids = role_ids' as Array[Snowflake] val
        emoji = emoji'
        emoji_id = emoji_id'
        emoji_name = emoji_name'
        emoji_animated = emoji_animated'
        title = title' as String
        description = description'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("channel_ids", _Snowflakes.to_json(channel_ids))
            .update("role_ids", _Snowflakes.to_json(role_ids))
            .update("title", title)
            .update("description", description)

        match emoji
        | let emoji': Emoji => obj = obj.update("emoji", emoji'.to_json())
        end

        match emoji_id
        | let emoji_id': Snowflake =>
            obj = obj.update("emoji_id", emoji_id'.to_json())
        end

        match emoji_name
        | let emoji_name': String => obj = obj.update("emoji_name", emoji_name')
        end

        match emoji_animated
        | let emoji_animated': Bool =>
            obj = obj.update("emoji_animated", emoji_animated')
        end

        obj

primitive _OnboardingPromptOptions
    fun apply(value: json.JsonValue): Array[OnboardingPromptOption] val ? =>
        """
        Decodes an array of onboarding prompt options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[OnboardingPromptOption](array.size())
            for option in array.values() do
                options.push(
                    OnboardingPromptOption.from_json(option as json.JsonObject)?
                )
            end
            options
        end

    fun to_json(options: Array[OnboardingPromptOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do
            array = array.push(option.to_json())
        end
        array

class val IncidentsData is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#incidents-data-object-incidents-data-structure
    """

    let invites_disabled_until: (ISO8601 | None)
        """
        when invites get enabled again
        """

    let dms_disabled_until: (ISO8601 | None)
        """
        when direct messages get enabled again
        """

    let dm_spam_detected_at: (ISO8601 | None)
        """
        when the dm spam was detected
        """

    let raid_detected_at: (ISO8601 | None)
        """
        when the raid was detected
        """

    new val create(
        invites_disabled_until': (ISO8601 | None) = None,
        dms_disabled_until': (ISO8601 | None) = None,
        dm_spam_detected_at': (ISO8601 | None) = None,
        raid_detected_at': (ISO8601 | None) = None
    ) =>
        invites_disabled_until = invites_disabled_until'
        dms_disabled_until = dms_disabled_until'
        dm_spam_detected_at = dm_spam_detected_at'
        raid_detected_at = raid_detected_at'

    new val from_json(obj: json.JsonObject) =>
        var invites_disabled_until': (ISO8601 | None) = None
        var dms_disabled_until': (ISO8601 | None) = None
        var dm_spam_detected_at': (ISO8601 | None) = None
        var raid_detected_at': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "invites_disabled_until" =>
                match value
                | let string: String => invites_disabled_until' = string
                end
            | "dms_disabled_until" =>
                match value
                | let string: String => dms_disabled_until' = string
                end
            | "dm_spam_detected_at" =>
                match value
                | let string: String => dm_spam_detected_at' = string
                end
            | "raid_detected_at" =>
                match value
                | let string: String => raid_detected_at' = string
                end
            end
        end

        invites_disabled_until = invites_disabled_until'
        dms_disabled_until = dms_disabled_until'
        dm_spam_detected_at = dm_spam_detected_at'
        raid_detected_at = raid_detected_at'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("invites_disabled_until", invites_disabled_until)
            .update("dms_disabled_until", dms_disabled_until)

        match dm_spam_detected_at
        | let dm_spam_detected_at': ISO8601 =>
            obj = obj.update("dm_spam_detected_at", dm_spam_detected_at')
        end

        match raid_detected_at
        | let raid_detected_at': ISO8601 =>
            obj = obj.update("raid_detected_at", raid_detected_at')
        end

        obj

class val ActiveThreads is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#list-active-guild-threads-response-body

    Unlike `ArchivedThreads`, this carries no `has_more`: the route hands back
    every active thread in the guild in one response.
    """

    let threads: Array[Channel] val
        """
        the active threads
        """

    let members: Array[ThreadMember] val
        """
        a thread member object for each returned thread the current user has
        joined
        """

    new val create(
        threads': Array[Channel] val,
        members': Array[ThreadMember] val
    ) =>
        threads = threads'
        members = members'

    new val from_json(obj: json.JsonObject) ? =>
        var threads': (Array[Channel] val | None) = None
        var members': (Array[ThreadMember] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "threads" => threads' = _Channels(value)?
            | "members" => members' = _ThreadMembers(value)?
            end
        end

        threads = threads' as Array[Channel] val
        members = members' as Array[ThreadMember] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("threads", _Channels.to_json(threads))
            .update("members", _ThreadMembers.to_json(members))

class val CurrentUserNick is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-current-user-nick

    The nickname the deprecated Modify Current User Nick route answers with.
    """

    let nick: (String | None)
        """
        the nickname the current user now carries in the guild
        """

    new val create(nick': (String | None) = None) =>
        nick = nick'

    new val from_json(obj: json.JsonObject) ? =>
        nick = match obj("nick")? | let string: String => string end

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("nick", nick)

class val BulkBanResponse is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#bulk-guild-ban-bulk-ban-response

    If none of the users could be banned, an error response code `500000: Failed
    to ban users` is returned instead.
    """

    let banned_users: Array[Snowflake] val
        """
        list of user ids, that were successfully banned
        """

    let failed_users: Array[Snowflake] val
        """
        list of user ids, that were not banned
        """

    new val create(
        banned_users': Array[Snowflake] val,
        failed_users': Array[Snowflake] val
    ) =>
        banned_users = banned_users'
        failed_users = failed_users'

    new val from_json(obj: json.JsonObject) ? =>
        var banned_users': (Array[Snowflake] val | None) = None
        var failed_users': (Array[Snowflake] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "banned_users" => banned_users' = _Snowflakes(value)?
            | "failed_users" => failed_users' = _Snowflakes(value)?
            end
        end

        banned_users = banned_users' as Array[Snowflake] val
        failed_users = failed_users' as Array[Snowflake] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("banned_users", _Snowflakes.to_json(banned_users))
            .update("failed_users", _Snowflakes.to_json(failed_users))

class val GuildRoleMemberCounts is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#get-guild-role-member-counts

    A map of role IDs to the number of members with the role. Does not include
    the @everyone role.
    """

    let counts: collections.Map[Snowflake, USize] val
        """
        the number of members carrying each role, keyed by role id
        """

    new val create(counts': collections.Map[Snowflake, USize] val) =>
        counts = counts'

    new val from_json(obj: json.JsonObject) ? =>
        counts = recover val
            let counts' = collections.Map[Snowflake, USize](obj.size())
            for (key, value) in obj.pairs() do
                counts'(Snowflake(key.u64()?)) = (value as I64).usize()
            end
            counts'
        end

    fun apply(role_id: Snowflake): USize ? =>
        """
        The number of members carrying `role_id`, erroring if the role was not
        counted — because it does not exist, or because it is @everyone.
        """

        counts(role_id)?

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
        for (role_id, count) in counts.pairs() do
            obj = obj.update(role_id.string(), count.i64())
        end
        obj

class val GuildPruneCount is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#get-guild-prune-count

    Handed back by both Get Guild Prune Count and Begin Guild Prune.
    """

    let pruned: (USize | None)
        """
        the number of members that would be, or were, removed in the prune
        operation

        `None` only for Begin Guild Prune called with `compute_prune_count` set
        to `false`.
        """

    new val create(pruned': (USize | None) = None) =>
        pruned = pruned'

    new val from_json(obj: json.JsonObject) ? =>
        pruned = match obj("pruned")? | let integer: I64 => integer.usize() end

    fun to_json(): json.JsonObject =>
        json.JsonObject.update(
            "pruned", match pruned | let pruned': USize => pruned'.i64() end
        )

class val GuildVanityUrl is Jsonable
    """
    https://docs.discord.com/developers/resources/guild#get-guild-vanity-url

    The partial invite object Get Guild Vanity URL answers with.
    """

    let code: (String | None)
        """
        the vanity invite code, or `None` if a vanity url for the guild is not
        set
        """

    let uses: USize
        """
        number of times this invite has been used
        """

    new val create(code': (String | None) = None, uses': USize) =>
        code = code'
        uses = uses'

    new val from_json(obj: json.JsonObject) ? =>
        var code': (String | None) = None
        var uses': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "code" =>
                match value | let string: String => code' = string end
            | "uses" => uses' = (value as I64).usize()
            end
        end

        code = code'
        uses = uses' as USize

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("code", code)
            .update("uses", uses.i64())

class val GetGuildParams
    """
    https://docs.discord.com/developers/resources/guild#get-guild-query-string-params
    """

    let with_counts: (Bool | None)
        """
        when true, will return approximate member and presence counts for the
        guild
        """

    new val create(with_counts': (Bool | None) = None) =>
        with_counts = with_counts'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_counts
        | let with_counts': Bool =>
            query.push(("with_counts", with_counts'.string()))
        end

        consume query

class val UpdateGuildParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-json-params

    All parameters to this endpoint are optional.

    Attempting to add or remove the `COMMUNITY` guild feature requires the
    `ADMINISTRATOR` permission.
    """

    let name: (String | None)
        """
        guild name
        """

    let verification_level: Nullable[VerificationLevel]
        """
        verification level
        """

    let default_message_notifications: Nullable[DefaultMessageNotificationLevel]
        """
        default message notification level
        """

    let explicit_content_filter: Nullable[ExplicitContentFilterLevel]
        """
        explicit content filter level
        """

    let afk_channel_id: Nullable[Snowflake]
        """
        id for afk channel
        """

    let afk_timeout: (USize | None)
        """
        afk timeout in seconds, can be set to: 60, 300, 900, 1800, 3600
        """

    let icon: Nullable[ImageData]
        """
        base64 1024x1024 png/jpeg/gif image for the guild icon (can be animated
        gif when the server has the `ANIMATED_ICON` feature)
        """

    let owner_id: (Snowflake | None)
        """
        user id to transfer guild ownership to (must be owner)
        """

    let splash: Nullable[ImageData]
        """
        base64 16:9 png/jpeg image for the guild splash (when the server has the
        `INVITE_SPLASH` feature)
        """

    let discovery_splash: Nullable[ImageData]
        """
        base64 16:9 png/jpeg image for the guild discovery splash (when the
        server has the `DISCOVERABLE` feature)
        """

    let banner: Nullable[ImageData]
        """
        base64 16:9 png/jpeg image for the guild banner (when the server has the
        `BANNER` feature; can be animated gif when the server has the
        `ANIMATED_BANNER` feature)
        """

    let system_channel_id: Nullable[Snowflake]
        """
        the id of the channel where guild notices such as welcome messages and
        boost events are posted
        """

    let system_channel_flags: (Array[SystemChannelFlag] val | None)
        """
        system channel flags
        """

    let rules_channel_id: Nullable[Snowflake]
        """
        the id of the channel where Community guilds display rules and/or
        guidelines
        """

    let public_updates_channel_id: Nullable[Snowflake]
        """
        the id of the channel where admins and moderators of Community guilds
        receive notices from Discord
        """

    let preferred_locale: Nullable[Locale]
        """
        the preferred locale of a Community guild used in server discovery and
        notices from Discord; defaults to "en-US"
        """

    let features: (Array[String] val | None)
        """
        enabled guild features
        """

    let description: Nullable[String]
        """
        the description for the guild
        """

    let premium_progress_bar_enabled: (Bool | None)
        """
        whether the guild's boost progress bar should be enabled
        """

    let safety_alerts_channel_id: Nullable[Snowflake]
        """
        the id of the channel where admins and moderators of Community guilds
        receive safety alerts from Discord
        """

    new val create(
        name': (String | None) = None,
        verification_level': Nullable[VerificationLevel] = None,
        default_message_notifications': Nullable[
            DefaultMessageNotificationLevel
        ] =
            None,
        explicit_content_filter': Nullable[ExplicitContentFilterLevel] = None,
        afk_channel_id': Nullable[Snowflake] = None,
        afk_timeout': (USize | None) = None,
        icon': Nullable[ImageData] = None,
        owner_id': (Snowflake | None) = None,
        splash': Nullable[ImageData] = None,
        discovery_splash': Nullable[ImageData] = None,
        banner': Nullable[ImageData] = None,
        system_channel_id': Nullable[Snowflake] = None,
        system_channel_flags': (Array[SystemChannelFlag] val | None) = None,
        rules_channel_id': Nullable[Snowflake] = None,
        public_updates_channel_id': Nullable[Snowflake] = None,
        preferred_locale': Nullable[Locale] = None,
        features': (Array[String] val | None) = None,
        description': Nullable[String] = None,
        premium_progress_bar_enabled': (Bool | None) = None,
        safety_alerts_channel_id': Nullable[Snowflake] = None
    ) =>
        name = name'
        verification_level = verification_level'
        default_message_notifications = default_message_notifications'
        explicit_content_filter = explicit_content_filter'
        afk_channel_id = afk_channel_id'
        afk_timeout = afk_timeout'
        icon = icon'
        owner_id = owner_id'
        splash = splash'
        discovery_splash = discovery_splash'
        banner = banner'
        system_channel_id = system_channel_id'
        system_channel_flags = system_channel_flags'
        rules_channel_id = rules_channel_id'
        public_updates_channel_id = public_updates_channel_id'
        preferred_locale = preferred_locale'
        features = features'
        description = description'
        premium_progress_bar_enabled = premium_progress_bar_enabled'
        safety_alerts_channel_id = safety_alerts_channel_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match verification_level
        | let verification_level': VerificationLevel =>
            obj =
                obj.update(
                    "verification_level", verification_level'.value().i64()
                )
        | Null => obj = obj.update("verification_level", None)
        end

        match default_message_notifications
        | let default_message_notifications': DefaultMessageNotificationLevel =>
            obj =
                obj.update(
                    "default_message_notifications",
                    default_message_notifications'.value().i64()
                )
        | Null => obj = obj.update("default_message_notifications", None)
        end

        match explicit_content_filter
        | let explicit_content_filter': ExplicitContentFilterLevel =>
            obj =
                obj.update(
                    "explicit_content_filter",
                    explicit_content_filter'.value().i64()
                )
        | Null => obj = obj.update("explicit_content_filter", None)
        end

        match afk_channel_id
        | let afk_channel_id': Snowflake =>
            obj = obj.update("afk_channel_id", afk_channel_id'.to_json())
        | Null => obj = obj.update("afk_channel_id", None)
        end

        match afk_timeout
        | let afk_timeout': USize =>
            obj = obj.update("afk_timeout", afk_timeout'.i64())
        end

        match icon
        | let icon': ImageData => obj = obj.update("icon", icon')
        | Null => obj = obj.update("icon", None)
        end

        match owner_id
        | let owner_id': Snowflake =>
            obj = obj.update("owner_id", owner_id'.to_json())
        end

        match splash
        | let splash': ImageData => obj = obj.update("splash", splash')
        | Null => obj = obj.update("splash", None)
        end

        match discovery_splash
        | let discovery_splash': ImageData =>
            obj = obj.update("discovery_splash", discovery_splash')
        | Null => obj = obj.update("discovery_splash", None)
        end

        match banner
        | let banner': ImageData => obj = obj.update("banner", banner')
        | Null => obj = obj.update("banner", None)
        end

        match system_channel_id
        | let system_channel_id': Snowflake =>
            obj = obj.update("system_channel_id", system_channel_id'.to_json())
        | Null => obj = obj.update("system_channel_id", None)
        end

        match system_channel_flags
        | let system_channel_flags': Array[SystemChannelFlag] val =>
            obj =
                obj.update(
                    "system_channel_flags",
                    _SystemChannelFlags.to_json(system_channel_flags')
                )
        end

        match rules_channel_id
        | let rules_channel_id': Snowflake =>
            obj = obj.update("rules_channel_id", rules_channel_id'.to_json())
        | Null => obj = obj.update("rules_channel_id", None)
        end

        match public_updates_channel_id
        | let public_updates_channel_id': Snowflake =>
            obj =
                obj.update(
                    "public_updates_channel_id",
                    public_updates_channel_id'.to_json()
                )
        | Null => obj = obj.update("public_updates_channel_id", None)
        end

        match preferred_locale
        | let preferred_locale': Locale =>
            obj = obj.update("preferred_locale", preferred_locale'.value())
        | Null => obj = obj.update("preferred_locale", None)
        end

        match features
        | let features': Array[String] val =>
            obj = obj.update("features", _Strings.to_json(features'))
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        | Null => obj = obj.update("description", None)
        end

        match premium_progress_bar_enabled
        | let premium_progress_bar_enabled': Bool =>
            obj =
                obj.update(
                    "premium_progress_bar_enabled",
                    premium_progress_bar_enabled'
                )
        end

        match safety_alerts_channel_id
        | let safety_alerts_channel_id': Snowflake =>
            obj =
                obj.update(
                    "safety_alerts_channel_id",
                    safety_alerts_channel_id'.to_json()
                )
        | Null => obj = obj.update("safety_alerts_channel_id", None)
        end

        obj

class val CreateGuildChannelParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#create-guild-channel-json-params

    All parameters to this endpoint are optional excluding `name`.
    """

    let name: String
        """
        channel name (1-100 characters)
        """

    let type': (ChannelType | None)
        """
        the type of channel
        """

    let topic: (String | None)
        """
        channel topic (0-1024 characters)
        """

    let bitrate: (USize | None)
        """
        the bitrate (in bits) of the voice or stage channel; min 8000
        """

    let user_limit: (USize | None)
        """
        the user limit of the voice channel
        """

    let rate_limit_per_user: (USize | None)
        """
        amount of seconds a user has to wait before sending another message
        (0-21600)
        """

    let position: (USize | None)
        """
        sorting position of the channel (channels with the same position are
        sorted by id)
        """

    let permission_overwrites: (Array[PermissionOverwrite] val | None)
        """
        the channel's permission overwrites
        """

    let parent_id: (Snowflake | None)
        """
        id of the parent category for a channel
        """

    let nsfw: (Bool | None)
        """
        whether the channel is nsfw
        """

    let rtc_region: (String | None)
        """
        channel voice region id of the voice or stage channel, automatic when
        set to null
        """

    let video_quality_mode: (VideoQualityMode | None)
        """
        the camera video quality mode of the voice channel
        """

    let default_auto_archive_duration: (USize | None)
        """
        the default duration that the clients use (not the API) for newly
        created threads in the channel, in minutes, to automatically archive the
        thread after recent activity
        """

    let default_reaction_emoji: (DefaultReaction | None)
        """
        emoji to show in the add reaction button on a thread in a GUILD_FORUM or
        a GUILD_MEDIA channel
        """

    let available_tags: (Array[ForumTagParams] val | None)
        """
        set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    let default_sort_order: (SortOrderType | None)
        """
        the default sort order type used to order posts in GUILD_FORUM and
        GUILD_MEDIA channels
        """

    let default_forum_layout: (ForumLayoutType | None)
        """
        the default forum layout view used to display posts in GUILD_FORUM
        channels
        """

    let default_thread_rate_limit_per_user: (USize | None)
        """
        the initial rate_limit_per_user to set on newly created threads in a
        channel. this field is copied to the thread at creation time and does
        not live update
        """

    new val create(
        name': String,
        type'': (ChannelType | None) = None,
        topic': (String | None) = None,
        bitrate': (USize | None) = None,
        user_limit': (USize | None) = None,
        rate_limit_per_user': (USize | None) = None,
        position': (USize | None) = None,
        permission_overwrites': (Array[PermissionOverwrite] val | None) = None,
        parent_id': (Snowflake | None) = None,
        nsfw': (Bool | None) = None,
        rtc_region': (String | None) = None,
        video_quality_mode': (VideoQualityMode | None) = None,
        default_auto_archive_duration': (USize | None) = None,
        default_reaction_emoji': (DefaultReaction | None) = None,
        available_tags': (Array[ForumTagParams] val | None) = None,
        default_sort_order': (SortOrderType | None) = None,
        default_forum_layout': (ForumLayoutType | None) = None,
        default_thread_rate_limit_per_user': (USize | None) = None
    ) =>
        name = name'
        type' = type''
        topic = topic'
        bitrate = bitrate'
        user_limit = user_limit'
        rate_limit_per_user = rate_limit_per_user'
        position = position'
        permission_overwrites = permission_overwrites'
        parent_id = parent_id'
        nsfw = nsfw'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        default_auto_archive_duration = default_auto_archive_duration'
        default_reaction_emoji = default_reaction_emoji'
        available_tags = available_tags'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match type'
        | let type'': ChannelType =>
            obj = obj.update("type", type''.value().i64())
        end

        match topic
        | let topic': String => obj = obj.update("topic", topic')
        end

        match bitrate
        | let bitrate': USize => obj = obj.update("bitrate", bitrate'.i64())
        end

        match user_limit
        | let user_limit': USize =>
            obj = obj.update("user_limit", user_limit'.i64())
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize =>
            obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        end

        match permission_overwrites
        | let permission_overwrites': Array[PermissionOverwrite] val =>
            obj =
                obj.update(
                    "permission_overwrites",
                    _PermissionOverwrites.to_json(permission_overwrites')
                )
        end

        match parent_id
        | let parent_id': Snowflake =>
            obj = obj.update("parent_id", parent_id'.to_json())
        end

        match nsfw
        | let nsfw': Bool => obj = obj.update("nsfw", nsfw')
        end

        match rtc_region
        | let rtc_region': String => obj = obj.update("rtc_region", rtc_region')
        end

        match video_quality_mode
        | let video_quality_mode': VideoQualityMode =>
            obj =
                obj.update(
                    "video_quality_mode", video_quality_mode'.value().i64()
                )
        end

        match default_auto_archive_duration
        | let default_auto_archive_duration': USize =>
            obj =
                obj.update(
                    "default_auto_archive_duration",
                    default_auto_archive_duration'.i64()
                )
        end

        match default_reaction_emoji
        | let default_reaction_emoji': DefaultReaction =>
            obj =
                obj.update(
                    "default_reaction_emoji", default_reaction_emoji'.to_json()
                )
        end

        match available_tags
        | let available_tags': Array[ForumTagParams] val =>
            obj =
                obj.update(
                    "available_tags", _ForumTagParams.to_json(available_tags')
                )
        end

        match default_sort_order
        | let default_sort_order': SortOrderType =>
            obj =
                obj.update(
                    "default_sort_order", default_sort_order'.value().i64()
                )
        end

        match default_forum_layout
        | let default_forum_layout': ForumLayoutType =>
            obj =
                obj.update(
                    "default_forum_layout", default_forum_layout'.value().i64()
                )
        end

        match default_thread_rate_limit_per_user
        | let default_thread_rate_limit_per_user': USize =>
            obj =
                obj.update(
                    "default_thread_rate_limit_per_user",
                    default_thread_rate_limit_per_user'.i64()
                )
        end

        obj

class val GuildChannelPosition is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-channel-positions-json-params

    A single entry of the array body sent to Modify Guild Channel Positions.
    """

    let id: Snowflake
        """
        channel id
        """

    let position: Nullable[USize]
        """
        sorting position of the channel (channels with the same position are
        sorted by id)
        """

    let lock_permissions: Nullable[Bool]
        """
        syncs the permission overwrites with the new parent, if moving to a new
        category
        """

    let parent_id: Nullable[Snowflake]
        """
        the new parent ID for the channel that is moved
        """

    new val create(
        id': Snowflake,
        position': Nullable[USize] = None,
        lock_permissions': Nullable[Bool] = None,
        parent_id': Nullable[Snowflake] = None
    ) =>
        id = id'
        position = position'
        lock_permissions = lock_permissions'
        parent_id = parent_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        | Null => obj = obj.update("position", None)
        end

        match lock_permissions
        | let lock_permissions': Bool =>
            obj = obj.update("lock_permissions", lock_permissions')
        | Null => obj = obj.update("lock_permissions", None)
        end

        match parent_id
        | let parent_id': Snowflake =>
            obj = obj.update("parent_id", parent_id'.to_json())
        | Null => obj = obj.update("parent_id", None)
        end

        obj

class val UpdateGuildChannelPositionsParams is ToJsonableArray
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-channel-positions

    This endpoint takes a JSON array of parameters.
    """

    let positions: Array[GuildChannelPosition] val
        """
        the channels to reposition
        """

    new val create(positions': Array[GuildChannelPosition] val) =>
        positions = positions'

    fun to_json(): json.JsonArray =>
        var array = json.JsonArray
        for position in positions.values() do
            array = array.push(position.to_json())
        end
        array

class val GetGuildMembersParams
    """
    https://docs.discord.com/developers/resources/guild#list-guild-members-query-string-params

    This endpoint is restricted according to whether the `GUILD_MEMBERS`
    Privileged Intent is enabled for your application.
    """

    let limit: (USize | None)
        """
        max number of members to return (1-1000), defaults to 1
        """

    let after: (Snowflake | None)
        """
        the highest user id in the previous page, defaults to 0
        """

    new val create(
        limit': (USize | None) = None,
        after': (Snowflake | None) = None
    ) =>
        limit = limit'
        after = after'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        consume query

class val SearchGuildMembersParams
    """
    https://docs.discord.com/developers/resources/guild#search-guild-members-query-string-params
    """

    let query: String
        """
        Query string to match username(s) and nickname(s) against.
        """

    let limit: (USize | None)
        """
        max number of members to return (1-1000), defaults to 1
        """

    new val create(query': String, limit': (USize | None) = None) =>
        query = query'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let params = recover iso Array[(String, String)] end

        params.push(("query", query))

        match limit
        | let limit': USize => params.push(("limit", limit'.string()))
        end

        consume params

class val AddGuildMemberParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#add-guild-member-json-params

    For guilds with Membership Screening enabled, this endpoint will default to
    adding new members as `pending` in the guild member object. Members that are
    `pending` will have to complete membership screening before they become full
    members that can talk.
    """

    let access_token: String
        """
        an oauth2 access token granted with the `guilds.join` to the bot's
        application for the user you want to add to the guild
        """

    let nick: (String | None)
        """
        value to set user's nickname to
        """

    let roles: (Array[Snowflake] val | None)
        """
        array of role ids the member is assigned
        """

    let mute: (Bool | None)
        """
        whether the user is muted in voice channels
        """

    let deaf: (Bool | None)
        """
        whether the user is deafened in voice channels
        """

    new val create(
        access_token': String,
        nick': (String | None) = None,
        roles': (Array[Snowflake] val | None) = None,
        mute': (Bool | None) = None,
        deaf': (Bool | None) = None
    ) =>
        access_token = access_token'
        nick = nick'
        roles = roles'
        mute = mute'
        deaf = deaf'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("access_token", access_token)

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        end

        match roles
        | let roles': Array[Snowflake] val =>
            obj = obj.update("roles", _Snowflakes.to_json(roles'))
        end

        match mute
        | let mute': Bool => obj = obj.update("mute", mute')
        end

        match deaf
        | let deaf': Bool => obj = obj.update("deaf", deaf')
        end

        obj

class val UpdateGuildMemberParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-member-json-params

    All parameters to this endpoint are optional and nullable. When moving
    members to channels, the API user must have permissions to both connect to
    the channel and have the `MOVE_MEMBERS` permission.
    """

    let nick: Nullable[String]
        """
        value to set user's nickname to

        Requires the `MANAGE_NICKNAMES` permission.
        """

    let roles: Nullable[Array[Snowflake] val]
        """
        array of role ids the member is assigned

        Requires the `MANAGE_ROLES` permission.
        """

    let mute: Nullable[Bool]
        """
        whether the user is muted in voice channels. Will throw a 400 error if
        the user is not in a voice channel

        Requires the `MUTE_MEMBERS` permission.
        """

    let deaf: Nullable[Bool]
        """
        whether the user is deafened in voice channels. Will throw a 400 error
        if the user is not in a voice channel

        Requires the `DEAFEN_MEMBERS` permission.
        """

    let channel_id: Nullable[Snowflake]
        """
        id of channel to move user to (if they are connected to voice)

        Requires the `MOVE_MEMBERS` permission.
        """

    let communication_disabled_until: Nullable[ISO8601]
        """
        when the user's timeout will expire and the user will be able to
        communicate in the guild again (up to 28 days in the future), set to
        null to remove timeout

        Requires the `MODERATE_MEMBERS` permission.
        """

    let flags: Nullable[Array[GuildMemberFlag] val]
        """
        guild member flags

        Requires the `MODERATE_MEMBERS` or the `MANAGE_GUILD` permission.
        """

    new val create(
        nick': Nullable[String] = None,
        roles': Nullable[Array[Snowflake] val] = None,
        mute': Nullable[Bool] = None,
        deaf': Nullable[Bool] = None,
        channel_id': Nullable[Snowflake] = None,
        communication_disabled_until': Nullable[ISO8601] = None,
        flags': Nullable[Array[GuildMemberFlag] val] = None
    ) =>
        nick = nick'
        roles = roles'
        mute = mute'
        deaf = deaf'
        channel_id = channel_id'
        communication_disabled_until = communication_disabled_until'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        | Null => obj = obj.update("nick", None)
        end

        match roles
        | let roles': Array[Snowflake] val =>
            obj = obj.update("roles", _Snowflakes.to_json(roles'))
        | Null => obj = obj.update("roles", None)
        end

        match mute
        | let mute': Bool => obj = obj.update("mute", mute')
        | Null => obj = obj.update("mute", None)
        end

        match deaf
        | let deaf': Bool => obj = obj.update("deaf", deaf')
        | Null => obj = obj.update("deaf", None)
        end

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        | Null => obj = obj.update("channel_id", None)
        end

        match communication_disabled_until
        | let communication_disabled_until': ISO8601 =>
            obj =
                obj.update(
                    "communication_disabled_until",
                    communication_disabled_until'
                )
        | Null => obj = obj.update("communication_disabled_until", None)
        end

        match flags
        | let flags': Array[GuildMemberFlag] val =>
            obj = obj.update("flags", _GuildMemberFlags.to_json(flags'))
        | Null => obj = obj.update("flags", None)
        end

        obj

class val UpdateCurrentMemberParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-current-member-json-params
    """

    let nick: Nullable[String]
        """
        value to set user's nickname to

        Requires the `CHANGE_NICKNAME` permission.
        """

    new val create(nick': Nullable[String] = None) =>
        nick = nick'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        | Null => obj = obj.update("nick", None)
        end

        obj

class val UpdateCurrentUserNickParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-current-user-nick-json-params

    Deprecated in favour of Modify Current Member.
    """

    let nick: Nullable[String]
        """
        value to set user's nickname to

        Requires the `CHANGE_NICKNAME` permission.
        """

    new val create(nick': Nullable[String] = None) =>
        nick = nick'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        | Null => obj = obj.update("nick", None)
        end

        obj

class val GetGuildBansParams
    """
    https://docs.discord.com/developers/resources/guild#get-guild-bans-query-string-params

    Provide a `before` and/or `after` to paginate. Users will always be returned
    in ascending order by `user.id`. If both `before` and `after` are provided,
    only `before` is respected.
    """

    let limit: (USize | None)
        """
        number of users to return (up to maximum 1000), defaults to 1000
        """

    let before: (Snowflake | None)
        """
        consider only users before given user id
        """

    let after: (Snowflake | None)
        """
        consider only users after given user id
        """

    new val create(
        limit': (USize | None) = None,
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None
    ) =>
        limit = limit'
        before = before'
        after = after'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        consume query

class val CreateGuildBanParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#create-guild-ban-json-params
    """

    let delete_message_seconds: (USize | None)
        """
        number of seconds to delete messages for, between 0 and 604800 (7 days),
        defaults to 0
        """

    new val create(delete_message_seconds': (USize | None) = None) =>
        delete_message_seconds = delete_message_seconds'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match delete_message_seconds
        | let delete_message_seconds': USize =>
            obj =
                obj.update(
                    "delete_message_seconds", delete_message_seconds'.i64()
                )
        end

        obj

class val BulkGuildBanParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#bulk-guild-ban-json-params

    If a user is already banned, or the bot lacks the permission to ban them,
    they will be listed in `failed_users`.
    """

    let user_ids: Array[Snowflake] val
        """
        list of user ids to ban (max 200)
        """

    let delete_message_seconds: (USize | None)
        """
        number of seconds to delete messages for, between 0 and 604800 (7 days),
        defaults to 0
        """

    new val create(
        user_ids': Array[Snowflake] val,
        delete_message_seconds': (USize | None) = None
    ) =>
        user_ids = user_ids'
        delete_message_seconds = delete_message_seconds'

    fun to_json(): json.JsonObject =>
        var obj =
            json.JsonObject.update("user_ids", _Snowflakes.to_json(user_ids))

        match delete_message_seconds
        | let delete_message_seconds': USize =>
            obj =
                obj.update(
                    "delete_message_seconds", delete_message_seconds'.i64()
                )
        end

        obj

class val CreateGuildRoleParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#create-guild-role-json-params

    All JSON params are optional.
    """

    let name: (String | None)
        """
        name of the role, max 100 characters. Default: "new role"
        """

    let permissions: (Array[Permission] val | None)
        """
        bitwise value of the enabled/disabled permissions. Default: @everyone
        permissions in guild
        """

    let color: (I64 | None)
        """
        RGB color value. Default: 0

        Deprecated in favour of `colors`.
        """

    let colors: (RoleColors | None)
        """
        the role's colors. Default: `primary_color` of 0
        """

    let hoist: (Bool | None)
        """
        whether the role should be displayed separately in the sidebar. Default:
        false
        """

    let icon: Nullable[ImageData]
        """
        the role's icon image (if the guild has the `ROLE_ICONS` feature).
        Default: null
        """

    let unicode_emoji: Nullable[String]
        """
        the role's unicode emoji as a standard emoji (if the guild has the
        `ROLE_ICONS` feature). Default: null
        """

    let mentionable: (Bool | None)
        """
        whether the role should be mentionable. Default: false
        """

    new val create(
        name': (String | None) = None,
        permissions': (Array[Permission] val | None) = None,
        color': (I64 | None) = None,
        colors': (RoleColors | None) = None,
        hoist': (Bool | None) = None,
        icon': Nullable[ImageData] = None,
        unicode_emoji': Nullable[String] = None,
        mentionable': (Bool | None) = None
    ) =>
        name = name'
        permissions = permissions'
        color = color'
        colors = colors'
        hoist = hoist'
        icon = icon'
        unicode_emoji = unicode_emoji'
        mentionable = mentionable'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match color
        | let color': I64 => obj = obj.update("color", color')
        end

        match colors
        | let colors': RoleColors =>
            obj = obj.update("colors", colors'.to_json())
        end

        match hoist
        | let hoist': Bool => obj = obj.update("hoist", hoist')
        end

        match icon
        | let icon': ImageData => obj = obj.update("icon", icon')
        | Null => obj = obj.update("icon", None)
        end

        match unicode_emoji
        | let unicode_emoji': String =>
            obj = obj.update("unicode_emoji", unicode_emoji')
        | Null => obj = obj.update("unicode_emoji", None)
        end

        match mentionable
        | let mentionable': Bool =>
            obj = obj.update("mentionable", mentionable')
        end

        obj

class val GuildRolePosition is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-role-positions-json-params

    A single entry of the array body sent to Modify Guild Role Positions.
    """

    let id: Snowflake
        """
        role
        """

    let position: Nullable[USize]
        """
        sorting position of the role (roles with the same position are sorted by
        id)
        """

    new val create(id': Snowflake, position': Nullable[USize] = None) =>
        id = id'
        position = position'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        | Null => obj = obj.update("position", None)
        end

        obj

class val UpdateGuildRolePositionsParams is ToJsonableArray
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-role-positions

    This endpoint takes a JSON array of parameters.
    """

    let positions: Array[GuildRolePosition] val
        """
        the roles to reposition
        """

    new val create(positions': Array[GuildRolePosition] val) =>
        positions = positions'

    fun to_json(): json.JsonArray =>
        var array = json.JsonArray
        for position in positions.values() do
            array = array.push(position.to_json())
        end
        array

class val UpdateGuildRoleParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-role-json-params

    All parameters to this endpoint are optional and nullable.
    """

    let name: Nullable[String]
        """
        name of the role, max 100 characters
        """

    let permissions: Nullable[Array[Permission] val]
        """
        bitwise value of the enabled/disabled permissions
        """

    let color: Nullable[I64]
        """
        RGB color value

        Deprecated in favour of `colors`.
        """

    let colors: Nullable[RoleColors]
        """
        the role's colors
        """

    let hoist: Nullable[Bool]
        """
        whether the role should be displayed separately in the sidebar
        """

    let icon: Nullable[ImageData]
        """
        the role's icon image (if the guild has the `ROLE_ICONS` feature)
        """

    let unicode_emoji: Nullable[String]
        """
        the role's unicode emoji as a standard emoji (if the guild has the
        `ROLE_ICONS` feature)
        """

    let mentionable: Nullable[Bool]
        """
        whether the role should be mentionable
        """

    new val create(
        name': Nullable[String] = None,
        permissions': Nullable[Array[Permission] val] = None,
        color': Nullable[I64] = None,
        colors': Nullable[RoleColors] = None,
        hoist': Nullable[Bool] = None,
        icon': Nullable[ImageData] = None,
        unicode_emoji': Nullable[String] = None,
        mentionable': Nullable[Bool] = None
    ) =>
        name = name'
        permissions = permissions'
        color = color'
        colors = colors'
        hoist = hoist'
        icon = icon'
        unicode_emoji = unicode_emoji'
        mentionable = mentionable'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        | Null => obj = obj.update("name", None)
        end

        match permissions
        | let permissions': Array[Permission] val =>
            obj = obj.update("permissions", _Permissions.to_json(permissions'))
        | Null => obj = obj.update("permissions", None)
        end

        match color
        | let color': I64 => obj = obj.update("color", color')
        | Null => obj = obj.update("color", None)
        end

        match colors
        | let colors': RoleColors =>
            obj = obj.update("colors", colors'.to_json())
        | Null => obj = obj.update("colors", None)
        end

        match hoist
        | let hoist': Bool => obj = obj.update("hoist", hoist')
        | Null => obj = obj.update("hoist", None)
        end

        match icon
        | let icon': ImageData => obj = obj.update("icon", icon')
        | Null => obj = obj.update("icon", None)
        end

        match unicode_emoji
        | let unicode_emoji': String =>
            obj = obj.update("unicode_emoji", unicode_emoji')
        | Null => obj = obj.update("unicode_emoji", None)
        end

        match mentionable
        | let mentionable': Bool =>
            obj = obj.update("mentionable", mentionable')
        | Null => obj = obj.update("mentionable", None)
        end

        obj

class val GetGuildPruneCountParams
    """
    https://docs.discord.com/developers/resources/guild#get-guild-prune-count-query-string-params

    By default, prune will not remove users with roles. You can optionally
    include specific roles in your prune by providing the `include_roles`
    parameter. Any inactive user that has a subset of the provided role(s) will
    be counted in the prune and users with additional roles will not.
    """

    let days: (USize | None)
        """
        number of days to count prune for (1-30), defaults to 7
        """

    let include_roles: (Array[Snowflake] val | None)
        """
        role(s) to include, comma-delimited array of snowflakes
        """

    new val create(
        days': (USize | None) = None,
        include_roles': (Array[Snowflake] val | None) = None
    ) =>
        days = days'
        include_roles = include_roles'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match days
        | let days': USize => query.push(("days", days'.string()))
        end

        match include_roles
        | let include_roles': Array[Snowflake] val =>
            query.push(("include_roles", _CommaSeparated(include_roles')))
        end

        consume query

class val BeginGuildPruneParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#begin-guild-prune-json-params

    For large guilds it's recommended to set the `compute_prune_count` option to
    false, forcing `pruned` to null.
    """

    let days: (USize | None)
        """
        number of days to prune (1-30), defaults to 7
        """

    let compute_prune_count: (Bool | None)
        """
        whether `pruned` is returned, discouraged for large guilds, defaults to
        true
        """

    let include_roles: (Array[Snowflake] val | None)
        """
        role(s) to include, defaults to none
        """

    new val create(
        days': (USize | None) = None,
        compute_prune_count': (Bool | None) = None,
        include_roles': (Array[Snowflake] val | None) = None
    ) =>
        days = days'
        compute_prune_count = compute_prune_count'
        include_roles = include_roles'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match days
        | let days': USize => obj = obj.update("days", days'.i64())
        end

        match compute_prune_count
        | let compute_prune_count': Bool =>
            obj = obj.update("compute_prune_count", compute_prune_count')
        end

        match include_roles
        | let include_roles': Array[Snowflake] val =>
            obj =
                obj.update("include_roles", _Snowflakes.to_json(include_roles'))
        end

        obj

class val UpdateGuildWidgetParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-widget

    Accepts a partial guild widget settings object.
    """

    let enabled: (Bool | None)
        """
        whether the widget is enabled
        """

    let channel_id: Nullable[Snowflake]
        """
        the widget channel id
        """

    new val create(
        enabled': (Bool | None) = None,
        channel_id': Nullable[Snowflake] = None
    ) =>
        enabled = enabled'
        channel_id = channel_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match enabled
        | let enabled': Bool => obj = obj.update("enabled", enabled')
        end

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        | Null => obj = obj.update("channel_id", None)
        end

        obj

trait val GuildWidgetStyle is _Enum[GuildWidgetStyle, String]
    """
    https://docs.discord.com/developers/resources/guild#get-guild-widget-image-widget-style-options
    """
primitive ShieldGuildWidgetStyle is GuildWidgetStyle
    """
    shield style widget with Discord icon and guild members online count
    """

    fun value(): String => "shield"
primitive Banner1GuildWidgetStyle is GuildWidgetStyle
    """
    large image with guild icon, name and online count. "POWERED BY DISCORD" as
    the footer of the widget
    """

    fun value(): String => "banner1"
primitive Banner2GuildWidgetStyle is GuildWidgetStyle
    """
    smaller widget style with guild icon, name and online count. Split on the
    right with Discord logo
    """

    fun value(): String => "banner2"
primitive Banner3GuildWidgetStyle is GuildWidgetStyle
    """
    large image with guild icon, name and online count. In the footer, Discord
    logo on the left and "Chat Now" on the right
    """

    fun value(): String => "banner3"
primitive Banner4GuildWidgetStyle is GuildWidgetStyle
    """
    large Discord logo at the top of the widget. Guild icon, name and online
    count in the middle portion of the widget and a "JOIN MY SERVER" button at
    the bottom
    """

    fun value(): String => "banner4"
primitive GuildWidgetStyles
    fun from(value: String): GuildWidgetStyle ? =>
        match value
        | "shield" => ShieldGuildWidgetStyle
        | "banner1" => Banner1GuildWidgetStyle
        | "banner2" => Banner2GuildWidgetStyle
        | "banner3" => Banner3GuildWidgetStyle
        | "banner4" => Banner4GuildWidgetStyle
        else error
        end

class val GetGuildWidgetImageParams
    """
    https://docs.discord.com/developers/resources/guild#get-guild-widget-image-query-string-params

    All parameters to this endpoint are optional.
    """

    let style: (GuildWidgetStyle | None)
        """
        style of the widget image returned (see below), defaults to `shield`
        """

    new val create(style': (GuildWidgetStyle | None) = None) =>
        style = style'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match style
        | let style': GuildWidgetStyle => query.push(("style", style'.value()))
        end

        consume query

class val UpdateGuildWelcomeScreenParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-welcome-screen-json-params

    All parameters to this endpoint are optional and nullable.
    """

    let enabled: Nullable[Bool]
        """
        whether the welcome screen is enabled
        """

    let welcome_channels: Nullable[Array[WelcomeScreenChannel] val]
        """
        channels linked in the welcome screen and their display options
        """

    let description: Nullable[String]
        """
        the server description to show in the welcome screen
        """

    new val create(
        enabled': Nullable[Bool] = None,
        welcome_channels': Nullable[Array[WelcomeScreenChannel] val] = None,
        description': Nullable[String] = None
    ) =>
        enabled = enabled'
        welcome_channels = welcome_channels'
        description = description'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match enabled
        | let enabled': Bool => obj = obj.update("enabled", enabled')
        | Null => obj = obj.update("enabled", None)
        end

        match welcome_channels
        | let welcome_channels': Array[WelcomeScreenChannel] val =>
            obj =
                obj.update(
                    "welcome_channels",
                    _WelcomeScreenChannels.to_json(welcome_channels')
                )
        | Null => obj = obj.update("welcome_channels", None)
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        | Null => obj = obj.update("description", None)
        end

        obj

class val UpdateGuildOnboardingParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-onboarding-json-params

    Onboarding enforces constraints when enabled. These constraints are that
    there must be at least 7 Default Channels and at least 5 of them must allow
    sending messages to the @everyone role. The `mode` field modifies what is
    considered when enforcing these constraints.
    """

    let prompts: Array[OnboardingPrompt] val
        """
        Prompts shown during onboarding and in customize community
        """

    let default_channel_ids: Array[Snowflake] val
        """
        Channel IDs that members get opted into automatically
        """

    let enabled: Bool
        """
        Whether onboarding is enabled in the guild
        """

    let mode: OnboardingMode
        """
        Current mode of onboarding
        """

    new val create(
        prompts': Array[OnboardingPrompt] val,
        default_channel_ids': Array[Snowflake] val,
        enabled': Bool,
        mode': OnboardingMode
    ) =>
        prompts = prompts'
        default_channel_ids = default_channel_ids'
        enabled = enabled'
        mode = mode'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("prompts", _OnboardingPrompts.to_json(prompts))
            .update(
                "default_channel_ids", _Snowflakes.to_json(default_channel_ids)
            )
            .update("enabled", enabled)
            .update("mode", mode.value().i64())

class val UpdateGuildIncidentActionsParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild#modify-guild-incident-actions-json-params

    Both fields are nullable and may be set to a timestamp up to 24 hours in the
    future.
    """

    let invites_disabled_until: Nullable[ISO8601]
        """
        when invites should be enabled again
        """

    let dms_disabled_until: Nullable[ISO8601]
        """
        when direct messages should be enabled again
        """

    new val create(
        invites_disabled_until': Nullable[ISO8601] = None,
        dms_disabled_until': Nullable[ISO8601] = None
    ) =>
        invites_disabled_until = invites_disabled_until'
        dms_disabled_until = dms_disabled_until'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match invites_disabled_until
        | let invites_disabled_until': ISO8601 =>
            obj = obj.update("invites_disabled_until", invites_disabled_until')
        | Null => obj = obj.update("invites_disabled_until", None)
        end

        match dms_disabled_until
        | let dms_disabled_until': ISO8601 =>
            obj = obj.update("dms_disabled_until", dms_disabled_until')
        | Null => obj = obj.update("dms_disabled_until", None)
        end

        obj

class val SettingsEmoji is Jsonable
    """
    The trimmed-down emoji Discord attaches to server guide entries.
    """

    let id: (Snowflake | None)
    let name: (String | None)
    let animated: Bool

    new val create(
        id': (Snowflake | None) = None,
        name': (String | None) = None,
        animated': Bool = false
    ) =>
        id = id'
        name = name'
        animated = animated'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var animated': Bool = false

        for (key, value) in obj.pairs() do
            match key
            | "id" =>
                match value
                | let string: String => id' = Snowflake.from_json(string)?
                end
            | "name" =>
                match value | let string: String => name' = string end
            | "animated" => animated' = value as Bool
            end
        end

        id = id'
        name = name'
        animated = animated'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update(
                "id",
                match id
                | let id': Snowflake => id'.to_json()
                end
            )
            .update(
                "name",
                match name
                | let name': String => name'
                end
            )
            .update("animated", animated)

trait val NewMemberActionType is _Enum[NewMemberActionType, U8]
    """
    https://docs.discord.com/developers/resources/guild#new-member-action-object-new-member-action-type
    """
primitive ViewNewMemberActionType is NewMemberActionType
    """
    the new member is pointed at a channel to read
    """

    fun value(): U8 => 0
primitive TalkNewMemberActionType is NewMemberActionType
    """
    the new member is pointed at a channel to post in
    """

    fun value(): U8 => 1
primitive NewMemberActionTypes
    fun from(value: U8): NewMemberActionType ? =>
        match value
        | 0 => ViewNewMemberActionType
        | 1 => TalkNewMemberActionType
        else error
        end

class val NewMemberAction is FromJsonable
    """
    https://docs.discord.com/developers/resources/guild#new-member-action-object

    One of the things the server guide suggests a new member does first.
    """

    let channel_id: Snowflake
    let action_type: NewMemberActionType
    let title: String
    let description: String
    let emoji: (SettingsEmoji | None)
    let icon: (String | None)

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var action_type': (NewMemberActionType | None) = None
        var title': (String | None) = None
        var description': (String | None) = None
        var emoji': (SettingsEmoji | None) = None
        var icon': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "action_type" =>
                action_type' = NewMemberActionTypes.from((value as I64).u8())?
            | "title" => title' = value as String
            | "description" => description' = value as String
            | "emoji" =>
                match value
                | let obj': json.JsonObject =>
                    emoji' = SettingsEmoji.from_json(obj')?
                end
            | "icon" =>
                match value | let string: String => icon' = string end
            end
        end

        channel_id = channel_id' as Snowflake
        action_type = action_type' as NewMemberActionType
        title = title' as String
        description = description' as String
        emoji = emoji'
        icon = icon'

primitive _NewMemberActions
    fun apply(value: json.JsonValue): Array[NewMemberAction] val ? =>
        """
        Decodes an array of new member actions.
        """

        let array = value as json.JsonArray
        recover val
            let actions = Array[NewMemberAction](array.size())
            for action in array.values() do
                actions.push(
                    NewMemberAction.from_json(action as json.JsonObject)?
                )
            end
            actions
        end

class val ResourceChannel is FromJsonable
    """
    https://docs.discord.com/developers/resources/guild#resource-channel-object

    A channel the server guide points new members at.
    """

    let channel_id: Snowflake
    let title: String
    let description: String
    let emoji: (SettingsEmoji | None)
    let icon: (String | None)

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var title': (String | None) = None
        var description': (String | None) = None
        var emoji': (SettingsEmoji | None) = None
        var icon': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "title" => title' = value as String
            | "description" => description' = value as String
            | "emoji" =>
                match value
                | let obj': json.JsonObject =>
                    emoji' = SettingsEmoji.from_json(obj')?
                end
            | "icon" =>
                match value | let string: String => icon' = string end
            end
        end

        channel_id = channel_id' as Snowflake
        title = title' as String
        description = description' as String
        emoji = emoji'
        icon = icon'

primitive _ResourceChannels
    fun apply(value: json.JsonValue): Array[ResourceChannel] val ? =>
        """
        Decodes an array of resource channels.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[ResourceChannel](array.size())
            for channel in array.values() do
                channels.push(
                    ResourceChannel.from_json(channel as json.JsonObject)?
                )
            end
            channels
        end

class val WelcomeMessage is FromJsonable
    """
    https://docs.discord.com/developers/resources/guild#welcome-message-object
    """

    let author_ids: Array[Snowflake] val
    let message: String

    new val from_json(obj: json.JsonObject) ? =>
        var author_ids': (Array[Snowflake] val | None) = None
        var message': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "author_ids" => author_ids' = _Snowflakes(value)?
            | "message" => message' = value as String
            end
        end

        author_ids = author_ids' as Array[Snowflake] val
        message = message' as String

class val GuildNewMemberWelcome is FromJsonable
    """
    https://docs.discord.com/developers/resources/guild#get-guild-new-member-welcome

    The server guide shown to members who have just joined.
    """

    let guild_id: Snowflake
    let enabled: Bool
    let welcome_message: (WelcomeMessage | None)
    let new_member_actions: Array[NewMemberAction] val
    let resource_channels: Array[ResourceChannel] val

    new val from_json(obj: json.JsonObject) ? =>
        var guild_id': (Snowflake | None) = None
        var enabled': (Bool | None) = None
        var welcome_message': (WelcomeMessage | None) = None
        var new_member_actions': (Array[NewMemberAction] val | None) = None
        var resource_channels': (Array[ResourceChannel] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "enabled" => enabled' = value as Bool
            | "welcome_message" =>
                match value
                | let obj': json.JsonObject =>
                    welcome_message' = WelcomeMessage.from_json(obj')?
                end
            | "new_member_actions" =>
                new_member_actions' = _NewMemberActions(value)?
            | "resource_channels" =>
                resource_channels' = _ResourceChannels(value)?
            end
        end

        guild_id = guild_id' as Snowflake
        enabled = enabled' as Bool
        welcome_message = welcome_message'
        new_member_actions =
            new_member_actions' as Array[NewMemberAction] val
        resource_channels = resource_channels' as Array[ResourceChannel] val
