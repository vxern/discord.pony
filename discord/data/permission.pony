use json = "json"

trait val Permission is _Enum[Permission, U8]
    """
    https://docs.discord.com/developers/topics/permissions#permissions-bitwise-permission-flags

    Permissions are a way to limit and grant certain abilities to users in
    Discord. A set of base permissions can be configured at the guild level for
    different roles. When these roles are attached to users, they grant or
    revoke specific privileges within the guild. Along with the guild-level
    permissions, Discord also supports permission overwrites that can be
    assigned to individual roles or members on a per-channel basis.

    Timed out members will temporarily lose all permissions except
    `ViewChannelPermission` and `ReadMessageHistoryPermission`. Owners and admin
    users with `AdministratorPermission` are exempt.
    """
primitive CreateInstantInvitePermission is Permission
    """
    Allows creation of instant invites

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 0
primitive KickMembersPermission is Permission
    """
    Allows kicking members
    """

    fun value(): U8 => 1
primitive BanMembersPermission is Permission
    """
    Allows banning members
    """

    fun value(): U8 => 2
primitive AdministratorPermission is Permission
    """
    Allows all permissions and bypasses channel permission overwrites
    """

    fun value(): U8 => 3
primitive ManageChannelsPermission is Permission
    """
    Allows management and editing of channels

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 4
primitive ManageGuildPermission is Permission
    """
    Allows management and editing of the guild
    """

    fun value(): U8 => 5
primitive AddReactionsPermission is Permission
    """
    Allows for adding new reactions to messages

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 6
primitive ViewAuditLogPermission is Permission
    """
    Allows for viewing of audit logs
    """

    fun value(): U8 => 7
primitive PrioritySpeakerPermission is Permission
    """
    Allows for using priority speaker in a voice channel

    Applies to voice channels.
    """

    fun value(): U8 => 8
primitive StreamPermission is Permission
    """
    Allows the user to go live

    Applies to voice and stage channels.
    """

    fun value(): U8 => 9
primitive ViewChannelPermission is Permission
    """
    Allows guild members to view a channel, which includes reading messages in
    text channels and joining voice channels

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 10
primitive SendMessagesPermission is Permission
    """
    Allows for sending messages in a channel and creating threads in a forum
    (does not allow sending messages in threads)

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 11
primitive SendTTSMessagesPermission is Permission
    """
    Allows for sending of `/tts` messages

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 12
primitive ManageMessagesPermission is Permission
    """
    Allows for deletion of other users messages

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 13
primitive EmbedLinksPermission is Permission
    """
    Links sent by users with this permission will be auto-embedded

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 14
primitive AttachFilesPermission is Permission
    """
    Allows for uploading images and files

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 15
primitive ReadMessageHistoryPermission is Permission
    """
    Allows for reading of message history

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 16
primitive MentionEveryonePermission is Permission
    """
    Allows for using the `@everyone` tag to notify all users in a channel, and
    the `@here` tag to notify all online users in a channel

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 17
primitive UseExternalEmojisPermission is Permission
    """
    Allows the usage of custom emojis from other servers

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 18
primitive ViewGuildInsightsPermission is Permission
    """
    Allows for viewing guild insights
    """

    fun value(): U8 => 19
primitive ConnectPermission is Permission
    """
    Allows for joining of a voice channel

    Applies to voice and stage channels.
    """

    fun value(): U8 => 20
primitive SpeakPermission is Permission
    """
    Allows for speaking in a voice channel

    Applies to voice channels.
    """

    fun value(): U8 => 21
primitive MuteMembersPermission is Permission
    """
    Allows for muting members in a voice channel

    Applies to voice and stage channels.
    """

    fun value(): U8 => 22
primitive DeafenMembersPermission is Permission
    """
    Allows for deafening of members in a voice channel

    Applies to voice channels.
    """

    fun value(): U8 => 23
primitive MoveMembersPermission is Permission
    """
    Allows for moving of members between voice channels

    Applies to voice and stage channels.
    """

    fun value(): U8 => 24
primitive UseVADPermission is Permission
    """
    Allows for using voice-activity-detection in a voice channel

    Applies to voice channels.
    """

    fun value(): U8 => 25
primitive ChangeNicknamePermission is Permission
    """
    Allows for modification of own nickname
    """

    fun value(): U8 => 26
primitive ManageNicknamesPermission is Permission
    """
    Allows for modification of other users nicknames
    """

    fun value(): U8 => 27
primitive ManageRolesPermission is Permission
    """
    Allows management and editing of roles

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 28
primitive ManageWebhooksPermission is Permission
    """
    Allows management and editing of webhooks

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 29
primitive ManageGuildExpressionsPermission is Permission
    """
    Allows for editing and deleting emojis, stickers, and soundboard sounds
    created by all users
    """

    fun value(): U8 => 30
primitive UseApplicationCommandsPermission is Permission
    """
    Allows members to use application commands, including slash commands and
    context menu commands

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 31
primitive RequestToSpeakPermission is Permission
    """
    Allows for requesting to speak in stage channels

    Applies to stage channels.
    """

    fun value(): U8 => 32
primitive ManageEventsPermission is Permission
    """
    Allows for editing and deleting scheduled events created by all users

    Applies to voice and stage channels.
    """

    fun value(): U8 => 33
primitive ManageThreadsPermission is Permission
    """
    Allows for deleting and archiving threads, and viewing all private threads

    Applies to text channels.
    """

    fun value(): U8 => 34
primitive CreatePublicThreadsPermission is Permission
    """
    Allows for creating public and announcement threads

    Applies to text channels.
    """

    fun value(): U8 => 35
primitive CreatePrivateThreadsPermission is Permission
    """
    Allows for creating private threads

    Applies to text channels.
    """

    fun value(): U8 => 36
primitive UseExternalStickersPermission is Permission
    """
    Allows the usage of custom stickers from other servers

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 37
primitive SendMessagesInThreadsPermission is Permission
    """
    Allows for sending messages in threads

    Applies to text channels.
    """

    fun value(): U8 => 38
primitive UseEmbeddedActivitiesPermission is Permission
    """
    Allows for using Activities (applications with the `EmbeddedApplicationFlag`
    flag)

    Applies to text and voice channels.
    """

    fun value(): U8 => 39
primitive ModerateMembersPermission is Permission
    """
    Allows for timing out users to prevent them from sending or reacting to
    messages in chat and threads, and from speaking in voice and stage channels
    """

    fun value(): U8 => 40
primitive ViewCreatorMonetizationAnalyticsPermission is Permission
    """
    Allows for viewing role subscription insights
    """

    fun value(): U8 => 41
primitive UseSoundboardPermission is Permission
    """
    Allows for using soundboard in a voice channel

    Applies to voice channels.
    """

    fun value(): U8 => 42
primitive CreateGuildExpressionsPermission is Permission
    """
    Allows for creating emojis, stickers, and soundboard sounds, and editing and
    deleting those created by the current user
    """

    fun value(): U8 => 43
primitive CreateEventsPermission is Permission
    """
    Allows for creating scheduled events, and editing and deleting those created
    by the current user

    Applies to voice and stage channels.
    """

    fun value(): U8 => 44
primitive UseExternalSoundsPermission is Permission
    """
    Allows the usage of custom soundboard sounds from other servers

    Applies to voice channels.
    """

    fun value(): U8 => 45
primitive SendVoiceMessagesPermission is Permission
    """
    Allows sending voice messages

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 46
primitive SetVoiceChannelStatusPermission is Permission
    """
    Allows setting voice channel status

    Applies to voice channels.
    """

    fun value(): U8 => 48
primitive SendPollsPermission is Permission
    """
    Allows sending polls

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 49
primitive UseExternalAppsPermission is Permission
    """
    Allows user-installed apps to send public responses. When disabled, users
    will still be allowed to use their apps but the responses will be ephemeral.
    This only applies to apps not also installed to the server.

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 50
primitive PinMessagesPermission is Permission
    """
    Allows pinning and unpinning messages

    Applies to text channels.
    """

    fun value(): U8 => 51
primitive BypassSlowmodePermission is Permission
    """
    Allows bypassing slowmode restrictions

    Applies to text, voice and stage channels.
    """

    fun value(): U8 => 52
class val UnknownPermission is Permission
    let _value: U8

    new val create(value': U8) =>
        _value = value'

    fun value(): U8 => _value
primitive Permissions
    fun from(value: U8): Permission ? =>
        match value
        | 0 => CreateInstantInvitePermission
        | 1 => KickMembersPermission
        | 2 => BanMembersPermission
        | 3 => AdministratorPermission
        | 4 => ManageChannelsPermission
        | 5 => ManageGuildPermission
        | 6 => AddReactionsPermission
        | 7 => ViewAuditLogPermission
        | 8 => PrioritySpeakerPermission
        | 9 => StreamPermission
        | 10 => ViewChannelPermission
        | 11 => SendMessagesPermission
        | 12 => SendTTSMessagesPermission
        | 13 => ManageMessagesPermission
        | 14 => EmbedLinksPermission
        | 15 => AttachFilesPermission
        | 16 => ReadMessageHistoryPermission
        | 17 => MentionEveryonePermission
        | 18 => UseExternalEmojisPermission
        | 19 => ViewGuildInsightsPermission
        | 20 => ConnectPermission
        | 21 => SpeakPermission
        | 22 => MuteMembersPermission
        | 23 => DeafenMembersPermission
        | 24 => MoveMembersPermission
        | 25 => UseVADPermission
        | 26 => ChangeNicknamePermission
        | 27 => ManageNicknamesPermission
        | 28 => ManageRolesPermission
        | 29 => ManageWebhooksPermission
        | 30 => ManageGuildExpressionsPermission
        | 31 => UseApplicationCommandsPermission
        | 32 => RequestToSpeakPermission
        | 33 => ManageEventsPermission
        | 34 => ManageThreadsPermission
        | 35 => CreatePublicThreadsPermission
        | 36 => CreatePrivateThreadsPermission
        | 37 => UseExternalStickersPermission
        | 38 => SendMessagesInThreadsPermission
        | 39 => UseEmbeddedActivitiesPermission
        | 40 => ModerateMembersPermission
        | 41 => ViewCreatorMonetizationAnalyticsPermission
        | 42 => UseSoundboardPermission
        | 43 => CreateGuildExpressionsPermission
        | 44 => CreateEventsPermission
        | 45 => UseExternalSoundsPermission
        | 46 => SendVoiceMessagesPermission
        | 48 => SetVoiceChannelStatusPermission
        | 49 => SendPollsPermission
        | 50 => UseExternalAppsPermission
        | 51 => PinMessagesPermission
        | 52 => BypassSlowmodePermission
        else error
        end

primitive _Permissions
    fun apply(value: json.JsonValue): Array[Permission] val ? =>
        """
        Decodes a permission bit set.

        Permission bit sets are serialised as strings since they are
        variable-length and do not necessarily fit in the 53 bits of precision a
        JSON number is guaranteed to carry.
        """

        let bits = (value as String).u64()?
        recover val
            let permissions = Array[Permission]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    permissions.push(
                        try
                            Permissions.from(shift)?
                        else
                            UnknownPermission(shift)
                        end
                    )
                end
                shift = shift + 1
            end
            permissions
        end

    fun to_json(permissions: Array[Permission] val): String =>
        var bits: U64 = 0
        for permission in permissions.values() do
            bits = bits or (U64(1) << permission.value().u64())
        end
        bits.string()

class val Role is Jsonable
    """
    https://docs.discord.com/developers/topics/permissions#role-object

    Roles represent a set of permissions attached to a group of users. Roles
    have names, colors, and can be "pinned" to the side bar, causing their
    members to be listed separately. Roles can have separate permission profiles
    for the global context (guild) and channel context. The `@everyone` role has
    the same ID as the guild it belongs to.
    """

    let id: Snowflake
        """
        role id
        """

    let name: String
        """
        role name
        """

    let color: I64
        """
        integer representation of hexadecimal color code

        Deprecated. This will still be returned by the API, but using the
        `colors` field is recommended when doing requests.
        """

    let colors: RoleColors
        """
        the role's colors
        """

    let hoist: Bool
        """
        if this role is pinned in the user listing
        """

    let icon: (String | None)
        """
        role icon hash
        """

    let unicode_emoji: (String | None)
        """
        role unicode emoji
        """

    let position: USize
        """
        position of this role (roles with the same position are sorted by id)
        """

    let permissions: Array[Permission] val
        """
        permission bit set
        """

    let managed: Bool
        """
        whether this role is managed by an integration
        """

    let mentionable: Bool
        """
        whether this role is mentionable
        """

    let tags: (RoleTags | None)
        """
        the tags this role has
        """

    let flags: Array[RoleFlag] val
        """
        role flags combined as a bitfield
        """

    new val create(
        id': Snowflake,
        name': String,
        color': I64,
        colors': RoleColors,
        hoist': Bool,
        icon': (String | None) = None,
        unicode_emoji': (String | None) = None,
        position': USize,
        permissions': Array[Permission] val,
        managed': Bool,
        mentionable': Bool,
        tags': (RoleTags | None) = None,
        flags': Array[RoleFlag] val
    ) =>
        id = id'
        name = name'
        color = color'
        colors = colors'
        hoist = hoist'
        icon = icon'
        unicode_emoji = unicode_emoji'
        position = position'
        permissions = permissions'
        managed = managed'
        mentionable = mentionable'
        tags = tags'
        flags = flags'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var color': (I64 | None) = None
        var colors': (RoleColors | None) = None
        var hoist': (Bool | None) = None
        var icon': (String | None) = None
        var unicode_emoji': (String | None) = None
        var position': (USize | None) = None
        var permissions': (Array[Permission] val | None) = None
        var managed': (Bool | None) = None
        var mentionable': (Bool | None) = None
        var tags': (RoleTags | None) = None
        var flags': (Array[RoleFlag] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "color" => color' = value as I64
            | "colors" =>
                colors' = RoleColors.from_json(value as json.JsonObject)?
            | "hoist" => hoist' = value as Bool
            | "icon" =>
                match value | let string: String => icon' = string end
            | "unicode_emoji" =>
                match value | let string: String => unicode_emoji' = string end
            | "position" => position' = (value as I64).usize()
            | "permissions" => permissions' = _Permissions(value)?
            | "managed" => managed' = value as Bool
            | "mentionable" => mentionable' = value as Bool
            | "tags" => tags' = RoleTags.from_json(value as json.JsonObject)?
            | "flags" => flags' = _RoleFlags((value as I64).u64())
            end
        end

        id = id' as Snowflake
        name = name' as String
        color = color' as I64
        colors = colors' as RoleColors
        hoist = hoist' as Bool
        icon = icon'
        unicode_emoji = unicode_emoji'
        position = position' as USize
        permissions = permissions' as Array[Permission] val
        managed = managed' as Bool
        mentionable = mentionable' as Bool
        tags = tags'
        flags = flags' as Array[RoleFlag] val

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("color", color)
            .update("colors", colors.to_json())
            .update("hoist", hoist)
            .update("icon", icon)
            .update("unicode_emoji", unicode_emoji)
            .update("position", position.i64())
            .update("permissions", _Permissions.to_json(permissions))
            .update("managed", managed)
            .update("mentionable", mentionable)
            .update("flags", _RoleFlags.to_json(flags))

        match tags
        | let tags': RoleTags => obj = obj.update("tags", tags'.to_json())
        end

        obj

primitive _Roles
    fun apply(value: json.JsonValue): Array[Role] val ? =>
        """
        Decodes an array of roles.
        """

        let array = value as json.JsonArray
        recover val
            let roles = Array[Role](array.size())
            for role in array.values() do
                roles.push(Role.from_json(role as json.JsonObject)?)
            end
            roles
        end

    fun to_json(roles: Array[Role] val): json.JsonArray =>
        var array = json.JsonArray
        for role in roles.values() do array = array.push(role.to_json()) end
        array

class val RoleTags is Jsonable
    """
    https://docs.discord.com/developers/topics/permissions#role-object-role-tags-structure

    Tags with type `null` represent booleans. They will be present and set to
    `null` if they are "true", and will be not present if they are "false".
    Those tags are modelled here as plain booleans.
    """

    let bot_id: (Snowflake | None)
        """
        the id of the bot this role belongs to
        """

    let integration_id: (Snowflake | None)
        """
        the id of the integration this role belongs to
        """

    let premium_subscriber: Bool
        """
        whether this is the guild's Booster role
        """

    let subscription_listing_id: (Snowflake | None)
        """
        the id of this role's subscription sku and listing
        """

    let available_for_purchase: Bool
        """
        whether this role is available for purchase
        """

    let guild_connections: Bool
        """
        whether this role is a guild's linked role
        """

    new val create(
        bot_id': (Snowflake | None) = None,
        integration_id': (Snowflake | None) = None,
        premium_subscriber': Bool,
        subscription_listing_id': (Snowflake | None) = None,
        available_for_purchase': Bool,
        guild_connections': Bool
    ) =>
        bot_id = bot_id'
        integration_id = integration_id'
        premium_subscriber = premium_subscriber'
        subscription_listing_id = subscription_listing_id'
        available_for_purchase = available_for_purchase'
        guild_connections = guild_connections'

    new val from_json(obj: json.JsonObject) ? =>
        var bot_id': (Snowflake | None) = None
        var integration_id': (Snowflake | None) = None
        var premium_subscriber': Bool = false
        var subscription_listing_id': (Snowflake | None) = None
        var available_for_purchase': Bool = false
        var guild_connections': Bool = false

        for (key, value) in obj.pairs() do
            match key
            | "bot_id" => bot_id' = Snowflake.from_json(value)?
            | "integration_id" => integration_id' = Snowflake.from_json(value)?
            | "premium_subscriber" => premium_subscriber' = true
            | "subscription_listing_id" =>
                subscription_listing_id' = Snowflake.from_json(value)?
            | "available_for_purchase" => available_for_purchase' = true
            | "guild_connections" => guild_connections' = true
            end
        end

        bot_id = bot_id'
        integration_id = integration_id'
        premium_subscriber = premium_subscriber'
        subscription_listing_id = subscription_listing_id'
        available_for_purchase = available_for_purchase'
        guild_connections = guild_connections'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match bot_id
        | let bot_id': Snowflake =>
            obj = obj.update("bot_id", bot_id'.to_json())
        end

        match integration_id
        | let integration_id': Snowflake =>
            obj = obj.update("integration_id", integration_id'.to_json())
        end

        if premium_subscriber then
            obj = obj.update("premium_subscriber", None)
        end

        match subscription_listing_id
        | let subscription_listing_id': Snowflake =>
            obj =
                obj.update(
                    "subscription_listing_id",
                    subscription_listing_id'.to_json()
                )
        end

        if available_for_purchase then
            obj = obj.update("available_for_purchase", None)
        end

        if guild_connections then
            obj = obj.update("guild_connections", None)
        end

        obj

class val RoleColors is Jsonable
    """
    https://docs.discord.com/developers/topics/permissions#role-object-role-colors-object

    This object will always be filled with `primary_color` being the role's
    `color`. Other fields can only be set to a non-null value if the guild has
    the `ENHANCED_ROLE_COLORS` guild feature.
    """

    let primary_color: I64
        """
        the primary color for the role
        """

    let secondary_color: (I64 | None)
        """
        the secondary color for the role, this will make the role a gradient
        between the other provided colors
        """

    let tertiary_color: (I64 | None)
        """
        the tertiary color for the role, this will turn the gradient into a
        holographic style
        """

    new val create(
        primary_color': I64,
        secondary_color': (I64 | None) = None,
        tertiary_color': (I64 | None) = None
    ) =>
        primary_color = primary_color'
        secondary_color = secondary_color'
        tertiary_color = tertiary_color'

    new val from_json(obj: json.JsonObject) ? =>
        var primary_color': (I64 | None) = None
        var secondary_color': (I64 | None) = None
        var tertiary_color': (I64 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "primary_color" => primary_color' = value as I64
            | "secondary_color" =>
                match value | let integer: I64 => secondary_color' = integer end
            | "tertiary_color" =>
                match value | let integer: I64 => tertiary_color' = integer end
            end
        end

        primary_color = primary_color' as I64
        secondary_color = secondary_color'
        tertiary_color = tertiary_color'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("primary_color", primary_color)
            .update("secondary_color", secondary_color)
            .update("tertiary_color", tertiary_color)

trait val RoleFlag is _Enum[RoleFlag, U8]
    """
    https://docs.discord.com/developers/topics/permissions#role-object-role-flags
    """
primitive InPromptRoleFlag is RoleFlag
    """
    role can be selected by members in an onboarding prompt
    """

    fun value(): U8 => 0
class val UnknownRoleFlag is RoleFlag
    let _value: U8

    new val create(value': U8) =>
        _value = value'

    fun value(): U8 => _value
primitive RoleFlags
    fun from(value: U8): RoleFlag ? =>
        match value
        | 0 => InPromptRoleFlag
        else error
        end

primitive _RoleFlags
    fun apply(bits: U64): Array[RoleFlag] val =>
        recover val
            let flags = Array[RoleFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    flags.push(
                        try
                            RoleFlags.from(shift)?
                        else
                            UnknownRoleFlag(shift)
                        end
                    )
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[RoleFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do
            bits = bits or (U64(1) << flag.value().u64())
        end
        bits.i64()
