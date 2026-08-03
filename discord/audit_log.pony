use collections = "collections"
use json = "json"

class val AuditLog is Jsonable
    """
    https://docs.discord.com/developers/resources/audit-log#audit-log-object-audit-log-structure

    When an administrative action is performed in a guild, an entry is added to its audit log. Viewing audit logs requires the VIEW_AUDIT_LOG permission and can be fetched by apps using the GET /guilds/{guild.id}/audit-logs endpoint, or seen by users in the guild’s Server Settings. All audit log entries are stored for 45 days.

    When an app is performing an eligible action using the APIs, it can pass an X-Audit-Log-Reason header to indicate why the action was taken. More information is in the audit log entry section.
    """

    // TODO(vxern): Add `application_commands` (array of application command objects; List of application commands referenced in the audit log) once `ApplicationCommand` is implemented.

    let audit_log_entries: Array[AuditLogEntry] val
        """
        List of audit log entries, sorted from most to least recent
        """

    let auto_moderation_rules: Array[AutoModerationRule] val
        """
        List of auto moderation rules referenced in the audit log
        """

    let guild_scheduled_events: Array[GuildScheduledEvent] val
        """
        List of guild scheduled events referenced in the audit log
        """

    // TODO(vxern): Add `integrations` (array of partial integration objects; List of partial integration objects) once a partial variant of `Integration` is implemented. Discord sends only `id`, `name`, `type` and `account`, so `Integration` — which requires `enabled` — cannot decode them.

    let threads: Array[Channel] val
        """
        List of threads referenced in the audit log

        Threads referenced in THREAD_CREATE and THREAD_UPDATE events are included in the threads map since archived threads might not be kept in memory by clients.
        """

    let users: Array[User] val
        """
        List of users referenced in the audit log
        """

    let webhooks: Array[Webhook] val
        """
        List of webhooks referenced in the audit log
        """

    new val from_json(obj: json.JsonObject) ? =>
        var audit_log_entries': (Array[AuditLogEntry] val | None) = None
        var auto_moderation_rules': (Array[AutoModerationRule] val | None) = None
        var guild_scheduled_events': (Array[GuildScheduledEvent] val | None) = None
        var threads': (Array[Channel] val | None) = None
        var users': (Array[User] val | None) = None
        var webhooks': (Array[Webhook] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "audit_log_entries" => audit_log_entries' = _AuditLogEntries(value)?
            | "auto_moderation_rules" => auto_moderation_rules' = _AutoModerationRules(value)?
            | "guild_scheduled_events" => guild_scheduled_events' = _GuildScheduledEvents(value)?
            | "threads" => threads' = _Channels(value)?
            | "users" => users' = _Users(value)?
            | "webhooks" => webhooks' = _Webhooks(value)?
            end
        end

        audit_log_entries = audit_log_entries' as Array[AuditLogEntry] val
        auto_moderation_rules = auto_moderation_rules' as Array[AutoModerationRule] val
        guild_scheduled_events = guild_scheduled_events' as Array[GuildScheduledEvent] val
        threads = threads' as Array[Channel] val
        users = users' as Array[User] val
        webhooks = webhooks' as Array[Webhook] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("audit_log_entries", _AuditLogEntries.to_json(audit_log_entries))
            .update("auto_moderation_rules", _AutoModerationRules.to_json(auto_moderation_rules))
            .update("guild_scheduled_events", _GuildScheduledEvents.to_json(guild_scheduled_events))
            .update("threads", _Channels.to_json(threads))
            .update("users", _Users.to_json(users))
            .update("webhooks", _Webhooks.to_json(webhooks))

class val AuditLogEntry is Jsonable
    """
    https://docs.discord.com/developers/resources/audit-log#audit-log-entry-object-audit-log-entry-structure

    Each audit log entry represents a single administrative action (or event), indicated by action_type. Most entries contain one to many changes in the changes array that affected an entity in Discord—whether that’s a user, channel, guild, emoji, or something else.

    The information (and structure) of an entry’s changes will be different depending on its type. For example, in MEMBER_ROLE_UPDATE events there is only one change: a member is either added or removed from a specific role. However, in CHANNEL_CREATE events there are many changes, including (but not limited to) the channel’s name, type, and permission overwrites added. More details are in the change object section.

    Apps can specify why an administrative action is being taken by passing an X-Audit-Log-Reason request header, which will be stored as the audit log entry’s reason field. The X-Audit-Log-Reason header supports 1-512 URL-encoded UTF-8 characters. Reasons are visible to users in the client and to apps when fetching audit log entries with the API.
    """

    let target_id: (String | None)
        """
        ID of the affected entity (webhook, user, role, etc.)
        """

    let changes: (Array[AuditLogChange] val | None)
        """
        Changes made to the target_id
        """

    let user_id: (Snowflake | None)
        """
        User or app that made the changes
        """

    let id: Snowflake
        """
        ID of the entry
        """

    let action_type: AuditLogEvent
        """
        Type of action that occurred
        """

    let options: (OptionalAuditEntryInfo | None)
        """
        Additional info for certain event types
        """

    let reason: (String | None)
        """
        Reason for the change (1-512 characters)
        """

    new val from_json(obj: json.JsonObject) ? =>
        var target_id': (String | None) = None
        var changes': (Array[AuditLogChange] val | None) = None
        var user_id': (Snowflake | None) = None
        var id': (Snowflake | None) = None
        var action_type': (AuditLogEvent | None) = None
        var options': (OptionalAuditEntryInfo | None) = None
        var reason': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "target_id" =>
                match value | let string: String => target_id' = string end
            | "changes" => changes' = _AuditLogChanges(value)?
            | "user_id" =>
                match value | let string: String => user_id' = Snowflake.from_json(string)? end
            | "id" => id' = Snowflake.from_json(value)?
            | "action_type" => action_type' = AuditLogEvents.from((value as I64).u8())?
            | "options" => options' = OptionalAuditEntryInfo.from_json(value as json.JsonObject)?
            | "reason" => reason' = value as String
            end
        end

        target_id = target_id'
        changes = changes'
        user_id = user_id'
        id = id' as Snowflake
        action_type = action_type' as AuditLogEvent
        options = options'
        reason = reason'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("target_id", target_id)
            .update("user_id", match user_id | let user_id': Snowflake => user_id'.to_json() end)
            .update("id", id.to_json())
            .update("action_type", action_type.value().i64())

        match changes
        | let changes': Array[AuditLogChange] val => obj = obj.update("changes", _AuditLogChanges.to_json(changes'))
        end

        match options
        | let options': OptionalAuditEntryInfo => obj = obj.update("options", options'.to_json())
        end

        match reason
        | let reason': String => obj = obj.update("reason", reason')
        end

        obj

primitive _AuditLogEntries
    fun apply(value: json.JsonValue): Array[AuditLogEntry] val ? =>
        """
        Decodes an array of audit log entries.
        """

        let array = value as json.JsonArray
        recover val
            let entries = Array[AuditLogEntry](array.size())
            for entry in array.values() do entries.push(AuditLogEntry.from_json(entry as json.JsonObject)?) end
            entries
        end

    fun to_json(entries: Array[AuditLogEntry] val): json.JsonArray =>
        var array = json.JsonArray
        for entry in entries.values() do array = array.push(entry.to_json()) end
        array

trait val AuditLogEvent is (collections.Hashable & Equatable[AuditLogEvent])
    """
    https://docs.discord.com/developers/resources/audit-log#audit-log-entry-object-audit-log-events

    Audit log events and values (the action_type field) that your app may receive.

    The Object Changed column notes which object’s values may be included in the entry. Though there are exceptions, possible keys in the changes array typically correspond to the object’s fields. The descriptions and types for those fields can be found in the linked documentation for the object.

    If no object is noted, there won’t be a changes array in the entry, though other fields like the target_id still exist and many have fields in the options object.

    * Object has exception(s) to available keys. See the exceptions section below for details.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: AuditLogEvent): Bool => value() == that.value()
primitive GuildUpdateAuditLogEvent is AuditLogEvent
    """
    Server settings were updated

    Object changed: Guild
    """

    fun value(): U8 => 1
primitive ChannelCreateAuditLogEvent is AuditLogEvent
    """
    Channel was created

    Object changed: Channel
    """

    fun value(): U8 => 10
primitive ChannelUpdateAuditLogEvent is AuditLogEvent
    """
    Channel settings were updated

    Object changed: Channel
    """

    fun value(): U8 => 11
primitive ChannelDeleteAuditLogEvent is AuditLogEvent
    """
    Channel was deleted

    Object changed: Channel
    """

    fun value(): U8 => 12
primitive ChannelOverwriteCreateAuditLogEvent is AuditLogEvent
    """
    Permission overwrite was added to a channel

    Object changed: Channel Overwrite
    """

    fun value(): U8 => 13
primitive ChannelOverwriteUpdateAuditLogEvent is AuditLogEvent
    """
    Permission overwrite was updated for a channel

    Object changed: Channel Overwrite
    """

    fun value(): U8 => 14
primitive ChannelOverwriteDeleteAuditLogEvent is AuditLogEvent
    """
    Permission overwrite was deleted from a channel

    Object changed: Channel Overwrite
    """

    fun value(): U8 => 15
primitive MemberKickAuditLogEvent is AuditLogEvent
    """
    Member was removed from server
    """

    fun value(): U8 => 20
primitive MemberPruneAuditLogEvent is AuditLogEvent
    """
    Members were pruned from server
    """

    fun value(): U8 => 21
primitive MemberBanAddAuditLogEvent is AuditLogEvent
    """
    Member was banned from server
    """

    fun value(): U8 => 22
primitive MemberBanRemoveAuditLogEvent is AuditLogEvent
    """
    Server ban was lifted for a member
    """

    fun value(): U8 => 23
primitive MemberUpdateAuditLogEvent is AuditLogEvent
    """
    Member was updated in server

    Object changed: Member
    """

    fun value(): U8 => 24
primitive MemberRoleUpdateAuditLogEvent is AuditLogEvent
    """
    Member was added or removed from a role

    Object changed: Partial Role*
    """

    fun value(): U8 => 25
primitive MemberMoveAuditLogEvent is AuditLogEvent
    """
    Member was moved to a different voice channel
    """

    fun value(): U8 => 26
primitive MemberDisconnectAuditLogEvent is AuditLogEvent
    """
    Member was disconnected from a voice channel
    """

    fun value(): U8 => 27
primitive BotAddAuditLogEvent is AuditLogEvent
    """
    Bot user was added to server
    """

    fun value(): U8 => 28
primitive RoleCreateAuditLogEvent is AuditLogEvent
    """
    Role was created

    Object changed: Role
    """

    fun value(): U8 => 30
primitive RoleUpdateAuditLogEvent is AuditLogEvent
    """
    Role was edited

    Object changed: Role
    """

    fun value(): U8 => 31
primitive RoleDeleteAuditLogEvent is AuditLogEvent
    """
    Role was deleted

    Object changed: Role
    """

    fun value(): U8 => 32
primitive InviteCreateAuditLogEvent is AuditLogEvent
    """
    Server invite was created

    Object changed: Invite and Invite Metadata*
    """

    fun value(): U8 => 40
primitive InviteUpdateAuditLogEvent is AuditLogEvent
    """
    Server invite was updated

    Object changed: Invite and Invite Metadata*
    """

    fun value(): U8 => 41
primitive InviteDeleteAuditLogEvent is AuditLogEvent
    """
    Server invite was deleted

    Object changed: Invite and Invite Metadata*
    """

    fun value(): U8 => 42
primitive WebhookCreateAuditLogEvent is AuditLogEvent
    """
    Webhook was created

    Object changed: Webhook*
    """

    fun value(): U8 => 50
primitive WebhookUpdateAuditLogEvent is AuditLogEvent
    """
    Webhook properties or channel were updated

    Object changed: Webhook*
    """

    fun value(): U8 => 51
primitive WebhookDeleteAuditLogEvent is AuditLogEvent
    """
    Webhook was deleted

    Object changed: Webhook*
    """

    fun value(): U8 => 52
primitive EmojiCreateAuditLogEvent is AuditLogEvent
    """
    Emoji was created

    Object changed: Emoji
    """

    fun value(): U8 => 60
primitive EmojiUpdateAuditLogEvent is AuditLogEvent
    """
    Emoji name was updated

    Object changed: Emoji
    """

    fun value(): U8 => 61
primitive EmojiDeleteAuditLogEvent is AuditLogEvent
    """
    Emoji was deleted

    Object changed: Emoji
    """

    fun value(): U8 => 62
primitive MessageDeleteAuditLogEvent is AuditLogEvent
    """
    Single message was deleted
    """

    fun value(): U8 => 72
primitive MessageBulkDeleteAuditLogEvent is AuditLogEvent
    """
    Multiple messages were deleted
    """

    fun value(): U8 => 73
primitive MessagePinAuditLogEvent is AuditLogEvent
    """
    Message was pinned to a channel
    """

    fun value(): U8 => 74
primitive MessageUnpinAuditLogEvent is AuditLogEvent
    """
    Message was unpinned from a channel
    """

    fun value(): U8 => 75
primitive IntegrationCreateAuditLogEvent is AuditLogEvent
    """
    App was added to server

    Object changed: Integration
    """

    fun value(): U8 => 80
primitive IntegrationUpdateAuditLogEvent is AuditLogEvent
    """
    App was updated (as an example, its scopes were updated)

    Object changed: Integration
    """

    fun value(): U8 => 81
primitive IntegrationDeleteAuditLogEvent is AuditLogEvent
    """
    App was removed from server

    Object changed: Integration
    """

    fun value(): U8 => 82
primitive StageInstanceCreateAuditLogEvent is AuditLogEvent
    """
    Stage instance was created (stage channel becomes live)

    Object changed: Stage Instance
    """

    fun value(): U8 => 83
primitive StageInstanceUpdateAuditLogEvent is AuditLogEvent
    """
    Stage instance details were updated

    Object changed: Stage Instance
    """

    fun value(): U8 => 84
primitive StageInstanceDeleteAuditLogEvent is AuditLogEvent
    """
    Stage instance was deleted (stage channel no longer live)

    Object changed: Stage Instance
    """

    fun value(): U8 => 85
primitive StickerCreateAuditLogEvent is AuditLogEvent
    """
    Sticker was created

    Object changed: Sticker
    """

    fun value(): U8 => 90
primitive StickerUpdateAuditLogEvent is AuditLogEvent
    """
    Sticker details were updated

    Object changed: Sticker
    """

    fun value(): U8 => 91
primitive StickerDeleteAuditLogEvent is AuditLogEvent
    """
    Sticker was deleted

    Object changed: Sticker
    """

    fun value(): U8 => 92
primitive GuildScheduledEventCreateAuditLogEvent is AuditLogEvent
    """
    Event was created

    Object changed: Guild Scheduled Event
    """

    fun value(): U8 => 100
primitive GuildScheduledEventUpdateAuditLogEvent is AuditLogEvent
    """
    Event was updated

    Object changed: Guild Scheduled Event
    """

    fun value(): U8 => 101
primitive GuildScheduledEventDeleteAuditLogEvent is AuditLogEvent
    """
    Event was cancelled

    Object changed: Guild Scheduled Event
    """

    fun value(): U8 => 102
primitive ThreadCreateAuditLogEvent is AuditLogEvent
    """
    Thread was created in a channel

    Object changed: Thread
    """

    fun value(): U8 => 110
primitive ThreadUpdateAuditLogEvent is AuditLogEvent
    """
    Thread was updated

    Object changed: Thread
    """

    fun value(): U8 => 111
primitive ThreadDeleteAuditLogEvent is AuditLogEvent
    """
    Thread was deleted

    Object changed: Thread
    """

    fun value(): U8 => 112
primitive ApplicationCommandPermissionUpdateAuditLogEvent is AuditLogEvent
    """
    Permissions were updated for a command

    Object changed: Command Permission*
    """

    fun value(): U8 => 121
primitive SoundboardSoundCreateAuditLogEvent is AuditLogEvent
    """
    Soundboard sound was created

    Object changed: Soundboard Sound
    """

    fun value(): U8 => 130
primitive SoundboardSoundUpdateAuditLogEvent is AuditLogEvent
    """
    Soundboard sound was updated

    Object changed: Soundboard Sound
    """

    fun value(): U8 => 131
primitive SoundboardSoundDeleteAuditLogEvent is AuditLogEvent
    """
    Soundboard sound was deleted

    Object changed: Soundboard Sound
    """

    fun value(): U8 => 132
primitive AutoModerationRuleCreateAuditLogEvent is AuditLogEvent
    """
    Auto Moderation rule was created

    Object changed: Auto Moderation Rule
    """

    fun value(): U8 => 140
primitive AutoModerationRuleUpdateAuditLogEvent is AuditLogEvent
    """
    Auto Moderation rule was updated

    Object changed: Auto Moderation Rule
    """

    fun value(): U8 => 141
primitive AutoModerationRuleDeleteAuditLogEvent is AuditLogEvent
    """
    Auto Moderation rule was deleted

    Object changed: Auto Moderation Rule
    """

    fun value(): U8 => 142
primitive AutoModerationBlockMessageAuditLogEvent is AuditLogEvent
    """
    Message was blocked by Auto Moderation
    """

    fun value(): U8 => 143
primitive AutoModerationFlagToChannelAuditLogEvent is AuditLogEvent
    """
    Message was flagged by Auto Moderation
    """

    fun value(): U8 => 144
primitive AutoModerationUserCommunicationDisabledAuditLogEvent is AuditLogEvent
    """
    Member was timed out by Auto Moderation
    """

    fun value(): U8 => 145
primitive AutoModerationQuarantineUserAuditLogEvent is AuditLogEvent
    """
    Member was quarantined by Auto Moderation
    """

    fun value(): U8 => 146
primitive CreatorMonetizationRequestCreatedAuditLogEvent is AuditLogEvent
    """
    Creator monetization request was created
    """

    fun value(): U8 => 150
primitive CreatorMonetizationTermsAcceptedAuditLogEvent is AuditLogEvent
    """
    Creator monetization terms were accepted
    """

    fun value(): U8 => 151
primitive OnboardingPromptCreateAuditLogEvent is AuditLogEvent
    """
    Guild Onboarding Question was created

    Object changed: Onboarding Prompt Structure
    """

    fun value(): U8 => 163
primitive OnboardingPromptUpdateAuditLogEvent is AuditLogEvent
    """
    Guild Onboarding Question was updated

    Object changed: Onboarding Prompt Structure
    """

    fun value(): U8 => 164
primitive OnboardingPromptDeleteAuditLogEvent is AuditLogEvent
    """
    Guild Onboarding Question was deleted

    Object changed: Onboarding Prompt Structure
    """

    fun value(): U8 => 165
primitive OnboardingCreateAuditLogEvent is AuditLogEvent
    """
    Guild Onboarding was created

    Object changed: Guild Onboarding
    """

    fun value(): U8 => 166
primitive OnboardingUpdateAuditLogEvent is AuditLogEvent
    """
    Guild Onboarding was updated

    Object changed: Guild Onboarding
    """

    fun value(): U8 => 167
primitive HomeSettingsCreateAuditLogEvent is AuditLogEvent
    """
    Guild Server Guide was created
    """

    fun value(): U8 => 190
primitive HomeSettingsUpdateAuditLogEvent is AuditLogEvent
    """
    Guild Server Guide was updated
    """

    fun value(): U8 => 191
primitive VoiceChannelStatusCreateAuditLogEvent is AuditLogEvent
    """
    A voice channel status was set by a user
    """

    fun value(): U8 => 192
primitive VoiceChannelStatusDeleteAuditLogEvent is AuditLogEvent
    """
    A voice channel status was deleted by a user
    """

    fun value(): U8 => 193
primitive AuditLogEvents
    fun from(value: U8): AuditLogEvent ? =>
        match value
        | 1 => GuildUpdateAuditLogEvent
        | 10 => ChannelCreateAuditLogEvent
        | 11 => ChannelUpdateAuditLogEvent
        | 12 => ChannelDeleteAuditLogEvent
        | 13 => ChannelOverwriteCreateAuditLogEvent
        | 14 => ChannelOverwriteUpdateAuditLogEvent
        | 15 => ChannelOverwriteDeleteAuditLogEvent
        | 20 => MemberKickAuditLogEvent
        | 21 => MemberPruneAuditLogEvent
        | 22 => MemberBanAddAuditLogEvent
        | 23 => MemberBanRemoveAuditLogEvent
        | 24 => MemberUpdateAuditLogEvent
        | 25 => MemberRoleUpdateAuditLogEvent
        | 26 => MemberMoveAuditLogEvent
        | 27 => MemberDisconnectAuditLogEvent
        | 28 => BotAddAuditLogEvent
        | 30 => RoleCreateAuditLogEvent
        | 31 => RoleUpdateAuditLogEvent
        | 32 => RoleDeleteAuditLogEvent
        | 40 => InviteCreateAuditLogEvent
        | 41 => InviteUpdateAuditLogEvent
        | 42 => InviteDeleteAuditLogEvent
        | 50 => WebhookCreateAuditLogEvent
        | 51 => WebhookUpdateAuditLogEvent
        | 52 => WebhookDeleteAuditLogEvent
        | 60 => EmojiCreateAuditLogEvent
        | 61 => EmojiUpdateAuditLogEvent
        | 62 => EmojiDeleteAuditLogEvent
        | 72 => MessageDeleteAuditLogEvent
        | 73 => MessageBulkDeleteAuditLogEvent
        | 74 => MessagePinAuditLogEvent
        | 75 => MessageUnpinAuditLogEvent
        | 80 => IntegrationCreateAuditLogEvent
        | 81 => IntegrationUpdateAuditLogEvent
        | 82 => IntegrationDeleteAuditLogEvent
        | 83 => StageInstanceCreateAuditLogEvent
        | 84 => StageInstanceUpdateAuditLogEvent
        | 85 => StageInstanceDeleteAuditLogEvent
        | 90 => StickerCreateAuditLogEvent
        | 91 => StickerUpdateAuditLogEvent
        | 92 => StickerDeleteAuditLogEvent
        | 100 => GuildScheduledEventCreateAuditLogEvent
        | 101 => GuildScheduledEventUpdateAuditLogEvent
        | 102 => GuildScheduledEventDeleteAuditLogEvent
        | 110 => ThreadCreateAuditLogEvent
        | 111 => ThreadUpdateAuditLogEvent
        | 112 => ThreadDeleteAuditLogEvent
        | 121 => ApplicationCommandPermissionUpdateAuditLogEvent
        | 130 => SoundboardSoundCreateAuditLogEvent
        | 131 => SoundboardSoundUpdateAuditLogEvent
        | 132 => SoundboardSoundDeleteAuditLogEvent
        | 140 => AutoModerationRuleCreateAuditLogEvent
        | 141 => AutoModerationRuleUpdateAuditLogEvent
        | 142 => AutoModerationRuleDeleteAuditLogEvent
        | 143 => AutoModerationBlockMessageAuditLogEvent
        | 144 => AutoModerationFlagToChannelAuditLogEvent
        | 145 => AutoModerationUserCommunicationDisabledAuditLogEvent
        | 146 => AutoModerationQuarantineUserAuditLogEvent
        | 150 => CreatorMonetizationRequestCreatedAuditLogEvent
        | 151 => CreatorMonetizationTermsAcceptedAuditLogEvent
        | 163 => OnboardingPromptCreateAuditLogEvent
        | 164 => OnboardingPromptUpdateAuditLogEvent
        | 165 => OnboardingPromptDeleteAuditLogEvent
        | 166 => OnboardingCreateAuditLogEvent
        | 167 => OnboardingUpdateAuditLogEvent
        | 190 => HomeSettingsCreateAuditLogEvent
        | 191 => HomeSettingsUpdateAuditLogEvent
        | 192 => VoiceChannelStatusCreateAuditLogEvent
        | 193 => VoiceChannelStatusDeleteAuditLogEvent
        else error
        end
class val OptionalAuditEntryInfo is Jsonable
    """
    https://docs.discord.com/developers/resources/audit-log#audit-log-entry-object-optional-audit-entry-info
    """

    let application_id: (Snowflake | None)
        """
        ID of the app whose permissions were targeted

        Event types: APPLICATION_COMMAND_PERMISSION_UPDATE
        """

    let auto_moderation_rule_name: (String | None)
        """
        Name of the Auto Moderation rule that was triggered

        Event types: AUTO_MODERATION_BLOCK_MESSAGE & AUTO_MODERATION_FLAG_TO_CHANNEL & AUTO_MODERATION_USER_COMMUNICATION_DISABLED & AUTO_MODERATION_QUARANTINE_USER
        """

    let auto_moderation_rule_trigger_type: (String | None)
        """
        Trigger type of the Auto Moderation rule that was triggered

        Event types: AUTO_MODERATION_BLOCK_MESSAGE & AUTO_MODERATION_FLAG_TO_CHANNEL & AUTO_MODERATION_USER_COMMUNICATION_DISABLED & AUTO_MODERATION_QUARANTINE_USER
        """

    let channel_id: (Snowflake | None)
        """
        Channel in which the entities were targeted

        Event types: MEMBER_MOVE & MESSAGE_PIN & MESSAGE_UNPIN & MESSAGE_DELETE & STAGE_INSTANCE_CREATE & STAGE_INSTANCE_UPDATE & STAGE_INSTANCE_DELETE & AUTO_MODERATION_BLOCK_MESSAGE & AUTO_MODERATION_FLAG_TO_CHANNEL & AUTO_MODERATION_USER_COMMUNICATION_DISABLED & AUTO_MODERATION_QUARANTINE_USER & VOICE_CHANNEL_STATUS_CREATE & VOICE_CHANNEL_STATUS_DELETE
        """

    let count: (String | None)
        """
        Number of entities that were targeted

        Event types: MESSAGE_DELETE & MESSAGE_BULK_DELETE & MEMBER_DISCONNECT & MEMBER_MOVE
        """

    let delete_member_days: (String | None)
        """
        Number of days after which inactive members were kicked

        Event types: MEMBER_PRUNE
        """

    let id: (Snowflake | None)
        """
        ID of the overwritten entity

        Event types: CHANNEL_OVERWRITE_CREATE & CHANNEL_OVERWRITE_UPDATE & CHANNEL_OVERWRITE_DELETE
        """

    let members_removed: (String | None)
        """
        Number of members removed by the prune

        Event types: MEMBER_PRUNE
        """

    let message_id: (Snowflake | None)
        """
        ID of the message that was targeted

        Event types: MESSAGE_PIN & MESSAGE_UNPIN
        """

    let role_name: (String | None)
        """
        Name of the role if type is "0" (not present if type is "1")

        Event types: CHANNEL_OVERWRITE_CREATE & CHANNEL_OVERWRITE_UPDATE & CHANNEL_OVERWRITE_DELETE
        """

    let type': (String | None)
        """
        Type of overwritten entity - role ("0") or member ("1")

        Event types: CHANNEL_OVERWRITE_CREATE & CHANNEL_OVERWRITE_UPDATE & CHANNEL_OVERWRITE_DELETE
        """

    let integration_type: (String | None)
        """
        The type of integration which performed the action

        Event types: MEMBER_KICK & MEMBER_ROLE_UPDATE
        """

    let status: (String | None)
        """
        The new voice channel status

        Event types: VOICE_CHANNEL_STATUS_CREATE
        """

    new val from_json(obj: json.JsonObject) ? =>
        var application_id': (Snowflake | None) = None
        var auto_moderation_rule_name': (String | None) = None
        var auto_moderation_rule_trigger_type': (String | None) = None
        var channel_id': (Snowflake | None) = None
        var count': (String | None) = None
        var delete_member_days': (String | None) = None
        var id': (Snowflake | None) = None
        var members_removed': (String | None) = None
        var message_id': (Snowflake | None) = None
        var role_name': (String | None) = None
        var type'': (String | None) = None
        var integration_type': (String | None) = None
        var status': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "auto_moderation_rule_name" => auto_moderation_rule_name' = value as String
            | "auto_moderation_rule_trigger_type" => auto_moderation_rule_trigger_type' = value as String
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "count" => count' = value as String
            | "delete_member_days" => delete_member_days' = value as String
            | "id" => id' = Snowflake.from_json(value)?
            | "members_removed" => members_removed' = value as String
            | "message_id" => message_id' = Snowflake.from_json(value)?
            | "role_name" => role_name' = value as String
            | "type" => type'' = value as String
            | "integration_type" => integration_type' = value as String
            | "status" => status' = value as String
            end
        end

        application_id = application_id'
        auto_moderation_rule_name = auto_moderation_rule_name'
        auto_moderation_rule_trigger_type = auto_moderation_rule_trigger_type'
        channel_id = channel_id'
        count = count'
        delete_member_days = delete_member_days'
        id = id'
        members_removed = members_removed'
        message_id = message_id'
        role_name = role_name'
        type' = type''
        integration_type = integration_type'
        status = status'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match application_id
        | let application_id': Snowflake => obj = obj.update("application_id", application_id'.to_json())
        end

        match auto_moderation_rule_name
        | let auto_moderation_rule_name': String => obj = obj.update("auto_moderation_rule_name", auto_moderation_rule_name')
        end

        match auto_moderation_rule_trigger_type
        | let auto_moderation_rule_trigger_type': String => obj = obj.update("auto_moderation_rule_trigger_type", auto_moderation_rule_trigger_type')
        end

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match count
        | let count': String => obj = obj.update("count", count')
        end

        match delete_member_days
        | let delete_member_days': String => obj = obj.update("delete_member_days", delete_member_days')
        end

        match id
        | let id': Snowflake => obj = obj.update("id", id'.to_json())
        end

        match members_removed
        | let members_removed': String => obj = obj.update("members_removed", members_removed')
        end

        match message_id
        | let message_id': Snowflake => obj = obj.update("message_id", message_id'.to_json())
        end

        match role_name
        | let role_name': String => obj = obj.update("role_name", role_name')
        end

        match type'
        | let type'': String => obj = obj.update("type", type'')
        end

        match integration_type
        | let integration_type': String => obj = obj.update("integration_type", integration_type')
        end

        match status
        | let status': String => obj = obj.update("status", status')
        end

        obj

class val AuditLogChange is Jsonable
    """
    https://docs.discord.com/developers/resources/audit-log#audit-log-change-object-audit-log-change-structure

    Many audit log events include a changes array in their entry object. The structure for the individual changes varies based on the event type and its changed objects, so apps shouldn’t depend on a single pattern of handling audit log events.

    Some events don’t follow the same pattern as other audit log events. Details about these exceptions are explained in the next section.

    If new_value is not present in the change object while old_value is, it indicates that the property has been reset or set to null. If old_value isn’t included, it indicated that the property was previously null.

    Audit Log Change Exceptions

        For most objects, the change keys may be any field on the changed object. The following table details the exceptions to this pattern.

        Command Permission
            Change key exceptions: snowflake as key
            Change object exceptions: The changes array contains objects with a key field representing the entity whose command was affected (role, channel, or user ID), a previous permissions object (with an old_value key), and an updated permissions object (with a new_value key)

        Invite and Invite Metadata
            Change key exceptions: Additional channel_id key (instead of object’s channel.id)

        Partial Role
            Change key exceptions: $add and $remove as keys
            Change object exceptions: new_value is an array of objects that contain the role id and name

        Webhook
            Change key exceptions: avatar_hash key (instead of avatar)
    """

    let new_value: json.JsonValue
        """
        New value of the key

        The value matches the type of the field on the changed object, so it is left undecoded. An absent value and a null value are both represented as `None`.
        """

    let old_value: json.JsonValue
        """
        Old value of the key

        The value matches the type of the field on the changed object, so it is left undecoded. An absent value and a null value are both represented as `None`.
        """

    let key: String
        """
        Name of the changed entity, with a few exceptions
        """

    new val from_json(obj: json.JsonObject) ? =>
        var new_value': json.JsonValue = None
        var old_value': json.JsonValue = None
        var key': (String | None) = None

        // The loop variable cannot be named `key`, as the name is taken by the field of the same name.
        for (field, value) in obj.pairs() do
            match field
            | "new_value" => new_value' = value
            | "old_value" => old_value' = value
            | "key" => key' = value as String
            end
        end

        new_value = new_value'
        old_value = old_value'
        key = key' as String

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("key", key)

        if new_value isnt None then obj = obj.update("new_value", new_value) end

        if old_value isnt None then obj = obj.update("old_value", old_value) end

        obj

primitive _AuditLogChanges
    fun apply(value: json.JsonValue): Array[AuditLogChange] val ? =>
        """
        Decodes an array of audit log changes.
        """

        let array = value as json.JsonArray
        recover val
            let changes = Array[AuditLogChange](array.size())
            for change in array.values() do changes.push(AuditLogChange.from_json(change as json.JsonObject)?) end
            changes
        end

    fun to_json(changes: Array[AuditLogChange] val): json.JsonArray =>
        var array = json.JsonArray
        for change in changes.values() do array = array.push(change.to_json()) end
        array

class val GetAuditLogParams
    """
    https://docs.discord.com/developers/resources/audit-log#get-guild-audit-log-query-string-params

    The returned list of audit log entries is ordered based on whether `before` or `after` is used.
    """

    let user_id: (Snowflake | None)
        """
        Entries from a specific user ID
        """

    let action_type: (AuditLogEvent | None)
        """
        Entries for a specific audit log event
        """

    let before: (Snowflake | None)
        """
        Entries with ID less than a specific audit log entry ID
        """

    let after: (Snowflake | None)
        """
        Entries with ID greater than a specific audit log entry ID
        """

    let limit: (USize | None)
        """
        Maximum number of entries (between 1-100) to return, defaults to 50
        """

    new val create(
        user_id': (Snowflake | None) = None,
        action_type': (AuditLogEvent | None) = None,
        before': (Snowflake | None) = None,
        after': (Snowflake | None) = None,
        limit': (USize | None) = None
    ) =>
        user_id = user_id'
        action_type = action_type'
        before = before'
        after = after'
        limit = limit'

    fun to_query(): RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match user_id
        | let user_id': Snowflake => query.push(("user_id", user_id'.string()))
        end

        match action_type
        | let action_type': AuditLogEvent => query.push(("action_type", action_type'.value().string()))
        end

        match before
        | let before': Snowflake => query.push(("before", before'.string()))
        end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query
