use collections = "collections"
use json = "json"

class val Guild
    """
    https://docs.discord.com/developers/resources/guild#guild-object-guild-structure

    Guilds in Discord represent an isolated collection of users and channels, and are often referred to as "servers" in the UI.
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
        discovery splash hash; only present for guilds with the "DISCOVERABLE" feature
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
        total permissions for the user in the guild (excludes overwrites and implicit permissions)
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
        the channel id that the widget will generate an invite to, or null if set to no invite
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

        Features are left as strings rather than decoded into an enum because Discord adds new feature flags without notice, and an unrecognised one would otherwise fail the decode of the whole guild.
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
        the id of the channel where guild notices such as welcome messages and boost events are posted
        """

    let system_channel_flags: Array[SystemChannelFlag] val
        """
        system channel flags
        """

    let rules_channel_id: (Snowflake | None)
        """
        the id of the channel where Community guilds can display rules and/or guidelines
        """

    let max_presences: (USize | None)
        """
        the maximum number of presences for the guild (null is always returned, apart from the largest of guilds)
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
        the preferred locale of a Community guild; used in server discovery and notices from Discord, and sent in interactions; defaults to "en-US"
        """

    let public_updates_channel_id: (Snowflake | None)
        """
        the id of the channel where admins and moderators of Community guilds receive notices from Discord
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
        approximate number of members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
        """

    let approximate_presence_count: (USize | None)
        """
        approximate number of non-offline members in this guild, returned from the GET /guilds/<id> and /users/@me/guilds endpoints when with_counts is true
        """

    let welcome_screen: (WelcomeScreen | None)
        """
        the welcome screen of a Community guild, shown to new members, returned in an Invite's guild object
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
        the id of the channel where admins and moderators of Community guilds receive safety alerts from Discord
        """

    let incidents_data: (IncidentsData | None)
        """
        the incidents data for this guild
        """

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
        var default_message_notifications': (DefaultMessageNotificationLevel | None) = None
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
                match value | let string: String => discovery_splash' = string end
            | "owner" => owner' = value as Bool
            | "owner_id" => owner_id' = Snowflake.from_json(value)?
            | "permissions" => permissions' = _Permissions(value)?
            | "afk_channel_id" =>
                match value | let string: String => afk_channel_id' = Snowflake.from_json(string)? end
            | "afk_timeout" => afk_timeout' = (value as I64).usize()
            | "widget_enabled" => widget_enabled' = value as Bool
            | "widget_channel_id" =>
                match value | let string: String => widget_channel_id' = Snowflake.from_json(string)? end
            | "verification_level" => verification_level' = VerificationLevels.from((value as I64).u8())?
            | "default_message_notifications" => default_message_notifications' = DefaultMessageNotificationLevels.from((value as I64).u8())?
            | "explicit_content_filter" => explicit_content_filter' = ExplicitContentFilterLevels.from((value as I64).u8())?
            | "roles" => roles' = _Roles(value)?
            | "emojis" => emojis' = _Emojis(value)?
            | "features" => features' = _Strings(value)?
            | "mfa_level" => mfa_level' = MFALevels.from((value as I64).u8())?
            | "application_id" =>
                match value | let string: String => application_id' = Snowflake.from_json(string)? end
            | "system_channel_id" =>
                match value | let string: String => system_channel_id' = Snowflake.from_json(string)? end
            | "system_channel_flags" => system_channel_flags' = _SystemChannelFlags((value as I64).u64())
            | "rules_channel_id" =>
                match value | let string: String => rules_channel_id' = Snowflake.from_json(string)? end
            | "max_presences" =>
                match value | let integer: I64 => max_presences' = integer.usize() end
            | "max_members" => max_members' = (value as I64).usize()
            | "vanity_url_code" =>
                match value | let string: String => vanity_url_code' = string end
            | "description" =>
                match value | let string: String => description' = string end
            | "banner" =>
                match value | let string: String => banner' = string end
            | "premium_tier" => premium_tier' = PremiumTiers.from((value as I64).u8())?
            | "premium_subscription_count" => premium_subscription_count' = (value as I64).usize()
            | "preferred_locale" => preferred_locale' = Locales.from(value as String)?
            | "public_updates_channel_id" =>
                match value | let string: String => public_updates_channel_id' = Snowflake.from_json(string)? end
            | "max_video_channel_users" => max_video_channel_users' = (value as I64).usize()
            | "max_stage_video_channel_users" => max_stage_video_channel_users' = (value as I64).usize()
            | "approximate_member_count" => approximate_member_count' = (value as I64).usize()
            | "approximate_presence_count" => approximate_presence_count' = (value as I64).usize()
            | "welcome_screen" => welcome_screen' = WelcomeScreen.from_json(value as json.JsonObject)?
            | "nsfw_level" => nsfw_level' = GuildNSFWLevels.from((value as I64).u8())?
            | "stickers" => stickers' = _Stickers(value)?
            | "premium_progress_bar_enabled" => premium_progress_bar_enabled' = value as Bool
            | "safety_alerts_channel_id" =>
                match value | let string: String => safety_alerts_channel_id' = Snowflake.from_json(string)? end
            | "incidents_data" =>
                match value | let obj': json.JsonObject => incidents_data' = IncidentsData.from_json(obj') end
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
        default_message_notifications = default_message_notifications' as DefaultMessageNotificationLevel
        explicit_content_filter = explicit_content_filter' as ExplicitContentFilterLevel
        roles = roles' as Array[Role] val
        emojis = emojis' as Array[Emoji] val
        features = features' as Array[String] val
        mfa_level = mfa_level' as MFALevel
        application_id = application_id'
        system_channel_id = system_channel_id'
        system_channel_flags = system_channel_flags' as Array[SystemChannelFlag] val
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
            .update("afk_channel_id", match afk_channel_id | let afk_channel_id': Snowflake => afk_channel_id'.to_json() end)
            .update("afk_timeout", afk_timeout.i64())
            .update("verification_level", verification_level.value().i64())
            .update("default_message_notifications", default_message_notifications.value().i64())
            .update("explicit_content_filter", explicit_content_filter.value().i64())
            .update("roles", _Roles.to_json(roles))
            .update("emojis", _Emojis.to_json(emojis))
            .update("features", _Strings.to_json(features))
            .update("mfa_level", mfa_level.value().i64())
            .update("application_id", match application_id | let application_id': Snowflake => application_id'.to_json() end)
            .update("system_channel_id", match system_channel_id | let system_channel_id': Snowflake => system_channel_id'.to_json() end)
            .update("system_channel_flags", _SystemChannelFlags.to_json(system_channel_flags))
            .update("rules_channel_id", match rules_channel_id | let rules_channel_id': Snowflake => rules_channel_id'.to_json() end)
            .update("vanity_url_code", vanity_url_code)
            .update("description", description)
            .update("banner", banner)
            .update("premium_tier", premium_tier.value().i64())
            .update("preferred_locale", preferred_locale.value())
            .update("public_updates_channel_id", match public_updates_channel_id | let public_updates_channel_id': Snowflake => public_updates_channel_id'.to_json() end)
            .update("nsfw_level", nsfw_level.value().i64())
            .update("premium_progress_bar_enabled", premium_progress_bar_enabled)
            .update("safety_alerts_channel_id", match safety_alerts_channel_id | let safety_alerts_channel_id': Snowflake => safety_alerts_channel_id'.to_json() end)
            .update("incidents_data", match incidents_data | let incidents_data': IncidentsData => incidents_data'.to_json() end)

        match icon_hash
        | let icon_hash': String => obj = obj.update("icon_hash", icon_hash')
        end

        match owner
        | let owner': Bool => obj = obj.update("owner", owner')
        end

        match permissions
        | let permissions': Array[Permission] val => obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match widget_enabled
        | let widget_enabled': Bool => obj = obj.update("widget_enabled", widget_enabled')
        end

        match widget_channel_id
        | let widget_channel_id': Snowflake => obj = obj.update("widget_channel_id", widget_channel_id'.to_json())
        end

        match max_presences
        | let max_presences': USize => obj = obj.update("max_presences", max_presences'.i64())
        end

        match max_members
        | let max_members': USize => obj = obj.update("max_members", max_members'.i64())
        end

        match premium_subscription_count
        | let premium_subscription_count': USize => obj = obj.update("premium_subscription_count", premium_subscription_count'.i64())
        end

        match max_video_channel_users
        | let max_video_channel_users': USize => obj = obj.update("max_video_channel_users", max_video_channel_users'.i64())
        end

        match max_stage_video_channel_users
        | let max_stage_video_channel_users': USize => obj = obj.update("max_stage_video_channel_users", max_stage_video_channel_users'.i64())
        end

        match approximate_member_count
        | let approximate_member_count': USize => obj = obj.update("approximate_member_count", approximate_member_count'.i64())
        end

        match approximate_presence_count
        | let approximate_presence_count': USize => obj = obj.update("approximate_presence_count", approximate_presence_count'.i64())
        end

        match welcome_screen
        | let welcome_screen': WelcomeScreen => obj = obj.update("welcome_screen", welcome_screen'.to_json())
        end

        match stickers
        | let stickers': Array[Sticker] val => obj = obj.update("stickers", _Stickers.to_json(stickers'))
        end

        obj

trait val DefaultMessageNotificationLevel is (collections.Hashable & Equatable[DefaultMessageNotificationLevel])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-default-message-notification-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: DefaultMessageNotificationLevel): Bool => value() == that.value()
primitive AllMessagesDefaultMessageNotificationLevel is DefaultMessageNotificationLevel
    """
    members will receive notifications for all messages by default
    """

    fun value(): U8 => 0
primitive OnlyMentionsDefaultMessageNotificationLevel is DefaultMessageNotificationLevel
    """
    members will receive notifications only for messages that @mention them by default
    """

    fun value(): U8 => 1
primitive DefaultMessageNotificationLevels
    fun from(value: U8): DefaultMessageNotificationLevel ? =>
        match value
        | 0 => AllMessagesDefaultMessageNotificationLevel
        | 1 => OnlyMentionsDefaultMessageNotificationLevel
        else error
        end

trait val ExplicitContentFilterLevel is (collections.Hashable & Equatable[ExplicitContentFilterLevel])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-explicit-content-filter-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ExplicitContentFilterLevel): Bool => value() == that.value()
primitive DisabledExplicitContentFilterLevel is ExplicitContentFilterLevel
    """
    media content will not be scanned
    """

    fun value(): U8 => 0
primitive MembersWithoutRolesExplicitContentFilterLevel is ExplicitContentFilterLevel
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

trait val MFALevel is (collections.Hashable & Equatable[MFALevel])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-mfa-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: MFALevel): Bool => value() == that.value()
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

trait val VerificationLevel is (collections.Hashable & Equatable[VerificationLevel])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-verification-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: VerificationLevel): Bool => value() == that.value()
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

trait val GuildNSFWLevel is (collections.Hashable & Equatable[GuildNSFWLevel])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-guild-nsfw-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: GuildNSFWLevel): Bool => value() == that.value()
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

trait val PremiumTier is (collections.Hashable & Equatable[PremiumTier])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-premium-tier
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: PremiumTier): Bool => value() == that.value()
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

trait val SystemChannelFlag is (collections.Hashable & Equatable[SystemChannelFlag])
    """
    https://docs.discord.com/developers/resources/guild#guild-object-system-channel-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SystemChannelFlag): Bool => value() == that.value()
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
primitive SuppressGuildReminderNotificationsSystemChannelFlag is SystemChannelFlag
    """
    Suppress server setup tips
    """

    fun value(): U8 => 2
primitive SuppressJoinNotificationRepliesSystemChannelFlag is SystemChannelFlag
    """
    Hide member join sticker reply buttons
    """

    fun value(): U8 => 3
primitive SuppressRoleSubscriptionPurchaseNotificationsSystemChannelFlag is SystemChannelFlag
    """
    Suppress role subscription purchase and renewal notifications
    """

    fun value(): U8 => 4
primitive SuppressRoleSubscriptionPurchaseNotificationRepliesSystemChannelFlag is SystemChannelFlag
    """
    Hide role subscription sticker reply buttons
    """

    fun value(): U8 => 5
primitive SystemChannelFlags
    fun from(value: U8): SystemChannelFlag ? =>
        match value
        | 0 => SuppressJoinNotificationsSystemChannelFlag
        | 1 => SuppressPremiumSubscriptionsSystemChannelFlag
        | 2 => SuppressGuildReminderNotificationsSystemChannelFlag
        | 3 => SuppressJoinNotificationRepliesSystemChannelFlag
        | 4 => SuppressRoleSubscriptionPurchaseNotificationsSystemChannelFlag
        | 5 => SuppressRoleSubscriptionPurchaseNotificationRepliesSystemChannelFlag
        else error
        end

primitive _SystemChannelFlags
    fun apply(bits: U64): Array[SystemChannelFlag] val =>
        recover val
            let flags = Array[SystemChannelFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(SystemChannelFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[SystemChannelFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

class val GuildPreview
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
                match value | let string: String => discovery_splash' = string end
            | "emojis" => emojis' = _Emojis(value)?
            | "features" => features' = _Strings(value)?
            | "approximate_member_count" => approximate_member_count' = (value as I64).usize()
            | "approximate_presence_count" => approximate_presence_count' = (value as I64).usize()
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
            .update("approximate_presence_count", approximate_presence_count.i64())
            .update("description", description)
            .update("stickers", _Stickers.to_json(stickers))

class val GuildWidgetSettings
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

    new val from_json(obj: json.JsonObject) ? =>
        var enabled': (Bool | None) = None
        var channel_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "enabled" => enabled' = value as Bool
            | "channel_id" =>
                match value | let string: String => channel_id' = Snowflake.from_json(string)? end
            end
        end

        enabled = enabled' as Bool
        channel_id = channel_id'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("enabled", enabled)
            .update("channel_id", match channel_id | let channel_id': Snowflake => channel_id'.to_json() end)

class val GuildWidget
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

    // TODO(vxern): Add `channels` (array of partial channel objects; voice and stage channels which are accessible by @everyone) once a partial variant of `Channel` is implemented. The widget carries only `id`, `name` and `position`, so `Channel` — which requires `type` — cannot decode them.

    let members: Array[User] val
        """
        special widget user objects that includes users presence (Limit 100)

        These are anonymised: the `id`, `discriminator` and `avatar` fields are placeholders. They also carry `status` and `avatar_url` fields that `User` does not model, so those are dropped on decode.
        """

    let presence_count: USize
        """
        number of online members in this guild
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var instant_invite': (String | None) = None
        var members': (Array[User] val | None) = None
        var presence_count': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "instant_invite" =>
                match value | let string: String => instant_invite' = string end
            | "members" => members' = _Users(value)?
            | "presence_count" => presence_count' = (value as I64).usize()
            end
        end

        id = id' as Snowflake
        name = name' as String
        instant_invite = instant_invite'
        members = members' as Array[User] val
        presence_count = presence_count' as USize

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("instant_invite", instant_invite)
            .update("members", _Users.to_json(members))
            .update("presence_count", presence_count.i64())

class val GuildMember
    """
    https://docs.discord.com/developers/resources/guild#guild-member-object-guild-member-structure

    The field `user` won't be included in the member object attached to MESSAGE_CREATE and MESSAGE_UPDATE gateway events.

    In GUILD_ events, `pending` will always be included as true or false. In non `GUILD_` events which can only be triggered by non-`pending` users, `pending` will not be included.
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
        whether the user has not yet passed the guild's Membership Screening requirements
        """

    let permissions: (Array[Permission] val | None)
        """
        total permissions of the member in the channel, including overwrites, returned when in the interaction object
        """

    let communication_disabled_until: (ISO8601 | None)
        """
        when the user's timeout will expire and the user will be able to communicate in the guild again, null or a time in the past if the user is not timed out
        """

    let avatar_decoration_data: (AvatarDecorationData | None)
        """
        data for the member's guild avatar decoration
        """

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
                match value | let string: String => communication_disabled_until' = string end
            | "avatar_decoration_data" =>
                match value | let obj': json.JsonObject => avatar_decoration_data' = AvatarDecorationData.from_json(obj')? end
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
        | let premium_since': ISO8601 => obj = obj.update("premium_since", premium_since')
        end

        match pending
        | let pending': Bool => obj = obj.update("pending", pending')
        end

        match permissions
        | let permissions': Array[Permission] val => obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match communication_disabled_until
        | let communication_disabled_until': ISO8601 => obj = obj.update("communication_disabled_until", communication_disabled_until')
        end

        match avatar_decoration_data
        | let avatar_decoration_data': AvatarDecorationData => obj = obj.update("avatar_decoration_data", avatar_decoration_data'.to_json())
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
            for member in array.values() do members.push(GuildMember.from_json(member as json.JsonObject)?) end
            members
        end

    fun to_json(members: Array[GuildMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do array = array.push(member.to_json()) end
        array

trait val GuildMemberFlag is (collections.Hashable & Equatable[GuildMemberFlag])
    """
    https://docs.discord.com/developers/resources/guild#guild-member-object-guild-member-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: GuildMemberFlag): Bool => value() == that.value()
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
                    try flags.push(GuildMemberFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[GuildMemberFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

class val Integration
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
        whether emoticons should be synced for this integration (twitch only currently)
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
            | "expire_behavior" => expire_behavior' = IntegrationExpireBehaviors.from((value as I64).u8())?
            | "expire_grace_period" => expire_grace_period' = (value as I64).usize()
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "account" => account' = IntegrationAccount.from_json(value as json.JsonObject)?
            | "synced_at" => synced_at' = value as String
            | "subscriber_count" => subscriber_count' = (value as I64).usize()
            | "revoked" => revoked' = value as Bool
            | "application" => application' = IntegrationApplication.from_json(value as json.JsonObject)?
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
        | let role_id': Snowflake => obj = obj.update("role_id", role_id'.to_json())
        end

        match enable_emoticons
        | let enable_emoticons': Bool => obj = obj.update("enable_emoticons", enable_emoticons')
        end

        match expire_behavior
        | let expire_behavior': IntegrationExpireBehavior => obj = obj.update("expire_behavior", expire_behavior'.value().i64())
        end

        match expire_grace_period
        | let expire_grace_period': USize => obj = obj.update("expire_grace_period", expire_grace_period'.i64())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match synced_at
        | let synced_at': ISO8601 => obj = obj.update("synced_at", synced_at')
        end

        match subscriber_count
        | let subscriber_count': USize => obj = obj.update("subscriber_count", subscriber_count'.i64())
        end

        match revoked
        | let revoked': Bool => obj = obj.update("revoked", revoked')
        end

        match application
        | let application': IntegrationApplication => obj = obj.update("application", application'.to_json())
        end

        match scopes
        | let scopes': Array[String] val => obj = obj.update("scopes", _Strings.to_json(scopes'))
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
            for integration in array.values() do integrations.push(Integration.from_json(integration as json.JsonObject)?) end
            integrations
        end

    fun to_json(integrations: Array[Integration] val): json.JsonArray =>
        var array = json.JsonArray
        for integration in integrations.values() do array = array.push(integration.to_json()) end
        array

trait val IntegrationExpireBehavior is (collections.Hashable & Equatable[IntegrationExpireBehavior])
    """
    https://docs.discord.com/developers/resources/guild#integration-object-integration-expire-behaviors
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: IntegrationExpireBehavior): Bool => value() == that.value()
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

class val IntegrationAccount
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

class val IntegrationApplication
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

class val Ban
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

class val WelcomeScreen
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

    new val from_json(obj: json.JsonObject) ? =>
        var description': (String | None) = None
        var welcome_channels': (Array[WelcomeScreenChannel] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "description" =>
                match value | let string: String => description' = string end
            | "welcome_channels" => welcome_channels' = _WelcomeScreenChannels(value)?
            end
        end

        description = description'
        welcome_channels = welcome_channels' as Array[WelcomeScreenChannel] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("description", description)
            .update("welcome_channels", _WelcomeScreenChannels.to_json(welcome_channels))

class val WelcomeScreenChannel
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
        the emoji name if custom, the unicode character if standard, or null if no emoji is set
        """

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
                match value | let string: String => emoji_id' = Snowflake.from_json(string)? end
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
            .update("emoji_id", match emoji_id | let emoji_id': Snowflake => emoji_id'.to_json() end)
            .update("emoji_name", emoji_name)

primitive _WelcomeScreenChannels
    fun apply(value: json.JsonValue): Array[WelcomeScreenChannel] val ? =>
        """
        Decodes an array of welcome screen channels.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[WelcomeScreenChannel](array.size())
            for channel in array.values() do channels.push(WelcomeScreenChannel.from_json(channel as json.JsonObject)?) end
            channels
        end

    fun to_json(channels: Array[WelcomeScreenChannel] val): json.JsonArray =>
        var array = json.JsonArray
        for channel in channels.values() do array = array.push(channel.to_json()) end
        array

class val GuildOnboarding
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
            | "default_channel_ids" => default_channel_ids' = _Snowflakes(value)?
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
            .update("default_channel_ids", _Snowflakes.to_json(default_channel_ids))
            .update("enabled", enabled)
            .update("mode", mode.value().i64())

trait val OnboardingMode is (collections.Hashable & Equatable[OnboardingMode])
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-onboarding-mode

    Defines the criteria used to satisfy Onboarding constraints that are required for enabling.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: OnboardingMode): Bool => value() == that.value()
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

class val OnboardingPrompt
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
        Indicates whether users are limited to selecting one option for the prompt
        """

    let required: Bool
        """
        Indicates whether the prompt is required before a user completes the onboarding flow
        """

    let in_onboarding: Bool
        """
        Indicates whether the prompt is present in the onboarding flow. If false, the prompt will only appear in the Channels & Roles tab
        """

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
            | "type" => type'' = OnboardingPromptTypes.from((value as I64).u8())?
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
            for prompt in array.values() do prompts.push(OnboardingPrompt.from_json(prompt as json.JsonObject)?) end
            prompts
        end

    fun to_json(prompts: Array[OnboardingPrompt] val): json.JsonArray =>
        var array = json.JsonArray
        for prompt in prompts.values() do array = array.push(prompt.to_json()) end
        array

trait val OnboardingPromptType is (collections.Hashable & Equatable[OnboardingPromptType])
    """
    https://docs.discord.com/developers/resources/guild#guild-onboarding-object-prompt-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: OnboardingPromptType): Bool => value() == that.value()
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

class val OnboardingPromptOption
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

        When creating or updating a prompt option, `emoji_id`, `emoji_name`, and `emoji_animated` should be used instead of this field.
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
        | let emoji_id': Snowflake => obj = obj.update("emoji_id", emoji_id'.to_json())
        end

        match emoji_name
        | let emoji_name': String => obj = obj.update("emoji_name", emoji_name')
        end

        match emoji_animated
        | let emoji_animated': Bool => obj = obj.update("emoji_animated", emoji_animated')
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
            for option in array.values() do options.push(OnboardingPromptOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[OnboardingPromptOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

class val IncidentsData
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

    new val from_json(obj: json.JsonObject) =>
        var invites_disabled_until': (ISO8601 | None) = None
        var dms_disabled_until': (ISO8601 | None) = None
        var dm_spam_detected_at': (ISO8601 | None) = None
        var raid_detected_at': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "invites_disabled_until" =>
                match value | let string: String => invites_disabled_until' = string end
            | "dms_disabled_until" =>
                match value | let string: String => dms_disabled_until' = string end
            | "dm_spam_detected_at" =>
                match value | let string: String => dm_spam_detected_at' = string end
            | "raid_detected_at" =>
                match value | let string: String => raid_detected_at' = string end
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
        | let dm_spam_detected_at': ISO8601 => obj = obj.update("dm_spam_detected_at", dm_spam_detected_at')
        end

        match raid_detected_at
        | let raid_detected_at': ISO8601 => obj = obj.update("raid_detected_at", raid_detected_at')
        end

        obj
