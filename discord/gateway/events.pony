use "../data"
use "collections"
use "debug"

type GatewayEventHandler[A: Any val] is {(A): (Bool | None)} val

type GatewayEmptyEventHandler is {(): (Bool | None)} val

trait _Removable
    fun ref remove(handler: Any val)

    fun ref clear()

class _Listeners[A: Any val] is _Removable
    embed _order: List[GatewayEventHandler[A]] = List[GatewayEventHandler[A]]
    embed _index: MapIs[Any val, ListNode[GatewayEventHandler[A]]] =
        MapIs[Any val, ListNode[GatewayEventHandler[A]]]

    fun ref add(handler: GatewayEventHandler[A]) =>
        if _index.contains(handler) then return end
        let node = ListNode[GatewayEventHandler[A]](handler)
        _order.append_node(node)
        _index(handler) = node
        Debug.out(
            "[gateway/events] a listener was added, " + _order.size().string()
            + " now on this event"
        )

    fun ref remove(handler: Any val) =>
        try
            (_index.remove(handler)?._2).remove()
            Debug.out(
                "[gateway/events] a listener was removed, "
                + _order.size().string()
                + " now on this event"
            )
        end

    fun ref clear() =>
        _index.clear()
        _order.clear()

    fun ref apply(event: A) =>
        Debug.out(
            "[gateway/events] running " + _order.size().string()
            + " listener(s)"
        )
        let spent = Array[GatewayEventHandler[A]]
        for handler in _order.values() do
            let keep =
                match handler(event) | let keep': Bool => keep' else true end
            if not keep then spent.push(handler) end
        end
        for handler in spent.values() do remove(handler) end

class _EmptyListeners is _Removable
    embed _order: List[GatewayEmptyEventHandler] =
        List[GatewayEmptyEventHandler]
    embed _index: MapIs[Any val, ListNode[GatewayEmptyEventHandler]] =
        MapIs[Any val, ListNode[GatewayEmptyEventHandler]]

    fun ref add(handler: GatewayEmptyEventHandler) =>
        if _index.contains(handler) then return end
        let node = ListNode[GatewayEmptyEventHandler](handler)
        _order.append_node(node)
        _index(handler) = node
        Debug.out(
            "[gateway/events] a listener was added, " + _order.size().string()
            + " now on this event"
        )

    fun ref remove(handler: Any val) =>
        try
            (_index.remove(handler)?._2).remove()
            Debug.out(
                "[gateway/events] a listener was removed, "
                + _order.size().string()
                + " now on this event"
            )
        end

    fun ref clear() =>
        _index.clear()
        _order.clear()

    fun ref apply() =>
        Debug.out(
            "[gateway/events] running " + _order.size().string()
            + " listener(s)"
        )
        let spent = Array[GatewayEmptyEventHandler]
        for handler in _order.values() do
            let keep = match handler() | let keep': Bool => keep' else true end
            if not keep then spent.push(handler) end
        end
        for handler in spent.values() do remove(handler) end

actor Events
    let _api: GatewayApi

    embed _ready: _Listeners[GatewayReady] = _Listeners[GatewayReady]
    embed _resumed: _EmptyListeners = _EmptyListeners
    embed _rate_limited: _Listeners[GatewayRateLimited] =
        _Listeners[GatewayRateLimited]
    embed _application_command_permissions_update: _Listeners[
        GuildApplicationCommandPermissions
    ] =
        _Listeners[GuildApplicationCommandPermissions]
    embed _auto_moderation_rule_create: _Listeners[AutoModerationRule] =
        _Listeners[AutoModerationRule]
    embed _auto_moderation_rule_update: _Listeners[AutoModerationRule] =
        _Listeners[AutoModerationRule]
    embed _auto_moderation_rule_delete: _Listeners[AutoModerationRule] =
        _Listeners[AutoModerationRule]
    embed _auto_moderation_action_execution: _Listeners[
        AutoModerationActionExecution
    ] =
        _Listeners[AutoModerationActionExecution]
    embed _channel_create: _Listeners[Channel] = _Listeners[Channel]
    embed _channel_update: _Listeners[Channel] = _Listeners[Channel]
    embed _channel_delete: _Listeners[Channel] = _Listeners[Channel]
    embed _channel_info: _Listeners[ChannelInfo] = _Listeners[ChannelInfo]
    embed _channel_pins_update: _Listeners[ChannelPinsUpdate] =
        _Listeners[ChannelPinsUpdate]
    embed _thread_create: _Listeners[ThreadCreate] = _Listeners[ThreadCreate]
    embed _thread_update: _Listeners[Channel] = _Listeners[Channel]
    embed _thread_delete: _Listeners[ThreadDelete] = _Listeners[ThreadDelete]
    embed _thread_list_sync: _Listeners[ThreadListSync] =
        _Listeners[ThreadListSync]
    embed _thread_member_update: _Listeners[ThreadMemberUpdate] =
        _Listeners[ThreadMemberUpdate]
    embed _thread_members_update: _Listeners[ThreadMembersUpdate] =
        _Listeners[ThreadMembersUpdate]
    embed _entitlement_create: _Listeners[Entitlement] = _Listeners[Entitlement]
    embed _entitlement_update: _Listeners[Entitlement] = _Listeners[Entitlement]
    embed _entitlement_delete: _Listeners[Entitlement] = _Listeners[Entitlement]
    embed _guild_create: _Listeners[(GuildCreate | UnavailableGuild)] =
        _Listeners[(GuildCreate | UnavailableGuild)]
    embed _guild_update: _Listeners[Guild] = _Listeners[Guild]
    embed _guild_delete: _Listeners[UnavailableGuild] =
        _Listeners[UnavailableGuild]
    embed _guild_audit_log_entry_create: _Listeners[GuildAuditLogEntryCreate] =
        _Listeners[GuildAuditLogEntryCreate]
    embed _guild_ban_add: _Listeners[GuildBanAdd] = _Listeners[GuildBanAdd]
    embed _guild_ban_remove: _Listeners[GuildBanRemove] =
        _Listeners[GuildBanRemove]
    embed _guild_emojis_update: _Listeners[GuildEmojisUpdate] =
        _Listeners[GuildEmojisUpdate]
    embed _guild_stickers_update: _Listeners[GuildStickersUpdate] =
        _Listeners[GuildStickersUpdate]
    embed _guild_integrations_update: _Listeners[GuildIntegrationsUpdate] =
        _Listeners[GuildIntegrationsUpdate]
    embed _guild_member_add: _Listeners[GuildMemberAdd] =
        _Listeners[GuildMemberAdd]
    embed _guild_member_remove: _Listeners[GuildMemberRemove] =
        _Listeners[GuildMemberRemove]
    embed _guild_member_update: _Listeners[GuildMemberUpdate] =
        _Listeners[GuildMemberUpdate]
    embed _guild_members_chunk: _Listeners[GuildMembersChunk] =
        _Listeners[GuildMembersChunk]
    embed _guild_role_create: _Listeners[GuildRoleCreate] =
        _Listeners[GuildRoleCreate]
    embed _guild_role_update: _Listeners[GuildRoleUpdate] =
        _Listeners[GuildRoleUpdate]
    embed _guild_role_delete: _Listeners[GuildRoleDelete] =
        _Listeners[GuildRoleDelete]
    embed _guild_scheduled_event_create: _Listeners[GuildScheduledEvent] =
        _Listeners[GuildScheduledEvent]
    embed _guild_scheduled_event_update: _Listeners[GuildScheduledEvent] =
        _Listeners[GuildScheduledEvent]
    embed _guild_scheduled_event_delete: _Listeners[GuildScheduledEvent] =
        _Listeners[GuildScheduledEvent]
    embed _guild_scheduled_event_user_add: _Listeners[
        GuildScheduledEventUserAdd
    ] =
        _Listeners[GuildScheduledEventUserAdd]
    embed _guild_scheduled_event_user_remove: _Listeners[
        GuildScheduledEventUserRemove
    ] =
        _Listeners[GuildScheduledEventUserRemove]
    embed _guild_soundboard_sound_create: _Listeners[SoundboardSound] =
        _Listeners[SoundboardSound]
    embed _guild_soundboard_sound_update: _Listeners[SoundboardSound] =
        _Listeners[SoundboardSound]
    embed _guild_soundboard_sound_delete: _Listeners[
        GuildSoundboardSoundDelete
    ] =
        _Listeners[GuildSoundboardSoundDelete]
    embed _guild_soundboard_sounds_update: _Listeners[
        GuildSoundboardSoundsUpdate
    ] =
        _Listeners[GuildSoundboardSoundsUpdate]
    embed _soundboard_sounds: _Listeners[SoundboardSounds] =
        _Listeners[SoundboardSounds]
    embed _integration_create: _Listeners[IntegrationCreate] =
        _Listeners[IntegrationCreate]
    embed _integration_update: _Listeners[IntegrationUpdate] =
        _Listeners[IntegrationUpdate]
    embed _integration_delete: _Listeners[IntegrationDelete] =
        _Listeners[IntegrationDelete]
    embed _interaction_create: _Listeners[Interaction] = _Listeners[Interaction]
    embed _invite_create: _Listeners[InviteCreate] = _Listeners[InviteCreate]
    embed _invite_delete: _Listeners[InviteDelete] = _Listeners[InviteDelete]
    embed _message_create: _Listeners[MessageCreate] = _Listeners[MessageCreate]
    embed _message_update: _Listeners[MessageUpdate] = _Listeners[MessageUpdate]
    embed _message_delete: _Listeners[MessageDelete] = _Listeners[MessageDelete]
    embed _message_delete_bulk: _Listeners[MessageDeleteBulk] =
        _Listeners[MessageDeleteBulk]
    embed _message_reaction_add: _Listeners[MessageReactionAdd] =
        _Listeners[MessageReactionAdd]
    embed _message_reaction_remove: _Listeners[MessageReactionRemove] =
        _Listeners[MessageReactionRemove]
    embed _message_reaction_remove_all: _Listeners[MessageReactionRemoveAll] =
        _Listeners[MessageReactionRemoveAll]
    embed _message_reaction_remove_emoji: _Listeners[
        MessageReactionRemoveEmoji
    ] =
        _Listeners[MessageReactionRemoveEmoji]
    embed _message_poll_vote_add: _Listeners[MessagePollVoteAdd] =
        _Listeners[MessagePollVoteAdd]
    embed _message_poll_vote_remove: _Listeners[MessagePollVoteRemove] =
        _Listeners[MessagePollVoteRemove]
    embed _presence_update: _Listeners[Presence] = _Listeners[Presence]
    embed _stage_instance_create: _Listeners[StageInstance] =
        _Listeners[StageInstance]
    embed _stage_instance_update: _Listeners[StageInstance] =
        _Listeners[StageInstance]
    embed _stage_instance_delete: _Listeners[StageInstance] =
        _Listeners[StageInstance]
    embed _subscription_create: _Listeners[Subscription] =
        _Listeners[Subscription]
    embed _subscription_update: _Listeners[Subscription] =
        _Listeners[Subscription]
    embed _subscription_delete: _Listeners[Subscription] =
        _Listeners[Subscription]
    embed _typing_start: _Listeners[TypingStart] = _Listeners[TypingStart]
    embed _user_update: _Listeners[User] = _Listeners[User]
    embed _voice_channel_effect_send: _Listeners[VoiceChannelEffectSend] =
        _Listeners[VoiceChannelEffectSend]
    embed _voice_channel_status_update: _Listeners[VoiceChannelStatusUpdate] =
        _Listeners[VoiceChannelStatusUpdate]
    embed _voice_channel_start_time_update: _Listeners[
        VoiceChannelStartTimeUpdate
    ] =
        _Listeners[VoiceChannelStartTimeUpdate]
    embed _voice_state_update: _Listeners[VoiceState] = _Listeners[VoiceState]
    embed _voice_server_update: _Listeners[VoiceServerUpdate] =
        _Listeners[VoiceServerUpdate]
    embed _webhooks_update: _Listeners[WebhooksUpdate] =
        _Listeners[WebhooksUpdate]

    embed _all: Array[_Removable] = Array[_Removable]

    new create(api: GatewayApi) =>
        _api = api

        _all.push(_ready)
        _all.push(_resumed)
        _all.push(_rate_limited)
        _all.push(_application_command_permissions_update)
        _all.push(_auto_moderation_rule_create)
        _all.push(_auto_moderation_rule_update)
        _all.push(_auto_moderation_rule_delete)
        _all.push(_auto_moderation_action_execution)
        _all.push(_channel_create)
        _all.push(_channel_update)
        _all.push(_channel_delete)
        _all.push(_channel_info)
        _all.push(_channel_pins_update)
        _all.push(_thread_create)
        _all.push(_thread_update)
        _all.push(_thread_delete)
        _all.push(_thread_list_sync)
        _all.push(_thread_member_update)
        _all.push(_thread_members_update)
        _all.push(_entitlement_create)
        _all.push(_entitlement_update)
        _all.push(_entitlement_delete)
        _all.push(_guild_create)
        _all.push(_guild_update)
        _all.push(_guild_delete)
        _all.push(_guild_audit_log_entry_create)
        _all.push(_guild_ban_add)
        _all.push(_guild_ban_remove)
        _all.push(_guild_emojis_update)
        _all.push(_guild_stickers_update)
        _all.push(_guild_integrations_update)
        _all.push(_guild_member_add)
        _all.push(_guild_member_remove)
        _all.push(_guild_member_update)
        _all.push(_guild_members_chunk)
        _all.push(_guild_role_create)
        _all.push(_guild_role_update)
        _all.push(_guild_role_delete)
        _all.push(_guild_scheduled_event_create)
        _all.push(_guild_scheduled_event_update)
        _all.push(_guild_scheduled_event_delete)
        _all.push(_guild_scheduled_event_user_add)
        _all.push(_guild_scheduled_event_user_remove)
        _all.push(_guild_soundboard_sound_create)
        _all.push(_guild_soundboard_sound_update)
        _all.push(_guild_soundboard_sound_delete)
        _all.push(_guild_soundboard_sounds_update)
        _all.push(_soundboard_sounds)
        _all.push(_integration_create)
        _all.push(_integration_update)
        _all.push(_integration_delete)
        _all.push(_interaction_create)
        _all.push(_invite_create)
        _all.push(_invite_delete)
        _all.push(_message_create)
        _all.push(_message_update)
        _all.push(_message_delete)
        _all.push(_message_delete_bulk)
        _all.push(_message_reaction_add)
        _all.push(_message_reaction_remove)
        _all.push(_message_reaction_remove_all)
        _all.push(_message_reaction_remove_emoji)
        _all.push(_message_poll_vote_add)
        _all.push(_message_poll_vote_remove)
        _all.push(_presence_update)
        _all.push(_stage_instance_create)
        _all.push(_stage_instance_update)
        _all.push(_stage_instance_delete)
        _all.push(_subscription_create)
        _all.push(_subscription_update)
        _all.push(_subscription_delete)
        _all.push(_typing_start)
        _all.push(_user_update)
        _all.push(_voice_channel_effect_send)
        _all.push(_voice_channel_status_update)
        _all.push(_voice_channel_start_time_update)
        _all.push(_voice_state_update)
        _all.push(_voice_server_update)
        _all.push(_webhooks_update)

    be off(handler: Any val) =>
        for listeners in _all.values() do listeners.remove(handler) end

    be clear() =>
        for listeners in _all.values() do listeners.clear() end

    be request_guild_members(event: GatewayRequestGuildMembersEvent) =>
        Debug.out("[gateway/events] requesting guild members")
        _api.send_message(event)

    be request_soundboard_sounds(event: GatewayRequestSoundboardSoundsEvent) =>
        Debug.out("[gateway/events] requesting soundboard sounds")
        _api.send_message(event)

    be request_channel_info(event: GatewayRequestChannelInfoEvent) =>
        Debug.out("[gateway/events] requesting channel info")
        _api.send_message(event)

    be update_voice_state(event: GatewayVoiceStateUpdateEvent) =>
        Debug.out("[gateway/events] updating our voice state")
        _api.send_message(event)

    be update_presence(event: GatewayPresenceUpdateEvent) =>
        Debug.out("[gateway/events] updating our presence")
        _api.send_message(event)

    be on_ready(handler: GatewayEventHandler[GatewayReady]) =>
        _ready.add(handler)

    be on_resumed(handler: GatewayEmptyEventHandler) =>
        _resumed.add(handler)

    be on_rate_limited(handler: GatewayEventHandler[GatewayRateLimited]) =>
        _rate_limited.add(handler)

    be on_application_command_permissions_update(
        handler: GatewayEventHandler[GuildApplicationCommandPermissions]
    ) =>
        _application_command_permissions_update.add(handler)

    be on_auto_moderation_rule_create(
        handler: GatewayEventHandler[AutoModerationRule]
    ) =>
        _auto_moderation_rule_create.add(handler)

    be on_auto_moderation_rule_update(
        handler: GatewayEventHandler[AutoModerationRule]
    ) =>
        _auto_moderation_rule_update.add(handler)

    be on_auto_moderation_rule_delete(
        handler: GatewayEventHandler[AutoModerationRule]
    ) =>
        _auto_moderation_rule_delete.add(handler)

    be on_auto_moderation_action_execution(
        handler: GatewayEventHandler[AutoModerationActionExecution]
    ) =>
        _auto_moderation_action_execution.add(handler)

    be on_channel_create(handler: GatewayEventHandler[Channel]) =>
        _channel_create.add(handler)

    be on_channel_update(handler: GatewayEventHandler[Channel]) =>
        _channel_update.add(handler)

    be on_channel_delete(handler: GatewayEventHandler[Channel]) =>
        _channel_delete.add(handler)

    be on_channel_info(handler: GatewayEventHandler[ChannelInfo]) =>
        _channel_info.add(handler)

    be on_channel_pins_update(
        handler: GatewayEventHandler[ChannelPinsUpdate]
    ) =>
        _channel_pins_update.add(handler)

    be on_thread_create(handler: GatewayEventHandler[ThreadCreate]) =>
        _thread_create.add(handler)

    be on_thread_update(handler: GatewayEventHandler[Channel]) =>
        _thread_update.add(handler)

    be on_thread_delete(handler: GatewayEventHandler[ThreadDelete]) =>
        _thread_delete.add(handler)

    be on_thread_list_sync(handler: GatewayEventHandler[ThreadListSync]) =>
        _thread_list_sync.add(handler)

    be on_thread_member_update(
        handler: GatewayEventHandler[ThreadMemberUpdate]
    ) =>
        _thread_member_update.add(handler)

    be on_thread_members_update(
        handler: GatewayEventHandler[ThreadMembersUpdate]
    ) =>
        _thread_members_update.add(handler)

    be on_entitlement_create(handler: GatewayEventHandler[Entitlement]) =>
        _entitlement_create.add(handler)

    be on_entitlement_update(handler: GatewayEventHandler[Entitlement]) =>
        _entitlement_update.add(handler)

    be on_entitlement_delete(handler: GatewayEventHandler[Entitlement]) =>
        _entitlement_delete.add(handler)

    be on_guild_create(
        handler: GatewayEventHandler[(GuildCreate | UnavailableGuild)]
    ) =>
        _guild_create.add(handler)

    be on_guild_update(handler: GatewayEventHandler[Guild]) =>
        _guild_update.add(handler)

    be on_guild_delete(handler: GatewayEventHandler[UnavailableGuild]) =>
        _guild_delete.add(handler)

    be on_guild_audit_log_entry_create(
        handler: GatewayEventHandler[GuildAuditLogEntryCreate]
    ) =>
        _guild_audit_log_entry_create.add(handler)

    be on_guild_ban_add(handler: GatewayEventHandler[GuildBanAdd]) =>
        _guild_ban_add.add(handler)

    be on_guild_ban_remove(handler: GatewayEventHandler[GuildBanRemove]) =>
        _guild_ban_remove.add(handler)

    be on_guild_emojis_update(
        handler: GatewayEventHandler[GuildEmojisUpdate]
    ) =>
        _guild_emojis_update.add(handler)

    be on_guild_stickers_update(
        handler: GatewayEventHandler[GuildStickersUpdate]
    ) =>
        _guild_stickers_update.add(handler)

    be on_guild_integrations_update(
        handler: GatewayEventHandler[GuildIntegrationsUpdate]
    ) =>
        _guild_integrations_update.add(handler)

    be on_guild_member_add(handler: GatewayEventHandler[GuildMemberAdd]) =>
        _guild_member_add.add(handler)

    be on_guild_member_remove(
        handler: GatewayEventHandler[GuildMemberRemove]
    ) =>
        _guild_member_remove.add(handler)

    be on_guild_member_update(
        handler: GatewayEventHandler[GuildMemberUpdate]
    ) =>
        _guild_member_update.add(handler)

    be on_guild_members_chunk(
        handler: GatewayEventHandler[GuildMembersChunk]
    ) =>
        _guild_members_chunk.add(handler)

    be on_guild_role_create(handler: GatewayEventHandler[GuildRoleCreate]) =>
        _guild_role_create.add(handler)

    be on_guild_role_update(handler: GatewayEventHandler[GuildRoleUpdate]) =>
        _guild_role_update.add(handler)

    be on_guild_role_delete(handler: GatewayEventHandler[GuildRoleDelete]) =>
        _guild_role_delete.add(handler)

    be on_guild_scheduled_event_create(
        handler: GatewayEventHandler[GuildScheduledEvent]
    ) =>
        _guild_scheduled_event_create.add(handler)

    be on_guild_scheduled_event_update(
        handler: GatewayEventHandler[GuildScheduledEvent]
    ) =>
        _guild_scheduled_event_update.add(handler)

    be on_guild_scheduled_event_delete(
        handler: GatewayEventHandler[GuildScheduledEvent]
    ) =>
        _guild_scheduled_event_delete.add(handler)

    be on_guild_scheduled_event_user_add(
        handler: GatewayEventHandler[GuildScheduledEventUserAdd]
    ) =>
        _guild_scheduled_event_user_add.add(handler)

    be on_guild_scheduled_event_user_remove(
        handler: GatewayEventHandler[GuildScheduledEventUserRemove]
    ) =>
        _guild_scheduled_event_user_remove.add(handler)

    be on_guild_soundboard_sound_create(
        handler: GatewayEventHandler[SoundboardSound]
    ) =>
        _guild_soundboard_sound_create.add(handler)

    be on_guild_soundboard_sound_update(
        handler: GatewayEventHandler[SoundboardSound]
    ) =>
        _guild_soundboard_sound_update.add(handler)

    be on_guild_soundboard_sound_delete(
        handler: GatewayEventHandler[GuildSoundboardSoundDelete]
    ) =>
        _guild_soundboard_sound_delete.add(handler)

    be on_guild_soundboard_sounds_update(
        handler: GatewayEventHandler[GuildSoundboardSoundsUpdate]
    ) =>
        _guild_soundboard_sounds_update.add(handler)

    be on_soundboard_sounds(handler: GatewayEventHandler[SoundboardSounds]) =>
        _soundboard_sounds.add(handler)

    be on_integration_create(handler: GatewayEventHandler[IntegrationCreate]) =>
        _integration_create.add(handler)

    be on_integration_update(handler: GatewayEventHandler[IntegrationUpdate]) =>
        _integration_update.add(handler)

    be on_integration_delete(handler: GatewayEventHandler[IntegrationDelete]) =>
        _integration_delete.add(handler)

    be on_interaction_create(handler: GatewayEventHandler[Interaction]) =>
        _interaction_create.add(handler)

    be on_invite_create(handler: GatewayEventHandler[InviteCreate]) =>
        _invite_create.add(handler)

    be on_invite_delete(handler: GatewayEventHandler[InviteDelete]) =>
        _invite_delete.add(handler)

    be on_message_create(handler: GatewayEventHandler[MessageCreate]) =>
        _message_create.add(handler)

    be on_message_update(handler: GatewayEventHandler[MessageUpdate]) =>
        _message_update.add(handler)

    be on_message_delete(handler: GatewayEventHandler[MessageDelete]) =>
        _message_delete.add(handler)

    be on_message_delete_bulk(
        handler: GatewayEventHandler[MessageDeleteBulk]
    ) =>
        _message_delete_bulk.add(handler)

    be on_message_reaction_add(
        handler: GatewayEventHandler[MessageReactionAdd]
    ) =>
        _message_reaction_add.add(handler)

    be on_message_reaction_remove(
        handler: GatewayEventHandler[MessageReactionRemove]
    ) =>
        _message_reaction_remove.add(handler)

    be on_message_reaction_remove_all(
        handler: GatewayEventHandler[MessageReactionRemoveAll]
    ) =>
        _message_reaction_remove_all.add(handler)

    be on_message_reaction_remove_emoji(
        handler: GatewayEventHandler[MessageReactionRemoveEmoji]
    ) =>
        _message_reaction_remove_emoji.add(handler)

    be on_message_poll_vote_add(
        handler: GatewayEventHandler[MessagePollVoteAdd]
    ) =>
        _message_poll_vote_add.add(handler)

    be on_message_poll_vote_remove(
        handler: GatewayEventHandler[MessagePollVoteRemove]
    ) =>
        _message_poll_vote_remove.add(handler)

    be on_presence_update(handler: GatewayEventHandler[Presence]) =>
        _presence_update.add(handler)

    be on_stage_instance_create(handler: GatewayEventHandler[StageInstance]) =>
        _stage_instance_create.add(handler)

    be on_stage_instance_update(handler: GatewayEventHandler[StageInstance]) =>
        _stage_instance_update.add(handler)

    be on_stage_instance_delete(handler: GatewayEventHandler[StageInstance]) =>
        _stage_instance_delete.add(handler)

    be on_subscription_create(handler: GatewayEventHandler[Subscription]) =>
        _subscription_create.add(handler)

    be on_subscription_update(handler: GatewayEventHandler[Subscription]) =>
        _subscription_update.add(handler)

    be on_subscription_delete(handler: GatewayEventHandler[Subscription]) =>
        _subscription_delete.add(handler)

    be on_typing_start(handler: GatewayEventHandler[TypingStart]) =>
        _typing_start.add(handler)

    be on_user_update(handler: GatewayEventHandler[User]) =>
        _user_update.add(handler)

    be on_voice_channel_effect_send(
        handler: GatewayEventHandler[VoiceChannelEffectSend]
    ) =>
        _voice_channel_effect_send.add(handler)

    be on_voice_channel_status_update(
        handler: GatewayEventHandler[VoiceChannelStatusUpdate]
    ) =>
        _voice_channel_status_update.add(handler)

    be on_voice_channel_start_time_update(
        handler: GatewayEventHandler[VoiceChannelStartTimeUpdate]
    ) =>
        _voice_channel_start_time_update.add(handler)

    be on_voice_state_update(handler: GatewayEventHandler[VoiceState]) =>
        _voice_state_update.add(handler)

    be on_voice_server_update(
        handler: GatewayEventHandler[VoiceServerUpdate]
    ) =>
        _voice_server_update.add(handler)

    be on_webhooks_update(handler: GatewayEventHandler[WebhooksUpdate]) =>
        _webhooks_update.add(handler)

    be _dispatch(name: String, data: GatewayDispatchEventData) =>
        Debug.out("[gateway/events] dispatching " + name)

        try
            match name
            | "READY" => _ready(data as GatewayReady)
            | "RESUMED" => _resumed()
            | "RATE_LIMITED" => _rate_limited(data as GatewayRateLimited)
            | "APPLICATION_COMMAND_PERMISSIONS_UPDATE" =>
                _application_command_permissions_update(
                    data as GuildApplicationCommandPermissions
                )
            | "AUTO_MODERATION_RULE_CREATE" =>
                _auto_moderation_rule_create(data as AutoModerationRule)
            | "AUTO_MODERATION_RULE_UPDATE" =>
                _auto_moderation_rule_update(data as AutoModerationRule)
            | "AUTO_MODERATION_RULE_DELETE" =>
                _auto_moderation_rule_delete(data as AutoModerationRule)
            | "AUTO_MODERATION_ACTION_EXECUTION" =>
                _auto_moderation_action_execution(
                    data as AutoModerationActionExecution
                )
            | "CHANNEL_CREATE" => _channel_create(data as Channel)
            | "CHANNEL_UPDATE" => _channel_update(data as Channel)
            | "CHANNEL_DELETE" => _channel_delete(data as Channel)
            | "CHANNEL_INFO" => _channel_info(data as ChannelInfo)
            | "CHANNEL_PINS_UPDATE" =>
                _channel_pins_update(data as ChannelPinsUpdate)
            | "THREAD_CREATE" => _thread_create(data as ThreadCreate)
            | "THREAD_UPDATE" => _thread_update(data as Channel)
            | "THREAD_DELETE" => _thread_delete(data as ThreadDelete)
            | "THREAD_LIST_SYNC" => _thread_list_sync(data as ThreadListSync)
            | "THREAD_MEMBER_UPDATE" =>
                _thread_member_update(data as ThreadMemberUpdate)
            | "THREAD_MEMBERS_UPDATE" =>
                _thread_members_update(data as ThreadMembersUpdate)
            | "ENTITLEMENT_CREATE" => _entitlement_create(data as Entitlement)
            | "ENTITLEMENT_UPDATE" => _entitlement_update(data as Entitlement)
            | "ENTITLEMENT_DELETE" => _entitlement_delete(data as Entitlement)
            | "GUILD_CREATE" =>
                _guild_create(data as (GuildCreate | UnavailableGuild))
            | "GUILD_UPDATE" => _guild_update(data as Guild)
            | "GUILD_DELETE" => _guild_delete(data as UnavailableGuild)
            | "GUILD_AUDIT_LOG_ENTRY_CREATE" =>
                _guild_audit_log_entry_create(data as GuildAuditLogEntryCreate)
            | "GUILD_BAN_ADD" => _guild_ban_add(data as GuildBanAdd)
            | "GUILD_BAN_REMOVE" => _guild_ban_remove(data as GuildBanRemove)
            | "GUILD_EMOJIS_UPDATE" =>
                _guild_emojis_update(data as GuildEmojisUpdate)
            | "GUILD_STICKERS_UPDATE" =>
                _guild_stickers_update(data as GuildStickersUpdate)
            | "GUILD_INTEGRATIONS_UPDATE" =>
                _guild_integrations_update(data as GuildIntegrationsUpdate)
            | "GUILD_MEMBER_ADD" => _guild_member_add(data as GuildMemberAdd)
            | "GUILD_MEMBER_REMOVE" =>
                _guild_member_remove(data as GuildMemberRemove)
            | "GUILD_MEMBER_UPDATE" =>
                _guild_member_update(data as GuildMemberUpdate)
            | "GUILD_MEMBERS_CHUNK" =>
                _guild_members_chunk(data as GuildMembersChunk)
            | "GUILD_ROLE_CREATE" => _guild_role_create(data as GuildRoleCreate)
            | "GUILD_ROLE_UPDATE" => _guild_role_update(data as GuildRoleUpdate)
            | "GUILD_ROLE_DELETE" => _guild_role_delete(data as GuildRoleDelete)
            | "GUILD_SCHEDULED_EVENT_CREATE" =>
                _guild_scheduled_event_create(data as GuildScheduledEvent)
            | "GUILD_SCHEDULED_EVENT_UPDATE" =>
                _guild_scheduled_event_update(data as GuildScheduledEvent)
            | "GUILD_SCHEDULED_EVENT_DELETE" =>
                _guild_scheduled_event_delete(data as GuildScheduledEvent)
            | "GUILD_SCHEDULED_EVENT_USER_ADD" =>
                _guild_scheduled_event_user_add(
                    data as GuildScheduledEventUserAdd
                )
            | "GUILD_SCHEDULED_EVENT_USER_REMOVE" =>
                _guild_scheduled_event_user_remove(
                    data as GuildScheduledEventUserRemove
                )
            | "GUILD_SOUNDBOARD_SOUND_CREATE" =>
                _guild_soundboard_sound_create(data as SoundboardSound)
            | "GUILD_SOUNDBOARD_SOUND_UPDATE" =>
                _guild_soundboard_sound_update(data as SoundboardSound)
            | "GUILD_SOUNDBOARD_SOUND_DELETE" =>
                _guild_soundboard_sound_delete(
                    data as GuildSoundboardSoundDelete
                )
            | "GUILD_SOUNDBOARD_SOUNDS_UPDATE" =>
                _guild_soundboard_sounds_update(
                    data as GuildSoundboardSoundsUpdate
                )
            | "SOUNDBOARD_SOUNDS" =>
                _soundboard_sounds(data as SoundboardSounds)
            | "INTEGRATION_CREATE" =>
                _integration_create(data as IntegrationCreate)
            | "INTEGRATION_UPDATE" =>
                _integration_update(data as IntegrationUpdate)
            | "INTEGRATION_DELETE" =>
                _integration_delete(data as IntegrationDelete)
            | "INTERACTION_CREATE" => _interaction_create(data as Interaction)
            | "INVITE_CREATE" => _invite_create(data as InviteCreate)
            | "INVITE_DELETE" => _invite_delete(data as InviteDelete)
            | "MESSAGE_CREATE" => _message_create(data as MessageCreate)
            | "MESSAGE_UPDATE" => _message_update(data as MessageUpdate)
            | "MESSAGE_DELETE" => _message_delete(data as MessageDelete)
            | "MESSAGE_DELETE_BULK" =>
                _message_delete_bulk(data as MessageDeleteBulk)
            | "MESSAGE_REACTION_ADD" =>
                _message_reaction_add(data as MessageReactionAdd)
            | "MESSAGE_REACTION_REMOVE" =>
                _message_reaction_remove(data as MessageReactionRemove)
            | "MESSAGE_REACTION_REMOVE_ALL" =>
                _message_reaction_remove_all(data as MessageReactionRemoveAll)
            | "MESSAGE_REACTION_REMOVE_EMOJI" =>
                _message_reaction_remove_emoji(
                    data as MessageReactionRemoveEmoji
                )
            | "MESSAGE_POLL_VOTE_ADD" =>
                _message_poll_vote_add(data as MessagePollVoteAdd)
            | "MESSAGE_POLL_VOTE_REMOVE" =>
                _message_poll_vote_remove(data as MessagePollVoteRemove)
            | "PRESENCE_UPDATE" => _presence_update(data as Presence)
            | "STAGE_INSTANCE_CREATE" =>
                _stage_instance_create(data as StageInstance)
            | "STAGE_INSTANCE_UPDATE" =>
                _stage_instance_update(data as StageInstance)
            | "STAGE_INSTANCE_DELETE" =>
                _stage_instance_delete(data as StageInstance)
            | "SUBSCRIPTION_CREATE" =>
                _subscription_create(data as Subscription)
            | "SUBSCRIPTION_UPDATE" =>
                _subscription_update(data as Subscription)
            | "SUBSCRIPTION_DELETE" =>
                _subscription_delete(data as Subscription)
            | "TYPING_START" => _typing_start(data as TypingStart)
            | "USER_UPDATE" => _user_update(data as User)
            | "VOICE_CHANNEL_EFFECT_SEND" =>
                _voice_channel_effect_send(data as VoiceChannelEffectSend)
            | "VOICE_CHANNEL_STATUS_UPDATE" =>
                _voice_channel_status_update(data as VoiceChannelStatusUpdate)
            | "VOICE_CHANNEL_START_TIME_UPDATE" =>
                _voice_channel_start_time_update(
                    data as VoiceChannelStartTimeUpdate
                )
            | "VOICE_STATE_UPDATE" => _voice_state_update(data as VoiceState)
            | "VOICE_SERVER_UPDATE" =>
                _voice_server_update(data as VoiceServerUpdate)
            | "WEBHOOKS_UPDATE" => _webhooks_update(data as WebhooksUpdate)
            else
                Debug.out("[gateway/events] " + name + " has no listener slot")
            end
        else
            Debug.out(
                "[gateway/events] " + name
                + " arrived carrying data of the wrong type"
            )
        end
