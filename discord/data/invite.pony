use json = "json"

class val Invite is Jsonable
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

    let guild: (PartialGuild | None)
        """
        the guild this invite is for

        This is a partial guild object, so most of its fields may be absent.
        """

    let channel: (PartialChannel | None)
        """
        the channel this invite is for

        This is a partial channel object carrying only `id`, `name` and `type`.
        """

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

    new val create(
        type'': InviteType,
        code': String,
        guild': (PartialGuild | None) = None,
        channel': (PartialChannel | None) = None,
        inviter': (User | None) = None,
        target_type': (InviteTargetType | None) = None,
        target_user': (User | None) = None,
        target_application': (Application | None) = None,
        approximate_presence_count': (USize | None) = None,
        approximate_member_count': (USize | None) = None,
        expires_at': (ISO8601 | None) = None,
        guild_scheduled_event': (GuildScheduledEvent | None) = None,
        flags': (Array[InviteFlag] val | None) = None
    ) =>
        type' = type''
        code = code'
        guild = guild'
        channel = channel'
        inviter = inviter'
        target_type = target_type'
        target_user = target_user'
        target_application = target_application'
        approximate_presence_count = approximate_presence_count'
        approximate_member_count = approximate_member_count'
        expires_at = expires_at'
        guild_scheduled_event = guild_scheduled_event'
        flags = flags'

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (InviteType | None) = None
        var code': (String | None) = None
        var guild': (PartialGuild | None) = None
        var channel': (PartialChannel | None) = None
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
            | "guild" =>
                match value | let obj': json.JsonObject => guild' = PartialGuild.from_json(obj')? end
            | "channel" =>
                match value | let obj': json.JsonObject => channel' = PartialChannel.from_json(obj')? end
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
        channel = channel'
        inviter = inviter'
        target_type = target_type'
        target_user = target_user'
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
        | let guild': PartialGuild => obj = obj.update("guild", guild'.to_json())
        end

        match channel
        | let channel': PartialChannel => obj = obj.update("channel", channel'.to_json())
        end

        match inviter
        | let inviter': User => obj = obj.update("inviter", inviter'.to_json())
        end

        match target_type
        | let target_type': InviteTargetType => obj = obj.update("target_type", target_type'.value().i64())
        end

        match target_user
        | let target_user': User => obj = obj.update("target_user", target_user'.to_json())
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

primitive _Invites
    fun apply(value: json.JsonValue): Array[Invite] val ? =>
        """
        Decodes an array of invites.
        """

        let array = value as json.JsonArray
        recover val
            let invites = Array[Invite](array.size())
            for invite in array.values() do invites.push(Invite.from_json(invite as json.JsonObject)?) end
            invites
        end

    fun to_json(invites: Array[Invite] val): json.JsonArray =>
        var array = json.JsonArray
        for invite in invites.values() do array = array.push(invite.to_json()) end
        array

trait val InviteType is _Enum[InviteType, U8]
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-types
    """
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

trait val InviteTargetType is _Enum[InviteTargetType, U8]
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-target-types
    """
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

trait val InviteFlag is _Enum[InviteFlag, U8]
    """
    https://docs.discord.com/developers/resources/invite#invite-object-invite-flags
    """
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

class val InviteMetadata is Jsonable
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

    new val create(
        uses': USize,
        max_uses': USize,
        max_age': USize,
        temporary': Bool,
        created_at': ISO8601
    ) =>
        uses = uses'
        max_uses = max_uses'
        max_age = max_age'
        temporary = temporary'
        created_at = created_at'

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

class val InviteStageInstance is Jsonable
    """
    https://docs.discord.com/developers/resources/invite#invite-stage-instance-object-invite-stage-instance-structure

    Deprecated.
    """

    let members: Array[PartialGuildMember] val
        """
        the members speaking in the Stage

        These are partial guild member objects, so most of their fields may be absent.
        """

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

    new val create(
        members': Array[PartialGuildMember] val,
        participant_count': USize,
        speaker_count': USize,
        topic': String
    ) =>
        members = members'
        participant_count = participant_count'
        speaker_count = speaker_count'
        topic = topic'

    new val from_json(obj: json.JsonObject) ? =>
        var members': (Array[PartialGuildMember] val | None) = None
        var participant_count': (USize | None) = None
        var speaker_count': (USize | None) = None
        var topic': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "members" => members' = _PartialGuildMembers(value)?
            | "participant_count" => participant_count' = (value as I64).usize()
            | "speaker_count" => speaker_count' = (value as I64).usize()
            | "topic" => topic' = value as String
            end
        end

        members = members' as Array[PartialGuildMember] val
        participant_count = participant_count' as USize
        speaker_count = speaker_count' as USize
        topic = topic' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("members", _PartialGuildMembers.to_json(members))
            .update("participant_count", participant_count.i64())
            .update("speaker_count", speaker_count.i64())
            .update("topic", topic)

class val TargetUsersJobStatus is Jsonable
    """
    https://docs.discord.com/developers/resources/invite#get-target-users-job-status

    Where the asynchronous processing of an invite's target users has got to.
    """

    let status: TargetUsersJobStatusCode
        """
        the current state of the job
        """

    let total_users: USize
        """
        the number of users in the uploaded file
        """

    let processed_users: USize
        """
        the number of users processed so far
        """

    let created_at: ISO8601
        """
        when the job was created
        """

    let completed_at: (ISO8601 | None)
        """
        when the job finished, or `None` while it is still running
        """

    let error_message: (String | None)
        """
        why the job failed, set only for a `FailedTargetUsersJobStatusCode` job
        """

    new val create(
        status': TargetUsersJobStatusCode,
        total_users': USize,
        processed_users': USize,
        created_at': ISO8601,
        completed_at': (ISO8601 | None) = None,
        error_message': (String | None) = None
    ) =>
        status = status'
        total_users = total_users'
        processed_users = processed_users'
        created_at = created_at'
        completed_at = completed_at'
        error_message = error_message'

    new val from_json(obj: json.JsonObject) ? =>
        var status': (TargetUsersJobStatusCode | None) = None
        var total_users': (USize | None) = None
        var processed_users': (USize | None) = None
        var created_at': (ISO8601 | None) = None
        var completed_at': (ISO8601 | None) = None
        var error_message': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "status" => status' = TargetUsersJobStatusCodes.from((value as I64).u8())?
            | "total_users" => total_users' = (value as I64).usize()
            | "processed_users" => processed_users' = (value as I64).usize()
            | "created_at" => created_at' = value as String
            | "completed_at" =>
                match value | let string: String => completed_at' = string end
            | "error_message" =>
                match value | let string: String => error_message' = string end
            end
        end

        status = status' as TargetUsersJobStatusCode
        total_users = total_users' as USize
        processed_users = processed_users' as USize
        created_at = created_at' as ISO8601
        completed_at = completed_at'
        error_message = error_message'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("status", status.value().i64())
            .update("total_users", total_users.i64())
            .update("processed_users", processed_users.i64())
            .update("created_at", created_at)
            .update("completed_at", completed_at)
            .update("error_message", error_message)

trait val TargetUsersJobStatusCode is _Enum[TargetUsersJobStatusCode, U8]
    """
    https://docs.discord.com/developers/resources/invite#get-target-users-job-status-status-codes
    """
primitive UnspecifiedTargetUsersJobStatusCode is TargetUsersJobStatusCode
    """
    The default value.
    """

    fun value(): U8 => 0
primitive ProcessingTargetUsersJobStatusCode is TargetUsersJobStatusCode
    """
    The job is still being processed.
    """

    fun value(): U8 => 1
primitive CompletedTargetUsersJobStatusCode is TargetUsersJobStatusCode
    """
    The job has been completed successfully.
    """

    fun value(): U8 => 2
primitive FailedTargetUsersJobStatusCode is TargetUsersJobStatusCode
    """
    The job has failed, see the `error_message` field for more details.
    """

    fun value(): U8 => 3
primitive TargetUsersJobStatusCodes
    fun from(value: U8): TargetUsersJobStatusCode ? =>
        match value
        | 0 => UnspecifiedTargetUsersJobStatusCode
        | 1 => ProcessingTargetUsersJobStatusCode
        | 2 => CompletedTargetUsersJobStatusCode
        | 3 => FailedTargetUsersJobStatusCode
        else error
        end

class val GetInviteParams
    """
    https://docs.discord.com/developers/resources/invite#get-invite-query-string-params
    """

    let with_counts: (Bool | None)
        """
        whether the invite should contain approximate member counts
        """

    let with_expiration: (Bool | None)
        """
        whether the invite should contain the expiration date
        """

    let guild_scheduled_event_id: (Snowflake | None)
        """
        the guild scheduled event to include with the invite
        """

    new val create(
        with_counts': (Bool | None) = None,
        with_expiration': (Bool | None) = None,
        guild_scheduled_event_id': (Snowflake | None) = None
    ) =>
        with_counts = with_counts'
        with_expiration = with_expiration'
        guild_scheduled_event_id = guild_scheduled_event_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_counts
        | let with_counts': Bool => query.push(("with_counts", with_counts'.string()))
        end

        match with_expiration
        | let with_expiration': Bool => query.push(("with_expiration", with_expiration'.string()))
        end

        match guild_scheduled_event_id
        | let guild_scheduled_event_id': Snowflake => query.push(("guild_scheduled_event_id", guild_scheduled_event_id'.string()))
        end

        consume query

class val UpdateInviteTargetUsersParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/invite#update-target-users-json-params

    Replaces the set of users an invite is targeted at.
    """

    let user_ids: Array[Snowflake] val
        """
        the ids of the users to target with this invite
        """

    new val create(user_ids': Array[Snowflake] val) =>
        user_ids = user_ids'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("user_ids", _Snowflakes.to_json(user_ids))
