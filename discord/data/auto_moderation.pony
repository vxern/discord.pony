use json = "json"

class val AutoModerationRule is Jsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-rule-object-auto-moderation-rule-structure

    Auto Moderation is a feature which allows each guild to set up rules that trigger based on some criteria. For example, a rule can trigger whenever a message contains a specific keyword.

    Rules can be configured to automatically execute actions whenever they trigger. For example, if a user tries to send a message which contains a certain keyword, a rule can trigger and block the message before it is sent.
    """

    let id: Snowflake
        """
        the id of this rule
        """

    let guild_id: Snowflake
        """
        the id of the guild which this rule belongs to
        """

    let name: String
        """
        the rule name
        """

    let creator_id: Snowflake
        """
        the user which first created this rule
        """

    let event_type: AutoModerationEventType
        """
        the rule event type
        """

    let trigger_type: AutoModerationTriggerType
        """
        the rule trigger type
        """

    let trigger_metadata: AutoModerationTriggerMetadata
        """
        the rule trigger metadata
        """

    let actions: Array[AutoModerationAction] val
        """
        the actions which will execute when the rule is triggered
        """

    let enabled: Bool
        """
        whether the rule is enabled
        """

    let exempt_roles: Array[Snowflake] val
        """
        the role ids that should not be affected by the rule (Maximum of 20)
        """

    let exempt_channels: Array[Snowflake] val
        """
        the channel ids that should not be affected by the rule (Maximum of 50)
        """

    new val create(
        id': Snowflake,
        guild_id': Snowflake,
        name': String,
        creator_id': Snowflake,
        event_type': AutoModerationEventType,
        trigger_type': AutoModerationTriggerType,
        trigger_metadata': AutoModerationTriggerMetadata,
        actions': Array[AutoModerationAction] val,
        enabled': Bool,
        exempt_roles': Array[Snowflake] val,
        exempt_channels': Array[Snowflake] val
    ) =>
        id = id'
        guild_id = guild_id'
        name = name'
        creator_id = creator_id'
        event_type = event_type'
        trigger_type = trigger_type'
        trigger_metadata = trigger_metadata'
        actions = actions'
        enabled = enabled'
        exempt_roles = exempt_roles'
        exempt_channels = exempt_channels'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var name': (String | None) = None
        var creator_id': (Snowflake | None) = None
        var event_type': (AutoModerationEventType | None) = None
        var trigger_type': (AutoModerationTriggerType | None) = None
        var trigger_metadata': (AutoModerationTriggerMetadata | None) = None
        var actions': (Array[AutoModerationAction] val | None) = None
        var enabled': (Bool | None) = None
        var exempt_roles': (Array[Snowflake] val | None) = None
        var exempt_channels': (Array[Snowflake] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "creator_id" => creator_id' = Snowflake.from_json(value)?
            | "event_type" => event_type' = AutoModerationEventTypes.from((value as I64).u8())?
            | "trigger_type" => trigger_type' = AutoModerationTriggerTypes.from((value as I64).u8())?
            | "trigger_metadata" => trigger_metadata' = AutoModerationTriggerMetadata.from_json(value as json.JsonObject)?
            | "actions" => actions' = _AutoModerationActions(value)?
            | "enabled" => enabled' = value as Bool
            | "exempt_roles" => exempt_roles' = _Snowflakes(value)?
            | "exempt_channels" => exempt_channels' = _Snowflakes(value)?
            end
        end

        id = id' as Snowflake
        guild_id = guild_id' as Snowflake
        name = name' as String
        creator_id = creator_id' as Snowflake
        event_type = event_type' as AutoModerationEventType
        trigger_type = trigger_type' as AutoModerationTriggerType
        trigger_metadata = trigger_metadata' as AutoModerationTriggerMetadata
        actions = actions' as Array[AutoModerationAction] val
        enabled = enabled' as Bool
        exempt_roles = exempt_roles' as Array[Snowflake] val
        exempt_channels = exempt_channels' as Array[Snowflake] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("name", name)
            .update("creator_id", creator_id.to_json())
            .update("event_type", event_type.value().i64())
            .update("trigger_type", trigger_type.value().i64())
            .update("trigger_metadata", trigger_metadata.to_json())
            .update("actions", _AutoModerationActions.to_json(actions))
            .update("enabled", enabled)
            .update("exempt_roles", _Snowflakes.to_json(exempt_roles))
            .update("exempt_channels", _Snowflakes.to_json(exempt_channels))

primitive _AutoModerationRules
    fun apply(value: json.JsonValue): Array[AutoModerationRule] val ? =>
        """
        Decodes an array of auto moderation rules.
        """

        let array = value as json.JsonArray
        recover val
            let rules = Array[AutoModerationRule](array.size())
            for rule in array.values() do rules.push(AutoModerationRule.from_json(rule as json.JsonObject)?) end
            rules
        end

    fun to_json(rules: Array[AutoModerationRule] val): json.JsonArray =>
        var array = json.JsonArray
        for rule in rules.values() do array = array.push(rule.to_json()) end
        array

trait val AutoModerationTriggerType is _Enum[AutoModerationTriggerType, U8]
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-rule-object-trigger-types

    Characterizes the type of content which can trigger the rule.
    """
primitive KeywordAutoModerationTriggerType is AutoModerationTriggerType
    """
    check if content contains words from a user defined list of keywords

    Max per guild: 6
    """

    fun value(): U8 => 1
primitive SpamAutoModerationTriggerType is AutoModerationTriggerType
    """
    check if content represents generic spam

    Max per guild: 1
    """

    fun value(): U8 => 3
primitive KeywordPresetAutoModerationTriggerType is AutoModerationTriggerType
    """
    check if content contains words from internal pre-defined wordsets

    Max per guild: 1
    """

    fun value(): U8 => 4
primitive MentionSpamAutoModerationTriggerType is AutoModerationTriggerType
    """
    check if content contains more unique mentions than allowed

    Max per guild: 1
    """

    fun value(): U8 => 5
primitive MemberProfileAutoModerationTriggerType is AutoModerationTriggerType
    """
    check if member profile contains words from a user defined list of keywords

    Max per guild: 1
    """

    fun value(): U8 => 6
primitive AutoModerationTriggerTypes
    fun from(value: U8): AutoModerationTriggerType ? =>
        match value
        | 1 => KeywordAutoModerationTriggerType
        | 3 => SpamAutoModerationTriggerType
        | 4 => KeywordPresetAutoModerationTriggerType
        | 5 => MentionSpamAutoModerationTriggerType
        | 6 => MemberProfileAutoModerationTriggerType
        else error
        end

class val AutoModerationTriggerMetadata is Jsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-rule-object-trigger-metadata

    Additional data used to determine whether a rule should be triggered. Different fields are relevant based on the value of trigger_type.
    """

    let keyword_filter: (Array[String] val | None)
        """
        substrings which will be searched for in content (Maximum of 1000)

        Trigger types: KEYWORD & MEMBER_PROFILE
        """

    let regex_patterns: (Array[String] val | None)
        """
        regular expression patterns which will be matched against content (Maximum of 10)

        Trigger types: KEYWORD & MEMBER_PROFILE
        """

    let presets: (Array[KeywordPresetType] val | None)
        """
        the internally pre-defined wordsets which will be searched for in content

        Trigger types: KEYWORD_PRESET
        """

    let allow_list: (Array[String] val | None)
        """
        substrings which should not trigger the rule (Maximum of 100 or 1000)

        Trigger types: KEYWORD & KEYWORD_PRESET & MEMBER_PROFILE
        """

    let mention_total_limit: (USize | None)
        """
        total number of unique role and user mentions allowed per message (Maximum of 50)

        Trigger types: MENTION_SPAM
        """

    let mention_raid_protection_enabled: (Bool | None)
        """
        whether to automatically detect mention raids

        Trigger types: MENTION_SPAM
        """

    new val create(
        keyword_filter': (Array[String] val | None) = None,
        regex_patterns': (Array[String] val | None) = None,
        presets': (Array[KeywordPresetType] val | None) = None,
        allow_list': (Array[String] val | None) = None,
        mention_total_limit': (USize | None) = None,
        mention_raid_protection_enabled': (Bool | None) = None
    ) =>
        keyword_filter = keyword_filter'
        regex_patterns = regex_patterns'
        presets = presets'
        allow_list = allow_list'
        mention_total_limit = mention_total_limit'
        mention_raid_protection_enabled = mention_raid_protection_enabled'

    new val from_json(obj: json.JsonObject) ? =>
        var keyword_filter': (Array[String] val | None) = None
        var regex_patterns': (Array[String] val | None) = None
        var presets': (Array[KeywordPresetType] val | None) = None
        var allow_list': (Array[String] val | None) = None
        var mention_total_limit': (USize | None) = None
        var mention_raid_protection_enabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "keyword_filter" => keyword_filter' = _Strings(value)?
            | "regex_patterns" => regex_patterns' = _Strings(value)?
            | "presets" => presets' = _KeywordPresets(value)?
            | "allow_list" => allow_list' = _Strings(value)?
            | "mention_total_limit" => mention_total_limit' = (value as I64).usize()
            | "mention_raid_protection_enabled" => mention_raid_protection_enabled' = value as Bool
            end
        end

        keyword_filter = keyword_filter'
        regex_patterns = regex_patterns'
        presets = presets'
        allow_list = allow_list'
        mention_total_limit = mention_total_limit'
        mention_raid_protection_enabled = mention_raid_protection_enabled'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match keyword_filter
        | let keyword_filter': Array[String] val => obj = obj.update("keyword_filter", _Strings.to_json(keyword_filter'))
        end

        match regex_patterns
        | let regex_patterns': Array[String] val => obj = obj.update("regex_patterns", _Strings.to_json(regex_patterns'))
        end

        match presets
        | let presets': Array[KeywordPresetType] val => obj = obj.update("presets", _KeywordPresets.to_json(presets'))
        end

        match allow_list
        | let allow_list': Array[String] val => obj = obj.update("allow_list", _Strings.to_json(allow_list'))
        end

        match mention_total_limit
        | let mention_total_limit': USize => obj = obj.update("mention_total_limit", mention_total_limit'.i64())
        end

        match mention_raid_protection_enabled
        | let mention_raid_protection_enabled': Bool => obj = obj.update("mention_raid_protection_enabled", mention_raid_protection_enabled')
        end

        obj

trait val KeywordPresetType is _Enum[KeywordPresetType, U8]
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-rule-object-keyword-preset-types
    """
primitive ProfanityKeywordPresetType is KeywordPresetType
    """
    words that may be considered forms of swearing or cursing
    """

    fun value(): U8 => 1
primitive SexualContentKeywordPresetType is KeywordPresetType
    """
    words that refer to sexually explicit behavior or activity
    """

    fun value(): U8 => 2
primitive SlursKeywordPresetType is KeywordPresetType
    """
    personal insults or words that may be considered hate speech
    """

    fun value(): U8 => 3
primitive KeywordPresetTypes
    fun from(value: U8): KeywordPresetType ? =>
        match value
        | 1 => ProfanityKeywordPresetType
        | 2 => SexualContentKeywordPresetType
        | 3 => SlursKeywordPresetType
        else error
        end

primitive _KeywordPresets
    fun apply(value: json.JsonValue): Array[KeywordPresetType] val ? =>
        """
        Decodes an array of keyword preset types.
        """

        let array = value as json.JsonArray
        recover val
            let presets = Array[KeywordPresetType](array.size())
            for preset in array.values() do presets.push(KeywordPresetTypes.from((preset as I64).u8())?) end
            presets
        end

    fun to_json(presets: Array[KeywordPresetType] val): json.JsonArray =>
        var array = json.JsonArray
        for preset in presets.values() do array = array.push(preset.value().i64()) end
        array

trait val AutoModerationEventType is _Enum[AutoModerationEventType, U8]
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-rule-object-event-types

    Indicates in what event context a rule should be checked.
    """
primitive MessageSendAutoModerationEventType is AutoModerationEventType
    """
    when a member sends or edits a message in the guild
    """

    fun value(): U8 => 1
primitive MemberUpdateAutoModerationEventType is AutoModerationEventType
    """
    when a member edits their profile
    """

    fun value(): U8 => 2
primitive AutoModerationEventTypes
    fun from(value: U8): AutoModerationEventType ? =>
        match value
        | 1 => MessageSendAutoModerationEventType
        | 2 => MemberUpdateAutoModerationEventType
        else error
        end

class val AutoModerationAction is Jsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-action-object-auto-moderation-action-structure

    An action which will execute whenever a rule is triggered.
    """

    let type': AutoModerationActionType
        """
        the type of action
        """

    let metadata: (AutoModerationActionMetadata | None)
        """
        additional metadata needed during execution for this specific action type
        """

    new val create(type'': AutoModerationActionType, metadata': (AutoModerationActionMetadata | None) = None) =>
        type' = type''
        metadata = metadata'

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (AutoModerationActionType | None) = None
        var metadata': (AutoModerationActionMetadata | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "type" => type'' = AutoModerationActionTypes.from((value as I64).u8())?
            | "metadata" => metadata' = AutoModerationActionMetadata.from_json(value as json.JsonObject)?
            end
        end

        type' = type'' as AutoModerationActionType
        metadata = metadata'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("type", type'.value().i64())

        match metadata
        | let metadata': AutoModerationActionMetadata => obj = obj.update("metadata", metadata'.to_json())
        end

        obj

primitive _AutoModerationActions
    fun apply(value: json.JsonValue): Array[AutoModerationAction] val ? =>
        """
        Decodes an array of auto moderation actions.
        """

        let array = value as json.JsonArray
        recover val
            let actions = Array[AutoModerationAction](array.size())
            for action in array.values() do actions.push(AutoModerationAction.from_json(action as json.JsonObject)?) end
            actions
        end

    fun to_json(actions: Array[AutoModerationAction] val): json.JsonArray =>
        var array = json.JsonArray
        for action in actions.values() do array = array.push(action.to_json()) end
        array

trait val AutoModerationActionType is _Enum[AutoModerationActionType, U8]
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-action-object-action-types
    """
primitive BlockMessageAutoModerationActionType is AutoModerationActionType
    """
    blocks a member's message and prevents it from being posted. A custom explanation can be specified and shown to members whenever their message is blocked.
    """

    fun value(): U8 => 1
primitive SendAlertMessageAutoModerationActionType is AutoModerationActionType
    """
    logs user content to a specified channel
    """

    fun value(): U8 => 2
primitive TimeoutAutoModerationActionType is AutoModerationActionType
    """
    timeout user for a specified duration

    Only supported for trigger types KEYWORD, SPAM and MENTION_SPAM.
    """

    fun value(): U8 => 3
primitive BlockMemberInteractionAutoModerationActionType is AutoModerationActionType
    """
    prevents a member from using text, voice, or other interactions
    """

    fun value(): U8 => 4
primitive AutoModerationActionTypes
    fun from(value: U8): AutoModerationActionType ? =>
        match value
        | 1 => BlockMessageAutoModerationActionType
        | 2 => SendAlertMessageAutoModerationActionType
        | 3 => TimeoutAutoModerationActionType
        | 4 => BlockMemberInteractionAutoModerationActionType
        else error
        end

class val AutoModerationActionMetadata is Jsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#auto-moderation-action-object-action-metadata

    Additional data used when an action is executed. Different fields are relevant based on the value of action type.
    """

    let channel_id: (Snowflake | None)
        """
        channel to which user content should be logged

        Action types: SEND_ALERT_MESSAGE
        """

    let duration_seconds: (USize | None)
        """
        timeout duration in seconds (maximum of 2419200 seconds, or 4 weeks)

        Action types: TIMEOUT
        """

    let custom_message: (String | None)
        """
        additional explanation that will be shown to members whenever their message is blocked (maximum of 150 characters)

        Action types: BLOCK_MESSAGE
        """

    new val create(
        channel_id': (Snowflake | None) = None,
        duration_seconds': (USize | None) = None,
        custom_message': (String | None) = None
    ) =>
        channel_id = channel_id'
        duration_seconds = duration_seconds'
        custom_message = custom_message'

    new val from_json(obj: json.JsonObject) ? =>
        var channel_id': (Snowflake | None) = None
        var duration_seconds': (USize | None) = None
        var custom_message': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "duration_seconds" => duration_seconds' = (value as I64).usize()
            | "custom_message" => custom_message' = value as String
            end
        end

        channel_id = channel_id'
        duration_seconds = duration_seconds'
        custom_message = custom_message'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match duration_seconds
        | let duration_seconds': USize => obj = obj.update("duration_seconds", duration_seconds'.i64())
        end

        match custom_message
        | let custom_message': String => obj = obj.update("custom_message", custom_message')
        end

        obj

class val CreateAutoModerationRuleParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#create-auto-moderation-rule-json-params
    """

    let name: String
        """
        the rule name
        """

    let event_type: AutoModerationEventType
        """
        the event type
        """

    let trigger_type: AutoModerationTriggerType
        """
        the trigger type
        """

    let actions: Array[AutoModerationAction] val
        """
        the actions which will execute when the rule is triggered
        """

    let trigger_metadata: (AutoModerationTriggerMetadata | None)
        """
        the trigger metadata

        Can be omitted based on `trigger_type`.
        """

    let enabled: (Bool | None)
        """
        whether the rule is enabled (False by default)
        """

    let exempt_roles: (Array[Snowflake] val | None)
        """
        the role ids that should not be affected by the rule (Maximum of 20)
        """

    let exempt_channels: (Array[Snowflake] val | None)
        """
        the channel ids that should not be affected by the rule (Maximum of 50)
        """

    new val create(
        name': String,
        event_type': AutoModerationEventType,
        trigger_type': AutoModerationTriggerType,
        actions': Array[AutoModerationAction] val,
        trigger_metadata': (AutoModerationTriggerMetadata | None) = None,
        enabled': (Bool | None) = None,
        exempt_roles': (Array[Snowflake] val | None) = None,
        exempt_channels': (Array[Snowflake] val | None) = None
    ) =>
        name = name'
        event_type = event_type'
        trigger_type = trigger_type'
        actions = actions'
        trigger_metadata = trigger_metadata'
        enabled = enabled'
        exempt_roles = exempt_roles'
        exempt_channels = exempt_channels'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("event_type", event_type.value().i64())
            .update("trigger_type", trigger_type.value().i64())
            .update("actions", _AutoModerationActions.to_json(actions))

        match trigger_metadata
        | let trigger_metadata': AutoModerationTriggerMetadata => obj = obj.update("trigger_metadata", trigger_metadata'.to_json())
        end

        match enabled
        | let enabled': Bool => obj = obj.update("enabled", enabled')
        end

        match exempt_roles
        | let exempt_roles': Array[Snowflake] val => obj = obj.update("exempt_roles", _Snowflakes.to_json(exempt_roles'))
        end

        match exempt_channels
        | let exempt_channels': Array[Snowflake] val => obj = obj.update("exempt_channels", _Snowflakes.to_json(exempt_channels'))
        end

        obj

class val UpdateAutoModerationRuleParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/auto-moderation#modify-auto-moderation-rule-json-params

    All parameters for this endpoint are optional.
    """

    let name: (String | None)
        """
        the rule name
        """

    let event_type: (AutoModerationEventType | None)
        """
        the event type
        """

    let trigger_metadata: (AutoModerationTriggerMetadata | None)
        """
        the trigger metadata

        Can be omitted based on `trigger_type`.
        """

    let actions: (Array[AutoModerationAction] val | None)
        """
        the actions which will execute when the rule is triggered
        """

    let enabled: (Bool | None)
        """
        whether the rule is enabled
        """

    let exempt_roles: (Array[Snowflake] val | None)
        """
        the role ids that should not be affected by the rule (Maximum of 20)
        """

    let exempt_channels: (Array[Snowflake] val | None)
        """
        the channel ids that should not be affected by the rule (Maximum of 50)
        """

    new val create(
        name': (String | None) = None,
        event_type': (AutoModerationEventType | None) = None,
        trigger_metadata': (AutoModerationTriggerMetadata | None) = None,
        actions': (Array[AutoModerationAction] val | None) = None,
        enabled': (Bool | None) = None,
        exempt_roles': (Array[Snowflake] val | None) = None,
        exempt_channels': (Array[Snowflake] val | None) = None
    ) =>
        name = name'
        event_type = event_type'
        trigger_metadata = trigger_metadata'
        actions = actions'
        enabled = enabled'
        exempt_roles = exempt_roles'
        exempt_channels = exempt_channels'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match event_type
        | let event_type': AutoModerationEventType => obj = obj.update("event_type", event_type'.value().i64())
        end

        match trigger_metadata
        | let trigger_metadata': AutoModerationTriggerMetadata => obj = obj.update("trigger_metadata", trigger_metadata'.to_json())
        end

        match actions
        | let actions': Array[AutoModerationAction] val => obj = obj.update("actions", _AutoModerationActions.to_json(actions'))
        end

        match enabled
        | let enabled': Bool => obj = obj.update("enabled", enabled')
        end

        match exempt_roles
        | let exempt_roles': Array[Snowflake] val => obj = obj.update("exempt_roles", _Snowflakes.to_json(exempt_roles'))
        end

        match exempt_channels
        | let exempt_channels': Array[Snowflake] val => obj = obj.update("exempt_channels", _Snowflakes.to_json(exempt_channels'))
        end

        obj
