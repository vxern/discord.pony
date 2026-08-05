use json = "json"

class val Channel is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-structure

    Represents a guild or DM channel within Discord.
    """

    let id: Snowflake
        """
        the id of this channel
        """

    let type': ChannelType
        """
        the type of channel
        """

    let guild_id: (Snowflake | None)
        """
        the id of the guild (may be missing for some channel objects received over gateway guild dispatches)
        """

    let position: (USize | None)
        """
        sorting position of the channel (channels with the same position are sorted by id)
        """

    let permission_overwrites: (Array[PermissionOverwrite] val | None)
        """
        explicit permission overwrites for members and roles
        """

    let name: (String | None)
        """
        the name of the channel (1-100 characters)
        """

    let topic: (String | None)
        """
        the channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels, 0-1024 characters for all others)
        """

    let nsfw: (Bool | None)
        """
        whether the channel is nsfw
        """

    let last_message_id: (Snowflake | None)
        """
        the id of the last message sent in this channel (or thread for GUILD_FORUM or GUILD_MEDIA channels) (may not point to an existing or valid message or thread)
        """

    let bitrate: (USize | None)
        """
        the bitrate (in bits) of the voice channel
        """

    let user_limit: (USize | None)
        """
        the user limit of the voice channel
        """

    let rate_limit_per_user: (USize | None)
        """
        amount of seconds a user has to wait before sending another message (0-21600); bots, as well as users with the permission manage_messages or manage_channel, are unaffected
        """

    let recipients: (Array[User] val | None)
        """
        the recipients of the DM
        """

    let icon: (String | None)
        """
        icon hash of the group DM
        """

    let owner_id: (Snowflake | None)
        """
        id of the creator of the group DM or thread
        """

    let application_id: (Snowflake | None)
        """
        application id of the group DM creator if it is bot-created
        """

    let managed: (Bool | None)
        """
        for group DM channels: whether the channel is managed by an application via the gdm.join OAuth2 scope
        """

    let parent_id: (Snowflake | None)
        """
        for guild channels: id of the parent category for a channel (each parent category can contain up to 50 channels), for threads: id of the text channel this thread was created
        """

    let last_pin_timestamp: (ISO8601 | None)
        """
        when the last pinned message was pinned. This may be null in events such as GUILD_CREATE when a message is not pinned.
        """

    let rtc_region: (String | None)
        """
        voice region id for the voice channel, automatic when set to null
        """

    let video_quality_mode: (VideoQualityMode | None)
        """
        the camera video quality mode of the voice channel, 1 when not present
        """

    let message_count: (USize | None)
        """
        number of messages (not including the initial message or deleted messages) in a thread
        """

    let member_count: (USize | None)
        """
        an approximate count of users in a thread, stops counting at 50
        """

    let thread_metadata: (ThreadMetadata | None)
        """
        thread-specific fields not needed by other channels
        """

    let member: (ThreadMember | None)
        """
        thread member object for the current user, if they have joined the thread, only included on certain API endpoints
        """

    let default_auto_archive_duration: (USize | None)
        """
        default duration, copied onto newly created threads, in minutes, threads will stop showing in the channel list after the specified period of inactivity, can be set to: 60, 1440, 4320, 10080
        """

    let permissions: (Array[Permission] val | None)
        """
        computed permissions for the invoking user in the channel, including overwrites, only included when part of the resolved data received on a slash command interaction. This does not include implicit permissions, which may need to be checked separately
        """

    let flags: (Array[ChannelFlag] val | None)
        """
        channel flags combined as a bitfield
        """

    let total_message_sent: (USize | None)
        """
        number of messages ever sent in a thread, it's similar to message_count on message creation, but will not decrement the number when a message is deleted
        """

    let available_tags: (Array[ForumTag] val | None)
        """
        the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    let applied_tags: (Array[Snowflake] val | None)
        """
        the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    let default_reaction_emoji: (DefaultReaction | None)
        """
        the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    let default_thread_rate_limit_per_user: (USize | None)
        """
        the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update.
        """

    let default_sort_order: (SortOrderType | None)
        """
        the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels. Defaults to null, which indicates a preferred sort order hasn't been set by a channel admin
        """

    let default_forum_layout: (ForumLayoutType | None)
        """
        the default forum layout view used to display posts in GUILD_FORUM channels. Defaults to 0, which indicates a layout view has not been set by a channel admin
        """

    new val create(
        id': Snowflake,
        type'': ChannelType,
        guild_id': (Snowflake | None) = None,
        position': (USize | None) = None,
        permission_overwrites': (Array[PermissionOverwrite] val | None) = None,
        name': (String | None) = None,
        topic': (String | None) = None,
        nsfw': (Bool | None) = None,
        last_message_id': (Snowflake | None) = None,
        bitrate': (USize | None) = None,
        user_limit': (USize | None) = None,
        rate_limit_per_user': (USize | None) = None,
        recipients': (Array[User] val | None) = None,
        icon': (String | None) = None,
        owner_id': (Snowflake | None) = None,
        application_id': (Snowflake | None) = None,
        managed': (Bool | None) = None,
        parent_id': (Snowflake | None) = None,
        last_pin_timestamp': (ISO8601 | None) = None,
        rtc_region': (String | None) = None,
        video_quality_mode': (VideoQualityMode | None) = None,
        message_count': (USize | None) = None,
        member_count': (USize | None) = None,
        thread_metadata': (ThreadMetadata | None) = None,
        member': (ThreadMember | None) = None,
        default_auto_archive_duration': (USize | None) = None,
        permissions': (Array[Permission] val | None) = None,
        flags': (Array[ChannelFlag] val | None) = None,
        total_message_sent': (USize | None) = None,
        available_tags': (Array[ForumTag] val | None) = None,
        applied_tags': (Array[Snowflake] val | None) = None,
        default_reaction_emoji': (DefaultReaction | None) = None,
        default_thread_rate_limit_per_user': (USize | None) = None,
        default_sort_order': (SortOrderType | None) = None,
        default_forum_layout': (ForumLayoutType | None) = None
    ) =>
        id = id'
        type' = type''
        guild_id = guild_id'
        position = position'
        permission_overwrites = permission_overwrites'
        name = name'
        topic = topic'
        nsfw = nsfw'
        last_message_id = last_message_id'
        bitrate = bitrate'
        user_limit = user_limit'
        rate_limit_per_user = rate_limit_per_user'
        recipients = recipients'
        icon = icon'
        owner_id = owner_id'
        application_id = application_id'
        managed = managed'
        parent_id = parent_id'
        last_pin_timestamp = last_pin_timestamp'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        message_count = message_count'
        member_count = member_count'
        thread_metadata = thread_metadata'
        member = member'
        default_auto_archive_duration = default_auto_archive_duration'
        permissions = permissions'
        flags = flags'
        total_message_sent = total_message_sent'
        available_tags = available_tags'
        applied_tags = applied_tags'
        default_reaction_emoji = default_reaction_emoji'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (ChannelType | None) = None
        var guild_id': (Snowflake | None) = None
        var position': (USize | None) = None
        var permission_overwrites': (Array[PermissionOverwrite] val | None) = None
        var name': (String | None) = None
        var topic': (String | None) = None
        var nsfw': (Bool | None) = None
        var last_message_id': (Snowflake | None) = None
        var bitrate': (USize | None) = None
        var user_limit': (USize | None) = None
        var rate_limit_per_user': (USize | None) = None
        var recipients': (Array[User] val | None) = None
        var icon': (String | None) = None
        var owner_id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var managed': (Bool | None) = None
        var parent_id': (Snowflake | None) = None
        var last_pin_timestamp': (ISO8601 | None) = None
        var rtc_region': (String | None) = None
        var video_quality_mode': (VideoQualityMode | None) = None
        var message_count': (USize | None) = None
        var member_count': (USize | None) = None
        var thread_metadata': (ThreadMetadata | None) = None
        var member': (ThreadMember | None) = None
        var default_auto_archive_duration': (USize | None) = None
        var permissions': (Array[Permission] val | None) = None
        var flags': (Array[ChannelFlag] val | None) = None
        var total_message_sent': (USize | None) = None
        var available_tags': (Array[ForumTag] val | None) = None
        var applied_tags': (Array[Snowflake] val | None) = None
        var default_reaction_emoji': (DefaultReaction | None) = None
        var default_thread_rate_limit_per_user': (USize | None) = None
        var default_sort_order': (SortOrderType | None) = None
        var default_forum_layout': (ForumLayoutType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = ChannelTypes.from((value as I64).u8())?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "position" => position' = (value as I64).usize()
            | "permission_overwrites" => permission_overwrites' = _PermissionOverwrites(value)?
            | "name" =>
                match value | let string: String => name' = string end
            | "topic" =>
                match value | let string: String => topic' = string end
            | "nsfw" => nsfw' = value as Bool
            | "last_message_id" =>
                match value | let string: String => last_message_id' = Snowflake.from_json(string)? end
            | "bitrate" => bitrate' = (value as I64).usize()
            | "user_limit" => user_limit' = (value as I64).usize()
            | "rate_limit_per_user" => rate_limit_per_user' = (value as I64).usize()
            | "recipients" => recipients' = _Users(value)?
            | "icon" =>
                match value | let string: String => icon' = string end
            | "owner_id" => owner_id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "managed" => managed' = value as Bool
            | "parent_id" =>
                match value | let string: String => parent_id' = Snowflake.from_json(string)? end
            | "last_pin_timestamp" =>
                match value | let string: String => last_pin_timestamp' = string end
            | "rtc_region" =>
                match value | let string: String => rtc_region' = string end
            | "video_quality_mode" => video_quality_mode' = VideoQualityModes.from((value as I64).u8())?
            | "message_count" => message_count' = (value as I64).usize()
            | "member_count" => member_count' = (value as I64).usize()
            | "thread_metadata" => thread_metadata' = ThreadMetadata.from_json(value as json.JsonObject)?
            | "member" => member' = ThreadMember.from_json(value as json.JsonObject)?
            | "default_auto_archive_duration" => default_auto_archive_duration' = (value as I64).usize()
            | "permissions" => permissions' = _Permissions(value)?
            | "flags" => flags' = _ChannelFlags((value as I64).u64())
            | "total_message_sent" => total_message_sent' = (value as I64).usize()
            | "available_tags" => available_tags' = _ForumTags(value)?
            | "applied_tags" => applied_tags' = _Snowflakes(value)?
            | "default_reaction_emoji" =>
                match value | let obj': json.JsonObject => default_reaction_emoji' = DefaultReaction.from_json(obj')? end
            | "default_thread_rate_limit_per_user" => default_thread_rate_limit_per_user' = (value as I64).usize()
            | "default_sort_order" =>
                match value | let integer: I64 => default_sort_order' = SortOrderTypes.from(integer.u8())? end
            | "default_forum_layout" => default_forum_layout' = ForumLayoutTypes.from((value as I64).u8())?
            end
        end

        id = id' as Snowflake
        type' = type'' as ChannelType
        guild_id = guild_id'
        position = position'
        permission_overwrites = permission_overwrites'
        name = name'
        topic = topic'
        nsfw = nsfw'
        last_message_id = last_message_id'
        bitrate = bitrate'
        user_limit = user_limit'
        rate_limit_per_user = rate_limit_per_user'
        recipients = recipients'
        icon = icon'
        owner_id = owner_id'
        application_id = application_id'
        managed = managed'
        parent_id = parent_id'
        last_pin_timestamp = last_pin_timestamp'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        message_count = message_count'
        member_count = member_count'
        thread_metadata = thread_metadata'
        member = member'
        default_auto_archive_duration = default_auto_archive_duration'
        permissions = permissions'
        flags = flags'
        total_message_sent = total_message_sent'
        available_tags = available_tags'
        applied_tags = applied_tags'
        default_reaction_emoji = default_reaction_emoji'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        end

        match permission_overwrites
        | let permission_overwrites': Array[PermissionOverwrite] val => obj = obj.update("permission_overwrites", _PermissionOverwrites.to_json(permission_overwrites'))
        end

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match topic
        | let topic': String => obj = obj.update("topic", topic')
        end

        match nsfw
        | let nsfw': Bool => obj = obj.update("nsfw", nsfw')
        end

        match last_message_id
        | let last_message_id': Snowflake => obj = obj.update("last_message_id", last_message_id'.to_json())
        end

        match bitrate
        | let bitrate': USize => obj = obj.update("bitrate", bitrate'.i64())
        end

        match user_limit
        | let user_limit': USize => obj = obj.update("user_limit", user_limit'.i64())
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        match recipients
        | let recipients': Array[User] val => obj = obj.update("recipients", _Users.to_json(recipients'))
        end

        match icon
        | let icon': String => obj = obj.update("icon", icon')
        end

        match owner_id
        | let owner_id': Snowflake => obj = obj.update("owner_id", owner_id'.to_json())
        end

        match application_id
        | let application_id': Snowflake => obj = obj.update("application_id", application_id'.to_json())
        end

        match managed
        | let managed': Bool => obj = obj.update("managed", managed')
        end

        match parent_id
        | let parent_id': Snowflake => obj = obj.update("parent_id", parent_id'.to_json())
        end

        match last_pin_timestamp
        | let last_pin_timestamp': ISO8601 => obj = obj.update("last_pin_timestamp", last_pin_timestamp')
        end

        match rtc_region
        | let rtc_region': String => obj = obj.update("rtc_region", rtc_region')
        end

        match video_quality_mode
        | let video_quality_mode': VideoQualityMode => obj = obj.update("video_quality_mode", video_quality_mode'.value().i64())
        end

        match message_count
        | let message_count': USize => obj = obj.update("message_count", message_count'.i64())
        end

        match member_count
        | let member_count': USize => obj = obj.update("member_count", member_count'.i64())
        end

        match thread_metadata
        | let thread_metadata': ThreadMetadata => obj = obj.update("thread_metadata", thread_metadata'.to_json())
        end

        match member
        | let member': ThreadMember => obj = obj.update("member", member'.to_json())
        end

        match default_auto_archive_duration
        | let default_auto_archive_duration': USize => obj = obj.update("default_auto_archive_duration", default_auto_archive_duration'.i64())
        end

        match permissions
        | let permissions': Array[Permission] val => obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match flags
        | let flags': Array[ChannelFlag] val => obj = obj.update("flags", _ChannelFlags.to_json(flags'))
        end

        match total_message_sent
        | let total_message_sent': USize => obj = obj.update("total_message_sent", total_message_sent'.i64())
        end

        match available_tags
        | let available_tags': Array[ForumTag] val => obj = obj.update("available_tags", _ForumTags.to_json(available_tags'))
        end

        match applied_tags
        | let applied_tags': Array[Snowflake] val => obj = obj.update("applied_tags", _Snowflakes.to_json(applied_tags'))
        end

        match default_reaction_emoji
        | let default_reaction_emoji': DefaultReaction => obj = obj.update("default_reaction_emoji", default_reaction_emoji'.to_json())
        end

        match default_thread_rate_limit_per_user
        | let default_thread_rate_limit_per_user': USize => obj = obj.update("default_thread_rate_limit_per_user", default_thread_rate_limit_per_user'.i64())
        end

        match default_sort_order
        | let default_sort_order': SortOrderType => obj = obj.update("default_sort_order", default_sort_order'.value().i64())
        end

        match default_forum_layout
        | let default_forum_layout': ForumLayoutType => obj = obj.update("default_forum_layout", default_forum_layout'.value().i64())
        end

        obj

primitive _Channels
    fun apply(value: json.JsonValue): Array[Channel] val ? =>
        """
        Decodes an array of channels.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[Channel](array.size())
            for channel in array.values() do channels.push(Channel.from_json(channel as json.JsonObject)?) end
            channels
        end

    fun to_json(channels: Array[Channel] val): json.JsonArray =>
        var array = json.JsonArray
        for channel in channels.values() do array = array.push(channel.to_json()) end
        array

class val PartialChannel is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-structure

    A channel Discord sent as a *partial* object: the same structure as `Channel`,
    but carrying only some of its fields. Invites, webhooks, interactions and
    guild widgets all embed channels this way, and none of them agree on which
    fields they include — a guild widget omits even `type` — so every field here
    but `id` is optional.

    The fields mean exactly what their `Channel` counterparts do, and are
    documented there. A field Discord omits is indistinguishable from a field
    Discord sent as `null`.
    """

    let id: Snowflake
    let type': (ChannelType | None)
    let guild_id: (Snowflake | None)
    let position: (USize | None)
    let permission_overwrites: (Array[PermissionOverwrite] val | None)
    let name: (String | None)
    let topic: (String | None)
    let nsfw: (Bool | None)
    let last_message_id: (Snowflake | None)
    let bitrate: (USize | None)
    let user_limit: (USize | None)
    let rate_limit_per_user: (USize | None)
    let recipients: (Array[User] val | None)
    let icon: (String | None)
    let owner_id: (Snowflake | None)
    let application_id: (Snowflake | None)
    let managed: (Bool | None)
    let parent_id: (Snowflake | None)
    let last_pin_timestamp: (ISO8601 | None)
    let rtc_region: (String | None)
    let video_quality_mode: (VideoQualityMode | None)
    let message_count: (USize | None)
    let member_count: (USize | None)
    let thread_metadata: (ThreadMetadata | None)
    let member: (ThreadMember | None)
    let default_auto_archive_duration: (USize | None)
    let permissions: (Array[Permission] val | None)
    let flags: (Array[ChannelFlag] val | None)
    let total_message_sent: (USize | None)
    let available_tags: (Array[ForumTag] val | None)
    let applied_tags: (Array[Snowflake] val | None)
    let default_reaction_emoji: (DefaultReaction | None)
    let default_thread_rate_limit_per_user: (USize | None)
    let default_sort_order: (SortOrderType | None)
    let default_forum_layout: (ForumLayoutType | None)

    new val create(
        id': Snowflake,
        type'': (ChannelType | None) = None,
        guild_id': (Snowflake | None) = None,
        position': (USize | None) = None,
        permission_overwrites': (Array[PermissionOverwrite] val | None) = None,
        name': (String | None) = None,
        topic': (String | None) = None,
        nsfw': (Bool | None) = None,
        last_message_id': (Snowflake | None) = None,
        bitrate': (USize | None) = None,
        user_limit': (USize | None) = None,
        rate_limit_per_user': (USize | None) = None,
        recipients': (Array[User] val | None) = None,
        icon': (String | None) = None,
        owner_id': (Snowflake | None) = None,
        application_id': (Snowflake | None) = None,
        managed': (Bool | None) = None,
        parent_id': (Snowflake | None) = None,
        last_pin_timestamp': (ISO8601 | None) = None,
        rtc_region': (String | None) = None,
        video_quality_mode': (VideoQualityMode | None) = None,
        message_count': (USize | None) = None,
        member_count': (USize | None) = None,
        thread_metadata': (ThreadMetadata | None) = None,
        member': (ThreadMember | None) = None,
        default_auto_archive_duration': (USize | None) = None,
        permissions': (Array[Permission] val | None) = None,
        flags': (Array[ChannelFlag] val | None) = None,
        total_message_sent': (USize | None) = None,
        available_tags': (Array[ForumTag] val | None) = None,
        applied_tags': (Array[Snowflake] val | None) = None,
        default_reaction_emoji': (DefaultReaction | None) = None,
        default_thread_rate_limit_per_user': (USize | None) = None,
        default_sort_order': (SortOrderType | None) = None,
        default_forum_layout': (ForumLayoutType | None) = None
    ) =>
        id = id'
        type' = type''
        guild_id = guild_id'
        position = position'
        permission_overwrites = permission_overwrites'
        name = name'
        topic = topic'
        nsfw = nsfw'
        last_message_id = last_message_id'
        bitrate = bitrate'
        user_limit = user_limit'
        rate_limit_per_user = rate_limit_per_user'
        recipients = recipients'
        icon = icon'
        owner_id = owner_id'
        application_id = application_id'
        managed = managed'
        parent_id = parent_id'
        last_pin_timestamp = last_pin_timestamp'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        message_count = message_count'
        member_count = member_count'
        thread_metadata = thread_metadata'
        member = member'
        default_auto_archive_duration = default_auto_archive_duration'
        permissions = permissions'
        flags = flags'
        total_message_sent = total_message_sent'
        available_tags = available_tags'
        applied_tags = applied_tags'
        default_reaction_emoji = default_reaction_emoji'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (ChannelType | None) = None
        var guild_id': (Snowflake | None) = None
        var position': (USize | None) = None
        var permission_overwrites': (Array[PermissionOverwrite] val | None) = None
        var name': (String | None) = None
        var topic': (String | None) = None
        var nsfw': (Bool | None) = None
        var last_message_id': (Snowflake | None) = None
        var bitrate': (USize | None) = None
        var user_limit': (USize | None) = None
        var rate_limit_per_user': (USize | None) = None
        var recipients': (Array[User] val | None) = None
        var icon': (String | None) = None
        var owner_id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var managed': (Bool | None) = None
        var parent_id': (Snowflake | None) = None
        var last_pin_timestamp': (ISO8601 | None) = None
        var rtc_region': (String | None) = None
        var video_quality_mode': (VideoQualityMode | None) = None
        var message_count': (USize | None) = None
        var member_count': (USize | None) = None
        var thread_metadata': (ThreadMetadata | None) = None
        var member': (ThreadMember | None) = None
        var default_auto_archive_duration': (USize | None) = None
        var permissions': (Array[Permission] val | None) = None
        var flags': (Array[ChannelFlag] val | None) = None
        var total_message_sent': (USize | None) = None
        var available_tags': (Array[ForumTag] val | None) = None
        var applied_tags': (Array[Snowflake] val | None) = None
        var default_reaction_emoji': (DefaultReaction | None) = None
        var default_thread_rate_limit_per_user': (USize | None) = None
        var default_sort_order': (SortOrderType | None) = None
        var default_forum_layout': (ForumLayoutType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = ChannelTypes.from((value as I64).u8())?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "position" => position' = (value as I64).usize()
            | "permission_overwrites" => permission_overwrites' = _PermissionOverwrites(value)?
            | "name" =>
                match value | let string: String => name' = string end
            | "topic" =>
                match value | let string: String => topic' = string end
            | "nsfw" => nsfw' = value as Bool
            | "last_message_id" =>
                match value | let string: String => last_message_id' = Snowflake.from_json(string)? end
            | "bitrate" => bitrate' = (value as I64).usize()
            | "user_limit" => user_limit' = (value as I64).usize()
            | "rate_limit_per_user" => rate_limit_per_user' = (value as I64).usize()
            | "recipients" => recipients' = _Users(value)?
            | "icon" =>
                match value | let string: String => icon' = string end
            | "owner_id" => owner_id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "managed" => managed' = value as Bool
            | "parent_id" =>
                match value | let string: String => parent_id' = Snowflake.from_json(string)? end
            | "last_pin_timestamp" =>
                match value | let string: String => last_pin_timestamp' = string end
            | "rtc_region" =>
                match value | let string: String => rtc_region' = string end
            | "video_quality_mode" => video_quality_mode' = VideoQualityModes.from((value as I64).u8())?
            | "message_count" => message_count' = (value as I64).usize()
            | "member_count" => member_count' = (value as I64).usize()
            | "thread_metadata" => thread_metadata' = ThreadMetadata.from_json(value as json.JsonObject)?
            | "member" => member' = ThreadMember.from_json(value as json.JsonObject)?
            | "default_auto_archive_duration" => default_auto_archive_duration' = (value as I64).usize()
            | "permissions" => permissions' = _Permissions(value)?
            | "flags" => flags' = _ChannelFlags((value as I64).u64())
            | "total_message_sent" => total_message_sent' = (value as I64).usize()
            | "available_tags" => available_tags' = _ForumTags(value)?
            | "applied_tags" => applied_tags' = _Snowflakes(value)?
            | "default_reaction_emoji" =>
                match value | let obj': json.JsonObject => default_reaction_emoji' = DefaultReaction.from_json(obj')? end
            | "default_thread_rate_limit_per_user" => default_thread_rate_limit_per_user' = (value as I64).usize()
            | "default_sort_order" =>
                match value | let integer: I64 => default_sort_order' = SortOrderTypes.from(integer.u8())? end
            | "default_forum_layout" => default_forum_layout' = ForumLayoutTypes.from((value as I64).u8())?
            end
        end

        id = id' as Snowflake
        type' = type''
        guild_id = guild_id'
        position = position'
        permission_overwrites = permission_overwrites'
        name = name'
        topic = topic'
        nsfw = nsfw'
        last_message_id = last_message_id'
        bitrate = bitrate'
        user_limit = user_limit'
        rate_limit_per_user = rate_limit_per_user'
        recipients = recipients'
        icon = icon'
        owner_id = owner_id'
        application_id = application_id'
        managed = managed'
        parent_id = parent_id'
        last_pin_timestamp = last_pin_timestamp'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        message_count = message_count'
        member_count = member_count'
        thread_metadata = thread_metadata'
        member = member'
        default_auto_archive_duration = default_auto_archive_duration'
        permissions = permissions'
        flags = flags'
        total_message_sent = total_message_sent'
        available_tags = available_tags'
        applied_tags = applied_tags'
        default_reaction_emoji = default_reaction_emoji'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match type'
        | let type'': ChannelType => obj = obj.update("type", type''.value().i64())
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        end

        match permission_overwrites
        | let permission_overwrites': Array[PermissionOverwrite] val => obj = obj.update("permission_overwrites", _PermissionOverwrites.to_json(permission_overwrites'))
        end

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match topic
        | let topic': String => obj = obj.update("topic", topic')
        end

        match nsfw
        | let nsfw': Bool => obj = obj.update("nsfw", nsfw')
        end

        match last_message_id
        | let last_message_id': Snowflake => obj = obj.update("last_message_id", last_message_id'.to_json())
        end

        match bitrate
        | let bitrate': USize => obj = obj.update("bitrate", bitrate'.i64())
        end

        match user_limit
        | let user_limit': USize => obj = obj.update("user_limit", user_limit'.i64())
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        match recipients
        | let recipients': Array[User] val => obj = obj.update("recipients", _Users.to_json(recipients'))
        end

        match icon
        | let icon': String => obj = obj.update("icon", icon')
        end

        match owner_id
        | let owner_id': Snowflake => obj = obj.update("owner_id", owner_id'.to_json())
        end

        match application_id
        | let application_id': Snowflake => obj = obj.update("application_id", application_id'.to_json())
        end

        match managed
        | let managed': Bool => obj = obj.update("managed", managed')
        end

        match parent_id
        | let parent_id': Snowflake => obj = obj.update("parent_id", parent_id'.to_json())
        end

        match last_pin_timestamp
        | let last_pin_timestamp': ISO8601 => obj = obj.update("last_pin_timestamp", last_pin_timestamp')
        end

        match rtc_region
        | let rtc_region': String => obj = obj.update("rtc_region", rtc_region')
        end

        match video_quality_mode
        | let video_quality_mode': VideoQualityMode => obj = obj.update("video_quality_mode", video_quality_mode'.value().i64())
        end

        match message_count
        | let message_count': USize => obj = obj.update("message_count", message_count'.i64())
        end

        match member_count
        | let member_count': USize => obj = obj.update("member_count", member_count'.i64())
        end

        match thread_metadata
        | let thread_metadata': ThreadMetadata => obj = obj.update("thread_metadata", thread_metadata'.to_json())
        end

        match member
        | let member': ThreadMember => obj = obj.update("member", member'.to_json())
        end

        match default_auto_archive_duration
        | let default_auto_archive_duration': USize => obj = obj.update("default_auto_archive_duration", default_auto_archive_duration'.i64())
        end

        match permissions
        | let permissions': Array[Permission] val => obj = obj.update("permissions", _Permissions.to_json(permissions'))
        end

        match flags
        | let flags': Array[ChannelFlag] val => obj = obj.update("flags", _ChannelFlags.to_json(flags'))
        end

        match total_message_sent
        | let total_message_sent': USize => obj = obj.update("total_message_sent", total_message_sent'.i64())
        end

        match available_tags
        | let available_tags': Array[ForumTag] val => obj = obj.update("available_tags", _ForumTags.to_json(available_tags'))
        end

        match applied_tags
        | let applied_tags': Array[Snowflake] val => obj = obj.update("applied_tags", _Snowflakes.to_json(applied_tags'))
        end

        match default_reaction_emoji
        | let default_reaction_emoji': DefaultReaction => obj = obj.update("default_reaction_emoji", default_reaction_emoji'.to_json())
        end

        match default_thread_rate_limit_per_user
        | let default_thread_rate_limit_per_user': USize => obj = obj.update("default_thread_rate_limit_per_user", default_thread_rate_limit_per_user'.i64())
        end

        match default_sort_order
        | let default_sort_order': SortOrderType => obj = obj.update("default_sort_order", default_sort_order'.value().i64())
        end

        match default_forum_layout
        | let default_forum_layout': ForumLayoutType => obj = obj.update("default_forum_layout", default_forum_layout'.value().i64())
        end

        obj

primitive _PartialChannels
    fun apply(value: json.JsonValue): Array[PartialChannel] val ? =>
        """
        Decodes an array of partial channels.
        """

        let array = value as json.JsonArray
        recover val
            let channels = Array[PartialChannel](array.size())
            for channel in array.values() do channels.push(PartialChannel.from_json(channel as json.JsonObject)?) end
            channels
        end

    fun to_json(channels: Array[PartialChannel] val): json.JsonArray =>
        var array = json.JsonArray
        for channel in channels.values() do array = array.push(channel.to_json()) end
        array

trait val ChannelType is _Enum[ChannelType, U8]
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-types
    """
primitive GuildTextChannelType is ChannelType
    """
    a text channel within a server
    """

    fun value(): U8 => 0
primitive DMChannelType is ChannelType
    """
    a direct message between users
    """

    fun value(): U8 => 1
primitive GuildVoiceChannelType is ChannelType
    """
    a voice channel within a server
    """

    fun value(): U8 => 2
primitive GroupDMChannelType is ChannelType
    """
    a direct message between multiple users
    """

    fun value(): U8 => 3
primitive GuildCategoryChannelType is ChannelType
    """
    an organizational category that contains up to 50 channels
    """

    fun value(): U8 => 4
primitive GuildAnnouncementChannelType is ChannelType
    """
    a channel that users can follow and crosspost into their own server (formerly news channels)
    """

    fun value(): U8 => 5
primitive AnnouncementThreadChannelType is ChannelType
    """
    a temporary sub-channel within a GUILD_ANNOUNCEMENT channel
    """

    fun value(): U8 => 10
primitive PublicThreadChannelType is ChannelType
    """
    a temporary sub-channel within a GUILD_TEXT or GUILD_FORUM channel
    """

    fun value(): U8 => 11
primitive PrivateThreadChannelType is ChannelType
    """
    a temporary sub-channel within a GUILD_TEXT channel that is only viewable by those invited and those with the MANAGE_THREADS permission
    """

    fun value(): U8 => 12
primitive GuildStageVoiceChannelType is ChannelType
    """
    a voice channel for hosting events with an audience
    """

    fun value(): U8 => 13
primitive GuildDirectoryChannelType is ChannelType
    """
    the channel in a hub containing the listed servers
    """

    fun value(): U8 => 14
primitive GuildForumChannelType is ChannelType
    """
    Channel that can only contain threads
    """

    fun value(): U8 => 15
primitive GuildMediaChannelType is ChannelType
    """
    Channel that can only contain threads, similar to GUILD_FORUM channels
    """

    fun value(): U8 => 16
primitive ChannelTypes
    fun from(value: U8): ChannelType ? =>
        match value
        | 0 => GuildTextChannelType
        | 1 => DMChannelType
        | 2 => GuildVoiceChannelType
        | 3 => GroupDMChannelType
        | 4 => GuildCategoryChannelType
        | 5 => GuildAnnouncementChannelType
        | 10 => AnnouncementThreadChannelType
        | 11 => PublicThreadChannelType
        | 12 => PrivateThreadChannelType
        | 13 => GuildStageVoiceChannelType
        | 14 => GuildDirectoryChannelType
        | 15 => GuildForumChannelType
        | 16 => GuildMediaChannelType
        else error
        end

primitive _ChannelTypes
    fun apply(value: json.JsonValue): Array[ChannelType] val ? =>
        """
        Decodes an array of channel types.
        """

        let array = value as json.JsonArray
        recover val
            let types = Array[ChannelType](array.size())
            for type' in array.values() do types.push(ChannelTypes.from((type' as I64).u8())?) end
            types
        end

    fun to_json(types: Array[ChannelType] val): json.JsonArray =>
        var array = json.JsonArray
        for type' in types.values() do array = array.push(type'.value().i64()) end
        array

trait val VideoQualityMode is _Enum[VideoQualityMode, U8]
    """
    https://docs.discord.com/developers/resources/channel#channel-object-video-quality-modes
    """
primitive AutoVideoQualityMode is VideoQualityMode
    """
    Discord chooses the quality for optimal performance
    """

    fun value(): U8 => 1
primitive FullVideoQualityMode is VideoQualityMode
    """
    720p
    """

    fun value(): U8 => 2
primitive VideoQualityModes
    fun from(value: U8): VideoQualityMode ? =>
        match value
        | 1 => AutoVideoQualityMode
        | 2 => FullVideoQualityMode
        else error
        end

trait val ChannelFlag is _Enum[ChannelFlag, U8]
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-flags
    """
primitive PinnedChannelFlag is ChannelFlag
    """
    this thread is pinned to the top of its parent GUILD_FORUM or GUILD_MEDIA channel
    """

    fun value(): U8 => 1
primitive RequireTagChannelFlag is ChannelFlag
    """
    whether a tag is required to be specified when creating a thread in a GUILD_FORUM or a GUILD_MEDIA channel. Tags are specified in the applied_tags field.
    """

    fun value(): U8 => 4
primitive HideMediaDownloadOptionsChannelFlag is ChannelFlag
    """
    when set hides the embedded media download options. Available only for media channels
    """

    fun value(): U8 => 15
primitive ChannelFlags
    fun from(value: U8): ChannelFlag ? =>
        match value
        | 1 => PinnedChannelFlag
        | 4 => RequireTagChannelFlag
        | 15 => HideMediaDownloadOptionsChannelFlag
        else error
        end

primitive _ChannelFlags
    fun apply(bits: U64): Array[ChannelFlag] val =>
        recover val
            let flags = Array[ChannelFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(ChannelFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[ChannelFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

trait val SortOrderType is _Enum[SortOrderType, U8]
    """
    https://docs.discord.com/developers/resources/channel#channel-object-sort-order-types
    """
primitive LatestActivitySortOrderType is SortOrderType
    """
    Sort forum posts by activity
    """

    fun value(): U8 => 0
primitive CreationDateSortOrderType is SortOrderType
    """
    Sort forum posts by creation time (from most recent to oldest)
    """

    fun value(): U8 => 1
primitive SortOrderTypes
    fun from(value: U8): SortOrderType ? =>
        match value
        | 0 => LatestActivitySortOrderType
        | 1 => CreationDateSortOrderType
        else error
        end

trait val ForumLayoutType is _Enum[ForumLayoutType, U8]
    """
    https://docs.discord.com/developers/resources/channel#channel-object-forum-layout-types
    """
primitive NotSetForumLayoutType is ForumLayoutType
    """
    No default has been set for forum channel
    """

    fun value(): U8 => 0
primitive ListViewForumLayoutType is ForumLayoutType
    """
    Display posts as a list
    """

    fun value(): U8 => 1
primitive GalleryViewForumLayoutType is ForumLayoutType
    """
    Display posts as a collection of tiles
    """

    fun value(): U8 => 2
primitive ForumLayoutTypes
    fun from(value: U8): ForumLayoutType ? =>
        match value
        | 0 => NotSetForumLayoutType
        | 1 => ListViewForumLayoutType
        | 2 => GalleryViewForumLayoutType
        else error
        end

class val FollowedChannel is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#followed-channel-object-followed-channel-structure
    """

    let channel_id: Snowflake
        """
        source channel id
        """

    let webhook_id: Snowflake
        """
        created target webhook id
        """

    new val create(channel_id': Snowflake, webhook_id': Snowflake) =>
        channel_id = channel_id'
        webhook_id = webhook_id'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var webhook_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "webhook_id" => webhook_id' = Snowflake.from_json(value)?
            end
        end

        channel_id = channel_id' as Snowflake
        webhook_id = webhook_id' as Snowflake

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("channel_id", channel_id.to_json())
            .update("webhook_id", webhook_id.to_json())

class val PermissionOverwrite is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#overwrite-object-overwrite-structure

    See permissions for more information about the allow and deny fields.
    """

    let id: Snowflake
        """
        role or user id
        """

    let type': PermissionOverwriteType
        """
        either 0 (role) or 1 (member)
        """

    let allow: Array[Permission] val
        """
        permission bit set
        """

    let deny: Array[Permission] val
        """
        permission bit set
        """

    new val create(
        id': Snowflake,
        type'': PermissionOverwriteType,
        allow': Array[Permission] val,
        deny': Array[Permission] val
    ) =>
        id = id'
        type' = type''
        allow = allow'
        deny = deny'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (PermissionOverwriteType | None) = None
        var allow': (Array[Permission] val | None) = None
        var deny': (Array[Permission] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = PermissionOverwriteTypes.from((value as I64).u8())?
            | "allow" => allow' = _Permissions(value)?
            | "deny" => deny' = _Permissions(value)?
            end
        end

        id = id' as Snowflake
        type' = type'' as PermissionOverwriteType
        allow = allow' as Array[Permission] val
        deny = deny' as Array[Permission] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("allow", _Permissions.to_json(allow))
            .update("deny", _Permissions.to_json(deny))

primitive _PermissionOverwrites
    fun apply(value: json.JsonValue): Array[PermissionOverwrite] val ? =>
        """
        Decodes an array of permission overwrites.
        """

        let array = value as json.JsonArray
        recover val
            let overwrites = Array[PermissionOverwrite](array.size())
            for overwrite in array.values() do overwrites.push(PermissionOverwrite.from_json(overwrite as json.JsonObject)?) end
            overwrites
        end

    fun to_json(overwrites: Array[PermissionOverwrite] val): json.JsonArray =>
        var array = json.JsonArray
        for overwrite in overwrites.values() do array = array.push(overwrite.to_json()) end
        array

trait val PermissionOverwriteType is _Enum[PermissionOverwriteType, U8]
    """
    https://docs.discord.com/developers/resources/channel#overwrite-object-overwrite-structure
    """
primitive RolePermissionOverwriteType is PermissionOverwriteType
    fun value(): U8 => 0
primitive MemberPermissionOverwriteType is PermissionOverwriteType
    fun value(): U8 => 1
primitive PermissionOverwriteTypes
    fun from(value: U8): PermissionOverwriteType ? =>
        match value
        | 0 => RolePermissionOverwriteType
        | 1 => MemberPermissionOverwriteType
        else error
        end

class val ThreadMetadata is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#thread-metadata-object-thread-metadata-structure

    The thread metadata object contains a number of thread-specific channel fields that are not needed by other channel types.
    """

    let archived: Bool
        """
        whether the thread is archived
        """

    let auto_archive_duration: USize
        """
        the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
        """

    let archive_timestamp: ISO8601
        """
        timestamp when the thread's archive status was last changed, used for calculating recent activity
        """

    let locked: Bool
        """
        whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
        """

    let invitable: (Bool | None)
        """
        whether non-moderators can add other non-moderators to a thread; only available on private threads
        """

    let create_timestamp: (ISO8601 | None)
        """
        timestamp when the thread was created; only populated for threads created after 2022-01-09
        """

    new val create(
        archived': Bool,
        auto_archive_duration': USize,
        archive_timestamp': ISO8601,
        locked': Bool,
        invitable': (Bool | None) = None,
        create_timestamp': (ISO8601 | None) = None
    ) =>
        archived = archived'
        auto_archive_duration = auto_archive_duration'
        archive_timestamp = archive_timestamp'
        locked = locked'
        invitable = invitable'
        create_timestamp = create_timestamp'

    new val from_json(obj: json.JsonObject) ? =>
        var archived': (Bool | None) = None
        var auto_archive_duration': (USize | None) = None
        var archive_timestamp': (ISO8601 | None) = None
        var locked': (Bool | None) = None
        var invitable': (Bool | None) = None
        var create_timestamp': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "archived" => archived' = value as Bool
            | "auto_archive_duration" => auto_archive_duration' = (value as I64).usize()
            | "archive_timestamp" => archive_timestamp' = value as String
            | "locked" => locked' = value as Bool
            | "invitable" => invitable' = value as Bool
            | "create_timestamp" =>
                match value | let string: String => create_timestamp' = string end
            end
        end

        archived = archived' as Bool
        auto_archive_duration = auto_archive_duration' as USize
        archive_timestamp = archive_timestamp' as ISO8601
        locked = locked' as Bool
        invitable = invitable'
        create_timestamp = create_timestamp'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("archived", archived)
            .update("auto_archive_duration", auto_archive_duration.i64())
            .update("archive_timestamp", archive_timestamp)
            .update("locked", locked)

        match invitable
        | let invitable': Bool => obj = obj.update("invitable", invitable')
        end

        match create_timestamp
        | let create_timestamp': ISO8601 => obj = obj.update("create_timestamp", create_timestamp')
        end

        obj

class val ThreadMember is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#thread-member-object-thread-member-structure

    A thread member object contains information about a user that has joined a thread.
    """

    let id: (Snowflake | None)
        """
        ID of the thread

        Omitted on the member sent within each thread in the GUILD_CREATE event.
        """

    let user_id: (Snowflake | None)
        """
        ID of the user

        Omitted on the member sent within each thread in the GUILD_CREATE event.
        """

    let join_timestamp: ISO8601
        """
        Time the user last joined the thread
        """

    let flags: USize
        """
        Any user-thread settings, currently only used for notifications
        """

    let member: (GuildMember | None)
        """
        Additional information about the user

        Only included when `with_member` is set to true when calling List Thread Members or Get Thread Member.
        """

    new val create(
        id': (Snowflake | None) = None,
        user_id': (Snowflake | None) = None,
        join_timestamp': ISO8601,
        flags': USize,
        member': (GuildMember | None) = None
    ) =>
        id = id'
        user_id = user_id'
        join_timestamp = join_timestamp'
        flags = flags'
        member = member'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var user_id': (Snowflake | None) = None
        var join_timestamp': (ISO8601 | None) = None
        var flags': (USize | None) = None
        var member': (GuildMember | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "user_id" => user_id' = Snowflake.from_json(value)?
            | "join_timestamp" => join_timestamp' = value as String
            | "flags" => flags' = (value as I64).usize()
            | "member" => member' = GuildMember.from_json(value as json.JsonObject)?
            end
        end

        id = id'
        user_id = user_id'
        join_timestamp = join_timestamp' as ISO8601
        flags = flags' as USize
        member = member'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("join_timestamp", join_timestamp)
            .update("flags", flags.i64())

        match id
        | let id': Snowflake => obj = obj.update("id", id'.to_json())
        end

        match user_id
        | let user_id': Snowflake => obj = obj.update("user_id", user_id'.to_json())
        end

        match member
        | let member': GuildMember => obj = obj.update("member", member'.to_json())
        end

        obj

primitive _ThreadMembers
    fun apply(value: json.JsonValue): Array[ThreadMember] val ? =>
        """
        Decodes an array of thread members.
        """

        let array = value as json.JsonArray
        recover val
            let members = Array[ThreadMember](array.size())
            for member in array.values() do members.push(ThreadMember.from_json(member as json.JsonObject)?) end
            members
        end

    fun to_json(members: Array[ThreadMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do array = array.push(member.to_json()) end
        array

class val ArchivedThreads is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#list-public-archived-threads-response-body

    A page of archived threads, as handed back by the three routes that list
    them: public, private, and joined private.
    """

    let threads: Array[Channel] val
        """
        the archived threads
        """

    let members: Array[ThreadMember] val
        """
        a thread member object for each returned thread the current user has joined
        """

    let has_more: Bool
        """
        whether there are potentially additional threads that could be returned on a subsequent call
        """

    new val create(
        threads': Array[Channel] val,
        members': Array[ThreadMember] val,
        has_more': Bool
    ) =>
        threads = threads'
        members = members'
        has_more = has_more'

    new val from_json(obj: json.JsonObject) ? =>
        var threads': (Array[Channel] val | None) = None
        var members': (Array[ThreadMember] val | None) = None
        var has_more': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "threads" => threads' = _Channels(value)?
            | "members" => members' = _ThreadMembers(value)?
            | "has_more" => has_more' = value as Bool
            end
        end

        threads = threads' as Array[Channel] val
        members = members' as Array[ThreadMember] val
        has_more = has_more' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("threads", _Channels.to_json(threads))
            .update("members", _ThreadMembers.to_json(members))
            .update("has_more", has_more)

class val DefaultReaction is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#default-reaction-object-default-reaction-structure

    An object that specifies the emoji to use as the default way to react to a forum post. Exactly one of emoji_id and emoji_name must be set.
    """

    let emoji_id: (Snowflake | None)
        """
        the id of a guild's custom emoji
        """

    let emoji_name: (String | None)
        """
        the unicode character of the emoji
        """

    new val create(emoji_id': (Snowflake | None) = None, emoji_name': (String | None) = None) =>
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    new val from_json(obj: json.JsonObject) ? =>
        var emoji_id': (Snowflake | None) = None
        var emoji_name': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "emoji_id" =>
                match value | let string: String => emoji_id' = Snowflake.from_json(string)? end
            | "emoji_name" =>
                match value | let string: String => emoji_name' = string end
            end
        end

        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("emoji_id", match emoji_id | let emoji_id': Snowflake => emoji_id'.to_json() end)
            .update("emoji_name", emoji_name)

class val ForumTag is Jsonable
    """
    https://docs.discord.com/developers/resources/channel#forum-tag-object-forum-tag-structure

    An object that represents a tag that is able to be applied to a thread in a GUILD_FORUM or GUILD_MEDIA channel.

    When updating a GUILD_FORUM or a GUILD_MEDIA channel, tag objects in `available_tags` only require the `name` field.
    """

    let id: Snowflake
        """
        the id of the tag
        """

    let name: String
        """
        the name of the tag (0-20 characters)
        """

    let moderated: Bool
        """
        whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
        """

    let emoji_id: (Snowflake | None)
        """
        the id of a guild's custom emoji
        """

    let emoji_name: (String | None)
        """
        the unicode character of the emoji
        """

    new val create(
        id': Snowflake,
        name': String,
        moderated': Bool,
        emoji_id': (Snowflake | None) = None,
        emoji_name': (String | None) = None
    ) =>
        id = id'
        name = name'
        moderated = moderated'
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var moderated': (Bool | None) = None
        var emoji_id': (Snowflake | None) = None
        var emoji_name': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "moderated" => moderated' = value as Bool
            | "emoji_id" =>
                match value | let string: String => emoji_id' = Snowflake.from_json(string)? end
            | "emoji_name" =>
                match value | let string: String => emoji_name' = string end
            end
        end

        id = id' as Snowflake
        name = name' as String
        moderated = moderated' as Bool
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("moderated", moderated)
            .update("emoji_id", match emoji_id | let emoji_id': Snowflake => emoji_id'.to_json() end)
            .update("emoji_name", emoji_name)

primitive _ForumTags
    fun apply(value: json.JsonValue): Array[ForumTag] val ? =>
        """
        Decodes an array of forum tags.
        """

        let array = value as json.JsonArray
        recover val
            let tags = Array[ForumTag](array.size())
            for forum_tag in array.values() do tags.push(ForumTag.from_json(forum_tag as json.JsonObject)?) end
            tags
        end

    fun to_json(tags: Array[ForumTag] val): json.JsonArray =>
        var array = json.JsonArray
        for forum_tag in tags.values() do array = array.push(forum_tag.to_json()) end
        array

class val ForumTagParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#forum-tag-object

    A tag to be applied to a `GUILD_FORUM` or `GUILD_MEDIA` channel's `available_tags`.

    Unlike the forum tag objects the API returns, only `name` is required here: `id` identifies an existing tag to keep or rename, and is omitted to create a new one.
    """

    let name: String
        """
        the name of the tag (0-20 characters)
        """

    let id: (Snowflake | None)
        """
        the id of an existing tag to update, omitted when creating a new tag
        """

    let moderated: (Bool | None)
        """
        whether this tag can only be added to or removed from threads by a member with the MANAGE_THREADS permission
        """

    let emoji_id: Nullable[Snowflake]
        """
        the id of a guild's custom emoji
        """

    let emoji_name: Nullable[String]
        """
        the unicode character of the emoji
        """

    new val create(
        name': String,
        id': (Snowflake | None) = None,
        moderated': (Bool | None) = None,
        emoji_id': Nullable[Snowflake] = None,
        emoji_name': Nullable[String] = None
    ) =>
        name = name'
        id = id'
        moderated = moderated'
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match id
        | let id': Snowflake => obj = obj.update("id", id'.to_json())
        end

        match moderated
        | let moderated': Bool => obj = obj.update("moderated", moderated')
        end

        match emoji_id
        | let emoji_id': Snowflake => obj = obj.update("emoji_id", emoji_id'.to_json())
        | Null => obj = obj.update("emoji_id", None)
        end

        match emoji_name
        | let emoji_name': String => obj = obj.update("emoji_name", emoji_name')
        | Null => obj = obj.update("emoji_name", None)
        end

        obj

primitive _ForumTagParams
    fun to_json(tags: Array[ForumTagParams] val): json.JsonArray =>
        var array = json.JsonArray
        for forum_tag in tags.values() do array = array.push(forum_tag.to_json()) end
        array

class val UpdateChannelParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#modify-channel

    The fields accepted depend on the channel being modified. Group DM channels accept only `name` and `icon`. Threads accept `name`, `archived`, `auto_archive_duration`, `locked`, `invitable`, `rate_limit_per_user`, `flags` and `applied_tags`. All other guild channels accept the remaining fields.

    All parameters to this endpoint are optional.
    """

    let name: (String | None)
        """
        1-100 character channel name
        """

    let icon: (ImageData | None)
        """
        base64 encoded icon (group DM only)
        """

    let type': (ChannelType | None)
        """
        the type of channel; only conversion between text and announcement is supported and only in guilds with the "NEWS" feature
        """

    let position: Nullable[USize]
        """
        the position of the channel in the left-hand listing
        """

    let topic: Nullable[String]
        """
        0-1024 character channel topic (0-4096 characters for GUILD_FORUM and GUILD_MEDIA channels)
        """

    let nsfw: Nullable[Bool]
        """
        whether the channel is nsfw
        """

    let rate_limit_per_user: Nullable[USize]
        """
        amount of seconds a user has to wait before sending another message (0-21600)
        """

    let bitrate: Nullable[USize]
        """
        the bitrate (in bits) of the voice or stage channel; min 8000
        """

    let user_limit: Nullable[USize]
        """
        the user limit of the voice or stage channel, max 99 for voice channels and 10000 for stage channels (0 refers to no limit)
        """

    let permission_overwrites: Nullable[Array[PermissionOverwrite] val]
        """
        channel or category-specific permissions
        """

    let parent_id: Nullable[Snowflake]
        """
        id of the new parent category for a channel
        """

    let rtc_region: Nullable[String]
        """
        channel voice region id, automatic when set to null
        """

    let video_quality_mode: Nullable[VideoQualityMode]
        """
        the camera video quality mode of the voice channel
        """

    let default_auto_archive_duration: Nullable[USize]
        """
        the default duration that the clients use (not the API) for newly created threads in the channel, in minutes, to automatically archive the thread after recent activity
        """

    let flags: (Array[ChannelFlag] val | None)
        """
        channel flags combined as a bitfield. Currently only `REQUIRE_TAG` (`1 << 4`) is supported by GUILD_FORUM and GUILD_MEDIA channels. `HIDE_MEDIA_DOWNLOAD_OPTIONS` (`1 << 15`) is supported only by GUILD_MEDIA channels
        """

    let available_tags: (Array[ForumTagParams] val | None)
        """
        the set of tags that can be used in a GUILD_FORUM or a GUILD_MEDIA channel; limited to 20
        """

    let default_reaction_emoji: Nullable[DefaultReaction]
        """
        the emoji to show in the add reaction button on a thread in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    let default_thread_rate_limit_per_user: (USize | None)
        """
        the initial rate_limit_per_user to set on newly created threads in a channel. this field is copied to the thread at creation time and does not live update
        """

    let default_sort_order: Nullable[SortOrderType]
        """
        the default sort order type used to order posts in GUILD_FORUM and GUILD_MEDIA channels
        """

    let default_forum_layout: (ForumLayoutType | None)
        """
        the default forum layout type used to display posts in GUILD_FORUM channels
        """

    let archived: (Bool | None)
        """
        whether the thread is archived
        """

    let auto_archive_duration: (USize | None)
        """
        the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
        """

    let locked: (Bool | None)
        """
        whether the thread is locked; when a thread is locked, only users with MANAGE_THREADS can unarchive it
        """

    let invitable: (Bool | None)
        """
        whether non-moderators can add other non-moderators to a thread; only available on private threads
        """

    let applied_tags: (Array[Snowflake] val | None)
        """
        the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel; limited to 5
        """

    new val create(
        name': (String | None) = None,
        icon': (ImageData | None) = None,
        type'': (ChannelType | None) = None,
        position': Nullable[USize] = None,
        topic': Nullable[String] = None,
        nsfw': Nullable[Bool] = None,
        rate_limit_per_user': Nullable[USize] = None,
        bitrate': Nullable[USize] = None,
        user_limit': Nullable[USize] = None,
        permission_overwrites': Nullable[Array[PermissionOverwrite] val] = None,
        parent_id': Nullable[Snowflake] = None,
        rtc_region': Nullable[String] = None,
        video_quality_mode': Nullable[VideoQualityMode] = None,
        default_auto_archive_duration': Nullable[USize] = None,
        flags': (Array[ChannelFlag] val | None) = None,
        available_tags': (Array[ForumTagParams] val | None) = None,
        default_reaction_emoji': Nullable[DefaultReaction] = None,
        default_thread_rate_limit_per_user': (USize | None) = None,
        default_sort_order': Nullable[SortOrderType] = None,
        default_forum_layout': (ForumLayoutType | None) = None,
        archived': (Bool | None) = None,
        auto_archive_duration': (USize | None) = None,
        locked': (Bool | None) = None,
        invitable': (Bool | None) = None,
        applied_tags': (Array[Snowflake] val | None) = None
    ) =>
        name = name'
        icon = icon'
        type' = type''
        position = position'
        topic = topic'
        nsfw = nsfw'
        rate_limit_per_user = rate_limit_per_user'
        bitrate = bitrate'
        user_limit = user_limit'
        permission_overwrites = permission_overwrites'
        parent_id = parent_id'
        rtc_region = rtc_region'
        video_quality_mode = video_quality_mode'
        default_auto_archive_duration = default_auto_archive_duration'
        flags = flags'
        available_tags = available_tags'
        default_reaction_emoji = default_reaction_emoji'
        default_thread_rate_limit_per_user = default_thread_rate_limit_per_user'
        default_sort_order = default_sort_order'
        default_forum_layout = default_forum_layout'
        archived = archived'
        auto_archive_duration = auto_archive_duration'
        locked = locked'
        invitable = invitable'
        applied_tags = applied_tags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match icon
        | let icon': ImageData => obj = obj.update("icon", icon')
        end

        match type'
        | let type'': ChannelType => obj = obj.update("type", type''.value().i64())
        end

        match position
        | let position': USize => obj = obj.update("position", position'.i64())
        | Null => obj = obj.update("position", None)
        end

        match topic
        | let topic': String => obj = obj.update("topic", topic')
        | Null => obj = obj.update("topic", None)
        end

        match nsfw
        | let nsfw': Bool => obj = obj.update("nsfw", nsfw')
        | Null => obj = obj.update("nsfw", None)
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        | Null => obj = obj.update("rate_limit_per_user", None)
        end

        match bitrate
        | let bitrate': USize => obj = obj.update("bitrate", bitrate'.i64())
        | Null => obj = obj.update("bitrate", None)
        end

        match user_limit
        | let user_limit': USize => obj = obj.update("user_limit", user_limit'.i64())
        | Null => obj = obj.update("user_limit", None)
        end

        match permission_overwrites
        | let permission_overwrites': Array[PermissionOverwrite] val => obj = obj.update("permission_overwrites", _PermissionOverwrites.to_json(permission_overwrites'))
        | Null => obj = obj.update("permission_overwrites", None)
        end

        match parent_id
        | let parent_id': Snowflake => obj = obj.update("parent_id", parent_id'.to_json())
        | Null => obj = obj.update("parent_id", None)
        end

        match rtc_region
        | let rtc_region': String => obj = obj.update("rtc_region", rtc_region')
        | Null => obj = obj.update("rtc_region", None)
        end

        match video_quality_mode
        | let video_quality_mode': VideoQualityMode => obj = obj.update("video_quality_mode", video_quality_mode'.value().i64())
        | Null => obj = obj.update("video_quality_mode", None)
        end

        match default_auto_archive_duration
        | let default_auto_archive_duration': USize => obj = obj.update("default_auto_archive_duration", default_auto_archive_duration'.i64())
        | Null => obj = obj.update("default_auto_archive_duration", None)
        end

        match flags
        | let flags': Array[ChannelFlag] val => obj = obj.update("flags", _ChannelFlags.to_json(flags'))
        end

        match available_tags
        | let available_tags': Array[ForumTagParams] val => obj = obj.update("available_tags", _ForumTagParams.to_json(available_tags'))
        end

        match default_reaction_emoji
        | let default_reaction_emoji': DefaultReaction => obj = obj.update("default_reaction_emoji", default_reaction_emoji'.to_json())
        | Null => obj = obj.update("default_reaction_emoji", None)
        end

        match default_thread_rate_limit_per_user
        | let default_thread_rate_limit_per_user': USize => obj = obj.update("default_thread_rate_limit_per_user", default_thread_rate_limit_per_user'.i64())
        end

        match default_sort_order
        | let default_sort_order': SortOrderType => obj = obj.update("default_sort_order", default_sort_order'.value().i64())
        | Null => obj = obj.update("default_sort_order", None)
        end

        match default_forum_layout
        | let default_forum_layout': ForumLayoutType => obj = obj.update("default_forum_layout", default_forum_layout'.value().i64())
        end

        match archived
        | let archived': Bool => obj = obj.update("archived", archived')
        end

        match auto_archive_duration
        | let auto_archive_duration': USize => obj = obj.update("auto_archive_duration", auto_archive_duration'.i64())
        end

        match locked
        | let locked': Bool => obj = obj.update("locked", locked')
        end

        match invitable
        | let invitable': Bool => obj = obj.update("invitable", invitable')
        end

        match applied_tags
        | let applied_tags': Array[Snowflake] val => obj = obj.update("applied_tags", _Snowflakes.to_json(applied_tags'))
        end

        obj

class val SetVoiceChannelStatusParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#set-voice-channel-status-json-params
    """

    let status: Nullable[String]
        """
        the new voice channel status, 0-500 characters
        """

    new val create(status': Nullable[String] = None) =>
        status = status'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match status
        | let status': String => obj = obj.update("status", status')
        | Null => obj = obj.update("status", None)
        end

        obj

class val UpdateChannelPermissionsParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#edit-channel-permissions-json-params
    """

    let type': PermissionOverwriteType
        """
        0 for a role or 1 for a member
        """

    let allow: Nullable[Array[Permission] val]
        """
        the bitwise value of all allowed permissions (default `"0"`)
        """

    let deny: Nullable[Array[Permission] val]
        """
        the bitwise value of all disallowed permissions (default `"0"`)
        """

    new val create(
        type'': PermissionOverwriteType,
        allow': Nullable[Array[Permission] val] = None,
        deny': Nullable[Array[Permission] val] = None
    ) =>
        type' = type''
        allow = allow'
        deny = deny'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("type", type'.value().i64())

        match allow
        | let allow': Array[Permission] val => obj = obj.update("allow", _Permissions.to_json(allow'))
        | Null => obj = obj.update("allow", None)
        end

        match deny
        | let deny': Array[Permission] val => obj = obj.update("deny", _Permissions.to_json(deny'))
        | Null => obj = obj.update("deny", None)
        end

        obj

class val CreateChannelInviteParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#create-channel-invite-json-params

    All JSON parameters for this route are optional, however the request body is not. If you are not sending any fields, you still have to send an empty JSON object (`{}`).
    """

    let max_age: (USize | None)
        """
        duration of invite in seconds before expiry, or 0 for never. between 0 and 604800 (7 days). Defaults to 86400 (24 hours)
        """

    let max_uses: (USize | None)
        """
        max number of uses or 0 for unlimited. between 0 and 100. Defaults to 0
        """

    let temporary: (Bool | None)
        """
        whether this invite only grants temporary membership. Defaults to false
        """

    let unique: (Bool | None)
        """
        if true, don't try to reuse a similar invite (useful for creating many unique one time use invites). Defaults to false
        """

    let target_type: (InviteTargetType | None)
        """
        the type of target for this voice channel invite
        """

    let target_user_id: (Snowflake | None)
        """
        the id of the user whose stream to display for this invite, required if `target_type` is 1, the user must be streaming in the channel
        """

    let target_application_id: (Snowflake | None)
        """
        the id of the embedded application to open for this invite, required if `target_type` is 2, the application must have the EMBEDDED flag
        """

    new val create(
        max_age': (USize | None) = None,
        max_uses': (USize | None) = None,
        temporary': (Bool | None) = None,
        unique': (Bool | None) = None,
        target_type': (InviteTargetType | None) = None,
        target_user_id': (Snowflake | None) = None,
        target_application_id': (Snowflake | None) = None
    ) =>
        max_age = max_age'
        max_uses = max_uses'
        temporary = temporary'
        unique = unique'
        target_type = target_type'
        target_user_id = target_user_id'
        target_application_id = target_application_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match max_age
        | let max_age': USize => obj = obj.update("max_age", max_age'.i64())
        end

        match max_uses
        | let max_uses': USize => obj = obj.update("max_uses", max_uses'.i64())
        end

        match temporary
        | let temporary': Bool => obj = obj.update("temporary", temporary')
        end

        match unique
        | let unique': Bool => obj = obj.update("unique", unique')
        end

        match target_type
        | let target_type': InviteTargetType => obj = obj.update("target_type", target_type'.value().i64())
        end

        match target_user_id
        | let target_user_id': Snowflake => obj = obj.update("target_user_id", target_user_id'.to_json())
        end

        match target_application_id
        | let target_application_id': Snowflake => obj = obj.update("target_application_id", target_application_id'.to_json())
        end

        obj

class val FollowAnnouncementChannelParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#follow-announcement-channel-json-params
    """

    let webhook_channel_id: Snowflake
        """
        id of target channel
        """

    new val create(webhook_channel_id': Snowflake) =>
        webhook_channel_id = webhook_channel_id'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("webhook_channel_id", webhook_channel_id.to_json())

class val AddGroupDMRecipientParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#group-dm-add-recipient-json-params
    """

    let access_token: String
        """
        access token of a user that has granted your app the `gdm.join` scope
        """

    let nick: (String | None)
        """
        nickname of the user being added
        """

    new val create(access_token': String, nick': (String | None) = None) =>
        access_token = access_token'
        nick = nick'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("access_token", access_token)

        match nick
        | let nick': String => obj = obj.update("nick", nick')
        end

        obj

class val StartThreadFromMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#start-thread-from-message-json-params
    """

    let name: String
        """
        1-100 character channel name
        """

    let auto_archive_duration: (USize | None)
        """
        the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
        """

    let rate_limit_per_user: (USize | None)
        """
        amount of seconds a user has to wait before sending another message (0-21600)
        """

    new val create(
        name': String,
        auto_archive_duration': (USize | None) = None,
        rate_limit_per_user': (USize | None) = None
    ) =>
        name = name'
        auto_archive_duration = auto_archive_duration'
        rate_limit_per_user = rate_limit_per_user'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match auto_archive_duration
        | let auto_archive_duration': USize => obj = obj.update("auto_archive_duration", auto_archive_duration'.i64())
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        obj

class val StartThreadWithoutMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#start-thread-without-message-json-params
    """

    let name: String
        """
        1-100 character channel name
        """

    let auto_archive_duration: (USize | None)
        """
        the thread will stop showing in the channel list after auto_archive_duration minutes of inactivity, can be set to: 60, 1440, 4320, 10080
        """

    let type': (ChannelType | None)
        """
        the type of thread to create

        Defaults to `PRIVATE_THREAD`.
        """

    let invitable: (Bool | None)
        """
        whether non-moderators can add other non-moderators to a thread; only available when creating a private thread
        """

    let rate_limit_per_user: (USize | None)
        """
        amount of seconds a user has to wait before sending another message (0-21600)
        """

    new val create(
        name': String,
        auto_archive_duration': (USize | None) = None,
        type'': (ChannelType | None) = None,
        invitable': (Bool | None) = None,
        rate_limit_per_user': (USize | None) = None
    ) =>
        name = name'
        auto_archive_duration = auto_archive_duration'
        type' = type''
        invitable = invitable'
        rate_limit_per_user = rate_limit_per_user'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match auto_archive_duration
        | let auto_archive_duration': USize => obj = obj.update("auto_archive_duration", auto_archive_duration'.i64())
        end

        match type'
        | let type'': ChannelType => obj = obj.update("type", type''.value().i64())
        end

        match invitable
        | let invitable': Bool => obj = obj.update("invitable", invitable')
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        obj

class val StartThreadInForumOrMediaChannelParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/channel#start-thread-in-forum-or-media-channel-json/form-params
    """

    let name: String
        """
        1-100 character channel name
        """

    let message: ForumThreadMessageParams
        """
        contents of the first message in the forum/media thread
        """

    let auto_archive_duration: (USize | None)
        """
        duration in minutes to automatically archive the thread after recent activity, can be set to: 60, 1440, 4320, 10080
        """

    let rate_limit_per_user: (USize | None)
        """
        amount of seconds a user has to wait before sending another message (0-21600)
        """

    let applied_tags: (Array[Snowflake] val | None)
        """
        the IDs of the set of tags that have been applied to a thread in a GUILD_FORUM or a GUILD_MEDIA channel
        """

    new val create(
        name': String,
        message': ForumThreadMessageParams,
        auto_archive_duration': (USize | None) = None,
        rate_limit_per_user': (USize | None) = None,
        applied_tags': (Array[Snowflake] val | None) = None
    ) =>
        name = name'
        message = message'
        auto_archive_duration = auto_archive_duration'
        rate_limit_per_user = rate_limit_per_user'
        applied_tags = applied_tags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("message", message.to_json())

        match auto_archive_duration
        | let auto_archive_duration': USize => obj = obj.update("auto_archive_duration", auto_archive_duration'.i64())
        end

        match rate_limit_per_user
        | let rate_limit_per_user': USize => obj = obj.update("rate_limit_per_user", rate_limit_per_user'.i64())
        end

        match applied_tags
        | let applied_tags': Array[Snowflake] val => obj = obj.update("applied_tags", _Snowflakes.to_json(applied_tags'))
        end

        obj

class val GetThreadMemberParams
    """
    https://docs.discord.com/developers/resources/channel#get-thread-member-query-string-params
    """

    let with_member: (Bool | None)
        """
        Whether to include a guild member object for the thread member
        """

    new val create(with_member': (Bool | None) = None) =>
        with_member = with_member'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_member
        | let with_member': Bool => query.push(("with_member", with_member'.string()))
        end

        consume query

class val GetThreadMembersParams
    """
    https://docs.discord.com/developers/resources/channel#list-thread-members-query-string-params

    Requires the `GUILD_MEMBERS` privileged intent to be enabled for the application.
    """

    let with_member: (Bool | None)
        """
        Whether to include a guild member object for each thread member
        """

    let after: (Snowflake | None)
        """
        Get thread members after this user ID
        """

    let limit: (USize | None)
        """
        Max number of thread members to return (1-100). Defaults to 100.
        """

    new val create(
        with_member': (Bool | None) = None,
        after': (Snowflake | None) = None,
        limit': (USize | None) = None
    ) =>
        with_member = with_member'
        after = after'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_member
        | let with_member': Bool => query.push(("with_member", with_member'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query

class val GetPublicArchivedThreadsParams
    """
    https://docs.discord.com/developers/resources/channel#list-public-archived-threads-query-string-params
    """

    let before: (ISO8601 | None)
        """
        returns threads archived before this timestamp
        """

    let limit: (USize | None)
        """
        optional maximum number of threads to return
        """

    new val create(before': (ISO8601 | None) = None, limit': (USize | None) = None) =>
        before = before'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match before
        | let before': ISO8601 => query.push(("before", before'))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query

class val GetPrivateArchivedThreadsParams
    """
    https://docs.discord.com/developers/resources/channel#list-private-archived-threads-query-string-params
    """

    let before: (ISO8601 | None)
        """
        returns threads archived before this timestamp
        """

    let limit: (USize | None)
        """
        optional maximum number of threads to return
        """

    new val create(before': (ISO8601 | None) = None, limit': (USize | None) = None) =>
        before = before'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match before
        | let before': ISO8601 => query.push(("before", before'))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query

class val GetJoinedPrivateArchivedThreadsParams
    """
    https://docs.discord.com/developers/resources/channel#list-joined-private-archived-threads-query-string-params
    """

    let before: (Snowflake | None)
        """
        returns threads before this id
        """

    let limit: (USize | None)
        """
        optional maximum number of threads to return
        """

    new val create(before': (Snowflake | None) = None, limit': (USize | None) = None) =>
        before = before'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query
