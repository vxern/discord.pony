class AuditLog
    """
    When an administrative action is performed in a guild, an entry is added to its audit log. Viewing audit logs requires the VIEW_AUDIT_LOG permission and can be fetched by apps using the GET /guilds/{guild.id}/audit-logs endpoint, or seen by users in the guild’s Server Settings. All audit log entries are stored for 45 days.

    When an app is performing an eligible action using the APIs, it can pass an X-Audit-Log-Reason header to indicate why the action was taken. More information is in the audit log entry section.
    """
    // TODO(vxern): Implement.

class AuditLogEntry
    """
    Each audit log entry represents a single administrative action (or event), indicated by action_type. Most entries contain one to many changes in the changes array that affected an entity in Discord—whether that’s a user, channel, guild, emoji, or something else.

    The information (and structure) of an entry’s changes will be different depending on its type. For example, in MEMBER_ROLE_UPDATE events there is only one change: a member is either added or removed from a specific role. However, in CHANNEL_CREATE events there are many changes, including (but not limited to) the channel’s name, type, and permission overwrites added. More details are in the change object section.

    Apps can specify why an administrative action is being taken by passing an X-Audit-Log-Reason request header, which will be stored as the audit log entry’s reason field. The X-Audit-Log-Reason header supports 1-512 URL-encoded UTF-8 characters. Reasons are visible to users in the client and to apps when fetching audit log entries with the API.
    """
    // TODO(vxern): Implement.

trait AuditLogEvent
    """
    Audit log events and values (the action_type field) that your app may receive.

    The Object Changed column notes which object’s values may be included in the entry. Though there are exceptions, possible keys in the changes array typically correspond to the object’s fields. The descriptions and types for those fields can be found in the linked documentation for the object.

    If no object is noted, there won’t be a changes array in the entry, though other fields like the target_id still exist and many have fields in the options object.
    """
    // TODO(vxern): Implement.

class OptionalAuditEntryInfo
    // TODO(vxern): Implement.

class AuditLogChange
    """
    Many audit log events include a changes array in their entry object. The structure for the individual changes varies based on the event type and its changed objects, so apps shouldn’t depend on a single pattern of handling audit log events.

    Some events don’t follow the same pattern as other audit log events. Details about these exceptions are explained in the next section.
    """
    // TODO(vxern): Implement.
