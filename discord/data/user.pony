use collections = "collections"
use json = "json"

class val User is Jsonable
    """
    https://docs.discord.com/developers/resources/user#user-object-user-structure

    Users in Discord are generally considered the base entity. Users can spawn across the entire platform, be members of guilds, participate in text and voice chat, and much more. Users are separated by a distinction of "bot" vs "normal." Although they are similar, bot users are automated users that are "owned" by another user. Unlike normal users, bot users do not have a limitation on the number of Guilds they can be a part of.
    """

    let id: Snowflake
        """
        the user's id
        """

    let username: String
        """
        the user's username, not unique across the platform
        """

    let discriminator: String
        """
        the user's Discord-tag
        """

    let global_name: (String | None)
        """
        the user's display name, if it is set. For bots, this is the application name
        """

    let avatar: (String | None)
        """
        the user's avatar hash
        """

    let bot: (Bool | None)
        """
        whether the user belongs to an OAuth2 application
        """

    let system: (Bool | None)
        """
        whether the user is an Official Discord System user (part of the urgent message system)
        """

    let mfa_enabled: (Bool | None)
        """
        whether the user has two factor enabled on their account
        """

    let banner: (String | None)
        """
        the user's banner hash
        """

    let accent_color: (I64 | None)
        """
        the user's banner color encoded as an integer representation of hexadecimal color code
        """

    let locale: (Locale | None)
        """
        the user's chosen language option
        """

    let verified: (Bool | None)
        """
        whether the email on this account has been verified
        """

    let email: (String | None)
        """
        the user's email
        """

    let flags: (Array[UserFlag] val | None)
        """
        the flags on a user's account
        """

    let premium_type: (PremiumType | None)
        """
        the type of Nitro subscription on a user's account
        """

    let public_flags: (Array[UserFlag] val | None)
        """
        the public flags on a user's account
        """

    let avatar_decoration_data: (AvatarDecorationData | None)
        """
        data for the user's avatar decoration
        """

    let collectibles: (Collectibles | None)
        """
        data for the user's collectibles
        """

    let primary_guild: (UserPrimaryGuild | None)
        """
        the user's primary guild
        """

    new val create(
        id': Snowflake,
        username': String,
        discriminator': String,
        global_name': (String | None) = None,
        avatar': (String | None) = None,
        bot': (Bool | None) = None,
        system': (Bool | None) = None,
        mfa_enabled': (Bool | None) = None,
        banner': (String | None) = None,
        accent_color': (I64 | None) = None,
        locale': (Locale | None) = None,
        verified': (Bool | None) = None,
        email': (String | None) = None,
        flags': (Array[UserFlag] val | None) = None,
        premium_type': (PremiumType | None) = None,
        public_flags': (Array[UserFlag] val | None) = None,
        avatar_decoration_data': (AvatarDecorationData | None) = None,
        collectibles': (Collectibles | None) = None,
        primary_guild': (UserPrimaryGuild | None) = None
    ) =>
        id = id'
        username = username'
        discriminator = discriminator'
        global_name = global_name'
        avatar = avatar'
        bot = bot'
        system = system'
        mfa_enabled = mfa_enabled'
        banner = banner'
        accent_color = accent_color'
        locale = locale'
        verified = verified'
        email = email'
        flags = flags'
        premium_type = premium_type'
        public_flags = public_flags'
        avatar_decoration_data = avatar_decoration_data'
        collectibles = collectibles'
        primary_guild = primary_guild'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var username': (String | None) = None
        var discriminator': (String | None) = None
        var global_name': (String | None) = None
        var avatar': (String | None) = None
        var bot': (Bool | None) = None
        var system': (Bool | None) = None
        var mfa_enabled': (Bool | None) = None
        var banner': (String | None) = None
        var accent_color': (I64 | None) = None
        var locale': (Locale | None) = None
        var verified': (Bool | None) = None
        var email': (String | None) = None
        var flags': (Array[UserFlag] val | None) = None
        var premium_type': (PremiumType | None) = None
        var public_flags': (Array[UserFlag] val | None) = None
        var avatar_decoration_data': (AvatarDecorationData | None) = None
        var collectibles': (Collectibles | None) = None
        var primary_guild': (UserPrimaryGuild | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "username" => username' = value as String
            | "discriminator" => discriminator' = value as String
            | "global_name" =>
                match value | let string: String => global_name' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "bot" => bot' = value as Bool
            | "system" => system' = value as Bool
            | "mfa_enabled" => mfa_enabled' = value as Bool
            | "banner" =>
                match value | let string: String => banner' = string end
            | "accent_color" =>
                match value | let integer: I64 => accent_color' = integer end
            | "locale" => locale' = Locales.from(value as String)?
            | "verified" => verified' = value as Bool
            | "email" =>
                match value | let string: String => email' = string end
            | "flags" => flags' = _UserFlags((value as I64).u64())
            | "premium_type" => premium_type' = PremiumTypes.from((value as I64).u8())?
            | "public_flags" => public_flags' = _UserFlags((value as I64).u64())
            | "avatar_decoration_data" =>
                match value | let obj': json.JsonObject => avatar_decoration_data' = AvatarDecorationData.from_json(obj')? end
            | "collectibles" =>
                match value | let obj': json.JsonObject => collectibles' = Collectibles.from_json(obj')? end
            | "primary_guild" =>
                match value | let obj': json.JsonObject => primary_guild' = UserPrimaryGuild.from_json(obj')? end
            end
        end

        id = id' as Snowflake
        username = username' as String
        discriminator = discriminator' as String
        global_name = global_name'
        avatar = avatar'
        bot = bot'
        system = system'
        mfa_enabled = mfa_enabled'
        banner = banner'
        accent_color = accent_color'
        locale = locale'
        verified = verified'
        email = email'
        flags = flags'
        premium_type = premium_type'
        public_flags = public_flags'
        avatar_decoration_data = avatar_decoration_data'
        collectibles = collectibles'
        primary_guild = primary_guild'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("username", username)
            .update("discriminator", discriminator)
            .update("global_name", global_name)
            .update("avatar", avatar)

        match bot
        | let bot': Bool => obj = obj.update("bot", bot')
        end

        match system
        | let system': Bool => obj = obj.update("system", system')
        end

        match mfa_enabled
        | let mfa_enabled': Bool => obj = obj.update("mfa_enabled", mfa_enabled')
        end

        match banner
        | let banner': String => obj = obj.update("banner", banner')
        end

        match accent_color
        | let accent_color': I64 => obj = obj.update("accent_color", accent_color')
        end

        match locale
        | let locale': Locale => obj = obj.update("locale", locale'.value())
        end

        match verified
        | let verified': Bool => obj = obj.update("verified", verified')
        end

        match email
        | let email': String => obj = obj.update("email", email')
        end

        match flags
        | let flags': Array[UserFlag] val => obj = obj.update("flags", _UserFlags.to_json(flags'))
        end

        match premium_type
        | let premium_type': PremiumType => obj = obj.update("premium_type", premium_type'.value().i64())
        end

        match public_flags
        | let public_flags': Array[UserFlag] val => obj = obj.update("public_flags", _UserFlags.to_json(public_flags'))
        end

        match avatar_decoration_data
        | let avatar_decoration_data': AvatarDecorationData => obj = obj.update("avatar_decoration_data", avatar_decoration_data'.to_json())
        end

        match collectibles
        | let collectibles': Collectibles => obj = obj.update("collectibles", collectibles'.to_json())
        end

        match primary_guild
        | let primary_guild': UserPrimaryGuild => obj = obj.update("primary_guild", primary_guild'.to_json())
        end

        obj

primitive _Users
    fun apply(value: json.JsonValue): Array[User] val ? =>
        """
        Decodes an array of users.
        """

        let array = value as json.JsonArray
        recover val
            let users = Array[User](array.size())
            for user in array.values() do users.push(User.from_json(user as json.JsonObject)?) end
            users
        end

    fun to_json(users: Array[User] val): json.JsonArray =>
        var array = json.JsonArray
        for user in users.values() do array = array.push(user.to_json()) end
        array

trait val UserFlag is _Enum[UserFlag, U8]
    """
    https://docs.discord.com/developers/resources/user#user-object-user-flags
    """
primitive StaffUserFlag is UserFlag
    """
    Discord Employee
    """

    fun value(): U8 => 0
primitive PartnerUserFlag is UserFlag
    """
    Partnered Server Owner
    """

    fun value(): U8 => 1
primitive HypesquadUserFlag is UserFlag
    """
    HypeSquad Events Member
    """

    fun value(): U8 => 2
primitive BugHunterLevel1UserFlag is UserFlag
    """
    Bug Hunter Level 1
    """

    fun value(): U8 => 3
primitive HypeSquadOnlineHouse1UserFlag is UserFlag
    """
    House Bravery Member
    """

    fun value(): U8 => 6
primitive HypeSquadOnlineHouse2UserFlag is UserFlag
    """
    House Brilliance Member
    """

    fun value(): U8 => 7
primitive HypeSquadOnlineHouse3UserFlag is UserFlag
    """
    House Balance Member
    """

    fun value(): U8 => 8
primitive PremiumEarlySupporterUserFlag is UserFlag
    """
    Early Nitro Supporter
    """

    fun value(): U8 => 9
primitive TeamPseudoUserUserFlag is UserFlag
    """
    User is a team
    """

    fun value(): U8 => 10
primitive BugHunterLevel2UserFlag is UserFlag
    """
    Bug Hunter Level 2
    """

    fun value(): U8 => 14
primitive VerifiedBotUserFlag is UserFlag
    """
    Verified Bot
    """

    fun value(): U8 => 16
primitive VerifiedDeveloperUserFlag is UserFlag
    """
    Early Verified Bot Developer
    """

    fun value(): U8 => 17
primitive CertifiedModeratorUserFlag is UserFlag
    """
    Moderator Programs Alumni
    """

    fun value(): U8 => 18
primitive BotHTTPInteractionsUserFlag is UserFlag
    """
    Bot uses only HTTP interactions and is shown in the online member list
    """

    fun value(): U8 => 19
primitive ActiveDeveloperUserFlag is UserFlag
    """
    User is an Active Developer
    """

    fun value(): U8 => 22
primitive UserFlags
    fun from(value: U8): UserFlag ? =>
        match value
        | 0 => StaffUserFlag
        | 1 => PartnerUserFlag
        | 2 => HypesquadUserFlag
        | 3 => BugHunterLevel1UserFlag
        | 6 => HypeSquadOnlineHouse1UserFlag
        | 7 => HypeSquadOnlineHouse2UserFlag
        | 8 => HypeSquadOnlineHouse3UserFlag
        | 9 => PremiumEarlySupporterUserFlag
        | 10 => TeamPseudoUserUserFlag
        | 14 => BugHunterLevel2UserFlag
        | 16 => VerifiedBotUserFlag
        | 17 => VerifiedDeveloperUserFlag
        | 18 => CertifiedModeratorUserFlag
        | 19 => BotHTTPInteractionsUserFlag
        | 22 => ActiveDeveloperUserFlag
        else error
        end

primitive _UserFlags
    fun apply(bits: U64): Array[UserFlag] val =>
        recover val
            let flags = Array[UserFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(UserFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[UserFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

trait val PremiumType is _Enum[PremiumType, U8]
    """
    https://docs.discord.com/developers/resources/user#user-object-premium-types

    Premium types denote the level of premium a user has. Visit the Nitro page to learn more about the premium plans we currently offer.
    """
primitive NonePremiumType is PremiumType
    fun value(): U8 => 0
primitive NitroClassicPremiumType is PremiumType
    fun value(): U8 => 1
primitive NitroPremiumType is PremiumType
    fun value(): U8 => 2
primitive NitroBasicPremiumType is PremiumType
    fun value(): U8 => 3
primitive PremiumTypes
    fun from(value: U8): PremiumType ? =>
        match value
        | 0 => NonePremiumType
        | 1 => NitroClassicPremiumType
        | 2 => NitroPremiumType
        | 3 => NitroBasicPremiumType
        else error
        end

class val AvatarDecorationData is Jsonable
    """
    https://docs.discord.com/developers/resources/user#avatar-decoration-data-object-avatar-decoration-data-structure

    The data for the user's avatar decoration.
    """

    let asset: String
        """
        the avatar decoration hash
        """

    let sku_id: Snowflake
        """
        id of the avatar decoration's SKU
        """

    new val create(asset': String, sku_id': Snowflake) =>
        asset = asset'
        sku_id = sku_id'

    new val from_json(obj: json.JsonObject) ? =>
        var asset': (String | None) = None
        var sku_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "asset" => asset' = value as String
            | "sku_id" => sku_id' = Snowflake.from_json(value)?
            end
        end

        asset = asset' as String
        sku_id = sku_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("asset", asset)
            .update("sku_id", sku_id.to_json())

class val Collectibles is Jsonable
    """
    https://docs.discord.com/developers/resources/user#collectibles

    The collectibles the user has, excluding Avatar Decorations and Profile Effects.
    """

    let nameplate: (Nameplate | None)
        """
        object mapping of the user's nameplate
        """

    new val create(nameplate': (Nameplate | None) = None) =>
        nameplate = nameplate'

    new val from_json(obj: json.JsonObject) ? =>
        var nameplate': (Nameplate | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "nameplate" =>
                match value | let obj': json.JsonObject => nameplate' = Nameplate.from_json(obj')? end
            end
        end

        nameplate = nameplate'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match nameplate
        | let nameplate': Nameplate => obj = obj.update("nameplate", nameplate'.to_json())
        end

        obj

class val Nameplate is Jsonable
    """
    https://docs.discord.com/developers/resources/user#nameplate

    The nameplate the user has.
    """

    let sku_id: Snowflake
        """
        ID of the nameplate SKU
        """

    let asset: String
        """
        path to the nameplate asset
        """

    let label: String
        """
        the label of this nameplate. Currently unused
        """

    let palette: String
        """
        background color of the nameplate
        """

    new val create(
        sku_id': Snowflake,
        asset': String,
        label': String,
        palette': String
    ) =>
        sku_id = sku_id'
        asset = asset'
        label = label'
        palette = palette'

    new val from_json(obj: json.JsonObject) ? =>
        var sku_id': (Snowflake | None) = None
        var asset': (String | None) = None
        var label': (String | None) = None
        var palette': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "sku_id" => sku_id' = Snowflake.from_json(value)?
            | "asset" => asset' = value as String
            | "label" => label' = value as String
            | "palette" => palette' = value as String
            end
        end

        sku_id = sku_id' as Snowflake
        asset = asset' as String
        label = label' as String
        palette = palette' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("sku_id", sku_id.to_json())
            .update("asset", asset)
            .update("label", label)
            .update("palette", palette)

class val UserPrimaryGuild is Jsonable
    """
    https://docs.discord.com/developers/resources/user#user-object-user-primary-guild
    """

    let identity_guild_id: (Snowflake | None)
        """
        the id of the user's primary guild
        """

    let identity_enabled: (Bool | None)
        """
        whether the user is displaying the primary guild's server tag. This can be null if the system clears the identity, e.g. because the server no longer supports tags
        """

    let tag': (String | None)
        """
        the text of the user's server tag. Limited to 4 characters
        """

    let badge: (String | None)
        """
        the server tag badge hash
        """

    new val create(
        identity_guild_id': (Snowflake | None) = None,
        identity_enabled': (Bool | None) = None,
        tag'': (String | None) = None,
        badge': (String | None) = None
    ) =>
        identity_guild_id = identity_guild_id'
        identity_enabled = identity_enabled'
        tag' = tag''
        badge = badge'

    new val from_json(obj: json.JsonObject) ? =>
        var identity_guild_id': (Snowflake | None) = None
        var identity_enabled': (Bool | None) = None
        var tag'': (String | None) = None
        var badge': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "identity_guild_id" =>
                match value | let string: String => identity_guild_id' = Snowflake.from_json(string)? end
            | "identity_enabled" =>
                match value | let bool: Bool => identity_enabled' = bool end
            | "tag" =>
                match value | let string: String => tag'' = string end
            | "badge" =>
                match value | let string: String => badge' = string end
            end
        end

        identity_guild_id = identity_guild_id'
        identity_enabled = identity_enabled'
        tag' = tag''
        badge = badge'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("identity_guild_id", match identity_guild_id | let identity_guild_id': Snowflake => identity_guild_id'.to_json() end)
            .update("identity_enabled", identity_enabled)
            .update("tag", tag')
            .update("badge", badge)

class val Connection is Jsonable
    """
    https://docs.discord.com/developers/resources/user#connection-object-connection-structure

    The connection object that the user has attached.
    """

    let id: String
        """
        id of the connection account
        """

    let name: String
        """
        the username of the connection account
        """

    let type': String
        """
        the service of this connection
        """

    let revoked: (Bool | None)
        """
        whether the connection is revoked
        """

    let integrations: (Array[Integration] val | None)
        """
        an array of partial server integrations
        """

    let verified: Bool
        """
        whether the connection is verified
        """

    let friend_sync: Bool
        """
        whether friend sync is enabled for this connection
        """

    let show_activity: Bool
        """
        whether activities related to this connection will be shown in presence updates
        """

    let two_way_link: Bool
        """
        whether this connection has a corresponding third party OAuth2 token
        """

    let visibility: ConnectionVisibility
        """
        visibility of this connection
        """

    new val create(
        id': String,
        name': String,
        type'': String,
        revoked': (Bool | None) = None,
        integrations': (Array[Integration] val | None) = None,
        verified': Bool,
        friend_sync': Bool,
        show_activity': Bool,
        two_way_link': Bool,
        visibility': ConnectionVisibility
    ) =>
        id = id'
        name = name'
        type' = type''
        revoked = revoked'
        integrations = integrations'
        verified = verified'
        friend_sync = friend_sync'
        show_activity = show_activity'
        two_way_link = two_way_link'
        visibility = visibility'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (String | None) = None
        var name': (String | None) = None
        var type'': (String | None) = None
        var revoked': (Bool | None) = None
        var integrations': (Array[Integration] val | None) = None
        var verified': (Bool | None) = None
        var friend_sync': (Bool | None) = None
        var show_activity': (Bool | None) = None
        var two_way_link': (Bool | None) = None
        var visibility': (ConnectionVisibility | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = value as String
            | "name" => name' = value as String
            | "type" => type'' = value as String
            | "revoked" => revoked' = value as Bool
            | "integrations" => integrations' = _Integrations(value)?
            | "verified" => verified' = value as Bool
            | "friend_sync" => friend_sync' = value as Bool
            | "show_activity" => show_activity' = value as Bool
            | "two_way_link" => two_way_link' = value as Bool
            | "visibility" => visibility' = ConnectionVisibilities.from((value as I64).u8())?
            end
        end

        id = id' as String
        name = name' as String
        type' = type'' as String
        revoked = revoked'
        integrations = integrations'
        verified = verified' as Bool
        friend_sync = friend_sync' as Bool
        show_activity = show_activity' as Bool
        two_way_link = two_way_link' as Bool
        visibility = visibility' as ConnectionVisibility

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id)
            .update("name", name)
            .update("type", type')
            .update("verified", verified)
            .update("friend_sync", friend_sync)
            .update("show_activity", show_activity)
            .update("two_way_link", two_way_link)
            .update("visibility", visibility.value().i64())

        match revoked
        | let revoked': Bool => obj = obj.update("revoked", revoked')
        end

        match integrations
        | let integrations': Array[Integration] val => obj = obj.update("integrations", _Integrations.to_json(integrations'))
        end

        obj

primitive _Connections
    fun apply(value: json.JsonValue): Array[Connection] val ? =>
        """
        Decodes an array of connections.
        """

        let array = value as json.JsonArray
        recover val
            let connections = Array[Connection](array.size())
            for connection in array.values() do connections.push(Connection.from_json(connection as json.JsonObject)?) end
            connections
        end

    fun to_json(connections: Array[Connection] val): json.JsonArray =>
        var array = json.JsonArray
        for connection in connections.values() do array = array.push(connection.to_json()) end
        array

trait val ConnectionVisibility is _Enum[ConnectionVisibility, U8]
    """
    https://docs.discord.com/developers/resources/user#connection-object-visibility-types
    """
primitive NoneConnectionVisibility is ConnectionVisibility
    """
    invisible to everyone except the user themselves
    """

    fun value(): U8 => 0
primitive EveryoneConnectionVisibility is ConnectionVisibility
    """
    visible to everyone
    """

    fun value(): U8 => 1
primitive ConnectionVisibilities
    fun from(value: U8): ConnectionVisibility ? =>
        match value
        | 0 => NoneConnectionVisibility
        | 1 => EveryoneConnectionVisibility
        else error
        end

class val ApplicationRoleConnection is Jsonable
    """
    https://docs.discord.com/developers/resources/user#application-role-connection-object-application-role-connection-structure

    The role connection object that an application has attached to a user.
    """

    let platform_name: (String | None)
        """
        the vanity name of the platform a bot has connected (max 50 characters)
        """

    let platform_username: (String | None)
        """
        the username on the platform a bot has connected (max 100 characters)
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        object mapping application role connection metadata keys to their string-ified value (max 100 characters) for the user on the platform a bot has connected
        """

    new val create(
        platform_name': (String | None) = None,
        platform_username': (String | None) = None,
        metadata': (collections.Map[String, String] val | None) = None
    ) =>
        platform_name = platform_name'
        platform_username = platform_username'
        metadata = metadata'

    new val from_json(obj: json.JsonObject) =>
        var platform_name': (String | None) = None
        var platform_username': (String | None) = None
        var metadata': (collections.Map[String, String] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "platform_name" =>
                match value | let string: String => platform_name' = string end
            | "platform_username" =>
                match value | let string: String => platform_username' = string end
            | "metadata" => metadata' = _Metadata(value)
            end
        end

        platform_name = platform_name'
        platform_username = platform_username'
        metadata = metadata'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("platform_name", platform_name)
            .update("platform_username", platform_username)

        match metadata
        | let metadata': collections.Map[String, String] val => obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        obj

class val UpdateCurrentUserParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/user#modify-current-user-json-params

    All parameters to this endpoint are optional.
    """

    let username: (String | None)
        """
        user's username, if changed may cause the user's discriminator to be randomized
        """

    let avatar: Nullable[ImageData]
        """
        if passed, modifies the user's avatar
        """

    let banner: Nullable[ImageData]
        """
        if passed, modifies the user's banner
        """

    new val create(
        username': (String | None) = None,
        avatar': Nullable[ImageData] = None,
        banner': Nullable[ImageData] = None
    ) =>
        username = username'
        avatar = avatar'
        banner = banner'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match username
        | let username': String => obj = obj.update("username", username')
        end

        match avatar
        | let avatar': ImageData => obj = obj.update("avatar", avatar')
        | Null => obj = obj.update("avatar", None)
        end

        match banner
        | let banner': ImageData => obj = obj.update("banner", banner')
        | Null => obj = obj.update("banner", None)
        end

        obj

class val GetCurrentUserGuildsParams
    """
    https://docs.discord.com/developers/resources/user#get-current-user-guilds-query-string-params

    This endpoint returns 200 guilds by default, which is the maximum number of guilds a non-bot user can join. Therefore, pagination is not needed for integrations that need to get a list of the users' guilds.

    The `before` and `after` parameters are mutually exclusive, only one may be passed at a time.
    """

    let before: (Snowflake | None)
        """
        get guilds before this guild ID
        """

    let after: (Snowflake | None)
        """
        get guilds after this guild ID
        """

    let limit: (USize | None)
        """
        max number of guilds to return (1-200). Defaults to 200.
        """

    let with_counts: (Bool | None)
        """
        include approximate member and presence counts in response. Defaults to false.
        """

    new val create(
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None,
        limit': (USize | None) = None,
        with_counts': (Bool | None) = None
    ) =>
        before = before'
        after = after'
        limit = limit'
        with_counts = with_counts'

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

        match with_counts
        | let with_counts': Bool => query.push(("with_counts", with_counts'.string()))
        end

        consume query

class val CreateDMParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/user#create-dm-json-params

    You should not use this endpoint to DM everyone in a server about something. DMs should generally be initiated by a user action. If you open a significant amount of DMs too quickly, your bot may be rate limited or blocked from opening new ones.
    """

    let recipient_id: Snowflake
        """
        the recipient to open a DM channel with
        """

    new val create(recipient_id': Snowflake) =>
        recipient_id = recipient_id'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("recipient_id", recipient_id.to_json())

class val CreateGroupDMParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/user#create-group-dm-json-params

    This endpoint is limited to 10 active group DMs.
    """

    let access_tokens: Array[String] val
        """
        access tokens of users that have granted your app the `gdm.join` scope
        """

    let nicks: collections.Map[Snowflake, String] val
        """
        a dictionary of user ids to their respective nicknames
        """

    new val create(access_tokens': Array[String] val, nicks': collections.Map[Snowflake, String] val) =>
        access_tokens = access_tokens'
        nicks = nicks'

    fun to_json(): json.JsonObject =>
        var nicks' = json.JsonObject
        for (id, nick) in nicks.pairs() do nicks' = nicks'.update(id.string(), nick) end

        json.JsonObject
            .update("access_tokens", _Strings.to_json(access_tokens))
            .update("nicks", nicks')

class val UpdateCurrentUserApplicationRoleConnectionParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/user#update-current-user-application-role-connection-json-params

    All parameters to this endpoint are optional.
    """

    let platform_name: (String | None)
        """
        the vanity name of the platform a bot has connected (max 50 characters)
        """

    let platform_username: (String | None)
        """
        the username on the platform a bot has connected (max 100 characters)
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        object mapping application role connection metadata keys to their string-ified value (max 100 characters) for the user on the platform a bot has connected
        """

    new val create(
        platform_name': (String | None) = None,
        platform_username': (String | None) = None,
        metadata': (collections.Map[String, String] val | None) = None
    ) =>
        platform_name = platform_name'
        platform_username = platform_username'
        metadata = metadata'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match platform_name
        | let platform_name': String => obj = obj.update("platform_name", platform_name')
        end

        match platform_username
        | let platform_username': String => obj = obj.update("platform_username", platform_username')
        end

        match metadata
        | let metadata': collections.Map[String, String] val => obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        obj
