use "data"
use courier = "courier"
use json = "json"

type Reason is String

actor Routes
    let api: RestApi
    let options: RestOptions

    new create(api': RestApi, options': RestOptions) =>
        api = api'
        options = options'

    be get_application_role_connection_metadata(application_id: Snowflake, handler: ResponseHandler[Array[ApplicationRoleConnectionMetadata] val]) =>
        """
        https://docs.discord.com/developers/resources/application-role-connection-metadata#get-application-role-connection-metadata-records

        Returns a list of application role connection metadata objects for the given application.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/role-connections/metadata"), _Decode.list[ApplicationRoleConnectionMetadata](handler, options.on_error))

    be update_application_role_connection_metadata(application_id: Snowflake, application_role_connection_metadata: Array[ApplicationRoleConnectionMetadata] val, handler: ResponseHandler[Array[ApplicationRoleConnectionMetadata] val]) =>
        """
        https://docs.discord.com/developers/resources/application-role-connection-metadata#update-application-role-connection-metadata-records

        Updates and returns a list of application role connection metadata objects for the given application.
        """

        var records = json.JsonArray
        for record in application_role_connection_metadata.values() do records = records.push(record.to_json()) end

        api.send_request(options.build_request(courier.PUT, "/applications/" + application_id.string() + "/role-connections/metadata" where body = json.JsonPrinter.print(records)), _Decode.list[ApplicationRoleConnectionMetadata](handler, options.on_error))

    be get_application(handler: ResponseHandler[Application]) =>
        """
        https://docs.discord.com/developers/resources/application#get-current-application

        Returns the application object associated with the requesting bot user.
        """

        api.send_request(options.build_request(courier.GET, "/applications/@me"), _Decode.entity[Application](handler, options.on_error))

    be update_application(params: UpdateApplicationParams, handler: ResponseHandler[Application]) =>
        """
        https://docs.discord.com/developers/resources/application#edit-current-application

        Edit properties of the app associated with the requesting bot user. Only properties that are passed will be updated. Returns the updated application object on success.
        """

        api.send_request(options.build_request(courier.PATCH, "/applications/@me" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Application](handler, options.on_error))

    be get_application_activity_instance(application_id: Snowflake, activity_instance_id: Snowflake, handler: ResponseHandler[ActivityInstance]) =>
        """
        https://docs.discord.com/developers/resources/application#get-application-activity-instance

        Returns a serialized activity instance, if it exists. Useful for preventing unwanted activity sessions.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/activity-instances/" + activity_instance_id.string()), _Decode.entity[ActivityInstance](handler, options.on_error))

    be get_audit_log(guild_id: Snowflake, params: GetAuditLogParams, handler: ResponseHandler[AuditLog]) =>
        """
        https://docs.discord.com/developers/resources/audit-log#get-guild-audit-log

        Returns an audit log object for the guild. Requires the VIEW_AUDIT_LOG permission.

        The returned list of audit log entries is ordered based on whether you use before or after. When using before, the list is ordered by the audit log entry ID descending (newer entries first). If after is used, the list is reversed and appears in ascending order (older entries first). Omitting both before and after defaults to before the current timestamp and will show the most recent entries in descending order by ID, the opposite can be achieved using after=0 (showing oldest entries).
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/audit-logs" where query = params.to_query()), _Decode.entity[AuditLog](handler, options.on_error))

    be get_auto_moderation_rules(guild_id: Snowflake, handler: ResponseHandler[Array[AutoModerationRule] val]) =>
        """
        https://docs.discord.com/developers/resources/auto-moderation#list-auto-moderation-rules-for-guild

        Get a list of all rules currently configured for the guild. Returns a list of auto moderation rule objects for the given guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/auto-moderation/rules"), _Decode.list[AutoModerationRule](handler, options.on_error))

    be get_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake, handler: ResponseHandler[AutoModerationRule]) =>
        """
        https://docs.discord.com/developers/resources/auto-moderation#get-auto-moderation-rule

        Get a single rule. Returns an auto moderation rule object.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string()), _Decode.entity[AutoModerationRule](handler, options.on_error))

    be create_auto_moderation_rule(guild_id: Snowflake, params: CreateAutoModerationRuleParams, handler: ResponseHandler[AutoModerationRule], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/auto-moderation#create-auto-moderation-rule

        Create a new rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Create Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/auto-moderation/rules" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[AutoModerationRule](handler, options.on_error))

    be update_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake, params: UpdateAutoModerationRuleParams, handler: ResponseHandler[AutoModerationRule], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/auto-moderation#modify-auto-moderation-rule

        Modify an existing rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Update Gateway event.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[AutoModerationRule](handler, options.on_error))

    be delete_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/auto-moderation#delete-auto-moderation-rule

        Delete a rule. Returns a 204 on success. Fires an Auto Moderation Rule Delete Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_channel(channel_id: Snowflake, handler: ResponseHandler[Channel]) =>
        """
        https://docs.discord.com/developers/resources/channel#get-channel

        Get a channel by ID. Returns a channel object. If the channel is a thread, a thread member object is included in the returned result.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string()), _Decode.entity[Channel](handler, options.on_error))

    be update_channel(channel_id: Snowflake, params: UpdateChannelParams, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#modify-channel

        Update a channel’s settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters.
        """

        api.send_request(options.build_request(courier.PATCH, "/channels/" + channel_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be set_voice_channel_status(channel_id: Snowflake, params: SetVoiceChannelStatusParams, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#set-voice-channel-status

        Set a voice channel’s status. Requires the SET_VOICE_CHANNEL_STATUS permission, and additionally the MANAGE_CHANNELS permission if the current user is not connected to the voice channel. Fires a Voice Channel Status Update Gateway event.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/voice-status" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.empty(handler, options.on_error))

    be delete_channel(channel_id: Snowflake, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#delete/close-channel

        Delete a channel, or close a private message. Requires the MANAGE_CHANNELS permission for the guild, or MANAGE_THREADS if the channel is a thread. Deleting a category does not delete its child channels; they will have their parent_id removed and a Channel Update Gateway event will fire for each of them. Returns a channel object on success. Fires a Channel Delete Gateway event (or Thread Delete if the channel was a thread).
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() where reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be update_channel_permissions(channel_id: Snowflake, permission_overwrite_id: Snowflake, params: UpdateChannelPermissionsParams, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#edit-channel-permissions

        Edit the channel permission overwrites for a user or role in a channel. Only usable for guild channels. Requires the MANAGE_ROLES permission. Only permissions your bot has in the guild or parent channel (if applicable) can be allowed/denied (unless your bot has a MANAGE_ROLES overwrite in the channel). Returns a 204 empty response on success. Fires a Channel Update Gateway event. For more information about permissions, see permissions.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/permissions/" + permission_overwrite_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.empty(handler, options.on_error))

    be get_channel_invites(channel_id: Snowflake, handler: ResponseHandler[Array[Invite] val]) =>
        """
        https://docs.discord.com/developers/resources/channel#get-channel-invites

        Returns a list of invite objects (with invite metadata) for the channel. Only usable for guild channels. Requires the MANAGE_CHANNELS permission.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/invites"), _Decode.list[Invite](handler, options.on_error))

    be create_channel_invite(channel_id: Snowflake, params: CreateChannelInviteParams, handler: ResponseHandler[Invite], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#create-channel-invite

        Create a new invite object for the channel. Only usable for guild channels. Requires the CREATE_INSTANT_INVITE permission. All JSON parameters for this route are optional, however the request body is not. If you are not sending any fields, you still have to send an empty JSON object ({}). Returns an invite object. Fires an Invite Create Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/invites" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Invite](handler, options.on_error))

    be delete_channel_permission_overwrite(channel_id: Snowflake, permission_overwrite_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#delete-channel-permission

        Delete a channel permission overwrite for a user or role in a channel. Only usable for guild channels. Requires the MANAGE_ROLES permission. Returns a 204 empty response on success. Fires a Channel Update Gateway event. For more information about permissions, see permissions
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/permissions/" + permission_overwrite_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be follow_announcement_channel(channel_id: Snowflake, params: FollowAnnouncementChannelParams, handler: ResponseHandler[FollowedChannel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#follow-announcement-channel

        Follow an Announcement Channel to send messages to a target channel. Requires the MANAGE_WEBHOOKS permission in the target channel. Returns a followed channel object. Fires a Webhooks Update Gateway event for the target channel.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/followers" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[FollowedChannel](handler, options.on_error))

    be trigger_typing_indicator(channel_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#trigger-typing-indicator

        Post a typing indicator for the specified channel, which expires after 10 seconds. Returns a 204 empty response on success. Fires a Typing Start Gateway event.

        Generally bots should not use this route. However, if a bot is responding to a command and expects the computation to take a few seconds, this endpoint may be called to let the user know that the bot is processing their message.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/typing"), _Decode.empty(handler, options.on_error))

    be add_group_dm_recipient(channel_id: Snowflake, user_id: Snowflake, params: AddGroupDMRecipientParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#group-dm-add-recipient

        Adds a recipient to a Group DM using their access token.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/recipients/" + user_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be remove_group_dm_recipient(channel_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#group-dm-remove-recipient

        Removes a recipient from a Group DM.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/recipients/" + user_id.string()), _Decode.empty(handler, options.on_error))

    be start_thread_from_message(channel_id: Snowflake, message_id: Snowflake, params: StartThreadFromMessageParams, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#start-thread-from-message

        Creates a new thread from an existing message. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. Fires a Thread Create and a Message Update Gateway event.

        When called on a GUILD_TEXT channel, creates a PUBLIC_THREAD. When called on a GUILD_ANNOUNCEMENT channel, creates a ANNOUNCEMENT_THREAD. Does not work on a GUILD_FORUM or a GUILD_MEDIA channel. The id of the created thread will be the same as the id of the source message, and as such a message can only have a single thread created from it.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/threads" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be start_thread_without_message(channel_id: Snowflake, params: StartThreadWithoutMessageParams, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#start-thread-without-message

        Creates a new thread that is not connected to an existing message. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. Fires a Thread Create Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/threads" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be start_thread_in_forum_or_media_channel(channel_id: Snowflake, params: StartThreadInForumOrMediaChannelParams, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/channel#start-thread-in-forum-or-media-channel

        Creates a new thread in a forum or a media channel, and sends a message within the created thread. Returns a channel, with a nested message object, on success, and a 400 BAD REQUEST on invalid parameters. Fires a Thread Create and Message Create Gateway event.
        - The type of the created thread is PUBLIC_THREAD.
        - See message formatting for more information on how to properly format messages.
        - The current user must have the SEND_MESSAGES permission (CREATE_PUBLIC_THREADS is ignored).
        - The maximum request size when sending a message is 25 MiB.
        - For the embed object, you can set every field except type (it will be rich regardless of if you try to set it), provider, video, and any height, width, or proxy_url values for images.
        - Examples for file uploads are available in Uploading Files.
        - Files must be attached using a multipart/form-data body as described in Uploading Files.
        - Note that when sending a message, you must provide a value for at least one of content, embeds, sticker_ids, components, or files[n].
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/threads" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be join_thread(channel_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#join-thread

        Adds the current user to a thread. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update and a Thread Create Gateway event.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/thread-members/@me"), _Decode.empty(handler, options.on_error))

    be add_thread_member(channel_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#add-thread-member

        Adds another member to a thread. Requires the ability to send messages in the thread. Also requires the thread is not archived. Returns a 204 empty response if the member is successfully added or was already a member of the thread. Fires a Thread Members Update Gateway event.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/thread-members/" + user_id.string()), _Decode.empty(handler, options.on_error))

    be leave_thread(channel_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#leave-thread

        Removes the current user from a thread. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/thread-members/@me"), _Decode.empty(handler, options.on_error))

    be remove_thread_member(channel_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/channel#remove-thread-member

        Removes another member from a thread. Requires the MANAGE_THREADS permission, or the creator of the thread if it is a PRIVATE_THREAD. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/thread-members/" + user_id.string()), _Decode.empty(handler, options.on_error))

    be get_thread_member(channel_id: Snowflake, user_id: Snowflake, params: GetThreadMemberParams, handler: ResponseHandler[ThreadMember]) =>
        """
        https://docs.discord.com/developers/resources/channel#get-thread-member

        Returns a thread member object for the specified user if they are a member of the thread, returns a 404 response otherwise.

        When with_member is set to true, the thread member object will include a member field containing a guild member object.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/thread-members/" + user_id.string() where query = params.to_query()), _Decode.entity[ThreadMember](handler, options.on_error))

    be get_thread_members(channel_id: Snowflake, params: GetThreadMembersParams, handler: ResponseHandler[Array[ThreadMember] val]) =>
        """
        https://docs.discord.com/developers/resources/channel#list-thread-members

        Returns array of thread members objects that are members of the thread.

        When with_member is set to true, the results will be paginated and each thread member object will include a member field containing a guild member object.

        This endpoint is restricted according to whether the GUILD_MEMBERS Privileged Intent is enabled for your application. Without it Discord answers 403 Missing Access, even for a thread the bot is itself a member of.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/thread-members" where query = params.to_query()), _Decode.list[ThreadMember](handler, options.on_error))

    be get_public_archived_threads(channel_id: Snowflake, params: GetPublicArchivedThreadsParams, handler: ResponseHandler[ArchivedThreads]) =>
        """
        https://docs.discord.com/developers/resources/channel#list-public-archived-threads

        Returns archived threads in the channel that are public. When called on a GUILD_TEXT channel, returns threads of type PUBLIC_THREAD. When called on a GUILD_ANNOUNCEMENT channel returns threads of type ANNOUNCEMENT_THREAD. Threads are ordered by archive_timestamp, in descending order. Requires the READ_MESSAGE_HISTORY permission.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/threads/archived/public" where query = params.to_query()), _Decode.entity[ArchivedThreads](handler, options.on_error))

    be get_private_archived_threads(channel_id: Snowflake, params: GetPrivateArchivedThreadsParams, handler: ResponseHandler[ArchivedThreads]) =>
        """
        https://docs.discord.com/developers/resources/channel#list-private-archived-threads

        Returns archived threads in the channel that are of type PRIVATE_THREAD. Threads are ordered by archive_timestamp, in descending order. Requires both the READ_MESSAGE_HISTORY and MANAGE_THREADS permissions.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/threads/archived/private" where query = params.to_query()), _Decode.entity[ArchivedThreads](handler, options.on_error))

    be get_joined_private_archived_threads(channel_id: Snowflake, params: GetJoinedPrivateArchivedThreadsParams, handler: ResponseHandler[ArchivedThreads]) =>
        """
        https://docs.discord.com/developers/resources/channel#list-joined-private-archived-threads

        Returns archived threads in the channel that are of type PRIVATE_THREAD, and the user has joined. Threads are ordered by their id, in descending order. Requires the READ_MESSAGE_HISTORY permission.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/users/@me/threads/archived/private" where query = params.to_query()), _Decode.entity[ArchivedThreads](handler, options.on_error))

    be get_guild_emojis(guild_id: Snowflake, handler: ResponseHandler[Array[Emoji] val]) =>
        """
        https://docs.discord.com/developers/resources/emoji#list-guild-emojis

        Returns a list of emoji objects for the given guild. Includes user fields if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/emojis"), _Decode.list[Emoji](handler, options.on_error))

    be get_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake, handler: ResponseHandler[Emoji]) =>
        """
        https://docs.discord.com/developers/resources/emoji#get-guild-emoji

        Returns an emoji object for the given guild and emoji IDs. Includes the user field if the bot has the MANAGE_GUILD_EXPRESSIONS permission, or if the bot created the emoji and has the CREATE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string()), _Decode.entity[Emoji](handler, options.on_error))

    be create_guild_emoji(guild_id: Snowflake, params: CreateGuildEmojiParams, handler: ResponseHandler[Emoji], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/emoji#create-guild-emoji

        Create a new emoji for the guild. Requires the CREATE_GUILD_EXPRESSIONS permission. Returns the new emoji object on success. Fires a Guild Emojis Update Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/emojis" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Emoji](handler, options.on_error))

    be update_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake, params: UpdateGuildEmojiParams, handler: ResponseHandler[Emoji], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/emoji#modify-guild-emoji

        Modify the given emoji. For emojis created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other emojis, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns the updated emoji object on success. Fires a Guild Emojis Update Gateway event.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Emoji](handler, options.on_error))

    be delete_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/emoji#delete-guild-emoji

        Delete the given emoji. For emojis created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other emojis, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns 204 No Content on success. Fires a Guild Emojis Update Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_application_emojis(application_id: Snowflake, handler: ResponseHandler[Array[Emoji] val]) =>
        """
        https://docs.discord.com/developers/resources/emoji#list-application-emojis

        Returns an object containing a list of emoji objects for the given application under the items key. Includes a user object for the team member that uploaded the emoji from the app’s settings, or for the bot user if uploaded using the API.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/emojis"), _Decode.wrapped[Emoji](handler, "items", options.on_error))

    be get_application_emoji(application_id: Snowflake, emoji_id: Snowflake, handler: ResponseHandler[Emoji]) =>
        """
        https://docs.discord.com/developers/resources/emoji#get-application-emoji

        Returns an emoji object for the given application and emoji IDs. Includes the user field.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/emojis/" + emoji_id.string()), _Decode.entity[Emoji](handler, options.on_error))

    be create_application_emoji(application_id: Snowflake, params: CreateApplicationEmojiParams, handler: ResponseHandler[Emoji]) =>
        """
        https://docs.discord.com/developers/resources/emoji#create-application-emoji

        Create a new emoji for the application. Returns the new emoji object on success.
        """

        api.send_request(options.build_request(courier.POST, "/applications/" + application_id.string() + "/emojis" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Emoji](handler, options.on_error))

    be update_application_emoji(application_id: Snowflake, emoji_id: Snowflake, params: UpdateApplicationEmojiParams, handler: ResponseHandler[Emoji]) =>
        """
        https://docs.discord.com/developers/resources/emoji#modify-application-emoji

        Modify the given emoji. Returns the updated emoji object on success.
        """

        api.send_request(options.build_request(courier.PATCH, "/applications/" + application_id.string() + "/emojis/" + emoji_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Emoji](handler, options.on_error))

    be delete_application_emoji(application_id: Snowflake, emoji_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/emoji#delete-application-emoji

        Delete the given emoji. Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/applications/" + application_id.string() + "/emojis/" + emoji_id.string()), _Decode.empty(handler, options.on_error))

    be get_entitlements(application_id: Snowflake, params: GetEntitlementsParams, handler: ResponseHandler[Array[Entitlement] val]) =>
        """
        https://docs.discord.com/developers/resources/entitlement#list-entitlements

        Returns all entitlements for a given app, active and expired.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/entitlements" where query = params.to_query()), _Decode.list[Entitlement](handler, options.on_error))

    be get_entitlement(application_id: Snowflake, entitlement_id: Snowflake, handler: ResponseHandler[Entitlement]) =>
        """
        https://docs.discord.com/developers/resources/entitlement#get-entitlement

        Returns an entitlement.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/entitlements/" + entitlement_id.string()), _Decode.entity[Entitlement](handler, options.on_error))

    be consume_entitlement(application_id: Snowflake, entitlement_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/entitlement#consume-an-entitlement

        For One-Time Purchase consumable SKUs, marks a given entitlement for the user as consumed. The entitlement will have consumed: true when using List Entitlements.

        Returns a 204 No Content on success.
        """

        api.send_request(options.build_request(courier.POST, "/applications/" + application_id.string() + "/entitlements/" + entitlement_id.string() + "/consume"), _Decode.empty(handler, options.on_error))

    be create_test_entitlement(application_id: Snowflake, params: CreateTestEntitlementParams, handler: ResponseHandler[Entitlement]) =>
        """
        https://docs.discord.com/developers/resources/entitlement#create-test-entitlement

        Creates a test entitlement to a given SKU for a given guild or user. Discord will act as though that user or guild has entitlement to your premium offering.

        This endpoint returns a partial entitlement object. It will not contain subscription_id, starts_at, or ends_at, as it's valid in perpetuity.

        After creating a test entitlement, you'll need to reload your Discord client. After doing so, you'll see that your server or user now has premium access.
        """

        api.send_request(options.build_request(courier.POST, "/applications/" + application_id.string() + "/entitlements" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Entitlement](handler, options.on_error))

    be delete_test_entitlement(application_id: Snowflake, entitlement_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/entitlement#delete-test-entitlement

        Deletes a currently-active test entitlement. Discord will act as though that user or guild _no longer has_ entitlement to your premium offering.

        Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/applications/" + application_id.string() + "/entitlements/" + entitlement_id.string()), _Decode.empty(handler, options.on_error))

    be get_guild(guild_id: Snowflake, params: GetGuildParams, handler: ResponseHandler[Guild]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild

        Returns the guild object for the given id. If with_counts is set to true, this endpoint will also return approximate_member_count and approximate_presence_count for the guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() where query = params.to_query()), _Decode.entity[Guild](handler, options.on_error))

    be get_guild_preview(guild_id: Snowflake, handler: ResponseHandler[GuildPreview]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-preview

        Returns the guild preview object for the given id.
        If the user is not in the guild, then the guild must be discoverable.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/preview"), _Decode.entity[GuildPreview](handler, options.on_error))

    be update_guild(guild_id: Snowflake, params: UpdateGuildParams, handler: ResponseHandler[Guild], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild

        Modify a guild's settings. Requires the MANAGE_GUILD permission. Returns the updated guild object on success. Fires a Guild Update Gateway event.

        All parameters to this endpoint are optional.

        This endpoint supports the X-Audit-Log-Reason header.

        Attempting to add or remove the COMMUNITY guild feature requires the ADMINISTRATOR permission.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Guild](handler, options.on_error))

    be get_guild_channels(guild_id: Snowflake, handler: ResponseHandler[Array[Channel] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-channels

        Returns a list of guild channel objects. Does not include threads.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/channels"), _Decode.list[Channel](handler, options.on_error))

    be create_guild_channel(guild_id: Snowflake, params: CreateGuildChannelParams, handler: ResponseHandler[Channel], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#create-guild-channel

        Create a new channel object for the guild. Requires the MANAGE_CHANNELS permission. If setting permission overwrites, only permissions your bot has in the guild can be allowed/denied. Setting MANAGE_ROLES permission in channels is only possible for guild administrators. Returns the new channel object on success. Fires a Channel Create Gateway event.

        All parameters to this endpoint are optional and nullable excluding name.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/channels" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Channel](handler, options.on_error))

    be update_guild_channel_positions(guild_id: Snowflake, params: UpdateGuildChannelPositionsParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-channel-positions

        Modify the positions of a set of channel objects for the guild. Requires MANAGE_CHANNELS permission. Returns a 204 empty response on success. Fires multiple Channel Update Gateway events.

        Only channels to be modified are required.

        This endpoint takes a JSON array of parameters in the following format:
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/channels" where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be get_active_guild_threads(guild_id: Snowflake, handler: ResponseHandler[ActiveThreads]) =>
        """
        https://docs.discord.com/developers/resources/guild#list-active-guild-threads

        Returns all active threads in the guild, including public and private threads. Threads are ordered by their id, in descending order.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/threads/active"), _Decode.entity[ActiveThreads](handler, options.on_error))

    be get_guild_member(guild_id: Snowflake, user_id: Snowflake, handler: ResponseHandler[GuildMember]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-member

        Returns a guild member object for the specified user.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/members/" + user_id.string()), _Decode.entity[GuildMember](handler, options.on_error))

    be get_guild_members(guild_id: Snowflake, params: GetGuildMembersParams, handler: ResponseHandler[Array[GuildMember] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#list-guild-members

        Returns a list of guild member objects that are members of the guild.

        This endpoint requires the GUILD_MEMBERS Privileged Intent.

        All parameters to this endpoint are optional.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/members" where query = params.to_query()), _Decode.list[GuildMember](handler, options.on_error))

    be search_guild_members(guild_id: Snowflake, params: SearchGuildMembersParams, handler: ResponseHandler[Array[GuildMember] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#search-guild-members

        Returns a list of guild member objects whose username or nickname starts with a provided string.

        All parameters to this endpoint except for query are optional
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/members/search" where query = params.to_query()), _Decode.list[GuildMember](handler, options.on_error))

    be add_guild_member(guild_id: Snowflake, user_id: Snowflake, params: AddGuildMemberParams, handler: ResponseHandler[GuildMember]) =>
        """
        https://docs.discord.com/developers/resources/guild#add-guild-member

        Adds a user to the guild, provided you have a valid oauth2 access token for the user with the guilds.join scope. Returns a 201 Created with the guild member as the body, or 204 No Content if the user is already a member of the guild. Fires a Guild Member Add Gateway event.

        For guilds with Membership Screening enabled, this endpoint will default to adding new members as pending in the guild member object. Members that are pending will have to complete membership screening before they become full members that can talk.

        All parameters to this endpoint except for access_token are optional.

        The Authorization header must be a Bot token (belonging to the same application used for authorization), and the bot must be a member of the guild with CREATE_INSTANT_INVITE permission.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/members/" + user_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[GuildMember](handler, options.on_error))

    be update_guild_member(guild_id: Snowflake, user_id: Snowflake, params: UpdateGuildMemberParams, handler: ResponseHandler[GuildMember], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-member

        Modify attributes of a guild member. Returns a 200 OK with the guild member as the body. Fires a Guild Member Update Gateway event. If the channel_id is set to null, this will force the target user to be disconnected from voice.

        All parameters to this endpoint are optional and nullable. When moving members to channels, the API user _must_ have permissions to both connect to the channel and have the MOVE_MEMBERS permission.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/members/" + user_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildMember](handler, options.on_error))

    be update_current_member(guild_id: Snowflake, params: UpdateCurrentMemberParams, handler: ResponseHandler[GuildMember], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-current-member

        Modifies the current member in a guild. Returns a 200 with the updated member object on success. Fires a Guild Member Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/members/@me" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildMember](handler, options.on_error))

    be update_current_user_nick(guild_id: Snowflake, params: UpdateCurrentUserNickParams, handler: ResponseHandler[CurrentUserNick], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-current-user-nick

        Deprecated in favor of Modify Current Member.

        Modifies the nickname of the current user in a guild. Returns a 200 with the nickname on success. Fires a Guild Member Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/members/@me/nick" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[CurrentUserNick](handler, options.on_error))

    be add_guild_member_role(guild_id: Snowflake, user_id: Snowflake, role_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#add-guild-member-role

        Adds a role to a guild member. Requires the MANAGE_ROLES permission. Returns a 204 empty response on success. Fires a Guild Member Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/members/" + user_id.string() + "/roles/" + role_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be remove_guild_member_role(guild_id: Snowflake, user_id: Snowflake, role_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#remove-guild-member-role

        Removes a role from a guild member. Requires the MANAGE_ROLES permission. Returns a 204 empty response on success. Fires a Guild Member Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/members/" + user_id.string() + "/roles/" + role_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be remove_guild_member(guild_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#remove-guild-member

        Remove a member from a guild. Requires KICK_MEMBERS permission. Returns a 204 empty response on success. Fires a Guild Member Remove Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/members/" + user_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_guild_bans(guild_id: Snowflake, params: GetGuildBansParams, handler: ResponseHandler[Array[Ban] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-bans

        Returns a list of ban objects for the users banned from this guild. Requires the BAN_MEMBERS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/bans" where query = params.to_query()), _Decode.list[Ban](handler, options.on_error))

    be get_guild_ban(guild_id: Snowflake, user_id: Snowflake, handler: ResponseHandler[Ban]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-ban

        Returns a ban object for the given user or a 404 not found if the ban cannot be found. Requires the BAN_MEMBERS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/bans/" + user_id.string()), _Decode.entity[Ban](handler, options.on_error))

    be create_guild_ban(guild_id: Snowflake, user_id: Snowflake, params: CreateGuildBanParams, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#create-guild-ban

        Create a guild ban, and optionally delete previous messages sent by the banned user. Requires the BAN_MEMBERS permission. Returns a 204 empty response on success. Fires a Guild Ban Add Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/bans/" + user_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.empty(handler, options.on_error))

    be remove_guild_ban(guild_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#remove-guild-ban

        Remove the ban for a user. Requires the BAN_MEMBERS permissions. Returns a 204 empty response on success. Fires a Guild Ban Remove Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/bans/" + user_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be bulk_guild_ban(guild_id: Snowflake, params: BulkGuildBanParams, handler: ResponseHandler[BulkBanResponse], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#bulk-guild-ban

        Ban up to 200 users from a guild, and optionally delete previous messages sent by the banned users. Requires both the BAN_MEMBERS and MANAGE_GUILD permissions. Returns a 200 response on success, including the fields banned_users with the IDs of the banned users and failed_users with IDs that could not be banned or were already banned.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/bulk-ban" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[BulkBanResponse](handler, options.on_error))

    be get_guild_roles(guild_id: Snowflake, handler: ResponseHandler[Array[Role] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-roles

        Returns a list of role objects for the guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/roles"), _Decode.list[Role](handler, options.on_error))

    be get_guild_role(guild_id: Snowflake, role_id: Snowflake, handler: ResponseHandler[Role]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-role

        Returns a role object for the specified role.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/roles/" + role_id.string()), _Decode.entity[Role](handler, options.on_error))

    be get_guild_role_member_counts(guild_id: Snowflake, handler: ResponseHandler[GuildRoleMemberCounts]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-role-member-counts

        Returns a map of role IDs to the number of members with the role. Does not include the @everyone role.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/roles/member-counts"), _Decode.entity[GuildRoleMemberCounts](handler, options.on_error))

    be create_guild_role(guild_id: Snowflake, params: CreateGuildRoleParams, handler: ResponseHandler[Role], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#create-guild-role

        Create a new role for the guild. Requires the MANAGE_ROLES permission. Returns the new role object on success. Fires a Guild Role Create Gateway event. All JSON params are optional.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/roles" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Role](handler, options.on_error))

    be update_guild_role_positions(guild_id: Snowflake, params: UpdateGuildRolePositionsParams, handler: ResponseHandler[Array[Role] val], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-role-positions

        Modify the positions of a set of role objects for the guild. Requires the MANAGE_ROLES permission. Returns a list of all of the guild's role objects on success. Fires multiple Guild Role Update Gateway events.

        This endpoint supports the X-Audit-Log-Reason header.

        This endpoint takes a JSON array of parameters in the following format:
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/roles" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.list[Role](handler, options.on_error))

    be update_guild_role(guild_id: Snowflake, role_id: Snowflake, params: UpdateGuildRoleParams, handler: ResponseHandler[Role], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-role

        Modify a guild role. Requires the MANAGE_ROLES permission. Returns the updated role on success. Fires a Guild Role Update Gateway event.

        All parameters to this endpoint are optional and nullable.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/roles/" + role_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Role](handler, options.on_error))

    be delete_guild_role(guild_id: Snowflake, role_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#delete-guild-role

        Delete a guild role. Requires the MANAGE_ROLES permission. Returns a 204 empty response on success. Fires a Guild Role Delete Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/roles/" + role_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_guild_prune_count(guild_id: Snowflake, params: GetGuildPruneCountParams, handler: ResponseHandler[GuildPruneCount]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-prune-count

        Returns an object with one pruned key indicating the number of members that would be removed in a prune operation. Requires the MANAGE_GUILD and KICK_MEMBERS permissions.

        By default, prune will not remove users with roles. You can optionally include specific roles in your prune by providing the include_roles parameter. Any inactive user that has a subset of the provided role(s) will be counted in the prune and users with additional roles will not.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/prune" where query = params.to_query()), _Decode.entity[GuildPruneCount](handler, options.on_error))

    be begin_guild_prune(guild_id: Snowflake, params: BeginGuildPruneParams, handler: ResponseHandler[GuildPruneCount], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#begin-guild-prune

        Begin a prune operation. Requires the MANAGE_GUILD and KICK_MEMBERS permissions. Returns an object with one pruned key indicating the number of members that were removed in the prune operation. For large guilds it's recommended to set the compute_prune_count option to false, forcing pruned to null. Fires multiple Guild Member Remove Gateway events.

        By default, prune will not remove users with roles. You can optionally include specific roles in your prune by providing the include_roles parameter. Any inactive user that has a subset of the provided role(s) will be included in the prune and users with additional roles will not.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/prune" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildPruneCount](handler, options.on_error))

    be get_guild_voice_regions(guild_id: Snowflake, handler: ResponseHandler[Array[VoiceRegion] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-voice-regions

        Returns a list of voice region objects for the guild. Unlike the similar /voice route, this returns VIP servers when the guild is VIP-enabled.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/regions"), _Decode.list[VoiceRegion](handler, options.on_error))

    be get_guild_invites(guild_id: Snowflake, handler: ResponseHandler[Array[Invite] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-invites

        Returns a list of invite objects. Requires the MANAGE_GUILD or VIEW_AUDIT_LOG permission. Invite Metadata is included with the MANAGE_GUILD permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/invites"), _Decode.list[Invite](handler, options.on_error))

    be get_guild_integrations(guild_id: Snowflake, handler: ResponseHandler[Array[Integration] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-integrations

        Returns a list of integration objects for the guild. Requires the MANAGE_GUILD permission.

        This endpoint returns a maximum of 50 integrations. If a guild has more integrations, they cannot be accessed.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/integrations"), _Decode.list[Integration](handler, options.on_error))

    be delete_guild_integration(guild_id: Snowflake, integration_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#delete-guild-integration

        Delete the attached integration object for the guild. Deletes any associated webhooks and kicks the associated bot if there is one. Requires the MANAGE_GUILD permission. Returns a 204 empty response on success. Fires Guild Integrations Update and Integration Delete Gateway events.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/integrations/" + integration_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_guild_widget_settings(guild_id: Snowflake, handler: ResponseHandler[GuildWidgetSettings]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-widget-settings

        Returns a guild widget settings object. Requires the MANAGE_GUILD permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/widget"), _Decode.entity[GuildWidgetSettings](handler, options.on_error))

    be update_guild_widget(guild_id: Snowflake, params: UpdateGuildWidgetParams, handler: ResponseHandler[GuildWidgetSettings], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-widget

        Modify a guild widget settings object for the guild. All attributes may be passed in with JSON and modified. Requires the MANAGE_GUILD permission. Returns the updated guild widget settings object. Fires a Guild Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/widget" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildWidgetSettings](handler, options.on_error))

    be get_guild_widget(guild_id: Snowflake, handler: ResponseHandler[GuildWidget]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-widget

        Returns the widget for the guild. Fires an Invite Create Gateway event when an invite channel is defined and a new Invite is generated.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/widget.json"), _Decode.entity[GuildWidget](handler, options.on_error))

    be get_guild_vanity_url(guild_id: Snowflake, handler: ResponseHandler[GuildVanityUrl]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-vanity-url

        Returns a partial invite object for guilds with that feature enabled. Requires the MANAGE_GUILD permission. code will be null if a vanity url for the guild is not set.

        This endpoint is required to get the usage count of the vanity invite, but the invite code can be accessed as vanity_url_code in the guild object without having the MANAGE_GUILD permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/vanity-url"), _Decode.entity[GuildVanityUrl](handler, options.on_error))

    be get_guild_widget_image(guild_id: Snowflake, params: GetGuildWidgetImageParams, handler: ResponseHandler[Array[U8] val]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-widget-image

        Returns a PNG image widget for the guild. Requires no permissions or authentication.

        All parameters to this endpoint are optional.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/widget.png" where query = params.to_query()), _Decode.bytes(handler, options.on_error))

    be get_guild_welcome_screen(guild_id: Snowflake, handler: ResponseHandler[WelcomeScreen]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-welcome-screen

        Returns the Welcome Screen object for the guild. If the welcome screen is not enabled, the MANAGE_GUILD permission is required.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/welcome-screen"), _Decode.entity[WelcomeScreen](handler, options.on_error))

    be update_guild_welcome_screen(guild_id: Snowflake, params: UpdateGuildWelcomeScreenParams, handler: ResponseHandler[WelcomeScreen], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-welcome-screen

        Modify the guild's Welcome Screen. Requires the MANAGE_GUILD permission. Returns the updated Welcome Screen object. May fire a Guild Update Gateway event.

        All parameters to this endpoint are optional and nullable.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/welcome-screen" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[WelcomeScreen](handler, options.on_error))

    be get_guild_onboarding(guild_id: Snowflake, handler: ResponseHandler[GuildOnboarding]) =>
        """
        https://docs.discord.com/developers/resources/guild#get-guild-onboarding

        Returns the Onboarding object for the guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/onboarding"), _Decode.entity[GuildOnboarding](handler, options.on_error))

    be update_guild_onboarding(guild_id: Snowflake, params: UpdateGuildOnboardingParams, handler: ResponseHandler[GuildOnboarding], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-onboarding

        Modifies the onboarding configuration of the guild. Returns a 200 with the Onboarding object for the guild. Requires the MANAGE_GUILD and MANAGE_ROLES permissions.

        Onboarding enforces constraints when enabled. These constraints are that there must be at least 7 Default Channels and at least 5 of them must allow sending messages to the @everyone role. The mode field modifies what is considered when enforcing these constraints.

        This endpoint supports the X-Audit-Log-Reason header.

        All parameters to this endpoint are optional.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/onboarding" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildOnboarding](handler, options.on_error))

    be update_guild_incident_actions(guild_id: Snowflake, params: UpdateGuildIncidentActionsParams, handler: ResponseHandler[IncidentsData]) =>
        """
        https://docs.discord.com/developers/resources/guild#modify-guild-incident-actions

        Modifies the incident actions of the guild. Returns a 200 with the Incidents Data object for the guild. Requires the MANAGE_GUILD permission.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/incident-actions" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[IncidentsData](handler, options.on_error))

    be get_guild_scheduled_events(guild_id: Snowflake, params: GetGuildScheduledEventsParams, handler: ResponseHandler[Array[GuildScheduledEvent] val]) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#list-scheduled-events-for-guild

        Returns a list of guild scheduled event objects for the given guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/scheduled-events" where query = params.to_query()), _Decode.list[GuildScheduledEvent](handler, options.on_error))

    be create_guild_scheduled_event(guild_id: Snowflake, params: CreateGuildScheduledEventParams, handler: ResponseHandler[GuildScheduledEvent], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#create-guild-scheduled-event

        Create a guild scheduled event in the guild. Returns a guild scheduled event object on success. Fires a Guild Scheduled Event Create Gateway event.

        A guild can have a maximum of 100 events with SCHEDULED or ACTIVE status at any time.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/scheduled-events" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildScheduledEvent](handler, options.on_error))

    be get_guild_scheduled_event(guild_id: Snowflake, guild_scheduled_event_id: Snowflake, params: GetGuildScheduledEventParams, handler: ResponseHandler[GuildScheduledEvent]) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event

        Get a guild scheduled event. Returns a guild scheduled event object on success.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/scheduled-events/" + guild_scheduled_event_id.string() where query = params.to_query()), _Decode.entity[GuildScheduledEvent](handler, options.on_error))

    be update_guild_scheduled_event(guild_id: Snowflake, guild_scheduled_event_id: Snowflake, params: UpdateGuildScheduledEventParams, handler: ResponseHandler[GuildScheduledEvent], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#modify-guild-scheduled-event

        Modify a guild scheduled event. Returns the modified guild scheduled event object on success. Fires a Guild Scheduled Event Update Gateway event.

        To start or end an event, use this endpoint to modify the event's status field.

        This endpoint supports the X-Audit-Log-Reason header.

        This endpoint silently discards entity_metadata for non-EXTERNAL events.

        All parameters to this endpoint are optional.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/scheduled-events/" + guild_scheduled_event_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[GuildScheduledEvent](handler, options.on_error))

    be delete_guild_scheduled_event(guild_id: Snowflake, guild_scheduled_event_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#delete-guild-scheduled-event

        Delete a guild scheduled event. Returns a 204 on success. Fires a Guild Scheduled Event Delete Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/scheduled-events/" + guild_scheduled_event_id.string()), _Decode.empty(handler, options.on_error))

    be get_guild_scheduled_event_users(guild_id: Snowflake, guild_scheduled_event_id: Snowflake, params: GetGuildScheduledEventUsersParams, handler: ResponseHandler[Array[GuildScheduledEventUser] val]) =>
        """
        https://docs.discord.com/developers/resources/guild-scheduled-event#get-guild-scheduled-event-users

        Get a list of guild scheduled event users subscribed to a guild scheduled event. Returns a list of guild scheduled event user objects on success. Guild member data, if it exists, is included if the with_member query parameter is set.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/scheduled-events/" + guild_scheduled_event_id.string() + "/users" where query = params.to_query()), _Decode.list[GuildScheduledEventUser](handler, options.on_error))

    be get_guild_template(template_code: String, handler: ResponseHandler[GuildTemplate]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#get-guild-template

        Returns a guild template object for the given code.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/templates/" + template_code), _Decode.entity[GuildTemplate](handler, options.on_error))

    be get_guild_templates(guild_id: Snowflake, handler: ResponseHandler[Array[GuildTemplate] val]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#get-guild-templates

        Returns an array of guild template objects. Requires the MANAGE_GUILD permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/templates"), _Decode.list[GuildTemplate](handler, options.on_error))

    be create_guild_template(guild_id: Snowflake, params: CreateGuildTemplateParams, handler: ResponseHandler[GuildTemplate]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#create-guild-template

        Creates a template for the guild. Requires the MANAGE_GUILD permission. Returns the created guild template object on success.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/templates" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[GuildTemplate](handler, options.on_error))

    be sync_guild_template(guild_id: Snowflake, template_code: String, handler: ResponseHandler[GuildTemplate]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#sync-guild-template

        Syncs the template to the guild's current state. Requires the MANAGE_GUILD permission. Returns the guild template object on success.
        """

        api.send_request(options.build_request(courier.PUT, "/guilds/" + guild_id.string() + "/templates/" + template_code), _Decode.entity[GuildTemplate](handler, options.on_error))

    be update_guild_template(guild_id: Snowflake, template_code: String, params: UpdateGuildTemplateParams, handler: ResponseHandler[GuildTemplate]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#modify-guild-template

        Modifies the template's metadata. Requires the MANAGE_GUILD permission. Returns the guild template object on success.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/templates/" + template_code where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[GuildTemplate](handler, options.on_error))

    be delete_guild_template(guild_id: Snowflake, template_code: String, handler: ResponseHandler[GuildTemplate]) =>
        """
        https://docs.discord.com/developers/resources/guild-template#delete-guild-template

        Deletes the template. Requires the MANAGE_GUILD permission. Returns the deleted guild template object on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/templates/" + template_code), _Decode.entity[GuildTemplate](handler, options.on_error))

    be get_invite(invite_code: String, params: GetInviteParams, handler: ResponseHandler[Invite]) =>
        """
        https://docs.discord.com/developers/resources/invite#get-invite

        Returns an invite object for the given code.
        """

        api.send_request(options.build_request(courier.GET, "/invites/" + invite_code where query = params.to_query()), _Decode.entity[Invite](handler, options.on_error))

    be delete_invite(invite_code: String, handler: ResponseHandler[Invite], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/invite#delete-invite

        Delete an invite. Requires the MANAGE_CHANNELS permission on the channel this invite belongs to, or MANAGE_GUILD to remove any invite across the guild. Returns an invite object on success. Fires an Invite Delete Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/invites/" + invite_code where reason = reason), _Decode.entity[Invite](handler, options.on_error))

    be get_invite_target_users(invite_code: String, handler: ResponseHandler[String]) =>
        """
        https://docs.discord.com/developers/resources/invite#get-target-users

        Gets the users allowed to see and accept this invite. Response is a CSV file with the header user_id and each user ID from the original file passed to invite create on its own line. Requires the caller to be the inviter, or have MANAGE_GUILD permission, or have VIEW_AUDIT_LOG permission.
        """

        api.send_request(options.build_request(courier.GET, "/invites/" + invite_code + "/target-users"), _Decode.text(handler, options.on_error))

    be update_invite_target_users(invite_code: String, params: UpdateInviteTargetUsersParams, handler: ResponseHandler[json.JsonValue]) =>
        """
        https://docs.discord.com/developers/resources/invite#update-target-users

        Updates the users allowed to see and accept this invite. Uploading a file with invalid user IDs will result in a 400 with the invalid IDs described. Requires the caller to be the inviter or have the MANAGE_GUILD permission.

        Discord documents no success body for this route, only the 400 it answers
        with for invalid user IDs, so the payload is handed back unmodelled.
        `get_invite_target_users_job_status` is how the asynchronous processing
        this route kicks off is followed.
        """

        api.send_request(options.build_request(courier.PUT, "/invites/" + invite_code + "/target-users" where body = json.JsonPrinter.print(params.to_json())), _Decode.payload(handler, options.on_error))

    be get_invite_target_users_job_status(invite_code: String, handler: ResponseHandler[TargetUsersJobStatus]) =>
        """
        https://docs.discord.com/developers/resources/invite#get-target-users-job-status

        Processing target users from a CSV when creating or updating an invite is done asynchronously. This endpoint allows you to check the status of that job. Requires the caller to be the inviter, or have MANAGE_GUILD permission, or have VIEW_AUDIT_LOG permission.
        """

        api.send_request(options.build_request(courier.GET, "/invites/" + invite_code + "/target-users/job-status"), _Decode.entity[TargetUsersJobStatus](handler, options.on_error))

    be create_lobby(params: CreateLobbyParams, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#create-lobby

        Creates a new lobby, adding any of the specified members to it, if provided.

        Returns a lobby object.

        Discord Social SDK clients will not be able to join or leave a lobby created using this API, such as Client::CreateOrJoinLobby. See Managing Lobbies for more information.
        """

        api.send_request(options.build_request(courier.POST, "/lobbies" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Lobby](handler, options.on_error))

    be create_or_join_lobby(params: CreateOrJoinLobbyParams, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#create-or-join-lobby

        Creates a new lobby for the application identified by a secret, or joins the calling user to the existing lobby with that secret if one already exists. Updates lobby metadata and the calling member's metadata on join.

        Uses Bearer token for authorization with the sdk.social_layer scope.

        Returns a lobby object.
        """

        api.send_request(options.build_request(courier.PUT, "/lobbies" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Lobby](handler, options.on_error))

    be get_lobby(lobby_id: Snowflake, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#get-lobby

        Returns a lobby object for the specified lobby id, if it exists.
        """

        api.send_request(options.build_request(courier.GET, "/lobbies/" + lobby_id.string()), _Decode.entity[Lobby](handler, options.on_error))

    be update_lobby(lobby_id: Snowflake, params: UpdateLobbyParams, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#modify-lobby

        Modifies the specified lobby with new values, if provided.

        Returns the updated lobby object.
        """

        api.send_request(options.build_request(courier.PATCH, "/lobbies/" + lobby_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Lobby](handler, options.on_error))

    be delete_lobby(lobby_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/lobby#delete-lobby

        Deletes the specified lobby if it exists.

        It is safe to call even if the lobby is already deleted as well.

        Returns nothing.
        """

        api.send_request(options.build_request(courier.DELETE, "/lobbies/" + lobby_id.string()), _Decode.empty(handler, options.on_error))

    be add_lobby_member(lobby_id: Snowflake, user_id: Snowflake, params: AddLobbyMemberParams, handler: ResponseHandler[LobbyMember]) =>
        """
        https://docs.discord.com/developers/resources/lobby#add-a-member-to-a-lobby

        Adds the provided user to the specified lobby. If called when the user is already a member of the lobby will update fields such as metadata on that user instead.

        Returns the lobby member object.
        """

        api.send_request(options.build_request(courier.PUT, "/lobbies/" + lobby_id.string() + "/members/" + user_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[LobbyMember](handler, options.on_error))

    be bulk_update_lobby_members(lobby_id: Snowflake, params: BulkUpdateLobbyMembersParams, handler: ResponseHandler[Array[LobbyMember] val]) =>
        """
        https://docs.discord.com/developers/resources/lobby#bulk-update-lobby-members

        Adds, updates, or removes up to 25 members from the specified lobby in a single request. Members with remove_member: false (the default) are upserted — added if not present, or updated with the provided metadata and flags if already a member. Members with remove_member: true are removed.

        Returns an array of lobby member objects for the upserted members. Removed members are not included in the response.

        Users unknown to Discord will return a 404 UNKNOWN_USER error. Users that fail permission checks or who have already reached the maximum number of lobbies per application (and are not already a member of this lobby) are silently dropped from the upsert set.
        """

        api.send_request(options.build_request(courier.POST, "/lobbies/" + lobby_id.string() + "/members/bulk" where body = json.JsonPrinter.print(params.to_json())), _Decode.list[LobbyMember](handler, options.on_error))

    be remove_lobby_member(lobby_id: Snowflake, user_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/lobby#remove-a-member-from-a-lobby

        Removes the provided user from the specified lobby. It is safe to call this even if the user is no longer a member of the lobby, but will fail if the lobby does not exist.

        Returns nothing.
        """

        api.send_request(options.build_request(courier.DELETE, "/lobbies/" + lobby_id.string() + "/members/" + user_id.string()), _Decode.empty(handler, options.on_error))

    be leave_lobby(lobby_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/lobby#leave-lobby

        Removes the current user from the specified lobby. It is safe to call this even if the user is no longer a member of the lobby, but will fail if the lobby does not exist.

        Uses Bearer token for authorization.

        Returns nothing.
        """

        api.send_request(options.build_request(courier.DELETE, "/lobbies/" + lobby_id.string() + "/members/@me"), _Decode.empty(handler, options.on_error))

    be link_channel_to_lobby(lobby_id: Snowflake, params: LinkChannelToLobbyParams, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#link-channel-to-lobby

        Links an existing text channel to a lobby. See Linked Channels for more information.

        Uses Bearer token for authorization and user must be a lobby member with CanLinkLobby lobby member flag.

        Returns a lobby object with a linked channel.
        """

        api.send_request(options.build_request(courier.PATCH, "/lobbies/" + lobby_id.string() + "/channel-linking" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Lobby](handler, options.on_error))

    be unlink_channel_from_lobby(lobby_id: Snowflake, handler: ResponseHandler[Lobby]) =>
        """
        https://docs.discord.com/developers/resources/lobby#unlink-channel-from-lobby

        Unlinks any currently linked channels from the specified lobby.

        Send a request to this endpoint with an empty body to unlink any currently linked channels from the specified lobby.

        Uses Bearer token for authorization and user must be a lobby member with CanLinkLobby lobby member flag.

        Returns a lobby object without a linked channel.
        """

        api.send_request(options.build_request(courier.PATCH, "/lobbies/" + lobby_id.string() + "/channel-linking"), _Decode.entity[Lobby](handler, options.on_error))

    be send_lobby_message(lobby_id: Snowflake, params: SendLobbyMessageParams, handler: ResponseHandler[LobbyMessage]) =>
        """
        https://docs.discord.com/developers/resources/lobby#send-lobby-message

        Sends a message to the specified lobby. The calling user must be a member of the lobby.

        Uses Bearer token for authorization with the sdk.social_layer scope.

        Returns the created lobby message object.

        If the lobby has a linked channel, the message is also forwarded to that channel. If forwarding fails (for example, due to AutoMod), the lobby message is still delivered to other lobby members.
        """

        api.send_request(options.build_request(courier.POST, "/lobbies/" + lobby_id.string() + "/messages" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[LobbyMessage](handler, options.on_error))

    be get_lobby_messages(lobby_id: Snowflake, params: GetLobbyMessagesParams, handler: ResponseHandler[Array[LobbyMessage] val]) =>
        """
        https://docs.discord.com/developers/resources/lobby#get-lobby-messages

        Returns the most recent messages in the specified lobby. The calling user must be a member of the lobby.

        Uses Bearer token for authorization with the sdk.social_layer scope.

        Returns an array of lobby message objects (see Send Lobby Message for the object shape).
        """

        api.send_request(options.build_request(courier.GET, "/lobbies/" + lobby_id.string() + "/messages" where query = params.to_query()), _Decode.list[LobbyMessage](handler, options.on_error))

    be update_lobby_message_moderation_metadata(lobby_id: Snowflake, message_id: Snowflake, params: UpdateLobbyMessageModerationMetadataParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/lobby#update-lobby-message-moderation-metadata

        Sets the moderation metadata for a lobby message. The metadata is app-scoped and delivered to active
        game clients via the Social SDK as a realtime message update. See Integrate Moderation
        for the full moderation flow.

        Uses Bot token for authorization.

        Returns HTTP 204: No Content on success.
        """

        api.send_request(options.build_request(courier.PUT, "/lobbies/" + lobby_id.string() + "/messages/" + message_id.string() + "/moderation-metadata" where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be create_lobby_channel_invite_for_self(lobby_id: Snowflake, handler: ResponseHandler[LobbyInvite]) =>
        """
        https://docs.discord.com/developers/resources/lobby#create-lobby-channel-invite-for-self

        Creates a single-use guild invite to the lobby's linked channel, targeted at the calling user. The lobby must have a linked channel and the caller must be a member of the lobby. The invite expires after one hour.

        Uses Bearer token for authorization with the sdk.social_layer scope.

        Returns a lobby invite object.
        """

        api.send_request(options.build_request(courier.POST, "/lobbies/" + lobby_id.string() + "/members/@me/invites"), _Decode.entity[LobbyInvite](handler, options.on_error))

    be create_lobby_channel_invite_for_user(lobby_id: Snowflake, user_id: Snowflake, handler: ResponseHandler[LobbyInvite]) =>
        """
        https://docs.discord.com/developers/resources/lobby#create-lobby-channel-invite-for-user

        Creates a single-use guild invite to the lobby's linked channel on behalf of an application, targeted at the specified user. The lobby must have a linked channel. The invite expires after one hour.

        Uses Bot token for authorization.

        Returns a lobby invite object.
        """

        api.send_request(options.build_request(courier.POST, "/lobbies/" + lobby_id.string() + "/members/" + user_id.string() + "/invites"), _Decode.entity[LobbyInvite](handler, options.on_error))

    be get_channel_messages(channel_id: Snowflake, params: GetChannelMessagesParams, handler: ResponseHandler[Array[Message] val]) =>
        """
        https://docs.discord.com/developers/resources/message#get-channel-messages

        Retrieves the messages in a channel. Returns an array of message objects from newest to oldest on success.

        If operating on a guild channel, this endpoint requires the current user to have the VIEW_CHANNEL permission. If the channel is a voice channel, they must _also_ have the CONNECT permission.

        If the current user is missing the READ_MESSAGE_HISTORY permission in the channel, then no messages will be returned.

        The before, after, and around parameters are mutually exclusive, only one may be passed at a time.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/messages" where query = params.to_query()), _Decode.list[Message](handler, options.on_error))

    be search_guild_messages(guild_id: Snowflake, params: SearchGuildMessagesParams, handler: ResponseHandler[MessageSearchResults]) =>
        """
        https://docs.discord.com/developers/resources/message#search-guild-messages

        Returns a list of messages without the reactions key that match a search query in the guild. Requires the READ_MESSAGE_HISTORY permission.

        This endpoint is restricted according to whether the MESSAGE_CONTENT Privileged Intent is enabled for your application.

        If the entity you are searching is not yet indexed, the endpoint will return a 202 accepted response. The response body will not contain any search results, and will look similar to an error response:

        You should retry the request after the timeframe specified in the retry_after field. If the retry_after field is 0, you should retry the request after a short delay.

        Due to speed optimizations, search may return slightly fewer results than the limit specified when messages have not been accessed for a long time.
        Clients should not rely on the length of the messages array to paginate results.

        Additionally, when messages are actively being created or deleted, the total_results field may not be accurate.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/messages/search" where query = params.to_query()), _Decode.entity[MessageSearchResults](handler, options.on_error))

    be get_channel_message(channel_id: Snowflake, message_id: Snowflake, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/message#get-channel-message

        Retrieves a specific message in the channel. Returns a message object on success.

        If operating on a guild channel, this endpoint requires the current user to have the VIEW_CHANNEL and READ_MESSAGE_HISTORY permissions. If the channel is a voice channel, they must _also_ have the CONNECT permission.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/messages/" + message_id.string()), _Decode.entity[Message](handler, options.on_error))

    be create_message(channel_id: Snowflake, params: CreateMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/message#create-message

        Discord may strip certain characters from message content, like invalid unicode characters or characters which cause unexpected message formatting. If you are passing user-generated strings into message content, consider sanitizing the data to prevent unexpected behavior and using allowed_mentions to prevent unexpected mentions.

        Post a message to a guild text or DM channel. Returns a message object. Fires a Message Create Gateway event. See message formatting for more information on how to properly format messages.

        To create a message as a reply or forward of another message, apps can include a message_reference.
        Refer to the documentation for required fields.

        Files must be attached using a multipart/form-data body as described in Uploading Files.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/messages" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be crosspost_message(channel_id: Snowflake, message_id: Snowflake, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/message#crosspost-message

        Crosspost a message in an Announcement Channel to following channels. This endpoint requires the SEND_MESSAGES permission, if the current user sent the message, or additionally the MANAGE_MESSAGES permission, for all other messages, to be present for the current user.

        Returns a message object. Fires a Message Update Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/crosspost"), _Decode.entity[Message](handler, options.on_error))

    be create_reaction(channel_id: Snowflake, message_id: Snowflake, emoji: String, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#create-reaction

        Create a reaction for the message. This endpoint requires the READ_MESSAGE_HISTORY permission to be present on the current user. Additionally, if nobody else has reacted to the message using this emoji, this endpoint requires the ADD_REACTIONS permission to be present on the current user. Returns a 204 empty response on success. Fires a Message Reaction Add Gateway event.
        The emoji must be URL Encoded or the request will fail with 10014: Unknown Emoji. To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions/" + emoji + "/@me"), _Decode.empty(handler, options.on_error))

    be delete_own_reaction(channel_id: Snowflake, message_id: Snowflake, emoji: String, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#delete-own-reaction

        Delete a reaction the current user has made for the message. Returns a 204 empty response on success. Fires a Message Reaction Remove Gateway event.
        The emoji must be URL Encoded or the request will fail with 10014: Unknown Emoji. To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions/" + emoji + "/@me"), _Decode.empty(handler, options.on_error))

    be delete_user_reaction(channel_id: Snowflake, message_id: Snowflake, emoji: String, user_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#delete-user-reaction

        Deletes another user's reaction. This endpoint requires the MANAGE_MESSAGES permission to be present on the current user. Returns a 204 empty response on success. Fires a Message Reaction Remove Gateway event.
        The emoji must be URL Encoded or the request will fail with 10014: Unknown Emoji. To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions/" + emoji + "/" + user_id.string()), _Decode.empty(handler, options.on_error))

    be get_reactions(channel_id: Snowflake, message_id: Snowflake, emoji: String, params: GetReactionsParams, handler: ResponseHandler[Array[User] val]) =>
        """
        https://docs.discord.com/developers/resources/message#get-reactions

        Get a list of users that reacted with this emoji. Returns an array of user objects on success.
        The emoji must be URL Encoded or the request will fail with 10014: Unknown Emoji. To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions/" + emoji where query = params.to_query()), _Decode.list[User](handler, options.on_error))

    be delete_all_reactions(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#delete-all-reactions

        Deletes all reactions on a message. This endpoint requires the MANAGE_MESSAGES permission to be present on the current user. Fires a Message Reaction Remove All Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions"), _Decode.empty(handler, options.on_error))

    be delete_all_reactions_for_emoji(channel_id: Snowflake, message_id: Snowflake, emoji: String, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#delete-all-reactions-for-emoji

        Deletes all the reactions for a given emoji on a message. This endpoint requires the MANAGE_MESSAGES permission to be present on the current user. Fires a Message Reaction Remove Emoji Gateway event.
        The emoji must be URL Encoded or the request will fail with 10014: Unknown Emoji. To use custom emoji, you must encode it in the format name:id with the emoji name and emoji id.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/reactions/" + emoji), _Decode.empty(handler, options.on_error))

    be update_message(channel_id: Snowflake, message_id: Snowflake, params: UpdateMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/message#edit-message

        Edit a previously sent message. The fields content, embeds, flags and components can be edited by the original message author. Other users can only edit flags and only if they have the MANAGE_MESSAGES permission in the corresponding channel. When specifying flags, ensure to include all previously set flags/bits in addition to ones that you are modifying. Only flags documented in the table below may be modified by users (unsupported flag changes are currently ignored without error).

        When the content field is edited, the arrays mentions and mention_roles and the boolean mention_everyone in the message object will be reconstructed from scratch based on the new content. When the message flag IS_COMPONENTS_V2 is set, the reconstructed arrays and boolean are based on the edited content in the components array. The allowed_mentions field of the edit request controls how this happens. If there is no explicit allowed_mentions in the edit request, the content will be parsed with _default_ allowances, that is, without regard to whether or not an allowed_mentions was present in the request that originally created the message.

        Returns a message object. Fires a Message Update Gateway event.

        Refer to Uploading Files for details on attachments and multipart/form-data requests.
        Any provided files will be appended to the message. To remove or replace files you will have to supply the attachments field which specifies the files to retain on the message after edit.

        Starting with API v10, the attachments array must contain all attachments that should be present after edit, including retained and new attachments provided in the request body.

        All parameters to this endpoint are optional and nullable.
        """

        api.send_request(options.build_request(courier.PATCH, "/channels/" + channel_id.string() + "/messages/" + message_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be delete_message(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/message#delete-message

        Delete a message. If operating on a guild channel and trying to delete a message that was not sent by the current user, this endpoint requires the MANAGE_MESSAGES permission. Returns a 204 empty response on success. Fires a Message Delete Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/" + message_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be bulk_delete_messages(channel_id: Snowflake, params: BulkDeleteMessagesParams, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/message#bulk-delete-messages

        Delete multiple messages in a single request. This endpoint can only be used on guild channels and requires the MANAGE_MESSAGES permission. Returns a 204 empty response on success. Fires a Message Delete Bulk Gateway event.

        Any message IDs given that do not exist or are invalid will count towards the minimum and maximum message count (currently 2 and 100 respectively).

        This endpoint will not delete messages older than 2 weeks, and will fail with a 400 BAD REQUEST if any message provided is older than that or if any duplicate message IDs are provided.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/messages/bulk-delete" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.empty(handler, options.on_error))

    be get_channel_pins(channel_id: Snowflake, params: GetChannelPinsParams, handler: ResponseHandler[ChannelPins]) =>
        """
        https://docs.discord.com/developers/resources/message#get-channel-pins

        Retrieves the list of pins in a channel. Requires the VIEW_CHANNEL permission. If the user is missing the READ_MESSAGE_HISTORY permission in the channel, then no pins will be returned.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/messages/pins" where query = params.to_query()), _Decode.entity[ChannelPins](handler, options.on_error))

    be pin_message(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/message#pin-message

        Pin a message in a channel. Requires the PIN_MESSAGES permission. Fires a Channel Pins Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/messages/pins/" + message_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be unpin_message(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/message#unpin-message

        Unpin a message in a channel. Requires the PIN_MESSAGES permission. Returns a 204 empty response on success. Fires a Channel Pins Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/messages/pins/" + message_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_pinned_messages_deprecated(channel_id: Snowflake, handler: ResponseHandler[Array[Message] val]) =>
        """
        https://docs.discord.com/developers/resources/message#get-pinned-messages-deprecated

        Gets the first 50 pinned messages in a channel, returning an array of message objects on success.
        This endpoint is deprecated. Use Get Channel Pins instead.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/pins"), _Decode.list[Message](handler, options.on_error))

    be pin_message_deprecated(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#pin-message-deprecated

        This endpoint is deprecated. Use Pin Message instead.
        """

        api.send_request(options.build_request(courier.PUT, "/channels/" + channel_id.string() + "/pins/" + message_id.string()), _Decode.empty(handler, options.on_error))

    be unpin_message_deprecated(channel_id: Snowflake, message_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/message#unpin-message-deprecated

        This endpoint is deprecated. Use Unpin Message instead.
        """

        api.send_request(options.build_request(courier.DELETE, "/channels/" + channel_id.string() + "/pins/" + message_id.string()), _Decode.empty(handler, options.on_error))

    be get_answer_voters(channel_id: Snowflake, message_id: Snowflake, answer_id: Snowflake, params: GetAnswerVotersParams, handler: ResponseHandler[Array[User] val]) =>
        """
        https://docs.discord.com/developers/resources/poll#get-answer-voters

        Get a list of users that voted for this specific answer.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/polls/" + message_id.string() + "/answers/" + answer_id.string() where query = params.to_query()), _Decode.wrapped[User](handler, "users", options.on_error))

    be end_poll(channel_id: Snowflake, message_id: Snowflake, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/poll#end-poll

        Immediately ends the poll. You cannot end polls from other users.

        Returns a message object. Fires a Message Update Gateway event.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/polls/" + message_id.string() + "/expire"), _Decode.entity[Message](handler, options.on_error))

    be get_skus(application_id: Snowflake, handler: ResponseHandler[Array[SKU] val]) =>
        """
        https://docs.discord.com/developers/resources/sku#list-skus

        Returns all SKUs for a given application.

        Because of how our SKU and subscription systems work, you will see two SKUs for your subscription offering. For integration and testing entitlements for Subscriptions, you should use the SKU with type: 5.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/skus"), _Decode.list[SKU](handler, options.on_error))

    be send_soundboard_sound(channel_id: Snowflake, params: SendSoundboardSoundParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/soundboard#send-soundboard-sound

        Send a soundboard sound to a voice channel the user is connected to. Fires a Voice Channel Effect Send Gateway event.

        Requires the SPEAK and USE_SOUNDBOARD permissions, and also the USE_EXTERNAL_SOUNDS permission if the sound is from a different server. Additionally, requires the user to be connected to the voice channel, having a voice state without deaf, self_deaf, mute, or suppress enabled.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/send-soundboard-sound" where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be get_default_soundboard_sounds(handler: ResponseHandler[Array[SoundboardSound] val]) =>
        """
        https://docs.discord.com/developers/resources/soundboard#list-default-soundboard-sounds

        Returns an array of soundboard sound objects that can be used by all users.
        """

        api.send_request(options.build_request(courier.GET, "/soundboard-default-sounds"), _Decode.list[SoundboardSound](handler, options.on_error))

    be get_guild_soundboard_sounds(guild_id: Snowflake, handler: ResponseHandler[Array[SoundboardSound] val]) =>
        """
        https://docs.discord.com/developers/resources/soundboard#list-guild-soundboard-sounds

        Returns a list of the guild's soundboard sounds. Includes user fields if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/soundboard-sounds"), _Decode.wrapped[SoundboardSound](handler, "items", options.on_error))

    be get_guild_soundboard_sound(guild_id: Snowflake, sound_id: Snowflake, handler: ResponseHandler[SoundboardSound]) =>
        """
        https://docs.discord.com/developers/resources/soundboard#get-guild-soundboard-sound

        Returns a soundboard sound object for the given sound id. Includes the user field if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/soundboard-sounds/" + sound_id.string()), _Decode.entity[SoundboardSound](handler, options.on_error))

    be create_guild_soundboard_sound(guild_id: Snowflake, params: CreateGuildSoundboardSoundParams, handler: ResponseHandler[SoundboardSound], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/soundboard#create-guild-soundboard-sound

        Create a new soundboard sound for the guild. Requires the CREATE_GUILD_EXPRESSIONS permission. Returns the new soundboard sound object on success. Fires a Guild Soundboard Sound Create Gateway event.

        Soundboard sounds have a max file size of 512kb and a max duration of 5.2 seconds.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/soundboard-sounds" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[SoundboardSound](handler, options.on_error))

    be update_guild_soundboard_sound(guild_id: Snowflake, sound_id: Snowflake, params: UpdateGuildSoundboardSoundParams, handler: ResponseHandler[SoundboardSound], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/soundboard#modify-guild-soundboard-sound

        Modify the given soundboard sound. For sounds created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other sounds, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns the updated soundboard sound object on success. Fires a Guild Soundboard Sound Update Gateway event.

        All parameters to this endpoint are optional.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/soundboard-sounds/" + sound_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[SoundboardSound](handler, options.on_error))

    be delete_guild_soundboard_sound(guild_id: Snowflake, sound_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/soundboard#delete-guild-soundboard-sound

        Delete the given soundboard sound. For sounds created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other sounds, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns 204 No Content on success. Fires a Guild Soundboard Sound Delete Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/soundboard-sounds/" + sound_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be create_stage_instance(params: CreateStageInstanceParams, handler: ResponseHandler[StageInstance], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/stage-instance#create-stage-instance

        Creates a new Stage instance associated to a Stage channel. Returns that Stage instance. Fires a Stage Instance Create Gateway event.

        Requires the user to be a moderator of the Stage channel.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/stage-instances" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[StageInstance](handler, options.on_error))

    be get_stage_instance(channel_id: Snowflake, handler: ResponseHandler[StageInstance]) =>
        """
        https://docs.discord.com/developers/resources/stage-instance#get-stage-instance

        Gets the stage instance associated with the Stage channel, if it exists.
        """

        api.send_request(options.build_request(courier.GET, "/stage-instances/" + channel_id.string()), _Decode.entity[StageInstance](handler, options.on_error))

    be update_stage_instance(channel_id: Snowflake, params: UpdateStageInstanceParams, handler: ResponseHandler[StageInstance], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/stage-instance#modify-stage-instance

        Updates fields of an existing Stage instance. Returns the updated Stage instance. Fires a Stage Instance Update Gateway event.

        Requires the user to be a moderator of the Stage channel.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/stage-instances/" + channel_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[StageInstance](handler, options.on_error))

    be delete_stage_instance(channel_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/stage-instance#delete-stage-instance

        Deletes the Stage instance. Returns 204 No Content. Fires a Stage Instance Delete Gateway event.

        Requires the user to be a moderator of the Stage channel.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/stage-instances/" + channel_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_sticker(sticker_id: Snowflake, handler: ResponseHandler[Sticker]) =>
        """
        https://docs.discord.com/developers/resources/sticker#get-sticker

        Returns a sticker object for the given sticker ID.
        """

        api.send_request(options.build_request(courier.GET, "/stickers/" + sticker_id.string()), _Decode.entity[Sticker](handler, options.on_error))

    be get_sticker_packs(handler: ResponseHandler[Array[StickerPack] val]) =>
        """
        https://docs.discord.com/developers/resources/sticker#list-sticker-packs

        Returns a list of available sticker packs.
        """

        api.send_request(options.build_request(courier.GET, "/sticker-packs"), _Decode.wrapped[StickerPack](handler, "sticker_packs", options.on_error))

    be get_sticker_pack(sticker_pack_id: Snowflake, handler: ResponseHandler[StickerPack]) =>
        """
        https://docs.discord.com/developers/resources/sticker#get-sticker-pack

        Returns a sticker pack object for the given sticker pack ID.
        """

        api.send_request(options.build_request(courier.GET, "/sticker-packs/" + sticker_pack_id.string()), _Decode.entity[StickerPack](handler, options.on_error))

    be get_guild_stickers(guild_id: Snowflake, handler: ResponseHandler[Array[Sticker] val]) =>
        """
        https://docs.discord.com/developers/resources/sticker#list-guild-stickers

        Returns an array of sticker objects for the given guild. Includes user fields if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/stickers"), _Decode.list[Sticker](handler, options.on_error))

    be get_guild_sticker(guild_id: Snowflake, sticker_id: Snowflake, handler: ResponseHandler[Sticker]) =>
        """
        https://docs.discord.com/developers/resources/sticker#get-guild-sticker

        Returns a sticker object for the given guild and sticker IDs. Includes the user field if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/stickers/" + sticker_id.string()), _Decode.entity[Sticker](handler, options.on_error))

    be create_guild_sticker(guild_id: Snowflake, params: CreateGuildStickerParams, handler: ResponseHandler[Sticker], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/sticker#create-guild-sticker

        Create a new sticker for the guild. Send a multipart/form-data body. Requires the CREATE_GUILD_EXPRESSIONS permission. Returns the new sticker object on success. Fires a Guild Stickers Update Gateway event.

        Every guilds has five free sticker slots by default, and each Boost level will grant access to more slots.

        This endpoint supports the X-Audit-Log-Reason header.

        Lottie stickers can only be uploaded on guilds that have either the VERIFIED and/or the PARTNERED guild feature.

        Uploaded stickers are constrained to 5 seconds in length for animated stickers, and 320 x 320 pixels.
        """

        api.send_request(options.build_request(courier.POST, "/guilds/" + guild_id.string() + "/stickers" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Sticker](handler, options.on_error))

    be update_guild_sticker(guild_id: Snowflake, sticker_id: Snowflake, params: UpdateGuildStickerParams, handler: ResponseHandler[Sticker], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/sticker#modify-guild-sticker

        Modify the given sticker. For stickers created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other stickers, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns the updated sticker object on success. Fires a Guild Stickers Update Gateway event.

        All parameters to this endpoint are optional.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/stickers/" + sticker_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Sticker](handler, options.on_error))

    be delete_guild_sticker(guild_id: Snowflake, sticker_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/sticker#delete-guild-sticker

        Delete the given sticker. For stickers created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other stickers, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns 204 No Content on success. Fires a Guild Stickers Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/guilds/" + guild_id.string() + "/stickers/" + sticker_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be get_sku_subscriptions(sku_id: Snowflake, params: GetSKUSubscriptionsParams, handler: ResponseHandler[Array[Subscription] val]) =>
        """
        https://docs.discord.com/developers/resources/subscription#list-sku-subscriptions

        Returns all subscriptions containing the SKU, filtered by user. Returns a list of subscription objects.
        """

        api.send_request(options.build_request(courier.GET, "/skus/" + sku_id.string() + "/subscriptions" where query = params.to_query()), _Decode.list[Subscription](handler, options.on_error))

    be get_sku_subscription(sku_id: Snowflake, subscription_id: Snowflake, handler: ResponseHandler[Subscription]) =>
        """
        https://docs.discord.com/developers/resources/subscription#get-sku-subscription

        Get a subscription by its ID. Returns a subscription object.
        """

        api.send_request(options.build_request(courier.GET, "/skus/" + sku_id.string() + "/subscriptions/" + subscription_id.string()), _Decode.entity[Subscription](handler, options.on_error))

    be get_current_user(handler: ResponseHandler[User]) =>
        """
        https://docs.discord.com/developers/resources/user#get-current-user

        Returns the user object of the requester's account. For OAuth2, this requires the identify scope, which will return the object _without_ an email, and optionally the email scope, which returns the object _with_ an email if the user has one.
        """

        api.send_request(options.build_request(courier.GET, "/users/@me"), _Decode.entity[User](handler, options.on_error))

    be get_user(user_id: Snowflake, handler: ResponseHandler[User]) =>
        """
        https://docs.discord.com/developers/resources/user#get-user

        Returns a user object for a given user ID.
        """

        api.send_request(options.build_request(courier.GET, "/users/" + user_id.string()), _Decode.entity[User](handler, options.on_error))

    be update_current_user(params: UpdateCurrentUserParams, handler: ResponseHandler[User]) =>
        """
        https://docs.discord.com/developers/resources/user#modify-current-user

        Modify the requester's user account settings. Returns a user object on success. Fires a User Update Gateway event.

        All parameters to this endpoint are optional.
        """

        api.send_request(options.build_request(courier.PATCH, "/users/@me" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[User](handler, options.on_error))

    be get_current_user_guilds(params: GetCurrentUserGuildsParams, handler: ResponseHandler[Array[PartialGuild] val]) =>
        """
        https://docs.discord.com/developers/resources/user#get-current-user-guilds

        Returns a list of partial guild objects the current user is a member of. For OAuth2, requires the guilds scope.
        """

        api.send_request(options.build_request(courier.GET, "/users/@me/guilds" where query = params.to_query()), _Decode.list[PartialGuild](handler, options.on_error))

    be get_current_user_guild_member(guild_id: Snowflake, handler: ResponseHandler[GuildMember]) =>
        """
        https://docs.discord.com/developers/resources/user#get-current-user-guild-member

        Returns a guild member object for the current user. Requires the guilds.members.read OAuth2 scope.
        """

        api.send_request(options.build_request(courier.GET, "/users/@me/guilds/" + guild_id.string() + "/member"), _Decode.entity[GuildMember](handler, options.on_error))

    be leave_guild(guild_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/user#leave-guild

        Leave a guild. Returns a 204 empty response on success. Fires a Guild Delete Gateway event and a Guild Member Remove Gateway event.
        """

        api.send_request(options.build_request(courier.DELETE, "/users/@me/guilds/" + guild_id.string()), _Decode.empty(handler, options.on_error))

    be create_dm(params: CreateDMParams, handler: ResponseHandler[Channel]) =>
        """
        https://docs.discord.com/developers/resources/user#create-dm

        Create a new DM channel with a user. Returns a DM channel object (if one already exists, it will be returned instead).

        You should not use this endpoint to DM everyone in a server about something. DMs should generally be initiated by a user action. If you open a significant amount of DMs too quickly, your bot may be rate limited or blocked from opening new ones.
        """

        api.send_request(options.build_request(courier.POST, "/users/@me/channels" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Channel](handler, options.on_error))

    be create_group_dm(params: CreateGroupDMParams, handler: ResponseHandler[Channel]) =>
        """
        https://docs.discord.com/developers/resources/user#create-group-dm

        Create a new group DM channel with multiple users. Returns a DM channel object. This endpoint was intended to be used with the now-deprecated GameBridge SDK. Fires a Channel Create Gateway event.

        This endpoint is limited to 10 active group DMs.
        """

        api.send_request(options.build_request(courier.POST, "/users/@me/channels" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Channel](handler, options.on_error))

    be get_current_user_connections(handler: ResponseHandler[Array[Connection] val]) =>
        """
        https://docs.discord.com/developers/resources/user#get-current-user-connections

        Returns a list of connection objects. Requires the connections OAuth2 scope.
        """

        api.send_request(options.build_request(courier.GET, "/users/@me/connections"), _Decode.list[Connection](handler, options.on_error))

    be get_current_user_application_role_connection(application_id: Snowflake, handler: ResponseHandler[ApplicationRoleConnection]) =>
        """
        https://docs.discord.com/developers/resources/user#get-current-user-application-role-connection

        Returns the application role connection for the user. Requires an OAuth2 access token with role_connections.write scope for the application specified in the path.
        """

        api.send_request(options.build_request(courier.GET, "/users/@me/applications/" + application_id.string() + "/role-connection"), _Decode.entity[ApplicationRoleConnection](handler, options.on_error))

    be update_current_user_application_role_connection(application_id: Snowflake, params: UpdateCurrentUserApplicationRoleConnectionParams, handler: ResponseHandler[ApplicationRoleConnection]) =>
        """
        https://docs.discord.com/developers/resources/user#update-current-user-application-role-connection

        Updates and returns the application role connection for the user. Requires an OAuth2 access token with role_connections.write scope for the application specified in the path.
        """

        api.send_request(options.build_request(courier.PUT, "/users/@me/applications/" + application_id.string() + "/role-connection" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[ApplicationRoleConnection](handler, options.on_error))

    be delete_current_user_application_role_connection(application_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/user#delete-current-user-application-role-connection

        Deletes the application role connection for the user. Requires an OAuth2 access token with role_connections.write scope for the application specified in the path.
        """

        api.send_request(options.build_request(courier.DELETE, "/users/@me/applications/" + application_id.string() + "/role-connection"), _Decode.empty(handler, options.on_error))

    be get_voice_regions(handler: ResponseHandler[Array[VoiceRegion] val]) =>
        """
        https://docs.discord.com/developers/resources/voice#list-voice-regions

        Returns an array of voice region objects that can be used when setting a voice or stage channel's rtc_region.
        """

        api.send_request(options.build_request(courier.GET, "/voice/regions"), _Decode.list[VoiceRegion](handler, options.on_error))

    be get_current_user_voice_state(guild_id: Snowflake, handler: ResponseHandler[VoiceState]) =>
        """
        https://docs.discord.com/developers/resources/voice#get-current-user-voice-state

        Returns the current user's voice state in the guild.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/voice-states/@me"), _Decode.entity[VoiceState](handler, options.on_error))

    be get_user_voice_state(guild_id: Snowflake, user_id: Snowflake, handler: ResponseHandler[VoiceState]) =>
        """
        https://docs.discord.com/developers/resources/voice#get-user-voice-state

        Returns the specified user's voice state in the guild.

        If the specified user is connected to a voice channel, the current user must have permission to connect to the channel.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/voice-states/" + user_id.string()), _Decode.entity[VoiceState](handler, options.on_error))

    be update_current_user_voice_state(guild_id: Snowflake, params: UpdateCurrentUserVoiceStateParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/voice#modify-current-user-voice-state

        Updates the current user's voice state. Returns 204 No Content on success. Fires a Voice State Update Gateway event.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/voice-states/@me" where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be update_user_voice_state(guild_id: Snowflake, user_id: Snowflake, params: UpdateUserVoiceStateParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/voice#modify-user-voice-state

        Updates another user's voice state. Returns 204 No Content on success. Fires a Voice State Update Gateway event.
        """

        api.send_request(options.build_request(courier.PATCH, "/guilds/" + guild_id.string() + "/voice-states/" + user_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be create_webhook(channel_id: Snowflake, params: CreateWebhookParams, handler: ResponseHandler[Webhook], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/webhook#create-webhook

        Creates a new webhook and returns a webhook object on success. Requires the MANAGE_WEBHOOKS permission. Fires a Webhooks Update Gateway event.

        An error will be returned if a webhook name (name) is not valid. A webhook name is valid if:

        - It does not contain the substrings clyde or discord (case-insensitive)
        - It follows the nickname guidelines in the Usernames and Nicknames documentation, with an exception that webhook names can be up to 80 characters

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.POST, "/channels/" + channel_id.string() + "/webhooks" where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Webhook](handler, options.on_error))

    be get_channel_webhooks(channel_id: Snowflake, handler: ResponseHandler[Array[Webhook] val]) =>
        """
        https://docs.discord.com/developers/resources/webhook#get-channel-webhooks

        Returns a list of channel webhook objects. Requires the MANAGE_WEBHOOKS permission.
        """

        api.send_request(options.build_request(courier.GET, "/channels/" + channel_id.string() + "/webhooks"), _Decode.list[Webhook](handler, options.on_error))

    be get_guild_webhooks(guild_id: Snowflake, handler: ResponseHandler[Array[Webhook] val]) =>
        """
        https://docs.discord.com/developers/resources/webhook#get-guild-webhooks

        Returns a list of guild webhook objects. Requires the MANAGE_WEBHOOKS permission.
        """

        api.send_request(options.build_request(courier.GET, "/guilds/" + guild_id.string() + "/webhooks"), _Decode.list[Webhook](handler, options.on_error))

    be get_webhook(webhook_id: Snowflake, handler: ResponseHandler[Webhook]) =>
        """
        https://docs.discord.com/developers/resources/webhook#get-webhook

        Returns the new webhook object for the given id.

        This request requires the MANAGE_WEBHOOKS permission unless the application making the request owns the
        webhook. (see: webhook.application_id)
        """

        api.send_request(options.build_request(courier.GET, "/webhooks/" + webhook_id.string()), _Decode.entity[Webhook](handler, options.on_error))

    be get_webhook_with_token(webhook_id: Snowflake, webhook_token: String, handler: ResponseHandler[Webhook]) =>
        """
        https://docs.discord.com/developers/resources/webhook#get-webhook-with-token

        Same as above, except this call does not require authentication and returns no user in the webhook object.
        """

        api.send_request(options.build_request(courier.GET, "/webhooks/" + webhook_id.string() + "/" + webhook_token), _Decode.entity[Webhook](handler, options.on_error))

    be update_webhook(webhook_id: Snowflake, params: UpdateWebhookParams, handler: ResponseHandler[Webhook], reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/webhook#modify-webhook

        Modify a webhook. Requires the MANAGE_WEBHOOKS permission. Returns the updated webhook object on success. Fires a Webhooks Update Gateway event.

        All parameters to this endpoint are optional.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.PATCH, "/webhooks/" + webhook_id.string() where body = json.JsonPrinter.print(params.to_json()), reason = reason), _Decode.entity[Webhook](handler, options.on_error))

    be update_webhook_with_token(webhook_id: Snowflake, webhook_token: String, params: UpdateWebhookWithTokenParams, handler: ResponseHandler[Webhook]) =>
        """
        https://docs.discord.com/developers/resources/webhook#modify-webhook-with-token

        Same as above, except this call does not require authentication, does not accept a channel_id parameter in the body, and does not return a user in the webhook object.
        """

        api.send_request(options.build_request(courier.PATCH, "/webhooks/" + webhook_id.string() + "/" + webhook_token where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Webhook](handler, options.on_error))

    be delete_webhook(webhook_id: Snowflake, handler: EmptyResponseHandler, reason: (Reason | None) = None) =>
        """
        https://docs.discord.com/developers/resources/webhook#delete-webhook

        Delete a webhook permanently. Requires the MANAGE_WEBHOOKS permission. Returns a 204 No Content response on success. Fires a Webhooks Update Gateway event.

        This endpoint supports the X-Audit-Log-Reason header.
        """

        api.send_request(options.build_request(courier.DELETE, "/webhooks/" + webhook_id.string() where reason = reason), _Decode.empty(handler, options.on_error))

    be delete_webhook_with_token(webhook_id: Snowflake, webhook_token: String, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/webhook#delete-webhook-with-token

        Same as above, except this call does not require authentication.
        """

        api.send_request(options.build_request(courier.DELETE, "/webhooks/" + webhook_id.string() + "/" + webhook_token), _Decode.empty(handler, options.on_error))

    be execute_webhook(webhook_id: Snowflake, webhook_token: String, params: ExecuteWebhookParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/webhook#execute-webhook

        Refer to Uploading Files for details on attachments and multipart/form-data requests. Returns a message or 204 No Content depending on the wait query parameter.

        Note that when sending a message, you must provide a value for at least one of content, embeds, components, file, or poll.

        If the webhook channel is a forum or media channel, you must provide either thread_id in the query string params, or thread_name in the JSON/form params. If thread_id is provided, the message will send in that thread. If thread_name is provided, a thread with that name will be created in the channel.

        Discord may strip certain characters from message content, like invalid unicode characters or characters which cause unexpected message formatting. If you are passing user-generated strings into message content, consider sanitizing the data to prevent unexpected behavior and using allowed_mentions to prevent unexpected mentions.
        """

        api.send_request(options.build_request(courier.POST, "/webhooks/" + webhook_id.string() + "/" + webhook_token where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be execute_slack_compatible_webhook(webhook_id: Snowflake, webhook_token: String, params: ExecuteSlackCompatibleWebhookParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/webhook#execute-slack-compatible-webhook

        Refer to Slack's documentation for more information. We do not support Slack's channel, icon_emoji, mrkdwn, or mrkdwn_in properties.
        """

        api.send_request(options.build_request(courier.POST, "/webhooks/" + webhook_id.string() + "/" + webhook_token + "/slack" where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be execute_github_compatible_webhook(webhook_id: Snowflake, webhook_token: String, params: ExecuteGithubCompatibleWebhookParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/webhook#execute-github-compatible-webhook

        Add a new webhook to your GitHub repo (in the repo's settings), and use this endpoint as the "Payload URL." You can choose what events your Discord channel receives by choosing the "Let me select individual events" option and selecting individual events for the new webhook you're configuring. The supported events are commit_comment, create, delete, fork, issue_comment, issues, member, public, pull_request, pull_request_review, pull_request_review_comment, push, release, watch, check_run, check_suite, discussion, and discussion_comment.
        """

        api.send_request(options.build_request(courier.POST, "/webhooks/" + webhook_id.string() + "/" + webhook_token + "/github" where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.empty(handler, options.on_error))

    be get_webhook_message(webhook_id: Snowflake, webhook_token: String, message_id: Snowflake, params: GetWebhookMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/webhook#get-webhook-message

        Returns a previously-sent webhook message from the same token. Returns a message object on success.
        """

        api.send_request(options.build_request(courier.GET, "/webhooks/" + webhook_id.string() + "/" + webhook_token + "/messages/" + message_id.string() where query = params.to_query()), _Decode.entity[Message](handler, options.on_error))

    be update_webhook_message(webhook_id: Snowflake, webhook_token: String, message_id: Snowflake, params: UpdateWebhookMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/resources/webhook#edit-webhook-message

        Edits a previously-sent webhook message from the same token. Returns a message object on success.

        When the content field is edited, the arrays mentions and mention_roles and the boolean mention_everyone in the message object will be reconstructed from scratch based on the new content. When the message flag IS_COMPONENTS_V2 is set, the reconstructed arrays and boolean are based on the edited content in the components array. The allowed_mentions field of the edit request controls how this happens. If there is no explicit allowed_mentions in the edit request, the content will be parsed with _default_ allowances, that is, without regard to whether or not an allowed_mentions was present in the request that originally created the message.

        Refer to Uploading Files for details on attachments and multipart/form-data requests.
        Any provided files will be appended to the message. To remove or replace files you will have to supply the attachments field which specifies the files to retain on the message after edit.

        Starting with API v10, the attachments array must contain all attachments that should be present after edit, including retained and new attachments provided in the request body.

        All parameters to this endpoint are optional and nullable.
        """

        api.send_request(options.build_request(courier.PATCH, "/webhooks/" + webhook_id.string() + "/" + webhook_token + "/messages/" + message_id.string() where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be delete_webhook_message(webhook_id: Snowflake, webhook_token: String, message_id: Snowflake, params: DeleteWebhookMessageParams, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/resources/webhook#delete-webhook-message

        Deletes a message that was created by the webhook. Returns a 204 No Content response on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/webhooks/" + webhook_id.string() + "/" + webhook_token + "/messages/" + message_id.string() where query = params.to_query()), _Decode.empty(handler, options.on_error))

    be create_interaction_response(interaction_id: Snowflake, interaction_token: String, params: CreateInteractionResponseParams, handler: ResponseHandler[InteractionCallbackResponse]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#create-interaction-response

        Create a response to an Interaction. Body is an interaction response. Returns 204 unless with_response is set to true which returns 200 with the body as interaction callback response.

        This endpoint also supports file attachments similar to the webhook endpoints. Refer to Uploading Files for details on uploading files and multipart/form-data requests.
        """

        api.send_request(options.build_request(courier.POST, "/interactions/" + interaction_id.string() + "/" + interaction_token + "/callback" where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[InteractionCallbackResponse](handler, options.on_error))

    be get_original_interaction_response(application_id: Snowflake, interaction_token: String, params: GetOriginalInteractionResponseParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#get-original-interaction-response

        Returns the initial Interaction response. Functions the same as Get Webhook Message.
        """

        api.send_request(options.build_request(courier.GET, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/@original" where query = params.to_query()), _Decode.entity[Message](handler, options.on_error))

    be update_original_interaction_response(application_id: Snowflake, interaction_token: String, params: UpdateOriginalInteractionResponseParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#edit-original-interaction-response

        Edits the initial Interaction response. Functions the same as Edit Webhook Message.
        """

        api.send_request(options.build_request(courier.PATCH, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/@original" where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be delete_original_interaction_response(application_id: Snowflake, interaction_token: String, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#delete-original-interaction-response

        Deletes the initial Interaction response. Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/@original"), _Decode.empty(handler, options.on_error))

    be create_followup_message(application_id: Snowflake, interaction_token: String, params: CreateFollowupMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#create-followup-message

        Apps are limited to 5 followup messages per interaction if it was initiated from a user-installed app and isn't installed in the server (meaning the authorizing integration owners object only contains USER_INSTALL)

        Create a followup message for an Interaction. Functions the same as Execute Webhook, but wait is always true. The thread_id, avatar_url, and username parameters are not supported when using this endpoint for interaction followups. You can use the EPHEMERAL message flag 1 << 6 (64) to send a message that only the user can see. You can also use the IS_COMPONENTS_V2 message flag 1 << 15 (32768) to send a component-based message.

        When using this endpoint directly after responding to an interaction with DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE, this endpoint will function as Edit Original Interaction Response for backwards compatibility. In this case, no new message will be created, and the loading message will be edited instead. The ephemeral flag will be ignored, and the value you provided in the initial defer response will be preserved, as an existing message's ephemeral state cannot be changed. This behavior is deprecated, and you should use the Edit Original Interaction Response endpoint in this case instead.
        """

        api.send_request(options.build_request(courier.POST, "/webhooks/" + application_id.string() + "/" + interaction_token where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be get_followup_message(application_id: Snowflake, interaction_token: String, message_id: Snowflake, params: GetFollowupMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#get-followup-message

        Returns a followup message for an Interaction. Functions the same as Get Webhook Message.
        """

        api.send_request(options.build_request(courier.GET, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/" + message_id.string() where query = params.to_query()), _Decode.entity[Message](handler, options.on_error))

    be update_followup_message(application_id: Snowflake, interaction_token: String, message_id: Snowflake, params: UpdateFollowupMessageParams, handler: ResponseHandler[Message]) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#edit-followup-message

        Edits a followup message for an Interaction. Functions the same as Edit Webhook Message.
        """

        api.send_request(options.build_request(courier.PATCH, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/" + message_id.string() where query = params.to_query(), body = json.JsonPrinter.print(params.to_json())), _Decode.entity[Message](handler, options.on_error))

    be delete_followup_message(application_id: Snowflake, interaction_token: String, message_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/interactions/receiving-and-responding#delete-followup-message

        Deletes a followup message for an Interaction. Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/webhooks/" + application_id.string() + "/" + interaction_token + "/messages/" + message_id.string()), _Decode.empty(handler, options.on_error))

    be get_global_application_commands(application_id: Snowflake, params: GetGlobalApplicationCommandsParams, handler: ResponseHandler[Array[ApplicationCommand] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-global-application-commands

        The objects returned by this endpoint may be augmented with additional fields if localization is active.

        Fetch all of the global commands for your application. Returns an array of application command objects.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/commands" where query = params.to_query()), _Decode.list[ApplicationCommand](handler, options.on_error))

    be create_global_application_command(application_id: Snowflake, params: CreateGlobalApplicationCommandParams, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#create-global-application-command

        Creating a command with the same name as an existing command for your application will overwrite the old command.

        Create a new global command. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.
        """

        api.send_request(options.build_request(courier.POST, "/applications/" + application_id.string() + "/commands" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be get_global_application_command(application_id: Snowflake, command_id: Snowflake, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-global-application-command

        Fetch a global command for your application. Returns an application command object.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/commands/" + command_id.string()), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be update_global_application_command(application_id: Snowflake, command_id: Snowflake, params: UpdateGlobalApplicationCommandParams, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#edit-global-application-command

        All parameters for this endpoint are optional.

        Edit a global command. Returns 200 and an application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.
        """

        api.send_request(options.build_request(courier.PATCH, "/applications/" + application_id.string() + "/commands/" + command_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be delete_global_application_command(application_id: Snowflake, command_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#delete-global-application-command

        Deletes a global command. Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/applications/" + application_id.string() + "/commands/" + command_id.string()), _Decode.empty(handler, options.on_error))

    be bulk_overwrite_global_application_commands(application_id: Snowflake, params: BulkOverwriteGlobalApplicationCommandsParams, handler: ResponseHandler[Array[ApplicationCommand] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#bulk-overwrite-global-application-commands

        Takes a list of application commands, overwriting the existing global command list for this application. Returns 200 and a list of application command objects. Commands that do not already exist will count toward daily application command create limits.

        This will overwrite all types of application commands: slash commands, user commands, and message commands.
        """

        api.send_request(options.build_request(courier.PUT, "/applications/" + application_id.string() + "/commands" where body = json.JsonPrinter.print(params.to_json())), _Decode.list[ApplicationCommand](handler, options.on_error))

    be get_guild_application_commands(application_id: Snowflake, guild_id: Snowflake, params: GetGuildApplicationCommandsParams, handler: ResponseHandler[Array[ApplicationCommand] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-guild-application-commands

        The objects returned by this endpoint may be augmented with additional fields if localization is active.

        Fetch all of the guild commands for your application for a specific guild. Returns an array of application command objects.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands" where query = params.to_query()), _Decode.list[ApplicationCommand](handler, options.on_error))

    be create_guild_application_command(application_id: Snowflake, guild_id: Snowflake, params: CreateGuildApplicationCommandParams, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#create-guild-application-command

        Creating a command with the same name as an existing command for your application will overwrite the old command.

        Create a new guild command. New guild commands will be available in the guild immediately. Returns 201 if a command with the same name does not already exist, or a 200 if it does (in which case the previous command will be overwritten). Both responses include an application command object.
        """

        api.send_request(options.build_request(courier.POST, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be get_guild_application_command(application_id: Snowflake, guild_id: Snowflake, command_id: Snowflake, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-guild-application-command

        Fetch a guild command for your application. Returns an application command object.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/" + command_id.string()), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be update_guild_application_command(application_id: Snowflake, guild_id: Snowflake, command_id: Snowflake, params: UpdateGuildApplicationCommandParams, handler: ResponseHandler[ApplicationCommand]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#edit-guild-application-command

        All parameters for this endpoint are optional.

        Edit a guild command. Updates for guild commands will be available immediately. Returns 200 and an application command object. All fields are optional, but any fields provided will entirely overwrite the existing values of those fields.
        """

        api.send_request(options.build_request(courier.PATCH, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/" + command_id.string() where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[ApplicationCommand](handler, options.on_error))

    be delete_guild_application_command(application_id: Snowflake, guild_id: Snowflake, command_id: Snowflake, handler: EmptyResponseHandler) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#delete-guild-application-command

        Delete a guild command. Returns 204 No Content on success.
        """

        api.send_request(options.build_request(courier.DELETE, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/" + command_id.string()), _Decode.empty(handler, options.on_error))

    be bulk_overwrite_guild_application_commands(application_id: Snowflake, guild_id: Snowflake, params: BulkOverwriteGuildApplicationCommandsParams, handler: ResponseHandler[Array[ApplicationCommand] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#bulk-overwrite-guild-application-commands

        Takes a list of application commands, overwriting the existing command list for this application for the targeted guild. Returns 200 and a list of application command objects.

        This will overwrite all types of application commands: slash commands, user commands, and message commands.
        """

        api.send_request(options.build_request(courier.PUT, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands" where body = json.JsonPrinter.print(params.to_json())), _Decode.list[ApplicationCommand](handler, options.on_error))

    be get_guild_application_command_permissions(application_id: Snowflake, guild_id: Snowflake, handler: ResponseHandler[Array[GuildApplicationCommandPermissions] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-guild-application-command-permissions

        Fetches permissions for all commands for your application in a guild. Returns an array of guild application command permissions objects.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/permissions"), _Decode.list[GuildApplicationCommandPermissions](handler, options.on_error))

    be get_application_command_permissions(application_id: Snowflake, guild_id: Snowflake, command_id: Snowflake, handler: ResponseHandler[GuildApplicationCommandPermissions]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#get-application-command-permissions

        Fetches permissions for a specific command for your application in a guild. Returns a guild application command permissions object.
        """

        api.send_request(options.build_request(courier.GET, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/" + command_id.string() + "/permissions"), _Decode.entity[GuildApplicationCommandPermissions](handler, options.on_error))

    be update_application_command_permissions(application_id: Snowflake, guild_id: Snowflake, command_id: Snowflake, params: UpdateApplicationCommandPermissionsParams, handler: ResponseHandler[GuildApplicationCommandPermissions]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#edit-application-command-permissions

        This endpoint will overwrite existing permissions for the command in that guild

        Edits command permissions for a specific command for your application in a guild and returns a guild application command permissions object. Fires an Application Command Permissions Update Gateway event.

        You can add up to 100 permission overwrites for a command.

        This endpoint requires authentication with a Bearer token that has permission to manage the guild and its roles. For more information, read above about application command permissions.

        Deleting or renaming a command will permanently delete all permissions for the command
        """

        api.send_request(options.build_request(courier.PUT, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/" + command_id.string() + "/permissions" where body = json.JsonPrinter.print(params.to_json())), _Decode.entity[GuildApplicationCommandPermissions](handler, options.on_error))

    be batch_update_application_command_permissions(application_id: Snowflake, guild_id: Snowflake, params: BatchUpdateApplicationCommandPermissionsParams, handler: ResponseHandler[Array[GuildApplicationCommandPermissions] val]) =>
        """
        https://docs.discord.com/developers/interactions/application-commands#batch-edit-application-command-permissions

        This endpoint has been disabled with updates to command permissions (Permissions v2). Instead, you can edit each application command permissions (though you should be careful to handle any potential rate limits).
        """

        api.send_request(options.build_request(courier.PUT, "/applications/" + application_id.string() + "/guilds/" + guild_id.string() + "/commands/permissions" where body = json.JsonPrinter.print(params.to_json())), _Decode.list[GuildApplicationCommandPermissions](handler, options.on_error))

    be get_current_bot_application_information(handler: ResponseHandler[Application]) =>
        """
        https://docs.discord.com/developers/topics/oauth2#get-current-bot-application-information

        Returns the bot's application object.
        """

        api.send_request(options.build_request(courier.GET, "/oauth2/applications/@me"), _Decode.entity[Application](handler, options.on_error))

    be get_current_authorization_information(handler: ResponseHandler[AuthorizationInformation]) =>
        """
        https://docs.discord.com/developers/topics/oauth2#get-current-authorization-information

        Returns info about the current authorization. Requires authentication with a bearer token.
        """

        api.send_request(options.build_request(courier.GET, "/oauth2/@me"), _Decode.entity[AuthorizationInformation](handler, options.on_error))

    be get_gateway(handler: ResponseHandler[GatewayInfo]) =>
        """
        https://docs.discord.com/developers/events/gateway#get-gateway

        This endpoint does not require authentication.

        Returns an object with a valid WSS URL which the app can use when Connecting to the Gateway. Apps should cache this value and only call this endpoint to retrieve a new URL when they are unable to properly establish a connection using the cached one.
        """

        api.send_request(options.build_request(courier.GET, "/gateway"), _Decode.entity[GatewayInfo](handler, options.on_error))

    be get_gateway_bot(handler: ResponseHandler[GatewayBotInfo]) =>
        """
        https://docs.discord.com/developers/events/gateway#get-gateway-bot

        This endpoint requires authentication using a valid bot token.

        Returns an object based on the information in Get Gateway, plus additional metadata that can help during the operation of large or sharded bots. Unlike the Get Gateway, this route should not be cached for extended periods of time as the value is not guaranteed to be the same per-call, and changes as the bot joins/leaves guilds.
        """

        api.send_request(options.build_request(courier.GET, "/gateway/bot"), _Decode.entity[GatewayBotInfo](handler, options.on_error))

primitive _Decode
    """
    Adapts typed handlers down to the `RawResponseHandler` that `RestApi` takes.

    Every adapter checks the status before decoding, so a route handler only
    ever runs on a response Discord actually succeeded at. Anything else — an
    error status, a body that will not parse, a payload that does not match the
    type the route returns — goes to `on_error` instead.
    """

    fun entity[A: FromJsonable val](handler: ResponseHandler[A], on_error: RestErrorHandler): RawResponseHandler =>
        """
        Decodes a lone object, as returned by routes documented as returning
        "a ... object".
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                try
                    handler(A.from_json(_Decode.parse(response)? as json.JsonObject)?)
                else
                    on_error(_Decode.undecodable(request, response))
                end
            end
        }

    fun list[A: FromJsonable val](handler: ResponseHandler[Array[A] val], on_error: RestErrorHandler): RawResponseHandler =>
        """
        Decodes an array, as returned by routes documented as returning "a list
        of ... objects".
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                try
                    handler(_Decode.entities[A](_Decode.parse(response)?)?)
                else
                    on_error(_Decode.undecodable(request, response))
                end
            end
        }

    fun wrapped[A: FromJsonable val](handler: ResponseHandler[Array[A] val], key: String, on_error: RestErrorHandler): RawResponseHandler =>
        """
        Decodes an array held under `key` of an enclosing object, as returned by
        routes documented as returning "an object containing a list of ...
        objects". The enclosing object carries nothing else, so it is unwrapped
        rather than modelled.
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                try
                    handler(_Decode.entities[A]((_Decode.parse(response)? as json.JsonObject)(key)?)?)
                else
                    on_error(_Decode.undecodable(request, response))
                end
            end
        }

    fun entities[A: FromJsonable val](value: json.JsonValue): Array[A] val ? =>
        """
        Decodes a JSON array into an array of the element type, erroring if it
        is not an array of objects each of which decodes.
        """

        let array = value as json.JsonArray
        recover val
            let entities' = Array[A](array.size())
            for value' in array.values() do entities'.push(A.from_json(value' as json.JsonObject)?) end
            entities'
        end

    // Spelled out rather than written as `ResponseHandler[json.JsonValue]`.
    // ponyc 0.68.0 loses the `json` package alias when a value typed by a
    // generic type alias reified with a package-qualified type is captured by a
    // lambda, and fails with "can't find definition of 'JsonValue'":
    //
    //     type H[A: Any val] is {(A)} val
    //     fun p(h: H[json.JsonValue]): {(json.JsonValue)} val => {(v: json.JsonValue) => h(v) }
    //
    // Naming the lambda type directly sidesteps the expansion. The routes above
    // can still write `ResponseHandler[json.JsonValue]`, as they never capture
    // the handler themselves.
    fun payload(handler: {(json.JsonValue)} val, on_error: RestErrorHandler): RawResponseHandler =>
        """
        Hands back the parsed JSON as-is, for routes whose response shape this
        package does not model yet.
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                try
                    handler(_Decode.parse(response)?)
                else
                    on_error(_Decode.undecodable(request, response))
                end
            end
        }

    fun text(handler: ResponseHandler[String], on_error: RestErrorHandler): RawResponseHandler =>
        """
        Hands back the body as text, for routes that do not respond with JSON.
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                handler(String.from_array(response.body))
            end
        }

    fun bytes(handler: ResponseHandler[Array[U8] val], on_error: RestErrorHandler): RawResponseHandler =>
        """
        Hands back the body unchanged, for routes that respond with binary.
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                handler(response.body)
            end
        }

    fun empty(handler: EmptyResponseHandler, on_error: RestErrorHandler): RawResponseHandler =>
        """
        Discards the body of a route that responds with no content.
        """

        {(request: courier.HTTPRequest val, response: courier.HTTPResponse val) =>
            match _Decode.rejected(request, response)
            | let rejection: RestError => on_error(rejection)
            else
                handler()
            end
        }

    fun rejected(request: courier.HTTPRequest val, response: courier.HTTPResponse val): (RestError | None) =>
        """
        Turns a non-success status into a `RestError`, carrying Discord's own
        error body along since that is where the JSON error code lives.
        """

        if (response.status < 200) or (response.status > 299) then
            RestError(request, "Discord answered " + response.status.string() + " " + response.reason + ": " + String.from_array(response.body))
        end

    fun undecodable(request: courier.HTTPRequest val, response: courier.HTTPResponse val): RestError =>
        """
        Reports a success response whose body was not what the route expected.
        """

        RestError(request, "the response body did not match the type this route returns: " + String.from_array(response.body))

    fun parse(response: courier.HTTPResponse val): json.JsonValue ? =>
        """
        Parses a response body as JSON, erroring if it is not well-formed.
        """

        match json.JsonParser.parse(String.from_array(response.body))
        | let _: json.JsonParseError => error
        | let parsed: json.JsonValue => parsed
        end
