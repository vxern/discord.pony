use json = "json"
use collections = "collections"

class val GuildScheduledEvent is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-structure

    A representation of a scheduled event in a guild.
    """

    let id: Snowflake
        """
        the id of the scheduled event
        """

    let guild_id: Snowflake
        """
        the guild id which the scheduled event belongs to
        """

    let channel_id: (Snowflake | None)
        """
        the channel id in which the scheduled event will be hosted, or null if
        scheduled entity type is EXTERNAL
        """

    let creator_id: (Snowflake | None)
        """
        the id of the user that created the scheduled event
        """

    let name: String
        """
        the name of the scheduled event (1-100 characters)
        """

    let description: (String | None)
        """
        the description of the scheduled event (1-1000 characters)
        """

    let scheduled_start_time: ISO8601
        """
        the time the scheduled event will start
        """

    let scheduled_end_time: (ISO8601 | None)
        """
        the time the scheduled event will end, required if entity_type is
        EXTERNAL
        """

    let privacy_level: GuildScheduledEventPrivacyLevel
        """
        the privacy level of the scheduled event
        """

    let status: GuildScheduledEventStatus
        """
        the status of the scheduled event
        """

    let entity_type: GuildScheduledEventEntityType
        """
        the type of the scheduled event
        """

    let entity_id: (Snowflake | None)
        """
        the id of an entity associated with a guild scheduled event
        """

    let entity_metadata: (GuildScheduledEventEntityMetadata | None)
        """
        additional metadata for the guild scheduled event
        """

    let creator: (User | None)
        """
        the user that created the scheduled event
        """

    let user_count: (USize | None)
        """
        the number of users subscribed to the scheduled event
        """

    let image: (String | None)
        """
        the cover image hash of the scheduled event
        """

    let recurrence_rule: (GuildScheduledEventRecurrenceRule | None)
        """
        the definition for how often this event should recur
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        channel_id': (Snowflake | None) = None,
        creator_id': (Snowflake | None) = None,
        name': String,
        description': (String | None) = None,
        scheduled_start_time': ISO8601,
        scheduled_end_time': (ISO8601 | None) = None,
        privacy_level': GuildScheduledEventPrivacyLevel,
        status': GuildScheduledEventStatus,
        entity_type': GuildScheduledEventEntityType,
        entity_id': (Snowflake | None) = None,
        entity_metadata': (GuildScheduledEventEntityMetadata | None) = None,
        creator': (User | None) = None,
        user_count': (USize | None) = None,
        image': (String | None) = None,
        recurrence_rule': (GuildScheduledEventRecurrenceRule | None) = None
    ) =>
        id = id'
        guild_id = guild_id'
        channel_id = channel_id'
        creator_id = creator_id'
        name = name'
        description = description'
        scheduled_start_time = scheduled_start_time'
        scheduled_end_time = scheduled_end_time'
        privacy_level = privacy_level'
        status = status'
        entity_type = entity_type'
        entity_id = entity_id'
        entity_metadata = entity_metadata'
        creator = creator'
        user_count = user_count'
        image = image'
        recurrence_rule = recurrence_rule'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var creator_id': (Snowflake | None) = None
        var name': (String | None) = None
        var description': (String | None) = None
        var scheduled_start_time': (ISO8601 | None) = None
        var scheduled_end_time': (ISO8601 | None) = None
        var privacy_level': (GuildScheduledEventPrivacyLevel | None) = None
        var status': (GuildScheduledEventStatus | None) = None
        var entity_type': (GuildScheduledEventEntityType | None) = None
        var entity_id': (Snowflake | None) = None
        var entity_metadata': (GuildScheduledEventEntityMetadata | None) = None
        var creator': (User | None) = None
        var user_count': (USize | None) = None
        var image': (String | None) = None
        var recurrence_rule': (GuildScheduledEventRecurrenceRule | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" =>
                match value
                | let string: String =>
                    channel_id' = Snowflake.from_json(string)?
                end
            | "creator_id" =>
                match value
                | let string: String =>
                    creator_id' = Snowflake.from_json(string)?
                end
            | "name" => name' = value as String
            | "description" =>
                match value | let string: String => description' = string end
            | "scheduled_start_time" => scheduled_start_time' = value as String
            | "scheduled_end_time" =>
                match value
                | let string: String => scheduled_end_time' = string
                end
            | "privacy_level" =>
                privacy_level' =
                    GuildScheduledEventPrivacyLevels.from((value as I64).u8())?
            | "status" =>
                status' = GuildScheduledEventStatuses.from((value as I64).u8())?
            | "entity_type" =>
                entity_type' =
                    GuildScheduledEventEntityTypes.from((value as I64).u8())?
            | "entity_id" =>
                match value
                | let string: String =>
                    entity_id' = Snowflake.from_json(string)?
                end
            | "entity_metadata" =>
                match value
                | let obj': json.JsonObject =>
                    entity_metadata' =
                        GuildScheduledEventEntityMetadata.from_json(obj')?
                end
            | "creator" => creator' = User.from_json(value as json.JsonObject)?
            | "user_count" => user_count' = (value as I64).usize()
            | "image" =>
                match value | let string: String => image' = string end
            | "recurrence_rule" =>
                match value
                | let obj': json.JsonObject =>
                    recurrence_rule' =
                        GuildScheduledEventRecurrenceRule.from_json(obj')?
                end
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        channel_id = channel_id'
        creator_id = creator_id'
        name = name' as String
        description = description'
        scheduled_start_time = scheduled_start_time' as ISO8601
        scheduled_end_time = scheduled_end_time'
        privacy_level = privacy_level' as GuildScheduledEventPrivacyLevel
        status = status' as GuildScheduledEventStatus
        entity_type = entity_type' as GuildScheduledEventEntityType
        entity_id = entity_id'
        entity_metadata = entity_metadata'
        creator = creator'
        user_count = user_count'
        image = image'
        recurrence_rule = recurrence_rule'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update(
                "channel_id",
                match channel_id
                | let channel_id': Snowflake => channel_id'.to_json()
                end
            )
            .update("name", name)
            .update("scheduled_start_time", scheduled_start_time)
            .update("scheduled_end_time", scheduled_end_time)
            .update("privacy_level", privacy_level.value().i64())
            .update("status", status.value().i64())
            .update("entity_type", entity_type.value().i64())
            .update(
                "entity_id",
                match entity_id
                | let entity_id': Snowflake => entity_id'.to_json()
                end
            )
            .update(
                "entity_metadata",
                match entity_metadata
                | let entity_metadata': GuildScheduledEventEntityMetadata =>
                    entity_metadata'.to_json()
                end
            )
            .update(
                "recurrence_rule",
                match recurrence_rule
                | let recurrence_rule': GuildScheduledEventRecurrenceRule =>
                    recurrence_rule'.to_json()
                end
            )

        match creator_id
        | let creator_id': Snowflake =>
            obj = obj.update("creator_id", creator_id'.to_json())
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        end

        match creator
        | let creator': User => obj = obj.update("creator", creator'.to_json())
        end

        match user_count
        | let user_count': USize =>
            obj = obj.update("user_count", user_count'.i64())
        end

        match image
        | let image': String => obj = obj.update("image", image')
        end

        obj

primitive _GuildScheduledEvents
    fun apply(value: json.JsonValue): Array[GuildScheduledEvent] val ? =>
        """
        Decodes an array of guild scheduled events.
        """

        let array = value as json.JsonArray
        recover val
            let guild_scheduled_events =
                Array[GuildScheduledEvent](array.size())
            for guild_scheduled_event in array.values() do
                guild_scheduled_events.push(
                    GuildScheduledEvent.from_json(
                        guild_scheduled_event as json.JsonObject
                    )?
                )
            end
            guild_scheduled_events
        end

    fun to_json(
        guild_scheduled_events: Array[GuildScheduledEvent] val
    ): json.JsonArray =>
        var array = json.JsonArray
        for guild_scheduled_event in guild_scheduled_events.values() do
            array = array.push(guild_scheduled_event.to_json())
        end
        array

trait val GuildScheduledEventPrivacyLevel is _Enum[
    GuildScheduledEventPrivacyLevel, U8
]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-privacy-level
    """
primitive GuildOnlyGuildScheduledEventPrivacyLevel is
    GuildScheduledEventPrivacyLevel
    """
    the scheduled event is only accessible to guild members
    """

    fun value(): U8 => 2
primitive GuildScheduledEventPrivacyLevels
    fun from(value: U8): GuildScheduledEventPrivacyLevel ? =>
        match value
        | 2 => GuildOnlyGuildScheduledEventPrivacyLevel
        else error
        end

trait val GuildScheduledEventEntityType is _Enum[
    GuildScheduledEventEntityType, U8
]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-entity-types
    """
primitive StageInstanceGuildScheduledEventEntityType is
    GuildScheduledEventEntityType
    """
    the scheduled event is hosted in a stage channel

    Requires `channel_id`. `entity_metadata` must be null and
    `scheduled_end_time` is optional.
    """

    fun value(): U8 => 1
primitive VoiceGuildScheduledEventEntityType is GuildScheduledEventEntityType
    """
    the scheduled event is hosted in a voice channel

    Requires `channel_id`. `entity_metadata` must be null and
    `scheduled_end_time` is optional.
    """

    fun value(): U8 => 2
primitive ExternalGuildScheduledEventEntityType is GuildScheduledEventEntityType
    """
    the scheduled event is hosted externally to Discord

    `channel_id` must be null, and `entity_metadata` and `scheduled_end_time`
    are both required.
    """

    fun value(): U8 => 3
primitive GuildScheduledEventEntityTypes
    fun from(value: U8): GuildScheduledEventEntityType ? =>
        match value
        | 1 => StageInstanceGuildScheduledEventEntityType
        | 2 => VoiceGuildScheduledEventEntityType
        | 3 => ExternalGuildScheduledEventEntityType
        else error
        end

trait val GuildScheduledEventStatus is _Enum[GuildScheduledEventStatus, U8]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-status

    Once `status` is set to COMPLETED or CANCELED, the `status` can no longer be
    updated.
    """
primitive ScheduledGuildScheduledEventStatus is GuildScheduledEventStatus
    fun value(): U8 => 1
primitive ActiveGuildScheduledEventStatus is GuildScheduledEventStatus
    fun value(): U8 => 2
primitive CompletedGuildScheduledEventStatus is GuildScheduledEventStatus
    fun value(): U8 => 3
primitive CanceledGuildScheduledEventStatus is GuildScheduledEventStatus
    fun value(): U8 => 4
primitive GuildScheduledEventStatuses
    fun from(value: U8): GuildScheduledEventStatus ? =>
        match value
        | 1 => ScheduledGuildScheduledEventStatus
        | 2 => ActiveGuildScheduledEventStatus
        | 3 => CompletedGuildScheduledEventStatus
        | 4 => CanceledGuildScheduledEventStatus
        else error
        end

class val GuildScheduledEventEntityMetadata is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-object-guild-scheduled-event-entity-metadata

    Additional metadata for the guild scheduled event.
    """

    let location: (String | None)
        """
        location of the event (1-100 characters)

        Required for events with an `entity_type` of EXTERNAL.
        """

    new val create(location': (String | None) = None) =>
        location = location'

    new val from_json(obj: json.JsonObject) ? =>
        var location': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "location" => location' = value as String
            end
        end

        location = location'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match location
        | let location': String => obj = obj.update("location", location')
        end

        obj

class val GuildScheduledEventRecurrenceRule is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-recurrence-rule-object-guild-scheduled-event-recurrence-rule-structure

    Discord's recurrence rule is a subset of the behaviors defined in the
    iCalendar RFC and implemented by python's dateutil rrule.

    There are currently many limitations on what you can set. These are
    documented alongside the individual fields.
    """

    let start: ISO8601
        """
        Starting time of the recurrence interval
        """

    let end': (ISO8601 | None)
        """
        Ending time of the recurrence interval
        """

    let frequency: GuildScheduledEventRecurrenceRuleFrequency
        """
        How often the event occurs
        """

    let interval: USize
        """
        The spacing between the events, defined by `frequency`. For example,
        `frequency` of WEEKLY and an `interval` of 2 would be "every-other week"
        """

    let by_weekday: (Array[GuildScheduledEventRecurrenceRuleWeekday] val | None)
        """
        Set of specific days within a week for the event to recur on
        """

    let by_n_weekday: (
        Array[GuildScheduledEventRecurrenceRuleNWeekday] val | None
    )
        """
        List of specific days within a specific week (1-5) to recur on
        """

    let by_month: (Array[GuildScheduledEventRecurrenceRuleMonth] val | None)
        """
        Set of specific months to recur on
        """

    let by_month_day: (Array[USize] val | None)
        """
        Set of specific dates within a month to recur on
        """

    let by_year_day: (Array[USize] val | None)
        """
        Set of days within a year to recur on (1-364)
        """

    let count: (USize | None)
        """
        The total amount of times that the event is allowed to recur before
        stopping
        """

    new val create(
        start': ISO8601,
        end'': (ISO8601 | None) = None,
        frequency': GuildScheduledEventRecurrenceRuleFrequency,
        interval': USize,
        by_weekday': (
            Array[GuildScheduledEventRecurrenceRuleWeekday] val | None
        ) =
            None,
        by_n_weekday': (
            Array[GuildScheduledEventRecurrenceRuleNWeekday] val | None
        ) =
            None,
        by_month': (Array[GuildScheduledEventRecurrenceRuleMonth] val | None) =
            None,
        by_month_day': (Array[USize] val | None) = None,
        by_year_day': (Array[USize] val | None) = None,
        count': (USize | None) = None
    ) =>
        start = start'
        end' = end''
        frequency = frequency'
        interval = interval'
        by_weekday = by_weekday'
        by_n_weekday = by_n_weekday'
        by_month = by_month'
        by_month_day = by_month_day'
        by_year_day = by_year_day'
        count = count'

    new val from_json(obj: json.JsonObject) ? =>
        var start': (ISO8601 | None) = None
        var end'': (ISO8601 | None) = None
        var frequency': (GuildScheduledEventRecurrenceRuleFrequency | None) =
            None
        var interval': (USize | None) = None
        var by_weekday': (
            Array[GuildScheduledEventRecurrenceRuleWeekday] val | None
        ) =
            None
        var by_n_weekday': (
            Array[GuildScheduledEventRecurrenceRuleNWeekday] val | None
        ) =
            None
        var by_month': (
            Array[GuildScheduledEventRecurrenceRuleMonth] val | None
        ) =
            None
        var by_month_day': (Array[USize] val | None) = None
        var by_year_day': (Array[USize] val | None) = None
        var count': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "start" => start' = value as String
            | "end" =>
                match value | let string: String => end'' = string end
            | "frequency" =>
                frequency' =
                    GuildScheduledEventRecurrenceRuleFrequencies.from(
                        (value as I64).u8()
                    )?
            | "interval" => interval' = (value as I64).usize()
            | "by_weekday" =>
                match value
                | let array: json.JsonArray =>
                    by_weekday' =
                        _GuildScheduledEventRecurrenceRuleWeekdays(array)?
                end
            | "by_n_weekday" =>
                match value
                | let array: json.JsonArray =>
                    by_n_weekday' =
                        _GuildScheduledEventRecurrenceRuleNWeekdays(array)?
                end
            | "by_month" =>
                match value
                | let array: json.JsonArray =>
                    by_month' = _GuildScheduledEventRecurrenceRuleMonths(array)?
                end
            | "by_month_day" =>
                match value
                | let array: json.JsonArray => by_month_day' = _USizes(array)?
                end
            | "by_year_day" =>
                match value
                | let array: json.JsonArray => by_year_day' = _USizes(array)?
                end
            | "count" =>
                match value | let integer: I64 => count' = integer.usize() end
            end
        end

        start = start' as ISO8601
        end' = end''
        frequency = frequency' as GuildScheduledEventRecurrenceRuleFrequency
        interval = interval' as USize
        by_weekday = by_weekday'
        by_n_weekday = by_n_weekday'
        by_month = by_month'
        by_month_day = by_month_day'
        by_year_day = by_year_day'
        count = count'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("start", start)
            .update("end", end')
            .update("frequency", frequency.value().i64())
            .update("interval", interval.i64())
            .update(
                "by_weekday",
                match by_weekday
                | let by_weekday': Array[
                    GuildScheduledEventRecurrenceRuleWeekday
                ] val =>
                    _GuildScheduledEventRecurrenceRuleWeekdays.to_json(
                        by_weekday'
                    )
                end
            )
            .update(
                "by_n_weekday",
                match by_n_weekday
                | let by_n_weekday': Array[
                    GuildScheduledEventRecurrenceRuleNWeekday
                ] val =>
                    _GuildScheduledEventRecurrenceRuleNWeekdays.to_json(
                        by_n_weekday'
                    )
                end
            )
            .update(
                "by_month",
                match by_month
                | let by_month': Array[
                    GuildScheduledEventRecurrenceRuleMonth
                ] val =>
                    _GuildScheduledEventRecurrenceRuleMonths.to_json(by_month')
                end
            )
            .update(
                "by_month_day",
                match by_month_day
                | let by_month_day': Array[USize] val =>
                    _USizes.to_json(by_month_day')
                end
            )
            .update(
                "by_year_day",
                match by_year_day
                | let by_year_day': Array[USize] val =>
                    _USizes.to_json(by_year_day')
                end
            )
            .update(
                "count", match count | let count': USize => count'.i64() end
            )

        obj

trait val GuildScheduledEventRecurrenceRuleFrequency is _Enum[
    GuildScheduledEventRecurrenceRuleFrequency, U8
]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-recurrence-rule-object-guild-scheduled-event-recurrence-rule-frequency
    """
primitive YearlyGuildScheduledEventRecurrenceRuleFrequency is
    GuildScheduledEventRecurrenceRuleFrequency
    fun value(): U8 => 0
primitive MonthlyGuildScheduledEventRecurrenceRuleFrequency is
    GuildScheduledEventRecurrenceRuleFrequency
    fun value(): U8 => 1
primitive WeeklyGuildScheduledEventRecurrenceRuleFrequency is
    GuildScheduledEventRecurrenceRuleFrequency
    fun value(): U8 => 2
primitive DailyGuildScheduledEventRecurrenceRuleFrequency is
    GuildScheduledEventRecurrenceRuleFrequency
    fun value(): U8 => 3
primitive GuildScheduledEventRecurrenceRuleFrequencies
    fun from(value: U8): GuildScheduledEventRecurrenceRuleFrequency ? =>
        match value
        | 0 => YearlyGuildScheduledEventRecurrenceRuleFrequency
        | 1 => MonthlyGuildScheduledEventRecurrenceRuleFrequency
        | 2 => WeeklyGuildScheduledEventRecurrenceRuleFrequency
        | 3 => DailyGuildScheduledEventRecurrenceRuleFrequency
        else error
        end

trait val GuildScheduledEventRecurrenceRuleWeekday is _Enum[
    GuildScheduledEventRecurrenceRuleWeekday, U8
]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-recurrence-rule-object-guild-scheduled-event-recurrence-rule-weekday
    """
primitive MondayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 0
primitive TuesdayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 1
primitive WednesdayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 2
primitive ThursdayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 3
primitive FridayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 4
primitive SaturdayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 5
primitive SundayGuildScheduledEventRecurrenceRuleWeekday is
    GuildScheduledEventRecurrenceRuleWeekday
    fun value(): U8 => 6
primitive GuildScheduledEventRecurrenceRuleWeekdays
    fun from(value: U8): GuildScheduledEventRecurrenceRuleWeekday ? =>
        match value
        | 0 => MondayGuildScheduledEventRecurrenceRuleWeekday
        | 1 => TuesdayGuildScheduledEventRecurrenceRuleWeekday
        | 2 => WednesdayGuildScheduledEventRecurrenceRuleWeekday
        | 3 => ThursdayGuildScheduledEventRecurrenceRuleWeekday
        | 4 => FridayGuildScheduledEventRecurrenceRuleWeekday
        | 5 => SaturdayGuildScheduledEventRecurrenceRuleWeekday
        | 6 => SundayGuildScheduledEventRecurrenceRuleWeekday
        else error
        end

primitive _GuildScheduledEventRecurrenceRuleWeekdays
    fun apply(
        array: json.JsonArray
    ): Array[GuildScheduledEventRecurrenceRuleWeekday] val ? =>
        """
        Decodes an array of weekdays.
        """

        recover val
            let weekdays =
                Array[GuildScheduledEventRecurrenceRuleWeekday](array.size())
            for weekday in array.values() do
                weekdays.push(
                    GuildScheduledEventRecurrenceRuleWeekdays.from(
                        (weekday as I64).u8()
                    )?
                )
            end
            weekdays
        end

    fun to_json(
        weekdays: Array[GuildScheduledEventRecurrenceRuleWeekday] val
    ): json.JsonArray =>
        var array = json.JsonArray
        for weekday in weekdays.values() do
            array = array.push(weekday.value().i64())
        end
        array

class val GuildScheduledEventRecurrenceRuleNWeekday is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-recurrence-rule-object-guild-scheduled-event-recurrence-rule-nweekday-structure
    """

    let n: USize
        """
        The week to reoccur on. 1 - 5
        """

    let day: GuildScheduledEventRecurrenceRuleWeekday
        """
        The day within the week to reoccur on
        """

    new val create(n': USize, day': GuildScheduledEventRecurrenceRuleWeekday) =>
        n = n'
        day = day'

    new val from_json(obj: json.JsonObject) ? =>
        var n': (USize | None) = None
        var day': (GuildScheduledEventRecurrenceRuleWeekday | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "n" => n' = (value as I64).usize()
            | "day" =>
                day' =
                    GuildScheduledEventRecurrenceRuleWeekdays.from(
                        (value as I64).u8()
                    )?
            end
        end

        n = n' as USize
        day = day' as GuildScheduledEventRecurrenceRuleWeekday

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("n", n.i64())
            .update("day", day.value().i64())

primitive _GuildScheduledEventRecurrenceRuleNWeekdays
    fun apply(
        array: json.JsonArray
    ): Array[GuildScheduledEventRecurrenceRuleNWeekday] val ? =>
        """
        Decodes an array of nweekdays.
        """

        recover val
            let nweekdays =
                Array[GuildScheduledEventRecurrenceRuleNWeekday](array.size())
            for nweekday in array.values() do
                nweekdays.push(
                    GuildScheduledEventRecurrenceRuleNWeekday.from_json(
                        nweekday as json.JsonObject
                    )?
                )
            end
            nweekdays
        end

    fun to_json(
        nweekdays: Array[GuildScheduledEventRecurrenceRuleNWeekday] val
    ): json.JsonArray =>
        var array = json.JsonArray
        for nweekday in nweekdays.values() do
            array = array.push(nweekday.to_json())
        end
        array

trait val GuildScheduledEventRecurrenceRuleMonth is _Enum[
    GuildScheduledEventRecurrenceRuleMonth, U8
]
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-recurrence-rule-object-guild-scheduled-event-recurrence-rule-month
    """
primitive JanuaryGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 1
primitive FebruaryGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 2
primitive MarchGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 3
primitive AprilGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 4
primitive MayGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 5
primitive JuneGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 6
primitive JulyGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 7
primitive AugustGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 8
primitive SeptemberGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 9
primitive OctoberGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 10
primitive NovemberGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 11
primitive DecemberGuildScheduledEventRecurrenceRuleMonth is
    GuildScheduledEventRecurrenceRuleMonth
    fun value(): U8 => 12
primitive GuildScheduledEventRecurrenceRuleMonths
    fun from(value: U8): GuildScheduledEventRecurrenceRuleMonth ? =>
        match value
        | 1 => JanuaryGuildScheduledEventRecurrenceRuleMonth
        | 2 => FebruaryGuildScheduledEventRecurrenceRuleMonth
        | 3 => MarchGuildScheduledEventRecurrenceRuleMonth
        | 4 => AprilGuildScheduledEventRecurrenceRuleMonth
        | 5 => MayGuildScheduledEventRecurrenceRuleMonth
        | 6 => JuneGuildScheduledEventRecurrenceRuleMonth
        | 7 => JulyGuildScheduledEventRecurrenceRuleMonth
        | 8 => AugustGuildScheduledEventRecurrenceRuleMonth
        | 9 => SeptemberGuildScheduledEventRecurrenceRuleMonth
        | 10 => OctoberGuildScheduledEventRecurrenceRuleMonth
        | 11 => NovemberGuildScheduledEventRecurrenceRuleMonth
        | 12 => DecemberGuildScheduledEventRecurrenceRuleMonth
        else error
        end

primitive _GuildScheduledEventRecurrenceRuleMonths
    fun apply(
        array: json.JsonArray
    ): Array[GuildScheduledEventRecurrenceRuleMonth] val ? =>
        """
        Decodes an array of months.
        """

        recover val
            let months =
                Array[GuildScheduledEventRecurrenceRuleMonth](array.size())
            for month in array.values() do
                months.push(
                    GuildScheduledEventRecurrenceRuleMonths.from(
                        (month as I64).u8()
                    )?
                )
            end
            months
        end

    fun to_json(
        months: Array[GuildScheduledEventRecurrenceRuleMonth] val
    ): json.JsonArray =>
        var array = json.JsonArray
        for month in months.values() do
            array = array.push(month.value().i64())
        end
        array

class val GuildScheduledEventUser is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-user-object-guild-scheduled-event-user-structure
    """

    let guild_scheduled_event_id: Snowflake
        """
        the scheduled event id which the user subscribed to
        """

    let user: User
        """
        user which subscribed to an event
        """

    let member: (GuildMember | None)
        """
        guild member data for this user for the guild which this event belongs
        to, if any
        """

    new val create(
        guild_scheduled_event_id': Snowflake,
        user': User,
        member': (GuildMember | None) = None
    ) =>
        guild_scheduled_event_id = guild_scheduled_event_id'
        user = user'
        member = member'

    new val from_json(obj: json.JsonObject) ? =>
        var guild_scheduled_event_id': (Snowflake | None) = None
        var user': (User | None) = None
        var member': (GuildMember | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "guild_scheduled_event_id" =>
                guild_scheduled_event_id' = Snowflake.from_json(value)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "member" =>
                member' = GuildMember.from_json(value as json.JsonObject)?
            end
        end

        guild_scheduled_event_id = guild_scheduled_event_id' as Snowflake
        user = user' as User
        member = member'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update(
                "guild_scheduled_event_id", guild_scheduled_event_id.to_json()
            )
            .update("user", user.to_json())

        match member
        | let member': GuildMember =>
            obj = obj.update("member", member'.to_json())
        end

        obj

primitive _GuildScheduledEventUsers
    fun apply(value: json.JsonValue): Array[GuildScheduledEventUser] val ? =>
        """
        Decodes an array of guild scheduled event users.
        """

        let array = value as json.JsonArray
        recover val
            let users = Array[GuildScheduledEventUser](array.size())
            for user in array.values() do
                users.push(
                    GuildScheduledEventUser.from_json(user as json.JsonObject)?
                )
            end
            users
        end

    fun to_json(users: Array[GuildScheduledEventUser] val): json.JsonArray =>
        var array = json.JsonArray
        for user in users.values() do array = array.push(user.to_json()) end
        array

primitive _USizes
    fun apply(array: json.JsonArray): Array[USize] val ? =>
        """
        Decodes an array of non-negative integers.
        """

        recover val
            let integers = Array[USize](array.size())
            for integer in array.values() do
                integers.push((integer as I64).usize())
            end
            integers
        end

    fun to_json(integers: Array[USize] val): json.JsonArray =>
        var array = json.JsonArray
        for integer in integers.values() do
            array = array.push(integer.i64())
        end
        array

class val GetGuildScheduledEventsParams
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#list-scheduled-events-for-guild-query-string-params
    """

    let with_user_count: (Bool | None)
        """
        include number of users subscribed to each event
        """

    new val create(with_user_count': (Bool | None) = None) =>
        with_user_count = with_user_count'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_user_count
        | let with_user_count': Bool =>
            query.push(("with_user_count", with_user_count'.string()))
        end

        consume query

class val CreateGuildScheduledEventParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#create-guild-scheduled-event-json-params

    A guild can have a maximum of 100 events with `SCHEDULED` or `ACTIVE` status
    at any time.
    """

    let name: String
        """
        the name of the scheduled event (1-100 characters)
        """

    let privacy_level: GuildScheduledEventPrivacyLevel
        """
        the privacy level of the scheduled event
        """

    let scheduled_start_time: ISO8601
        """
        the time the event will start
        """

    let entity_type: GuildScheduledEventEntityType
        """
        the entity type of the scheduled event
        """

    let channel_id: (Snowflake | None)
        """
        the channel id of the scheduled event

        Optional for events with an `entity_type` of `STAGE_INSTANCE` or
        `VOICE`, and must be null for events with an `entity_type` of
        `EXTERNAL`.
        """

    let entity_metadata: (GuildScheduledEventEntityMetadata | None)
        """
        the entity metadata of the scheduled event

        Required for events with an `entity_type` of `EXTERNAL`.
        """

    let scheduled_end_time: (ISO8601 | None)
        """
        the time the event will end

        Required for events with an `entity_type` of `EXTERNAL`.
        """

    let description: (String | None)
        """
        the description of the scheduled event (1-1000 characters)
        """

    let image: (ImageData | None)
        """
        the cover image of the scheduled event
        """

    let recurrence_rule: (GuildScheduledEventRecurrenceRule | None)
        """
        the definition for how often this event should recur
        """

    new val create(
        name': String,
        privacy_level': GuildScheduledEventPrivacyLevel,
        scheduled_start_time': ISO8601,
        entity_type': GuildScheduledEventEntityType,
        channel_id': (Snowflake | None) = None,
        entity_metadata': (GuildScheduledEventEntityMetadata | None) = None,
        scheduled_end_time': (ISO8601 | None) = None,
        description': (String | None) = None,
        image': (ImageData | None) = None,
        recurrence_rule': (GuildScheduledEventRecurrenceRule | None) = None
    ) =>
        name = name'
        privacy_level = privacy_level'
        scheduled_start_time = scheduled_start_time'
        entity_type = entity_type'
        channel_id = channel_id'
        entity_metadata = entity_metadata'
        scheduled_end_time = scheduled_end_time'
        description = description'
        image = image'
        recurrence_rule = recurrence_rule'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("privacy_level", privacy_level.value().i64())
            .update("scheduled_start_time", scheduled_start_time)
            .update("entity_type", entity_type.value().i64())

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        end

        match entity_metadata
        | let entity_metadata': GuildScheduledEventEntityMetadata =>
            obj = obj.update("entity_metadata", entity_metadata'.to_json())
        end

        match scheduled_end_time
        | let scheduled_end_time': ISO8601 =>
            obj = obj.update("scheduled_end_time", scheduled_end_time')
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        end

        match image
        | let image': ImageData => obj = obj.update("image", image')
        end

        match recurrence_rule
        | let recurrence_rule': GuildScheduledEventRecurrenceRule =>
            obj = obj.update("recurrence_rule", recurrence_rule'.to_json())
        end

        obj

class val GetGuildScheduledEventParams
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event-query-string-params
    """

    let with_user_count: (Bool | None)
        """
        include number of users subscribed to this event
        """

    new val create(with_user_count': (Bool | None) = None) =>
        with_user_count = with_user_count'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_user_count
        | let with_user_count': Bool =>
            query.push(("with_user_count", with_user_count'.string()))
        end

        consume query

class val UpdateGuildScheduledEventParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#modify-guild-scheduled-event-json-params

    All parameters to this endpoint are optional.

    To start or end an event, use this endpoint to modify the event's `status`
    field.
    """

    let name: (String | None)
        """
        the name of the scheduled event (1-100 characters)
        """

    let privacy_level: (GuildScheduledEventPrivacyLevel | None)
        """
        the privacy level of the scheduled event
        """

    let scheduled_start_time: (ISO8601 | None)
        """
        the time the event will start
        """

    let entity_type: (GuildScheduledEventEntityType | None)
        """
        the entity type of the scheduled event
        """

    let channel_id: Nullable[Snowflake]
        """
        the channel id of the scheduled event, set to null if changing
        `entity_type` to `EXTERNAL`
        """

    let entity_metadata: Nullable[GuildScheduledEventEntityMetadata]
        """
        the entity metadata of the scheduled event

        Required for events with an `entity_type` of `EXTERNAL`.
        """

    let scheduled_end_time: Nullable[ISO8601]
        """
        the time the event will end

        Required for events with an `entity_type` of `EXTERNAL`.
        """

    let description: Nullable[String]
        """
        the description of the scheduled event (1-1000 characters)
        """

    let image: (ImageData | None)
        """
        the cover image of the scheduled event
        """

    let status: (GuildScheduledEventStatus | None)
        """
        the status of the scheduled event
        """

    let recurrence_rule: Nullable[GuildScheduledEventRecurrenceRule]
        """
        the definition for how often this event should recur
        """

    new val create(
        name': (String | None) = None,
        privacy_level': (GuildScheduledEventPrivacyLevel | None) = None,
        scheduled_start_time': (ISO8601 | None) = None,
        entity_type': (GuildScheduledEventEntityType | None) = None,
        channel_id': Nullable[Snowflake] = None,
        entity_metadata': Nullable[GuildScheduledEventEntityMetadata] = None,
        scheduled_end_time': Nullable[ISO8601] = None,
        description': Nullable[String] = None,
        image': (ImageData | None) = None,
        status': (GuildScheduledEventStatus | None) = None,
        recurrence_rule': Nullable[GuildScheduledEventRecurrenceRule] = None
    ) =>
        name = name'
        privacy_level = privacy_level'
        scheduled_start_time = scheduled_start_time'
        entity_type = entity_type'
        channel_id = channel_id'
        entity_metadata = entity_metadata'
        scheduled_end_time = scheduled_end_time'
        description = description'
        image = image'
        status = status'
        recurrence_rule = recurrence_rule'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match privacy_level
        | let privacy_level': GuildScheduledEventPrivacyLevel =>
            obj = obj.update("privacy_level", privacy_level'.value().i64())
        end

        match scheduled_start_time
        | let scheduled_start_time': ISO8601 =>
            obj = obj.update("scheduled_start_time", scheduled_start_time')
        end

        match entity_type
        | let entity_type': GuildScheduledEventEntityType =>
            obj = obj.update("entity_type", entity_type'.value().i64())
        end

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        | Null => obj = obj.update("channel_id", None)
        end

        match entity_metadata
        | let entity_metadata': GuildScheduledEventEntityMetadata =>
            obj = obj.update("entity_metadata", entity_metadata'.to_json())
        | Null => obj = obj.update("entity_metadata", None)
        end

        match scheduled_end_time
        | let scheduled_end_time': ISO8601 =>
            obj = obj.update("scheduled_end_time", scheduled_end_time')
        | Null => obj = obj.update("scheduled_end_time", None)
        end

        match description
        | let description': String =>
            obj = obj.update("description", description')
        | Null => obj = obj.update("description", None)
        end

        match image
        | let image': ImageData => obj = obj.update("image", image')
        end

        match status
        | let status': GuildScheduledEventStatus =>
            obj = obj.update("status", status'.value().i64())
        end

        match recurrence_rule
        | let recurrence_rule': GuildScheduledEventRecurrenceRule =>
            obj = obj.update("recurrence_rule", recurrence_rule'.to_json())
        | Null => obj = obj.update("recurrence_rule", None)
        end

        obj

class val GetGuildScheduledEventUsersParams
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event-users-query-string-params

    Provide a `before` and/or `after` to paginate. Users will always be returned
    in ascending order by `user_id`. If both `before` and `after` are provided,
    only `before` is respected.
    """

    let limit: (USize | None)
        """
        number of users to return (up to maximum 100), defaults to 100
        """

    let with_member: (Bool | None)
        """
        include guild member data if it exists, defaults to false
        """

    let before: (Snowflake | None)
        """
        consider only users before given user id
        """

    let after: (Snowflake | None)
        """
        consider only users after given user id
        """

    new val create(
        limit': (USize | None) = None,
        with_member': (Bool | None) = None,
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None
    ) =>
        limit = limit'
        with_member = with_member'
        before = before'
        after = after'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        match with_member
        | let with_member': Bool =>
            query.push(("with_member", with_member'.string()))
        end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        consume query

class val GuildScheduledEventException is Jsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#guild-scheduled-event-exception-object

    An override of a single occurrence of a recurring scheduled event, either
    moving it to a different time or cancelling it outright.
    """

    let event_id: Snowflake
        """
        the id of the recurring scheduled event this exception belongs to
        """

    let event_exception_id: Snowflake
        """
        the id of this exception
        """

    let scheduled_start_time: (ISO8601 | None)
        """
        the time this occurrence starts, or null to keep the recurring time
        """

    let scheduled_end_time: (ISO8601 | None)
        """
        the time this occurrence ends, or null to keep the recurring time
        """

    let is_canceled: Bool
        """
        whether this occurrence has been cancelled
        """

    new val create(
        event_id': Snowflake,
        event_exception_id': Snowflake,
        scheduled_start_time': (ISO8601 | None) = None,
        scheduled_end_time': (ISO8601 | None) = None,
        is_canceled': Bool = false
    ) =>
        event_id = event_id'
        event_exception_id = event_exception_id'
        scheduled_start_time = scheduled_start_time'
        scheduled_end_time = scheduled_end_time'
        is_canceled = is_canceled'

    new val from_json(obj: json.JsonObject) ? =>
        var event_id': (Snowflake | None) = None
        var event_exception_id': (Snowflake | None) = None
        var scheduled_start_time': (ISO8601 | None) = None
        var scheduled_end_time': (ISO8601 | None) = None
        var is_canceled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "event_id" => event_id' = Snowflake.from_json(value)?
            | "event_exception_id" =>
                event_exception_id' = Snowflake.from_json(value)?
            | "scheduled_start_time" =>
                match value
                | let string: String => scheduled_start_time' = string
                end
            | "scheduled_end_time" =>
                match value
                | let string: String => scheduled_end_time' = string
                end
            | "is_canceled" => is_canceled' = value as Bool
            end
        end

        event_id = event_id' as Snowflake
        event_exception_id = event_exception_id' as Snowflake
        scheduled_start_time = scheduled_start_time'
        scheduled_end_time = scheduled_end_time'
        is_canceled = is_canceled' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("event_id", event_id.to_json())
            .update("event_exception_id", event_exception_id.to_json())
            .update(
                "scheduled_start_time",
                match scheduled_start_time
                | let scheduled_start_time': ISO8601 => scheduled_start_time'
                end
            )
            .update(
                "scheduled_end_time",
                match scheduled_end_time
                | let scheduled_end_time': ISO8601 => scheduled_end_time'
                end
            )
            .update("is_canceled", is_canceled)

primitive _GuildScheduledEventExceptions
    fun apply(value: json.JsonValue): Array[GuildScheduledEventException] val ? =>
        """
        Decodes an array of guild scheduled event exceptions.
        """

        let array = value as json.JsonArray
        recover val
            let exceptions = Array[GuildScheduledEventException](array.size())
            for exception' in array.values() do
                exceptions.push(
                    GuildScheduledEventException.from_json(
                        exception' as json.JsonObject
                    )?
                )
            end
            exceptions
        end

class val CreateGuildScheduledEventExceptionParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#create-guild-scheduled-event-exception-json-params

    The occurrence being overridden is named by
    `original_scheduled_start_time`, which must line up with a start time the
    event's recurrence rule actually produces.
    """

    let original_scheduled_start_time: ISO8601
        """
        the start time of the occurrence being overridden
        """

    let scheduled_start_time: Nullable[ISO8601]
        """
        the time this occurrence should start instead
        """

    let scheduled_end_time: Nullable[ISO8601]
        """
        the time this occurrence should end instead
        """

    let is_canceled: Nullable[Bool]
        """
        whether this occurrence should be cancelled
        """

    new val create(
        original_scheduled_start_time': ISO8601,
        scheduled_start_time': Nullable[ISO8601] = None,
        scheduled_end_time': Nullable[ISO8601] = None,
        is_canceled': Nullable[Bool] = None
    ) =>
        original_scheduled_start_time = original_scheduled_start_time'
        scheduled_start_time = scheduled_start_time'
        scheduled_end_time = scheduled_end_time'
        is_canceled = is_canceled'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update(
                "original_scheduled_start_time", original_scheduled_start_time
            )

        match scheduled_start_time
        | let scheduled_start_time': ISO8601 =>
            obj = obj.update("scheduled_start_time", scheduled_start_time')
        | Null => obj = obj.update("scheduled_start_time", None)
        end

        match scheduled_end_time
        | let scheduled_end_time': ISO8601 =>
            obj = obj.update("scheduled_end_time", scheduled_end_time')
        | Null => obj = obj.update("scheduled_end_time", None)
        end

        match is_canceled
        | let is_canceled': Bool =>
            obj = obj.update("is_canceled", is_canceled')
        | Null => obj = obj.update("is_canceled", None)
        end

        obj

class val UpdateGuildScheduledEventExceptionParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#modify-guild-scheduled-event-exception-json-params

    All parameters to this endpoint are optional.
    """

    let scheduled_start_time: Nullable[ISO8601]
        """
        the time this occurrence should start instead
        """

    let scheduled_end_time: Nullable[ISO8601]
        """
        the time this occurrence should end instead
        """

    let is_canceled: Nullable[Bool]
        """
        whether this occurrence should be cancelled
        """

    new val create(
        scheduled_start_time': Nullable[ISO8601] = None,
        scheduled_end_time': Nullable[ISO8601] = None,
        is_canceled': Nullable[Bool] = None
    ) =>
        scheduled_start_time = scheduled_start_time'
        scheduled_end_time = scheduled_end_time'
        is_canceled = is_canceled'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match scheduled_start_time
        | let scheduled_start_time': ISO8601 =>
            obj = obj.update("scheduled_start_time", scheduled_start_time')
        | Null => obj = obj.update("scheduled_start_time", None)
        end

        match scheduled_end_time
        | let scheduled_end_time': ISO8601 =>
            obj = obj.update("scheduled_end_time", scheduled_end_time')
        | Null => obj = obj.update("scheduled_end_time", None)
        end

        match is_canceled
        | let is_canceled': Bool =>
            obj = obj.update("is_canceled", is_canceled')
        | Null => obj = obj.update("is_canceled", None)
        end

        obj

class val GuildScheduledEventUserCounts is FromJsonable
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event-user-counts

    How many users are subscribed to a recurring event, split out per
    overridden occurrence.
    """

    let guild_scheduled_event_count: USize
        """
        the number of users subscribed to the event as a whole
        """

    let guild_scheduled_event_exception_counts:
        collections.Map[Snowflake, USize] val
        """
        the number of users subscribed to each overridden occurrence, keyed by
        exception id
        """

    new val from_json(obj: json.JsonObject) ? =>
        var guild_scheduled_event_count': (USize | None) = None
        var guild_scheduled_event_exception_counts': (
            collections.Map[Snowflake, USize] val | None
        ) =
            None

        for (key, value) in obj.pairs() do
            match key
            | "guild_scheduled_event_count" =>
                guild_scheduled_event_count' = (value as I64).usize()
            | "guild_scheduled_event_exception_counts" =>
                let counts = value as json.JsonObject
                guild_scheduled_event_exception_counts' =
                    recover val
                        let counts' =
                            collections.Map[Snowflake, USize](counts.size())
                        for (id, count) in counts.pairs() do
                            counts'(Snowflake(id.u64()?)) = (count as I64).usize()
                        end
                        counts'
                    end
            end
        end

        guild_scheduled_event_count = guild_scheduled_event_count' as USize
        guild_scheduled_event_exception_counts =
            guild_scheduled_event_exception_counts' as
                collections.Map[Snowflake, USize] val

class val GetGuildScheduledEventUserCountsParams
    """
    https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event-user-counts-query-string-params
    """

    let guild_scheduled_event_exception_ids: (Array[Snowflake] val | None)
        """
        the overridden occurrences to count subscribers for (up to 10)
        """

    new val create(
        guild_scheduled_event_exception_ids': (Array[Snowflake] val | None) =
            None
    ) =>
        guild_scheduled_event_exception_ids =
            guild_scheduled_event_exception_ids'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match guild_scheduled_event_exception_ids
        | let ids: Array[Snowflake] val =>
            for id in ids.values() do
                query.push(
                    ("guild_scheduled_event_exception_ids", id.string())
                )
            end
        end

        consume query
