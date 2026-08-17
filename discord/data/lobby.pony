use collections = "collections"
use json = "json"

class val Lobby is Jsonable
    """
    https://docs.discord.com/developers/resources/lobby#lobby-object

    A Lobby within Discord. See Managing Lobbies for more information.
    """

    let id: Snowflake
        """
        the id of this channel
        """

    let application_id: Snowflake
        """
        application that created the lobby
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        dictionary of string key/value pairs. The max total length is 1000.
        """

    let members: Array[LobbyMember] val
        """
        members of the lobby
        """

    let linked_channel: (Channel | None)
        """
        the guild channel linked to the lobby
        """

    new val create(
        id': Snowflake,
        application_id': Snowflake,
        metadata': (collections.Map[String, String] val | None) = None,
        members': Array[LobbyMember] val,
        linked_channel': (Channel | None) = None
    ) =>
        id = id'
        application_id = application_id'
        metadata = metadata'
        members = members'
        linked_channel = linked_channel'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var metadata': (collections.Map[String, String] val | None) = None
        var members': (Array[LobbyMember] val | None) = None
        var linked_channel': (Channel | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "metadata" => metadata' = _Metadata(value)
            | "members" => members' = _LobbyMembers(value)?
            | "linked_channel" =>
                linked_channel' = Channel.from_json(value as json.JsonObject)?
            end
        end

        id = id' as Snowflake
        application_id = application_id' as Snowflake
        metadata = metadata'
        members = members' as Array[LobbyMember] val
        linked_channel = linked_channel'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("application_id", application_id.to_json())
            .update("members", _LobbyMembers.to_json(members))

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match linked_channel
        | let linked_channel': Channel =>
            obj = obj.update("linked_channel", linked_channel'.to_json())
        end

        obj

class val LobbyMember is Jsonable
    """
    https://docs.discord.com/developers/resources/lobby#lobby-member-object

    Represents a member of a lobby, including optional metadata and flags.
    """

    let id: Snowflake
        """
        the id of the user
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        dictionary of string key/value pairs. The max total length is 1000.
        """

    let flags: (Array[LobbyMemberFlag] val | None)
        """
        lobby member flags combined as a bitfield
        """

    new val create(
        id': Snowflake,
        metadata': (collections.Map[String, String] val | None) = None,
        flags': (Array[LobbyMemberFlag] val | None) = None
    ) =>
        id = id'
        metadata = metadata'
        flags = flags'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var metadata': (collections.Map[String, String] val | None) = None
        var flags': (Array[LobbyMemberFlag] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "metadata" => metadata' = _Metadata(value)
            | "flags" => flags' = _LobbyMemberFlags((value as I64).u64())
            end
        end

        id = id' as Snowflake
        metadata = metadata'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match flags
        | let flags': Array[LobbyMemberFlag] val =>
            obj = obj.update("flags", _LobbyMemberFlags.to_json(flags'))
        end

        obj

primitive _LobbyMembers
    fun apply(value: json.JsonValue): Array[LobbyMember] val ? =>
        """
        Decodes an array of lobby members.
        """

        let array = value as json.JsonArray
        recover val
            let members = Array[LobbyMember](array.size())
            for member in array.values() do
                members.push(LobbyMember.from_json(member as json.JsonObject)?)
            end
            members
        end

    fun to_json(members: Array[LobbyMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do
            array = array.push(member.to_json())
        end
        array

trait val LobbyMemberFlag is _Enum[LobbyMemberFlag, U8]
    """
    https://docs.discord.com/developers/resources/lobby#lobby-member-object-lobby-member-flags
    """
primitive CanLinkLobbyLobbyMemberFlag is LobbyMemberFlag
    """
    user can link a text channel to a lobby
    """

    fun value(): U8 => 0
class val UnknownLobbyMemberFlag is LobbyMemberFlag
    let _value: U8

    new val create(value': U8) =>
        _value = value'

    fun value(): U8 => _value
primitive LobbyMemberFlags
    fun from(value: U8): LobbyMemberFlag ? =>
        match value
        | 0 => CanLinkLobbyLobbyMemberFlag
        else error
        end

primitive _LobbyMemberFlags
    fun apply(bits: U64): Array[LobbyMemberFlag] val =>
        recover val
            let flags = Array[LobbyMemberFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    flags.push(
                        try
                            LobbyMemberFlags.from(shift)?
                        else
                            UnknownLobbyMemberFlag(shift)
                        end
                    )
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[LobbyMemberFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do
            bits = bits or (U64(1) << flag.value().u64())
        end
        bits.i64()

primitive _Metadata
    fun apply(
        value: json.JsonValue
    ): (collections.Map[String, String] val | None) =>
        """
        Decodes a dictionary of string key/value pairs.
        """

        match value
        | let obj: json.JsonObject =>
            recover val
                let map = collections.Map[String, String](obj.size())
                for (key, value') in obj.pairs() do
                    match value' | let string: String => map(key) = string end
                end
                map
            end
        end

    fun to_json(map: collections.Map[String, String] box): json.JsonObject =>
        var obj = json.JsonObject
        for (key, value) in map.pairs() do obj = obj.update(key, value) end
        obj

class val LobbyMessage is Jsonable
    """
    https://docs.discord.com/developers/resources/lobby#lobby-message-object
    """

    let id: Snowflake
        """
        id of the message
        """

    let type': MessageType
        """
        message type
        """

    let content: String
        """
        message content
        """

    let lobby_id: Snowflake
        """
        id of the lobby this message was sent to
        """

    let channel_id: Snowflake
        """
        included for compatibility with the messages interface; equal to
        `lobby_id`
        """

    let author: User
        """
        the user who sent the message
        """

    let lobby_member: (LobbyMessageMember | None)
        """
        the author's lobby member additional display name, captured when the
        message was sent

        Omitted if the author had no `additional_name` set.
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        dispatch-only metadata sent with the message
        """

    let moderation_metadata: (collections.Map[String, String] val | None)
        """
        moderation metadata set via Update Lobby Message Moderation Metadata
        """

    let flags: Array[MessageFlag] val
        """
        message flags
        """

    let application_id: Snowflake
        """
        the application that sent the message
        """

    new val create(
        id': Snowflake,
        type'': MessageType,
        content': String,
        lobby_id': Snowflake,
        channel_id': Snowflake,
        author': User,
        lobby_member': (LobbyMessageMember | None) = None,
        metadata': (collections.Map[String, String] val | None) = None,
        moderation_metadata': (collections.Map[String, String] val | None) =
            None,
        flags': Array[MessageFlag] val,
        application_id': Snowflake
    ) =>
        id = id'
        type' = type''
        content = content'
        lobby_id = lobby_id'
        channel_id = channel_id'
        author = author'
        lobby_member = lobby_member'
        metadata = metadata'
        moderation_metadata = moderation_metadata'
        flags = flags'
        application_id = application_id'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (MessageType | None) = None
        var content': (String | None) = None
        var lobby_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var author': (User | None) = None
        var lobby_member': (LobbyMessageMember | None) = None
        var metadata': (collections.Map[String, String] val | None) = None
        var moderation_metadata': (collections.Map[String, String] val | None) =
            None
        var flags': (Array[MessageFlag] val | None) = None
        var application_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = MessageTypes.from((value as I64).u8())?
            | "content" => content' = value as String
            | "lobby_id" => lobby_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "author" => author' = User.from_json(value as json.JsonObject)?
            | "lobby_member" =>
                lobby_member' =
                    LobbyMessageMember.from_json(value as json.JsonObject)?
            | "metadata" => metadata' = _Metadata(value)
            | "moderation_metadata" => moderation_metadata' = _Metadata(value)
            | "flags" => flags' = _MessageFlags((value as I64).u64())
            | "application_id" => application_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        type' = type'' as MessageType
        content = content' as String
        lobby_id = lobby_id' as Snowflake
        channel_id = channel_id' as Snowflake
        author = author' as User
        lobby_member = lobby_member'
        metadata = metadata'
        moderation_metadata = moderation_metadata'
        flags = flags' as Array[MessageFlag] val
        application_id = application_id' as Snowflake

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("content", content)
            .update("lobby_id", lobby_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("author", author.to_json())
            .update("flags", _MessageFlags.to_json(flags))
            .update("application_id", application_id.to_json())

        match lobby_member
        | let lobby_member': LobbyMessageMember =>
            obj = obj.update("lobby_member", lobby_member'.to_json())
        end

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match moderation_metadata
        | let moderation_metadata': collections.Map[String, String] val =>
            obj =
                obj.update(
                    "moderation_metadata",
                    _Metadata.to_json(moderation_metadata')
                )
        end

        obj

class val LobbyMessageMember is Jsonable
    """
    https://docs.discord.com/developers/resources/lobby#lobby-message-object

    The slice of the author's lobby member the message carries.
    """

    let additional_name: String
        """
        the author's lobby member additional display name, captured when the
        message was sent
        """

    new val create(additional_name': String) =>
        additional_name = additional_name'

    new val from_json(obj: json.JsonObject) ? =>
        var additional_name': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "additional_name" => additional_name' = value as String
            end
        end

        additional_name = additional_name' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("additional_name", additional_name)

primitive _LobbyMessages
    fun apply(value: json.JsonValue): Array[LobbyMessage] val ? =>
        """
        Decodes an array of lobby messages.
        """

        let array = value as json.JsonArray
        recover val
            let messages = Array[LobbyMessage](array.size())
            for message in array.values() do
                messages.push(
                    LobbyMessage.from_json(message as json.JsonObject)?
                )
            end
            messages
        end

    fun to_json(messages: Array[LobbyMessage] val): json.JsonArray =>
        var array = json.JsonArray
        for message in messages.values() do
            array = array.push(message.to_json())
        end
        array

class val LobbyInvite is Jsonable
    """
    https://docs.discord.com/developers/resources/lobby#lobby-invite-object
    """

    let code: String
        """
        the invite code for the lobby's linked channel
        """

    new val create(code': String) =>
        code = code'

    new val from_json(obj: json.JsonObject) ? =>
        var code': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "code" => code' = value as String
            end
        end

        code = code' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("code", code)

class val CreateLobbyParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#create-lobby-json-params

    All parameters to this endpoint are optional.
    """

    let metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let members: (Array[LobbyMemberParams] val | None)
        """
        optional array of up to 25 users to be added to the lobby
        """

    let idle_timeout_seconds: (USize | None)
        """
        seconds to wait before shutting down a lobby after it becomes idle.
        Value can be between 5 and 604800 (7 days).
        """

    new val create(
        metadata': (collections.Map[String, String] val | None) = None,
        members': (Array[LobbyMemberParams] val | None) = None,
        idle_timeout_seconds': (USize | None) = None
    ) =>
        metadata = metadata'
        members = members'
        idle_timeout_seconds = idle_timeout_seconds'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match members
        | let members': Array[LobbyMemberParams] val =>
            obj = obj.update("members", _LobbyMemberParams.to_json(members'))
        end

        match idle_timeout_seconds
        | let idle_timeout_seconds': USize =>
            obj =
                obj.update("idle_timeout_seconds", idle_timeout_seconds'.i64())
        end

        obj

class val LobbyMemberParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#create-lobby-lobby-member-params

    A member to seed a lobby with.
    """

    let id: Snowflake
        """
        the id of the user
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let flags: (Array[LobbyMemberFlag] val | None)
        """
        lobby member flags combined as a bitfield
        """

    new val create(
        id': Snowflake,
        metadata': (collections.Map[String, String] val | None) = None,
        flags': (Array[LobbyMemberFlag] val | None) = None
    ) =>
        id = id'
        metadata = metadata'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("id", id.to_json())

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match flags
        | let flags': Array[LobbyMemberFlag] val =>
            obj = obj.update("flags", _LobbyMemberFlags.to_json(flags'))
        end

        obj

primitive _LobbyMemberParams
    fun to_json(members: Array[LobbyMemberParams] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do
            array = array.push(member.to_json())
        end
        array

class val CreateOrJoinLobbyParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#create-or-join-lobby-json-params

    Adds the current user to a lobby matching the given secret, creating the
    lobby if one does not already exist.
    """

    let secret: String
        """
        the secret to use for the lobby (1-250 characters)
        """

    let lobby_metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let member_metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let idle_timeout_seconds: (USize | None)
        """
        seconds to wait before shutting down a lobby after it becomes idle.
        Value can be between 5 and 604800 (7 days).
        """

    new val create(
        secret': String,
        lobby_metadata': (collections.Map[String, String] val | None) = None,
        member_metadata': (collections.Map[String, String] val | None) = None,
        idle_timeout_seconds': (USize | None) = None
    ) =>
        secret = secret'
        lobby_metadata = lobby_metadata'
        member_metadata = member_metadata'
        idle_timeout_seconds = idle_timeout_seconds'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("secret", secret)

        match lobby_metadata
        | let lobby_metadata': collections.Map[String, String] val =>
            obj =
                obj.update("lobby_metadata", _Metadata.to_json(lobby_metadata'))
        end

        match member_metadata
        | let member_metadata': collections.Map[String, String] val =>
            obj =
                obj.update(
                    "member_metadata", _Metadata.to_json(member_metadata')
                )
        end

        match idle_timeout_seconds
        | let idle_timeout_seconds': USize =>
            obj =
                obj.update("idle_timeout_seconds", idle_timeout_seconds'.i64())
        end

        obj

class val UpdateLobbyParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#modify-lobby-json-params

    All parameters to this endpoint are optional. Any parameters that are not
    provided will be reset.
    """

    let metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let members: (Array[LobbyMemberParams] val | None)
        """
        optional array of up to 25 users to be added to the lobby
        """

    let idle_timeout_seconds: (USize | None)
        """
        seconds to wait before shutting down a lobby after it becomes idle.
        Value can be between 5 and 604800 (7 days).
        """

    new val create(
        metadata': (collections.Map[String, String] val | None) = None,
        members': (Array[LobbyMemberParams] val | None) = None,
        idle_timeout_seconds': (USize | None) = None
    ) =>
        metadata = metadata'
        members = members'
        idle_timeout_seconds = idle_timeout_seconds'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match members
        | let members': Array[LobbyMemberParams] val =>
            obj = obj.update("members", _LobbyMemberParams.to_json(members'))
        end

        match idle_timeout_seconds
        | let idle_timeout_seconds': USize =>
            obj =
                obj.update("idle_timeout_seconds", idle_timeout_seconds'.i64())
        end

        obj

class val AddLobbyMemberParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#add-a-member-to-a-lobby-json-params
    """

    let metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let flags: (Array[LobbyMemberFlag] val | None)
        """
        lobby member flags combined as a bitfield
        """

    new val create(
        metadata': (collections.Map[String, String] val | None) = None,
        flags': (Array[LobbyMemberFlag] val | None) = None
    ) =>
        metadata = metadata'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match flags
        | let flags': Array[LobbyMemberFlag] val =>
            obj = obj.update("flags", _LobbyMemberFlags.to_json(flags'))
        end

        obj

class val BulkUpdateLobbyMembersParams is ToJsonableArray
    """
    https://docs.discord.com/developers/resources/lobby#bulk-update-lobby-members

    This endpoint takes a JSON array of lobby member params, replacing the
    lobby's membership with the supplied set.
    """

    let members: Array[LobbyMemberParams] val
        """
        the members the lobby should end up with (max 25)
        """

    new val create(members': Array[LobbyMemberParams] val) =>
        members = members'

    fun to_json(): json.JsonArray =>
        _LobbyMemberParams.to_json(members)

class val LinkChannelToLobbyParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#link-channel-to-lobby-json-params
    """

    let channel_id: (Snowflake | None)
        """
        the id of the channel to link to the lobby. If not provided, will unlink
        any currently linked channels from the lobby.
        """

    new val create(channel_id': (Snowflake | None) = None) =>
        channel_id = channel_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        end

        obj

class val SendLobbyMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#send-lobby-message-json-params

    At least one of `content` or `embeds` must be provided.
    """

    let content: (String | None)
        """
        Message contents (up to 2000 characters)
        """

    let metadata: (collections.Map[String, String] val | None)
        """
        optional dictionary of string key/value pairs. The max total length is
        1000.
        """

    let allowed_mentions: (AllowedMentions | None)
        """
        Allowed mentions for the message
        """

    let flags: (Array[MessageFlag] val | None)
        """
        Message flags combined as a bitfield
        """

    new val create(
        content': (String | None) = None,
        metadata': (collections.Map[String, String] val | None) = None,
        allowed_mentions': (AllowedMentions | None) = AllowedMentions.none(),
        flags': (Array[MessageFlag] val | None) = None
    ) =>
        content = content'
        metadata = metadata'
        allowed_mentions = allowed_mentions'
        flags = flags'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        end

        match metadata
        | let metadata': collections.Map[String, String] val =>
            obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions =>
            obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        end

        match flags
        | let flags': Array[MessageFlag] val =>
            obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        obj

class val GetLobbyMessagesParams
    """
    https://docs.discord.com/developers/resources/lobby#get-lobby-messages-query-string-params
    """

    let limit: (USize | None)
        """
        max number of messages to return (1-100)
        """

    new val create(limit': (USize | None) = None) =>
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query

class val UpdateLobbyMessageModerationMetadataParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/lobby#update-lobby-message-moderation-metadata-json-params
    """

    let metadata: collections.Map[String, String] val
        """
        dictionary of string key/value pairs. The max total length is 1000.
        """

    new val create(metadata': collections.Map[String, String] val) =>
        metadata = metadata'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("metadata", _Metadata.to_json(metadata))
