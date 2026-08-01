use collections = "collections"
use json = "json"

class val Invite
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-structure

    Represents a code that when used, adds a user to a guild or group DM channel.
    """

    let type': InviteType
        """
        the type of invite
        """

    let code: String
        """
        the invite code (unique ID)
        """

    let guild: (Guild | None)
        """
        the guild this invite is for
        """

    // TODO(vxern): Add `channel` (partial channel object; the channel this invite is for) once `Channel` is implemented.

    let inviter: (User | None)
        """
        the user who created the invite
        """

    let target_type: (InviteTargetType | None)
        """
        the type of target for this voice channel invite
        """

    let target_user: (User | None)
        """
        the user whose stream to display for this voice channel stream invite
        """

    let target_application: (Application | None)
        """
        the embedded application to open for this voice channel embedded application invite
        """

    let approximate_presence_count: (USize | None)
        """
        approximate count of online members, returned from the GET /invites/<code> endpoint when with_counts is true
        """

    let approximate_member_count: (USize | None)
        """
        approximate count of total members, returned from the GET /invites/<code> endpoint when with_counts is true
        """

    let expires_at: (ISO8601 | None)
        """
        the expiration date of this invite, returned from the GET /invites/<code> endpoint when with_expiration is true
        """

    let guild_scheduled_event: (GuildScheduledEvent | None)
        """
        guild scheduled event data, only included if guild_scheduled_event_id contains a valid guild scheduled event id
        """

    let flags: (Array[InviteFlag] val | None)
        """
        invite flags
        """

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (InviteType | None) = None
        var code': (String | None) = None
        var guild': (Guild | None) = None
        var inviter': (User | None) = None
        var target_type': (InviteTargetType | None) = None
        var target_user': (User | None) = None
        var target_application': (Application | None) = None
        var approximate_presence_count': (USize | None) = None
        var approximate_member_count': (USize | None) = None
        var expires_at': (ISO8601 | None) = None
        var guild_scheduled_event': (GuildScheduledEvent | None) = None
        var flags': (Array[InviteFlag] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "type" => type'' = InviteTypes.from((value as I64).u8())?
            | "code" => code' = value as String
            | "guild" => guild' = Guild.from_json(value as json.JsonObject)?
            | "inviter" => inviter' = User.from_json(value as json.JsonObject)?
            | "target_type" => target_type' = InviteTargetTypes.from((value as I64).u8())?
            | "target_user" => target_user' = User.from_json(value as json.JsonObject)?
            | "target_application" => target_application' = Application.from_json(value as json.JsonObject)?
            | "approximate_presence_count" => approximate_presence_count' = (value as I64).usize()
            | "approximate_member_count" => approximate_member_count' = (value as I64).usize()
            | "expires_at" =>
                match value | let string: String => expires_at' = string end
            | "guild_scheduled_event" => guild_scheduled_event' = GuildScheduledEvent.from_json(value as json.JsonObject)?
            | "flags" => flags' = _InviteFlags((value as I64).u64())
            end
        end

        type' = type'' as InviteType
        code = code' as String
        guild = guild'
        target_type = target_type'
        target_application = target_application'
        approximate_presence_count = approximate_presence_count'
        approximate_member_count = approximate_member_count'
        expires_at = expires_at'
        guild_scheduled_event = guild_scheduled_event'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("type", type'.value().i64())
            .update("code", code)

        match guild
        | let guild': Guild => obj = obj.update("guild", guild'.to_json())
        end

        match target_type
        | let target_type': InviteTargetType => obj = obj.update("target_type", target_type'.value().i64())
        end

        match target_application
        | let target_application': Application => obj = obj.update("target_application", target_application'.to_json())
        end

        match approximate_presence_count
        | let approximate_presence_count': USize => obj = obj.update("approximate_presence_count", approximate_presence_count'.i64())
        end

        match approximate_member_count
        | let approximate_member_count': USize => obj = obj.update("approximate_member_count", approximate_member_count'.i64())
        end

        match expires_at
        | let expires_at': ISO8601 => obj = obj.update("expires_at", expires_at')
        end

        match guild_scheduled_event
        | let guild_scheduled_event': GuildScheduledEvent => obj = obj.update("guild_scheduled_event", guild_scheduled_event'.to_json())
        end

        match flags
        | let flags': Array[InviteFlag] val => obj = obj.update("flags", _InviteFlags.to_json(flags'))
        end

        obj

trait val InviteType is (collections.Hashable & Equatable[InviteType])
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InviteType): Bool => value() == that.value()
primitive GuildInviteType is InviteType
    fun value(): U8 => 0
primitive GroupDMInviteType is InviteType
    fun value(): U8 => 1
primitive FriendInviteType is InviteType
    fun value(): U8 => 2
primitive InviteTypes
    fun from(value: U8): InviteType ? =>
        match value
        | 0 => GuildInviteType
        | 1 => GroupDMInviteType
        | 2 => FriendInviteType
        else error
        end

trait val InviteTargetType is (collections.Hashable & Equatable[InviteTargetType])
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-target-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InviteTargetType): Bool => value() == that.value()
primitive StreamInviteTargetType is InviteTargetType
    fun value(): U8 => 1
primitive EmbeddedApplicationInviteTargetType is InviteTargetType
    fun value(): U8 => 2
primitive InviteTargetTypes
    fun from(value: U8): InviteTargetType ? =>
        match value
        | 1 => StreamInviteTargetType
        | 2 => EmbeddedApplicationInviteTargetType
        else error
        end

trait val InviteFlag is (collections.Hashable & Equatable[InviteFlag])
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InviteFlag): Bool => value() == that.value()
primitive IsGuestInviteInviteFlag is InviteFlag
    """
    this invite is a guest invite for a voice channel
    """

    fun value(): U8 => 0
primitive IsApplicationBypassInviteFlag is InviteFlag
    """
    this invite bypasses the guild's join requests
    """

    fun value(): U8 => 6
primitive InviteFlags
    fun from(value: U8): InviteFlag ? =>
        match value
        | 0 => IsGuestInviteInviteFlag
        | 6 => IsApplicationBypassInviteFlag
        else error
        end

primitive _InviteFlags
    fun apply(bits: U64): Array[InviteFlag] val =>
        recover val
            let flags = Array[InviteFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(InviteFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[InviteFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

class val InviteMetadata
    """
    https://docs.discord.com/developers/resources/invite#invite-metadata-object-invite-metadata-structure

    Extra information about an invite, will extra info.
    """

    let uses: USize
        """
        number of times this invite has been used
        """

    let max_uses: USize
        """
        max number of times this invite can be used
        """

    let max_age: USize
        """
        duration (in seconds) after which the invite expires
        """

    let temporary: Bool
        """
        whether this invite only grants temporary membership
        """

    let created_at: ISO8601
        """
        when this invite was created
        """

    new val from_json(obj: json.JsonObject) ? =>
        var uses': (USize | None) = None
        var max_uses': (USize | None) = None
        var max_age': (USize | None) = None
        var temporary': (Bool | None) = None
        var created_at': (ISO8601 | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "uses" => uses' = (value as I64).usize()
            | "max_uses" => max_uses' = (value as I64).usize()
            | "max_age" => max_age' = (value as I64).usize()
            | "temporary" => temporary' = value as Bool
            | "created_at" => created_at' = value as String
            end
        end

        uses = uses' as USize
        max_uses = max_uses' as USize
        max_age = max_age' as USize
        temporary = temporary' as Bool
        created_at = created_at' as ISO8601

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("uses", uses.i64())
            .update("max_uses", max_uses.i64())
            .update("max_age", max_age.i64())
            .update("temporary", temporary)
            .update("created_at", created_at)

class val InviteStageInstance
    """
    https://docs.discord.com/developers/resources/invite#invite-stage-instance-object-invite-stage-instance-structure

    Deprecated.
    """

    let members: Array[GuildMember] val
        """
        the members speaking in the Stage
        """

    // TODO(vxern): These are *partial* guild members, so a payload that omits any of the fields `GuildMember` requires will fail to decode. Needs a partial variant of `GuildMember`.

    let participant_count: USize
        """
        the number of users in the Stage
        """

    let speaker_count: USize
        """
        the number of users speaking in the Stage
        """

    let topic: String
        """
        the topic of the Stage instance (1-120 characters)
        """

    new val from_json(obj: json.JsonObject) ? =>
        var members': (Array[GuildMember] val | None) = None
        var participant_count': (USize | None) = None
        var speaker_count': (USize | None) = None
        var topic': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "members" => members' = _GuildMembers(value)?
            | "participant_count" => participant_count' = (value as I64).usize()
            | "speaker_count" => speaker_count' = (value as I64).usize()
            | "topic" => topic' = value as String
            end
        end

        members = members' as Array[GuildMember] val
        participant_count = participant_count' as USize
        speaker_count = speaker_count' as USize
        topic = topic' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("members", _GuildMembers.to_json(members))
            .update("participant_count", participant_count.i64())
            .update("speaker_count", speaker_count.i64())
            .update("topic", topic)
