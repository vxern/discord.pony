class AutoModerationRule
    """
    Auto Moderation is a feature which allows each guild to set up rules that trigger based on some criteria. For example, a rule can trigger whenever a message contains a specific keyword.

    Rules can be configured to automatically execute actions whenever they trigger. For example, if a user tries to send a message which contains a certain keyword, a rule can trigger and block the message before it is sent.
    """
    // TODO(vxern): Implement.

class AutoModerationTriggerType
    """
    Characterizes the type of content which can trigger the rule.
    """
    // TODO(vxern): Implement.

class AutoModerationTriggerMetadata
    """
    Additional data used to determine whether a rule should be triggered. Different fields are relevant based on the value of trigger_type.
    """
    // TODO(vxern): Implement.

class KeywordPresetType
    // TODO(vxern): Implement.

class AutoModerationEventType
    """
    Indicates in what event context a rule should be checked.
    """

class AutoModerationAction
    """
    An action which will execute whenever a rule is triggered.
    """
    // TODO(vxern): Implement.

class AutoModerationActionType
    // TODO(vxern): Implement.

class AutoModerationActionMetadata
    """
    Additional data used when an action is executed. Different fields are relevant based on the value of action type."""
    // TODO(vxern): Implement.
