use collections = "collections"
use json = "json"

class val Lobby
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

    let metadata: (collections.Map[String, String] | None)
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

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var metadata': (collections.Map[String, String] | None) = None
        var members': (Array[LobbyMember] val | None) = None
        var linked_channel': (Channel | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "metadata" => metadata' = _Metadata(value)
            | "members" => members' = _LobbyMembers(value)?
            | "linked_channel" => linked_channel' = Channel.from_json(value as json.JsonObject)?
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
        | let metadata': collections.Map[String, String] box => obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match linked_channel
        | let linked_channel': Channel => obj = obj.update("linked_channel", linked_channel'.to_json())
        end

        obj

class val LobbyMember
    """
    https://docs.discord.com/developers/resources/lobby#lobby-member-object

    Represents a member of a lobby, including optional metadata and flags.
    """

    let id: Snowflake
        """
        the id of the user
        """

    let metadata: (collections.Map[String, String] | None)
        """
        dictionary of string key/value pairs. The max total length is 1000.
        """

    let flags: (Array[LobbyMemberFlag] val | None)
        """
        lobby member flags combined as a bitfield
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var metadata': (collections.Map[String, String] | None) = None
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
        | let metadata': collections.Map[String, String] box => obj = obj.update("metadata", _Metadata.to_json(metadata'))
        end

        match flags
        | let flags': Array[LobbyMemberFlag] val => obj = obj.update("flags", _LobbyMemberFlags.to_json(flags'))
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
            for member in array.values() do members.push(LobbyMember.from_json(member as json.JsonObject)?) end
            members
        end

    fun to_json(members: Array[LobbyMember] val): json.JsonArray =>
        var array = json.JsonArray
        for member in members.values() do array = array.push(member.to_json()) end
        array

trait val LobbyMemberFlag is (collections.Hashable & Equatable[LobbyMemberFlag])
    """
    https://docs.discord.com/developers/resources/lobby#lobby-member-object-lobby-member-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: LobbyMemberFlag): Bool => value() == that.value()
primitive CanLinkLobbyLobbyMemberFlag is LobbyMemberFlag
    """
    user can link a text channel to a lobby
    """

    fun value(): U8 => 0
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
                    try flags.push(LobbyMemberFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[LobbyMemberFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()

primitive _Metadata
    fun apply(value: json.JsonValue): (collections.Map[String, String] | None) =>
        """
        Decodes a dictionary of string key/value pairs.
        """

        match value
        | let obj: json.JsonObject =>
            let map = collections.Map[String, String](obj.size())
            for (key, value') in obj.pairs() do
                match value' | let string: String => map(key) = string end
            end
            map
        end

    fun to_json(map: collections.Map[String, String] box): json.JsonObject =>
        var obj = json.JsonObject
        for (key, value) in map.pairs() do obj = obj.update(key, value) end
        obj
