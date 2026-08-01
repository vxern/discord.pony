use collections = "collections"
use json = "json"

class val Channel
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

    // TODO(vxern): Add `recipients` (array of user objects; the recipients of the DM) once `User` is implemented.

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

    let permissions: (String | None)
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
        var permissions': (String | None) = None
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
            | "permissions" => permissions' = value as String
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
        | let permissions': String => obj = obj.update("permissions", permissions')
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

trait val ChannelType is (collections.Hashable & Equatable[ChannelType])
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ChannelType): Bool => value() == that.value()
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

trait val VideoQualityMode is (collections.Hashable & Equatable[VideoQualityMode])
    """
    https://docs.discord.com/developers/resources/channel#channel-object-video-quality-modes
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: VideoQualityMode): Bool => value() == that.value()
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

trait val ChannelFlag is (collections.Hashable & Equatable[ChannelFlag])
    """
    https://docs.discord.com/developers/resources/channel#channel-object-channel-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ChannelFlag): Bool => value() == that.value()
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

trait val SortOrderType is (collections.Hashable & Equatable[SortOrderType])
    """
    https://docs.discord.com/developers/resources/channel#channel-object-sort-order-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SortOrderType): Bool => value() == that.value()
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

trait val ForumLayoutType is (collections.Hashable & Equatable[ForumLayoutType])
    """
    https://docs.discord.com/developers/resources/channel#channel-object-forum-layout-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ForumLayoutType): Bool => value() == that.value()
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

class val FollowedChannel
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

class val PermissionOverwrite
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

    let allow: String
        """
        permission bit set
        """

    let deny: String
        """
        permission bit set
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (PermissionOverwriteType | None) = None
        var allow': (String | None) = None
        var deny': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = PermissionOverwriteTypes.from((value as I64).u8())?
            | "allow" => allow' = value as String
            | "deny" => deny' = value as String
            end
        end

        id = id' as Snowflake
        type' = type'' as PermissionOverwriteType
        allow = allow' as String
        deny = deny' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("allow", allow)
            .update("deny", deny)

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

trait val PermissionOverwriteType is (collections.Hashable & Equatable[PermissionOverwriteType])
    """
    https://docs.discord.com/developers/resources/channel#overwrite-object-overwrite-structure
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: PermissionOverwriteType): Bool => value() == that.value()
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

class val ThreadMetadata
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

class val ThreadMember
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

class val DefaultReaction
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

class val ForumTag
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
