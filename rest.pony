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
        Returns a list of application role connection metadata objects for the given application.
        """
    
    // TODO(vxern): Implement.
    be update_application_role_connection_metadata(application_id: Snowflake, application_role_connection_metadata: Array[ApplicationRoleConnectionMetadata]) => "/applications/" + application_id.string() + "/role-connections/metadata"
        """
        Updates and returns a list of application role connection metadata objects for the given application.
        """
    
    // TODO(vxern): Implement.
    be get_application() => "/applications/@me"
        """
        Returns the application object associated with the requesting bot user.
        """

    // TODO(vxern): Implement.
    be update_application(application: Application) => "/applications/@me"
        """
        Edit properties of the app associated with the requesting bot user. Only properties that are passed will be updated. Returns the updated application object on success.
        """

    // TODO(vxern): Implement.
    be get_application_activity_instance(application_id: Snowflake, activity_instance_id: Snowflake) => "/applications/" + application_id.string() + "/activity-instances/" + activity_instance_id.string()
        """
        Returns a serialized activity instance, if it exists. Useful for preventing unwanted activity sessions.
        """

    // TODO(vxern): Implement.
    be get_audit_log(guild_id: Snowflake, params: ParamsStub) => "/guilds/" + guild_id.string() + "/audit-logs"
        """
        Returns an audit log object for the guild. Requires the VIEW_AUDIT_LOG permission.

        The returned list of audit log entries is ordered based on whether you use before or after. When using before, the list is ordered by the audit log entry ID descending (newer entries first). If after is used, the list is reversed and appears in ascending order (older entries first). Omitting both before and after defaults to before the current timestamp and will show the most recent entries in descending order by ID, the opposite can be achieved using after=0 (showing oldest entries).
        """

    // TODO(vxern): Implement.
    be get_auto_moderation_rules(guild_id: Snowflake) => "/guilds/" + guild_id.string() + "/auto-moderation/rules"
        """
        Get a list of all rules currently configured for the guild. Returns a list of auto moderation rule objects for the given guild.
        """

    // TODO(vxern): Implement.
    be get_auto_moderation_rule(guild_id: Snowflake, auto_moderation_rule_id: Snowflake) => "/guilds/" + guild_id + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        Get a single rule. Returns an auto moderation rule object.
        """

    // TODO(vxern): Implement.
    be create_auto_moderation_rule(guild_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/guilds/" + guild_id.string() + "/auto-moderation/rules"
        """
        Create a new rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Create Gateway event.
        """

    // TODO(vxern): Implement.
    be edit_auto_moderation_rule(guild_id: Snowflake, params: ParamsStub, reason: Reason = None) => "/guilds/" + guild_id + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        Modify an existing rule. Returns an auto moderation rule on success. Fires an Auto Moderation Rule Update Gateway event.
        """

    // TODO(vxern): Implement.
    be delete_auto_moderation_rule(guild_id: Snowflake, reason: Reason = None) => "/guilds/" + guild_id + "/auto-moderation/rules/" + auto_moderation_rule_id.string()
        """
        Delete a rule. Returns a 204 on success. Fires an Auto Moderation Rule Delete Gateway event.
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

trait RestVersion
    fun value(): U64
    fun id(): String => "v" + value().string()
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
