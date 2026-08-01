use collections = "collections"
use json = "json"

type InteractionData is (ApplicationCommandData | MessageComponentData | ModalSubmitData)
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-data

    While the `data` field is present for every interaction type except PING, its structure depends on the interaction's type.
    """

class val Interaction
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-structure

    An Interaction is the message that your application receives when a user uses an application command or a message component.

    For Slash Commands, it includes the values that the user submitted.

    For User Commands and Message Commands, it includes the resolved user or message on which the action was taken.

    For Message Components it includes identifying information about the component that was used. It will also include some metadata about how the interaction was triggered: the `guild_id`, `channel`, `member` and other fields.
    """

    let id: Snowflake
        """
        ID of the interaction
        """

    let application_id: Snowflake
        """
        ID of the application this interaction is for
        """

    let type': InteractionType
        """
        Type of interaction
        """

    let data: (InteractionData | None)
        """
        Interaction data payload

        Which of the three shapes this holds is determined by `type`.
        """

    // TODO(vxern): Add `guild` (partial guild object; Guild that the interaction was sent from) once a partial variant of `Guild` is implemented.

    let guild_id: (Snowflake | None)
        """
        Guild that the interaction was sent from
        """

    // TODO(vxern): Add `channel` (partial channel object; Channel that the interaction was sent from) once a partial variant of `Channel` is implemented.

    let channel_id: (Snowflake | None)
        """
        Channel that the interaction was sent from
        """

    let member: (GuildMember | None)
        """
        Guild member data for the invoking user, including permissions
        """

    let user: (User | None)
        """
        User object for the invoking user, if invoked in a DM
        """

    let token: String
        """
        Continuation token for responding to the interaction
        """

    let version: USize
        """
        Read-only property, always 1
        """

    let message: (Message | None)
        """
        For components, the message they were attached to
        """

    let app_permissions: Array[Permission] val
        """
        Bitwise set of permissions the app has in the source location of the interaction
        """

    let locale: (Locale | None)
        """
        Selected language of the invoking user

        Available on all interaction types except PING.
        """

    let guild_locale: (Locale | None)
        """
        Guild's preferred locale, if invoked in a guild
        """

    let entitlements: Array[Entitlement] val
        """
        For monetized apps, any entitlements for the invoking user, representing access to premium SKUs
        """

    let authorizing_integration_owners: collections.Map[ApplicationIntegrationType, Snowflake]
        """
        Mapping of installation contexts that the interaction was authorized for to related user or guild IDs
        """

    let context: (InteractionContextType | None)
        """
        Context where the interaction was triggered from
        """

    let attachment_size_limit: USize
        """
        Attachment size limit in bytes
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var type'': (InteractionType | None) = None
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var member': (GuildMember | None) = None
        var user': (User | None) = None
        var token': (String | None) = None
        var version': (USize | None) = None
        var message': (Message | None) = None
        var app_permissions': (Array[Permission] val | None) = None
        var locale': (Locale | None) = None
        var guild_locale': (Locale | None) = None
        var entitlements': (Array[Entitlement] val | None) = None
        var authorizing_integration_owners': (collections.Map[ApplicationIntegrationType, Snowflake] | None) = None
        var context': (InteractionContextType | None) = None
        var attachment_size_limit': (USize | None) = None

        // `data` is held undecoded until the whole object has been walked, as which shape it takes depends on `type`, and the two keys may arrive in either order.
        var data': (json.JsonObject | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "type" => type'' = InteractionTypes.from((value as I64).u8())?
            | "data" => data' = value as json.JsonObject
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel_id" => channel_id' = Snowflake.from_json(value)?
            | "member" => member' = GuildMember.from_json(value as json.JsonObject)?
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "token" => token' = value as String
            | "version" => version' = (value as I64).usize()
            | "message" => message' = Message.from_json(value as json.JsonObject)?
            | "app_permissions" => app_permissions' = _Permissions(value)?
            | "locale" => locale' = Locales.from(value as String)?
            | "guild_locale" => guild_locale' = Locales.from(value as String)?
            | "entitlements" => entitlements' = _Entitlements(value)?
            | "authorizing_integration_owners" => authorizing_integration_owners' = _AuthorizingIntegrationOwners(value)?
            | "context" => context' = InteractionContextTypes.from((value as I64).u8())?
            | "attachment_size_limit" => attachment_size_limit' = (value as I64).usize()
            end
        end

        id = id' as Snowflake
        application_id = application_id' as Snowflake
        type' = type'' as InteractionType
        guild_id = guild_id'
        channel_id = channel_id'
        member = member'
        user = user'
        token = token' as String
        version = version' as USize
        message = message'
        app_permissions = app_permissions' as Array[Permission] val
        locale = locale'
        guild_locale = guild_locale'
        entitlements = entitlements' as Array[Entitlement] val
        authorizing_integration_owners = authorizing_integration_owners' as collections.Map[ApplicationIntegrationType, Snowflake]
        context = context'
        attachment_size_limit = attachment_size_limit' as USize

        data =
            match (type', data')
            | (ApplicationCommandInteractionType, let obj': json.JsonObject) => ApplicationCommandData.from_json(obj')?
            | (ApplicationCommandAutocompleteInteractionType, let obj': json.JsonObject) => ApplicationCommandData.from_json(obj')?
            | (MessageComponentInteractionType, let obj': json.JsonObject) => MessageComponentData.from_json(obj')?
            | (ModalSubmitInteractionType, let obj': json.JsonObject) => ModalSubmitData.from_json(obj')?
            end

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("application_id", application_id.to_json())
            .update("type", type'.value().i64())
            .update("token", token)
            .update("version", version.i64())
            .update("app_permissions", _Permissions.to_json(app_permissions))
            .update("entitlements", _Entitlements.to_json(entitlements))
            .update("authorizing_integration_owners", _AuthorizingIntegrationOwners.to_json(authorizing_integration_owners))
            .update("attachment_size_limit", attachment_size_limit.i64())

        match data
        | let data': ApplicationCommandData => obj = obj.update("data", data'.to_json())
        | let data': MessageComponentData => obj = obj.update("data", data'.to_json())
        | let data': ModalSubmitData => obj = obj.update("data", data'.to_json())
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match channel_id
        | let channel_id': Snowflake => obj = obj.update("channel_id", channel_id'.to_json())
        end

        match member
        | let member': GuildMember => obj = obj.update("member", member'.to_json())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match message
        | let message': Message => obj = obj.update("message", message'.to_json())
        end

        match locale
        | let locale': Locale => obj = obj.update("locale", locale'.value())
        end

        match guild_locale
        | let guild_locale': Locale => obj = obj.update("guild_locale", guild_locale'.value())
        end

        match context
        | let context': InteractionContextType => obj = obj.update("context", context'.value().i64())
        end

        obj

primitive _AuthorizingIntegrationOwners
    fun apply(value: json.JsonValue): collections.Map[ApplicationIntegrationType, Snowflake] ? =>
        """
        Decodes a mapping of installation contexts to the related user or guild IDs.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[ApplicationIntegrationType, Snowflake](obj.size())
        for (key, value') in obj.pairs() do
            map(ApplicationIntegrationTypes.from(key.u8()?)?) = Snowflake.from_json(value')?
        end
        map

    fun to_json(map: collections.Map[ApplicationIntegrationType, Snowflake] box): json.JsonObject =>
        var obj = json.JsonObject
        for (integration_type, id) in map.pairs() do obj = obj.update(integration_type.value().string(), id.to_json()) end
        obj

trait val InteractionType is (collections.Hashable & Equatable[InteractionType])
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-type
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InteractionType): Bool => value() == that.value()
primitive PingInteractionType is InteractionType
    fun value(): U8 => 1
primitive ApplicationCommandInteractionType is InteractionType
    fun value(): U8 => 2
primitive MessageComponentInteractionType is InteractionType
    fun value(): U8 => 3
primitive ApplicationCommandAutocompleteInteractionType is InteractionType
    fun value(): U8 => 4
primitive ModalSubmitInteractionType is InteractionType
    fun value(): U8 => 5
primitive InteractionTypes
    fun from(value: U8): InteractionType ? =>
        match value
        | 1 => PingInteractionType
        | 2 => ApplicationCommandInteractionType
        | 3 => MessageComponentInteractionType
        | 4 => ApplicationCommandAutocompleteInteractionType
        | 5 => ModalSubmitInteractionType
        else error
        end

trait val InteractionContextType is (collections.Hashable & Equatable[InteractionContextType])
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-context-types

    Context in Discord where an interaction can be used, or where it was triggered from. Details about using interaction contexts for application commands is in the commands context documentation.
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InteractionContextType): Bool => value() == that.value()
primitive GuildInteractionContextType is InteractionContextType
    """
    Interaction can be used within servers
    """

    fun value(): U8 => 0
primitive BotDMInteractionContextType is InteractionContextType
    """
    Interaction can be used within DMs with the app’s bot user
    """

    fun value(): U8 => 1
primitive PrivateChannelInteractionContextType is InteractionContextType
    """
    Interaction can be used within Group DMs and DMs other than the app’s bot user
    """

    fun value(): U8 => 2
primitive InteractionContextTypes
    fun from(value: U8): InteractionContextType ? =>
        match value
        | 0 => GuildInteractionContextType
        | 1 => BotDMInteractionContextType
        | 2 => PrivateChannelInteractionContextType
        else error
        end

class val ApplicationCommandData
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-application-command-data-structure

    Sent in APPLICATION_COMMAND and APPLICATION_COMMAND_AUTOCOMPLETE interactions.
    """

    let id: Snowflake
        """
        the ID of the invoked command
        """

    let name: String
        """
        the name of the invoked command
        """

    // TODO(vxern): Add `type` (integer; the type of the invoked command) once `ApplicationCommandType` is implemented.

    let resolved: (ResolvedData | None)
        """
        converted users + roles + channels + attachments
        """

    // TODO(vxern): Add `options` (array of application command interaction data option objects; the params + values from the user) once `ApplicationCommandInteractionDataOption` is implemented.

    let guild_id: (Snowflake | None)
        """
        the id of the guild the command is registered to
        """

    let target_id: (Snowflake | None)
        """
        id of the user or message targeted by a user or message command
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var resolved': (ResolvedData | None) = None
        var guild_id': (Snowflake | None) = None
        var target_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "resolved" => resolved' = ResolvedData.from_json(value as json.JsonObject)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "target_id" => target_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        name = name' as String
        resolved = resolved'
        guild_id = guild_id'
        target_id = target_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)

        match resolved
        | let resolved': ResolvedData => obj = obj.update("resolved", resolved'.to_json())
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match target_id
        | let target_id': Snowflake => obj = obj.update("target_id", target_id'.to_json())
        end

        obj

class val MessageComponentData
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-message-component-data-structure

    Sent in MESSAGE_COMPONENT interactions.
    """

    let custom_id: String
        """
        the custom_id of the component
        """

    let component_type: ComponentType
        """
        the type of the component
        """

    let values: (Array[String] val | None)
        """
        values the user selected in a select menu component

        This is always present for select menu components.
        """

    let resolved: (ResolvedData | None)
        """
        resolved entities from selected options
        """

    new val from_json(obj: json.JsonObject) ? =>
        var custom_id': (String | None) = None
        var component_type': (ComponentType | None) = None
        var values': (Array[String] val | None) = None
        var resolved': (ResolvedData | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "custom_id" => custom_id' = value as String
            | "component_type" => component_type' = ComponentTypes.from((value as I64).u8())?
            | "values" => values' = _Strings(value)?
            | "resolved" => resolved' = ResolvedData.from_json(value as json.JsonObject)?
            end
        end

        custom_id = custom_id' as String
        component_type = component_type' as ComponentType
        values = values'
        resolved = resolved'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("custom_id", custom_id)
            .update("component_type", component_type.value().i64())

        match values
        | let values': Array[String] val => obj = obj.update("values", _Strings.to_json(values'))
        end

        match resolved
        | let resolved': ResolvedData => obj = obj.update("resolved", resolved'.to_json())
        end

        obj

class val ModalSubmitData
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-modal-submit-data-structure

    Sent in MODAL_SUBMIT interactions.
    """

    let custom_id: String
        """
        the custom_id of the modal
        """

    let components: Array[Component] val
        """
        Values submitted by the user
        """

    new val from_json(obj: json.JsonObject) ? =>
        var custom_id': (String | None) = None
        var components': (Array[Component] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "custom_id" => custom_id' = value as String
            | "components" => components' = _Components(value)?
            end
        end

        custom_id = custom_id' as String
        components = components' as Array[Component] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("custom_id", custom_id)
            .update("components", _Components.to_json(components))

class val ResolvedData
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-resolved-data-structure

    If data for a Member is included, data for its corresponding User will also be included.
    """

    let users: (collections.Map[Snowflake, User] | None)
        """
        the ids and User objects
        """

    // TODO(vxern): Add `members` (map of snowflakes to partial member objects; the ids and partial Member objects) once a partial variant of `GuildMember` is implemented. Discord omits `user`, `deaf` and `mute` here, and `GuildMember` requires the latter two.

    let roles: (collections.Map[Snowflake, Role] | None)
        """
        the ids and Role objects
        """

    let channels: (collections.Map[Snowflake, Channel] | None)
        """
        the ids and partial Channel objects

        Partial Channel objects only have `id`, `name`, `type` and `permissions` fields. Threads will also have `thread_metadata` and `parent_id` fields.
        """

    let messages: (collections.Map[Snowflake, Message] | None)
        """
        the ids and partial Message objects
        """

    let attachments: (collections.Map[Snowflake, MessageAttachment] | None)
        """
        the ids and attachment objects
        """

    new val from_json(obj: json.JsonObject) ? =>
        var users': (collections.Map[Snowflake, User] | None) = None
        var roles': (collections.Map[Snowflake, Role] | None) = None
        var channels': (collections.Map[Snowflake, Channel] | None) = None
        var messages': (collections.Map[Snowflake, Message] | None) = None
        var attachments': (collections.Map[Snowflake, MessageAttachment] | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "users" => users' = _ResolvedUsers(value)?
            | "roles" => roles' = _ResolvedRoles(value)?
            | "channels" => channels' = _ResolvedChannels(value)?
            | "messages" => messages' = _ResolvedMessages(value)?
            | "attachments" => attachments' = _ResolvedAttachments(value)?
            end
        end

        users = users'
        roles = roles'
        channels = channels'
        messages = messages'
        attachments = attachments'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match users
        | let users': collections.Map[Snowflake, User] box => obj = obj.update("users", _ResolvedUsers.to_json(users'))
        end

        match roles
        | let roles': collections.Map[Snowflake, Role] box => obj = obj.update("roles", _ResolvedRoles.to_json(roles'))
        end

        match channels
        | let channels': collections.Map[Snowflake, Channel] box => obj = obj.update("channels", _ResolvedChannels.to_json(channels'))
        end

        match messages
        | let messages': collections.Map[Snowflake, Message] box => obj = obj.update("messages", _ResolvedMessages.to_json(messages'))
        end

        match attachments
        | let attachments': collections.Map[Snowflake, MessageAttachment] box => obj = obj.update("attachments", _ResolvedAttachments.to_json(attachments'))
        end

        obj

primitive _ResolvedUsers
    fun apply(value: json.JsonValue): collections.Map[Snowflake, User] ? =>
        """
        Decodes a mapping of snowflakes to users.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[Snowflake, User](obj.size())
        for (key, value') in obj.pairs() do
            map(Snowflake.from_json(key)?) = User.from_json(value' as json.JsonObject)?
        end
        map

    fun to_json(map: collections.Map[Snowflake, User] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, user) in map.pairs() do obj = obj.update(id.string(), user.to_json()) end
        obj

primitive _ResolvedRoles
    fun apply(value: json.JsonValue): collections.Map[Snowflake, Role] ? =>
        """
        Decodes a mapping of snowflakes to roles.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[Snowflake, Role](obj.size())
        for (key, value') in obj.pairs() do
            map(Snowflake.from_json(key)?) = Role.from_json(value' as json.JsonObject)?
        end
        map

    fun to_json(map: collections.Map[Snowflake, Role] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, role) in map.pairs() do obj = obj.update(id.string(), role.to_json()) end
        obj

primitive _ResolvedChannels
    fun apply(value: json.JsonValue): collections.Map[Snowflake, Channel] ? =>
        """
        Decodes a mapping of snowflakes to channels.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[Snowflake, Channel](obj.size())
        for (key, value') in obj.pairs() do
            map(Snowflake.from_json(key)?) = Channel.from_json(value' as json.JsonObject)?
        end
        map

    fun to_json(map: collections.Map[Snowflake, Channel] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, channel) in map.pairs() do obj = obj.update(id.string(), channel.to_json()) end
        obj

primitive _ResolvedMessages
    fun apply(value: json.JsonValue): collections.Map[Snowflake, Message] ? =>
        """
        Decodes a mapping of snowflakes to messages.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[Snowflake, Message](obj.size())
        for (key, value') in obj.pairs() do
            map(Snowflake.from_json(key)?) = Message.from_json(value' as json.JsonObject)?
        end
        map

    fun to_json(map: collections.Map[Snowflake, Message] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, message) in map.pairs() do obj = obj.update(id.string(), message.to_json()) end
        obj

primitive _ResolvedAttachments
    fun apply(value: json.JsonValue): collections.Map[Snowflake, MessageAttachment] ? =>
        """
        Decodes a mapping of snowflakes to attachments.
        """

        let obj = value as json.JsonObject
        let map = collections.Map[Snowflake, MessageAttachment](obj.size())
        for (key, value') in obj.pairs() do
            map(Snowflake.from_json(key)?) = MessageAttachment.from_json(value' as json.JsonObject)?
        end
        map

    fun to_json(map: collections.Map[Snowflake, MessageAttachment] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, attachment) in map.pairs() do obj = obj.update(id.string(), attachment.to_json()) end
        obj

class val InteractionResponse
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-interaction-response-structure
    """

    let type': InteractionCallbackType
        """
        the type of response
        """

    // TODO(vxern): Add `data` (interaction callback data; an optional response message) once `ApplicationCommandOptionChoice` is implemented. The messages and modal variants are now expressible, but the autocomplete variant carries `choices`, and the variant in play is determined by `type` rather than by a tag on `data` itself.

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (InteractionCallbackType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "type" => type'' = InteractionCallbackTypes.from((value as I64).u8())?
            end
        end

        type' = type'' as InteractionCallbackType

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("type", type'.value().i64())

trait val InteractionCallbackType is (collections.Hashable & Equatable[InteractionCallbackType])
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-interaction-callback-type
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: InteractionCallbackType): Bool => value() == that.value()
primitive PongInteractionCallbackType is InteractionCallbackType
    """
    ACK a Ping
    """

    fun value(): U8 => 1
primitive ChannelMessageWithSourceInteractionCallbackType is InteractionCallbackType
    """
    respond to an interaction with a message
    """

    fun value(): U8 => 4
primitive DeferredChannelMessageWithSourceInteractionCallbackType is InteractionCallbackType
    """
    ACK an interaction and edit a response later, the user sees a loading state
    """

    fun value(): U8 => 5
primitive DeferredUpdateMessageInteractionCallbackType is InteractionCallbackType
    """
    for components, ACK an interaction and edit the original message later; the user does not see a loading state

    Only valid for component-based interactions.
    """

    fun value(): U8 => 6
primitive UpdateMessageInteractionCallbackType is InteractionCallbackType
    """
    for components, edit the message the component was attached to

    Only valid for component-based interactions.
    """

    fun value(): U8 => 7
primitive ApplicationCommandAutocompleteResultInteractionCallbackType is InteractionCallbackType
    """
    respond to an autocomplete interaction with suggested choices
    """

    fun value(): U8 => 8
primitive ModalInteractionCallbackType is InteractionCallbackType
    """
    respond to an interaction with a popup modal

    Not available for MODAL_SUBMIT and PING interactions.
    """

    fun value(): U8 => 9
primitive PremiumRequiredInteractionCallbackType is InteractionCallbackType
    """
    deprecated; respond to an interaction with an upgrade button, only available for apps with monetization enabled
    """

    fun value(): U8 => 10
primitive LaunchActivityInteractionCallbackType is InteractionCallbackType
    """
    launch the Activity associated with the app

    Only available for apps with Activities enabled.
    """

    fun value(): U8 => 12
primitive InteractionCallbackTypes
    fun from(value: U8): InteractionCallbackType ? =>
        match value
        | 1 => PongInteractionCallbackType
        | 4 => ChannelMessageWithSourceInteractionCallbackType
        | 5 => DeferredChannelMessageWithSourceInteractionCallbackType
        | 6 => DeferredUpdateMessageInteractionCallbackType
        | 7 => UpdateMessageInteractionCallbackType
        | 8 => ApplicationCommandAutocompleteResultInteractionCallbackType
        | 9 => ModalInteractionCallbackType
        | 10 => PremiumRequiredInteractionCallbackType
        | 12 => LaunchActivityInteractionCallbackType
        else error
        end

class val InteractionCallbackResponse
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-response-object
    """

    let interaction: InteractionCallback
        """
        The interaction object associated with the interaction response
        """

    let resource: (InteractionCallbackResource | None)
        """
        The resource that was created by the interaction response
        """

    new val from_json(obj: json.JsonObject) ? =>
        var interaction': (InteractionCallback | None) = None
        var resource': (InteractionCallbackResource | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "interaction" => interaction' = InteractionCallback.from_json(value as json.JsonObject)?
            | "resource" => resource' = InteractionCallbackResource.from_json(value as json.JsonObject)?
            end
        end

        interaction = interaction' as InteractionCallback
        resource = resource'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("interaction", interaction.to_json())

        match resource
        | let resource': InteractionCallbackResource => obj = obj.update("resource", resource'.to_json())
        end

        obj

class val InteractionCallback
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-object
    """

    let id: Snowflake
        """
        ID of the interaction
        """

    let type': InteractionType
        """
        Interaction type
        """

    let activity_instance_id: (String | None)
        """
        Instance ID of the Activity if one was launched or joined
        """

    let response_message_id: (Snowflake | None)
        """
        ID of the message that was created by the interaction
        """

    let response_message_loading: (Bool | None)
        """
        Whether or not the message is in a loading state
        """

    let response_message_ephemeral: (Bool | None)
        """
        Whether or not the response message was ephemeral
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (InteractionType | None) = None
        var activity_instance_id': (String | None) = None
        var response_message_id': (Snowflake | None) = None
        var response_message_loading': (Bool | None) = None
        var response_message_ephemeral': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = InteractionTypes.from((value as I64).u8())?
            | "activity_instance_id" =>
                match value | let string: String => activity_instance_id' = string end
            | "response_message_id" =>
                match value | let string: String => response_message_id' = Snowflake.from_json(string)? end
            | "response_message_loading" => response_message_loading' = value as Bool
            | "response_message_ephemeral" => response_message_ephemeral' = value as Bool
            end
        end

        id = id' as Snowflake
        type' = type'' as InteractionType
        activity_instance_id = activity_instance_id'
        response_message_id = response_message_id'
        response_message_loading = response_message_loading'
        response_message_ephemeral = response_message_ephemeral'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())

        match activity_instance_id
        | let activity_instance_id': String => obj = obj.update("activity_instance_id", activity_instance_id')
        end

        match response_message_id
        | let response_message_id': Snowflake => obj = obj.update("response_message_id", response_message_id'.to_json())
        end

        match response_message_loading
        | let response_message_loading': Bool => obj = obj.update("response_message_loading", response_message_loading')
        end

        match response_message_ephemeral
        | let response_message_ephemeral': Bool => obj = obj.update("response_message_ephemeral", response_message_ephemeral')
        end

        obj

class val InteractionCallbackResource
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-resource-object
    """

    let type': InteractionCallbackType
        """
        Interaction callback type
        """

    let activity_instance: (InteractionCallbackActivityInstanceResource | None)
        """
        Represents the Activity launched by this interaction

        Only present if `type` is LAUNCH_ACTIVITY.
        """

    let message: (Message | None)
        """
        Message created by the interaction

        Only present if `type` is either CHANNEL_MESSAGE_WITH_SOURCE or UPDATE_MESSAGE.
        """

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (InteractionCallbackType | None) = None
        var activity_instance': (InteractionCallbackActivityInstanceResource | None) = None
        var message': (Message | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "type" => type'' = InteractionCallbackTypes.from((value as I64).u8())?
            | "activity_instance" => activity_instance' = InteractionCallbackActivityInstanceResource.from_json(value as json.JsonObject)?
            | "message" => message' = Message.from_json(value as json.JsonObject)?
            end
        end

        type' = type'' as InteractionCallbackType
        activity_instance = activity_instance'
        message = message'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("type", type'.value().i64())

        match activity_instance
        | let activity_instance': InteractionCallbackActivityInstanceResource => obj = obj.update("activity_instance", activity_instance'.to_json())
        end

        match message
        | let message': Message => obj = obj.update("message", message'.to_json())
        end

        obj

class val InteractionCallbackActivityInstanceResource
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-activity-instance-resource
    """

    let id: String
        """
        Instance ID of the Activity if one was launched or joined
        """

    new val from_json(obj: json.JsonObject) ? =>
        var id': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = value as String
            end
        end

        id = id' as String

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id)
