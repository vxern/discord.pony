use collections = "collections"

// TODO(vxern): This is temporary.
type ParamsStub is None
type Reason is (String | None)

actor Rest
    let options: RestOptions

    new create(options': RestOptions) => options = options'

    fun base_url() => "https://discord.com/api"

    fun bot_authorization_header(token: String) => "Authorization: Bot " + token
    
    // TODO(vxern): Implement.
    be get_application_role_connection_metadata(application_id: Snowflake) => "/applications/" + application_id.string() + "/role-connections/metadata"
        """
        https://docs.discord.com/developers/resources/application-role-connection-metadata#get-application-role-connection-metadata-records

        Returns a list of application role connection metadata objects for the given application.
        """
    
    // TODO(vxern): Implement.
    be update_application_role_connection_metadata(application_id: Snowflake, application_role_connection_metadata: Array[ApplicationRoleConnectionMetadata] val) => "/applications/" + application_id.string() + "/role-connections/metadata"
        """
        https://docs.discord.com/developers/resources/application-role-connection-metadata#update-application-role-connection-metadata-records

        Updates and returns a list of application role connection metadata objects for the given application.
        """
    
    // TODO(vxern): Implement.
    be get_application() => "/applications/@me"
        """
        https://docs.discord.com/developers/resources/application#get-current-application

        Returns the application object associated with the requesting bot user.
        """

    // TODO(vxern): Implement.
    be update_application(application: Application) => "/applications/@me"
        """
        https://docs.discord.com/developers/resources/application#edit-current-application

        Edit properties of the app associated with the requesting bot user. Only properties that are passed will be updated. Returns the updated application object on success.
        """

    // TODO(vxern): Implement.
    be get_application_activity_instance(application_id: Snowflake, activity_instance_id: Snowflake) => "/applications/" + application_id.string() + "/activity-instances/" + activity_instance_id.string()
        """
        https://docs.discord.com/developers/resources/application#get-application-activity-instance

        Returns a serialized activity instance, if it exists. Useful for preventing unwanted activity sessions.
        """

    // TODO(vxern): Implement.
    be get_audit_log(guild_id: Snowflake, params: ParamsStub) => "/guilds/" + guild_id.string() + "/audit-logs"
        """
        https://docs.discord.com/developers/resources/audit-log#get-guild-audit-log

        Returns an audit log object for the guild. Requires the VIEW_AUDIT_LOG permission.

        The returned list of audit log entries is ordered based on whether you use before or after. When using before, the list is ordered by the audit log entry ID descending (newer entries first). If after is used, the list is reversed and appears in ascending order (older entries first). Omitting both before and after defaults to before the current timestamp and will show the most recent entries in descending order by ID, the opposite can be achieved using after=0 (showing oldest entries).
        """

    // TODO(vxern): Implement.
    be get_auto_moderation_rules(guild_id: Snowflake) => "/guilds/" + guild_id.string() + "/auto-moderation/rules"
        """
        https://docs.discord.com/developers/resources/auto-moderation#list-auto-moderation-rules-for-guild

        Get a list of all rules currently configured for the guild. Returns a list of auto moderation rule objects for the given guild.
        """

    // TODO(vxern): Implement.
    be get_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake) => "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        https://docs.discord.com/developers/resources/auto-moderation#get-auto-moderation-rule

        Get a single rule. Returns an auto moderation rule object.
        """

    // TODO(vxern): Implement.
    be create_auto_moderation_rule(guild_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/guilds/" + guild_id.string() + "/auto-moderation/rules"
        """
        https://docs.discord.com/developers/resources/auto-moderation#create-auto-moderation-rule

        Create a new rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Create Gateway event.
        """

    // TODO(vxern): Implement.
    be edit_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        https://docs.discord.com/developers/resources/auto-moderation#modify-auto-moderation-rule

        Modify an existing rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Update Gateway event.
        """

    // TODO(vxern): Implement.
    be delete_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake, reason: Reason = None) => "/guilds/" + guild_id.string() + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        https://docs.discord.com/developers/resources/auto-moderation#delete-auto-moderation-rule
        
        Delete a rule. Returns a 204 on success. Fires an Auto Moderation Rule Delete Gateway event.
        """

    // TODO(vxern): Implement.
    be get_channel(channel_id: Snowflake) => "/channels/" + channel_id.string()
        """
        https://docs.discord.com/developers/resources/channel#get-channel

        Get a channel by ID. Returns a channel object. If the channel is a thread, a thread member object is included in the returned result.
        """

    // TODO(vxern): Implement.
    be edit_channel(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string()
        """
        https://docs.discord.com/developers/resources/channel#modify-channel

        Update a channel’s settings. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters.
        """

    // TODO(vxern): Implement.
    be set_voice_channel_status(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/voice-status"
        """
        https://docs.discord.com/developers/resources/channel#set-voice-channel-status

        Set a voice channel’s status. Requires the SET_VOICE_CHANNEL_STATUS permission, and additionally the MANAGE_CHANNELS permission if the current user is not connected to the voice channel. Fires a Voice Channel Status Update Gateway event.
        """

    // TODO(vxern): Implement.
    be delete_channel(channel_id: Snowflake, reason: Reason = None) => "/channels/" + channel_id.string()
        """
        https://docs.discord.com/developers/resources/channel#delete/close-channel

        Delete a channel, or close a private message. Requires the MANAGE_CHANNELS permission for the guild, or MANAGE_THREADS if the channel is a thread. Deleting a category does not delete its child channels; they will have their parent_id removed and a Channel Update Gateway event will fire for each of them. Returns a channel object on success. Fires a Channel Delete Gateway event (or Thread Delete if the channel was a thread).
        """

    // TODO(vxern): Implement.
    be edit_channel_permissions(channel_id: Snowflake, permission_overwrite_id: Snowflake, reason: Reason = None) => "/channels/" + channel_id.string() + "/permissions/" + permission_overwrite_id.string()
        """
        https://docs.discord.com/developers/resources/channel#edit-channel-permissions

        Edit the channel permission overwrites for a user or role in a channel. Only usable for guild channels. Requires the MANAGE_ROLES permission. Only permissions your bot has in the guild or parent channel (if applicable) can be allowed/denied (unless your bot has a MANAGE_ROLES overwrite in the channel). Returns a 204 empty response on success. Fires a Channel Update Gateway event. For more information about permissions, see permissions.
        """

    // TODO(vxern): Implement.
    be get_channel_invites(channel_id: Snowflake) => "/channels/" + channel_id.string() + "/invites"
        """
        https://docs.discord.com/developers/resources/channel#get-channel-invites

        Returns a list of invite objects (with invite metadata) for the channel. Only usable for guild channels. Requires the MANAGE_CHANNELS permission.
        """

    // TODO(vxern): Implement.
    be create_channel_invite(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/invites"
        """
        https://docs.discord.com/developers/resources/channel#create-channel-invite

        Create a new invite object for the channel. Only usable for guild channels. Requires the CREATE_INSTANT_INVITE permission. All JSON parameters for this route are optional, however the request body is not. If you are not sending any fields, you still have to send an empty JSON object ({}). Returns an invite object. Fires an Invite Create Gateway event.
        """

    // TODO(vxern): Implement.
    be delete_channel_permission_overwrite(channel_id: Snowflake, permission_overwrite_id: Snowflake, reason: Reason = None) => "/channels/" + channel_id.string() + "/permissions/" + permission_overwrite_id.string()
        """
        https://docs.discord.com/developers/resources/channel#delete-channel-permission

        Delete a channel permission overwrite for a user or role in a channel. Only usable for guild channels. Requires the MANAGE_ROLES permission. Returns a 204 empty response on success. Fires a Channel Update Gateway event. For more information about permissions, see permissions
        """

    // TODO(vxern): Implement.
    be follow_announcement_channel(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/followers"
        """
        https://docs.discord.com/developers/resources/channel#follow-announcement-channel

        Follow an Announcement Channel to send messages to a target channel. Requires the MANAGE_WEBHOOKS permission in the target channel. Returns a followed channel object. Fires a Webhooks Update Gateway event for the target channel.
        """

    // TODO(vxern): Implement.
    be trigger_typing_indicator(channel_id: Snowflake) => "/channels/" + channel_id.string() + "/typing"
        """
        https://docs.discord.com/developers/resources/channel#trigger-typing-indicator

        Post a typing indicator for the specified channel, which expires after 10 seconds. Returns a 204 empty response on success. Fires a Typing Start Gateway event.

        Generally bots should not use this route. However, if a bot is responding to a command and expects the computation to take a few seconds, this endpoint may be called to let the user know that the bot is processing their message.
        """

    // TODO(vxern): Implement.
    be add_group_dm_recipient(channel_id: Snowflake, user_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/recipients/" + user_id.string()
        """
        https://docs.discord.com/developers/resources/channel#group-dm-add-recipient

        Adds a recipient to a Group DM using their access token.
        """

    // TODO(vxern): Implement.
    be remove_group_dm_recipient(channel_id: Snowflake, user_id: Snowflake) => "/channels/" + channel_id.string() + "/recipients/" + user_id.string()
        """
        https://docs.discord.com/developers/resources/channel#group-dm-remove-recipient

        Removes a recipient from a Group DM.
        """

    // TODO(vxern): Implement.
    be start_thread_from_message(channel_id: Snowflake, message_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/messages/" + message_id.string() + "/threads"
        """
        https://docs.discord.com/developers/resources/channel#start-thread-from-message

        Creates a new thread from an existing message. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. Fires a Thread Create and a Message Update Gateway event.

        When called on a GUILD_TEXT channel, creates a PUBLIC_THREAD. When called on a GUILD_ANNOUNCEMENT channel, creates a ANNOUNCEMENT_THREAD. Does not work on a GUILD_FORUM or a GUILD_MEDIA channel. The id of the created thread will be the same as the id of the source message, and as such a message can only have a single thread created from it.
        """

    // TODO(vxern): Implement.
    be start_thread_without_message(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/threads"
        """
        https://docs.discord.com/developers/resources/channel#start-thread-without-message

        Creates a new thread that is not connected to an existing message. Returns a channel on success, and a 400 BAD REQUEST on invalid parameters. Fires a Thread Create Gateway event.
        """

    // TODO(vxern): Implement.
    be start_thread_in_forum_or_media_channel(channel_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/channels/" + channel_id.string() + "/threads"
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

    // TODO(vxern): Implement.
    be join_thread(channel_id: Snowflake) => "/channels/" + channel_id.string() + "/thread-members/@me"
        """
        https://docs.discord.com/developers/resources/channel#join-thread

        Adds the current user to a thread. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update and a Thread Create Gateway event.
        """

    // TODO(vxern): Implement.
    be add_thread_member(channel_id: Snowflake, user_id: Snowflake) => "/channels/" + channel_id.string() + "/thread-members/" + user_id.string()
        """
        https://docs.discord.com/developers/resources/channel#add-thread-member

        Adds another member to a thread. Requires the ability to send messages in the thread. Also requires the thread is not archived. Returns a 204 empty response if the member is successfully added or was already a member of the thread. Fires a Thread Members Update Gateway event.
        """

    // TODO(vxern): Implement.
    be leave_thread(channel_id: Snowflake) => "/channels/" + channel_id.string() + "/thread-members/@me"
        """
        https://docs.discord.com/developers/resources/channel#leave-thread

        Removes the current user from a thread. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update Gateway event.
        """

    // TODO(vxern): Implement.
    be remove_thread_member(channel_id: Snowflake, user_id: Snowflake) => "/channels/" + channel_id.string() + "/thread-members/" + user_id.string()
        """
        https://docs.discord.com/developers/resources/channel#remove-thread-member

        Removes another member from a thread. Requires the MANAGE_THREADS permission, or the creator of the thread if it is a PRIVATE_THREAD. Also requires the thread is not archived. Returns a 204 empty response on success. Fires a Thread Members Update Gateway event.
        """

    // TODO(vxern): Implement.
    be get_thread_member(channel_id: Snowflake, user_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/thread-members/" + user_id.string()
        """
        https://docs.discord.com/developers/resources/channel#get-thread-member

        Returns a thread member object for the specified user if they are a member of the thread, returns a 404 response otherwise.

        When with_member is set to true, the thread member object will include a member field containing a guild member object.
        """

    // TODO(vxern): Implement.
    be get_thread_members(channel_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/thread-members"
        """
        https://docs.discord.com/developers/resources/channel#list-thread-members

        Returns array of thread members objects that are members of the thread.

        When with_member is set to true, the results will be paginated and each thread member object will include a member field containing a guild member object.
        """

    // TODO(vxern): Implement.
    be get_public_archived_threads(channel_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/threads/archived/public"
        """
        https://docs.discord.com/developers/resources/channel#list-public-archived-threads

        Returns archived threads in the channel that are public. When called on a GUILD_TEXT channel, returns threads of type PUBLIC_THREAD. When called on a GUILD_ANNOUNCEMENT channel returns threads of type ANNOUNCEMENT_THREAD. Threads are ordered by archive_timestamp, in descending order. Requires the READ_MESSAGE_HISTORY permission.
        """

    // TODO(vxern): Implement.
    be get_private_archived_threads(channel_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/threads/archived/private"
        """
        https://docs.discord.com/developers/resources/channel#list-private-archived-threads

        Returns archived threads in the channel that are of type PRIVATE_THREAD. Threads are ordered by archive_timestamp, in descending order. Requires both the READ_MESSAGE_HISTORY and MANAGE_THREADS permissions.
        """

    // TODO(vxern): Implement.
    be get_joined_private_archived_threads(channel_id: Snowflake, params: ParamsStub) => "/channels/" + channel_id.string() + "/users/@me/threads/archived/private"
        """
        https://docs.discord.com/developers/resources/channel#list-joined-private-archived-threads

        Returns archived threads in the channel that are of type PRIVATE_THREAD, and the user has joined. Threads are ordered by their id, in descending order. Requires the READ_MESSAGE_HISTORY permission.
        """

    // TODO(vxern): Implement.
    be get_guild_emojis(guild_id: Snowflake) => "/guilds/" + guild_id.string() + "/emojis"
        """
        https://docs.discord.com/developers/resources/emoji#list-guild-emojis

        Returns a list of emoji objects for the given guild. Includes user fields if the bot has the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission.
        """

    // TODO(vxern): Implement.
    be get_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake) => "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#get-guild-emoji

        Returns an emoji object for the given guild and emoji IDs. Includes the user field if the bot has the MANAGE_GUILD_EXPRESSIONS permission, or if the bot created the emoji and has the CREATE_GUILD_EXPRESSIONS permission.
        """

    // TODO(vxern): Implement.
    be create_guild_emoji(guild_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/guilds/" + guild_id.string() + "/emojis"
        """
        https://docs.discord.com/developers/resources/emoji#create-guild-emoji

        Create a new emoji for the guild. Requires the CREATE_GUILD_EXPRESSIONS permission. Returns the new emoji object on success. Fires a Guild Emojis Update Gateway event.
        """

    // TODO(vxern): Implement.
    be update_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake, reason: Reason = None) => "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#modify-guild-emoji

        Modify the given emoji. For emojis created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other emojis, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns the updated emoji object on success. Fires a Guild Emojis Update Gateway event.
        """

    // TODO(vxern): Implement.
    be delete_guild_emoji(guild_id: Snowflake, emoji_id: Snowflake, reason: Reason = None) => "/guilds/" + guild_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#delete-guild-emoji

        Delete the given emoji. For emojis created by the current user, requires either the CREATE_GUILD_EXPRESSIONS or MANAGE_GUILD_EXPRESSIONS permission. For other emojis, requires the MANAGE_GUILD_EXPRESSIONS permission. Returns 204 No Content on success. Fires a Guild Emojis Update Gateway event.
        """

    // TODO(vxern): Implement.
    be get_application_emojis(application_id: Snowflake) => "/applications/" + application_id.string() + "/emojis"
        """
        https://docs.discord.com/developers/resources/emoji#list-application-emojis

        Returns an object containing a list of emoji objects for the given application under the items key. Includes a user object for the team member that uploaded the emoji from the app’s settings, or for the bot user if uploaded using the API.
        """

    // TODO(vxern): Implement.
    be get_application_emoji(application_id: Snowflake, emoji_id: Snowflake) => "/applications/" + application_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#get-application-emoji

        Returns an emoji object for the given application and emoji IDs. Includes the user field.
        """

    // TODO(vxern): Implement.
    be create_application_emoji(application_id: Snowflake) => "/applications/" + application_id.string() + "/emojis"
        """
        https://docs.discord.com/developers/resources/emoji#create-application-emoji

        Create a new emoji for the application. Returns the new emoji object on success.
        """

    // TODO(vxern): Implement.
    be update_application_emoji(application_id: Snowflake, emoji_id: Snowflake) => "/applications/" + application_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#modify-application-emoji

        Modify the given emoji. Returns the updated emoji object on success.
        """

    // TODO(vxern): Implement.
    be delete_application_emoji(application_id: Snowflake, emoji_id: Snowflake) => "/applications/" + application_id.string() + "/emojis/" + emoji_id.string()
        """
        https://docs.discord.com/developers/resources/emoji#delete-application-emoji

        Delete the given emoji. Returns 204 No Content on success.
        """

class val RestOptions
    let version: RestVersion val
    let user_agent: String

    new create(
        version': RestVersion val = RestDefaults.version(),
        user_agent': String = RestDefaults.user_agent()
    ) =>
        version = version'
        user_agent = user_agent'

trait val RestVersion is (collections.Hashable & Equatable[RestVersion])
    fun value(): U64
    fun id(): String => "v" + value().string()
    fun hash(): USize => value().hash()
    fun eq(that: RestVersion): Bool => value() == that.value()
primitive RestVersion6 is RestVersion
    fun value(): U64 => 6
primitive RestVersion7 is RestVersion
    fun value(): U64 => 7
primitive RestVersion8 is RestVersion
    fun value(): U64 => 8
primitive RestVersion9 is RestVersion
    fun value(): U64 => 9
primitive RestVersion10 is RestVersion
    fun value(): U64 => 10

primitive RestDefaults
    fun version(): RestVersion val => RestVersion6

    fun user_agent(): String =>
        "discord.pony (https://github.com/vxern/discord.pony, 1.0.0)"
