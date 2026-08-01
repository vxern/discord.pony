use collections = "collections"
use json = "json"

class val StageInstance
    """
    https://docs.discord.com/developers/resources/stage-instance#stage-instance-object-stage-instance-structure

    A Stage Instance holds information about a live stage.

    Definitions

        Liveness: A Stage channel is considered live when there is an associated stage instance. Conversely, a Stage channel is not live when there is no associated stage instance.

        Speakers: A participant of a Stage channel is a speaker when they are not server muted, and do not have the suppress flag set on their voice state.

        Topic: The blurb that gets shown below the channel's name, among other places.
    """

    let id: Snowflake
        """
        The id of this Stage instance
        """

    let guild_id: Snowflake
        """
        The guild id of the associated Stage channel
        """

    let channel_id: Snowflake
        """
        The id of the associated Stage channel
        """

    let topic: String
        """
        The topic of the Stage instance (1-120 characters)
        """

    let privacy_level: StageInstancePrivacyLevel
        """
        The privacy level of the Stage instance
        """

    let discoverable_disabled: Bool
        """
        Whether or not Stage Discovery is disabled (deprecated)
        """

    let guild_scheduled_event_id: (Snowflake | None)
        """
        The id of the scheduled event for this Stage instance
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var topic': (String | None) = None
        var privacy_level': (StageInstancePrivacyLevel | None) = None
        var discoverable_disabled': (Bool | None) = None
        var guild_scheduled_event_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "topic" => topic' = value as String
            | "privacy_level" => privacy_level' = StageInstancePrivacyLevels.from((value as I64).u8())?
            | "discoverable_disabled" => discoverable_disabled' = value as Bool
            | "guild_scheduled_event_id" =>
                match value | let string: String => guild_scheduled_event_id' = Snowflake.from_json(string)? end
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        channel_id = channel_id' as Snowflake
        topic = topic' as String
        privacy_level = privacy_level' as StageInstancePrivacyLevel
        discoverable_disabled = discoverable_disabled' as Bool
        guild_scheduled_event_id = guild_scheduled_event_id'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("channel_id", channel_id.to_json())
            .update("topic", topic)
            .update("privacy_level", privacy_level.value().i64())
            .update("discoverable_disabled", discoverable_disabled)
            .update("guild_scheduled_event_id", match guild_scheduled_event_id | let guild_scheduled_event_id': Snowflake => guild_scheduled_event_id'.to_json() end)

trait val StageInstancePrivacyLevel is (collections.Hashable & Equatable[StageInstancePrivacyLevel])
    """
    https://docs.discord.com/developers/resources/stage-instance#stage-instance-object-privacy-level
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: StageInstancePrivacyLevel): Bool => value() == that.value()
primitive PublicStageInstancePrivacyLevel is StageInstancePrivacyLevel
    """
    The Stage instance is visible publicly. (deprecated)
    """

    fun value(): U8 => 1
primitive GuildOnlyStageInstancePrivacyLevel is StageInstancePrivacyLevel
    """
    The Stage instance is visible to only guild members.
    """

    fun value(): U8 => 2
primitive StageInstancePrivacyLevels
    fun from(value: U8): StageInstancePrivacyLevel ? =>
        match value
        | 1 => PublicStageInstancePrivacyLevel
        | 2 => GuildOnlyStageInstancePrivacyLevel
        else error
        end
