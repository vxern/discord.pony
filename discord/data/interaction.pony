use collections = "collections"
use json = "json"

type InteractionData is (ApplicationCommandData | MessageComponentData | ModalSubmitData)
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-data

    While the `data` field is present for every interaction type except PING, its structure depends on the interaction's type.
    """

class val Interaction is Jsonable
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

    let guild: (PartialGuild | None)
        """
        Guild that the interaction was sent from

        This is a partial guild object, so most of its fields may be absent.
        """

    let guild_id: (Snowflake | None)
        """
        Guild that the interaction was sent from
        """

    let channel: (PartialChannel | None)
        """
        Channel that the interaction was sent from

        This is a partial channel object, so most of its fields may be absent.
        """

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

    let authorizing_integration_owners: collections.Map[ApplicationIntegrationType, Snowflake] val
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

    new val create(
        id': Snowflake,
        application_id': Snowflake,
        type'': InteractionType,
        data': (InteractionData | None) = None,
        guild': (PartialGuild | None) = None,
        guild_id': (Snowflake | None) = None,
        channel': (PartialChannel | None) = None,
        channel_id': (Snowflake | None) = None,
        member': (GuildMember | None) = None,
        user': (User | None) = None,
        token': String,
        version': USize,
        message': (Message | None) = None,
        app_permissions': Array[Permission] val,
        locale': (Locale | None) = None,
        guild_locale': (Locale | None) = None,
        entitlements': Array[Entitlement] val,
        authorizing_integration_owners': collections.Map[ApplicationIntegrationType, Snowflake] val,
        context': (InteractionContextType | None) = None,
        attachment_size_limit': USize
    ) =>
        id = id'
        application_id = application_id'
        type' = type''
        data = data'
        guild = guild'
        guild_id = guild_id'
        channel = channel'
        channel_id = channel_id'
        member = member'
        user = user'
        token = token'
        version = version'
        message = message'
        app_permissions = app_permissions'
        locale = locale'
        guild_locale = guild_locale'
        entitlements = entitlements'
        authorizing_integration_owners = authorizing_integration_owners'
        context = context'
        attachment_size_limit = attachment_size_limit'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var type'': (InteractionType | None) = None
        var guild': (PartialGuild | None) = None
        var guild_id': (Snowflake | None) = None
        var channel': (PartialChannel | None) = None
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
        var authorizing_integration_owners': (collections.Map[ApplicationIntegrationType, Snowflake] val | None) = None
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
            | "guild" => guild' = PartialGuild.from_json(value as json.JsonObject)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "channel" => channel' = PartialChannel.from_json(value as json.JsonObject)?
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
        guild = guild'
        guild_id = guild_id'
        channel = channel'
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
        authorizing_integration_owners = authorizing_integration_owners' as collections.Map[ApplicationIntegrationType, Snowflake] val
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

        match guild
        | let guild': PartialGuild => obj = obj.update("guild", guild'.to_json())
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match channel
        | let channel': PartialChannel => obj = obj.update("channel", channel'.to_json())
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
    fun apply(value: json.JsonValue): collections.Map[ApplicationIntegrationType, Snowflake] val ? =>
        """
        Decodes a mapping of installation contexts to the related user or guild IDs.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[ApplicationIntegrationType, Snowflake](obj.size())
            for (key, value') in obj.pairs() do
                map(ApplicationIntegrationTypes.from(key.u8()?)?) = Snowflake.from_json(value')?
            end
            map
        end

    fun to_json(map: collections.Map[ApplicationIntegrationType, Snowflake] box): json.JsonObject =>
        var obj = json.JsonObject
        for (integration_type, id) in map.pairs() do obj = obj.update(integration_type.value().string(), id.to_json()) end
        obj

trait val InteractionType is _Enum[InteractionType, U8]
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-type
    """
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

trait val InteractionContextType is _Enum[InteractionContextType, U8]
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-interaction-context-types

    Context in Discord where an interaction can be used, or where it was triggered from. Details about using interaction contexts for application commands is in the commands context documentation.
    """
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

type ApplicationCommandInteractionDataOptionValue is (String | I64 | F64 | Bool)
    """
    The value a user supplied for an application command option, whose type follows the option's own `type`.
    """

class val ApplicationCommandInteractionDataOption is Jsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-application-command-interaction-data-option-structure

    All options have names, and an option can either be a parameter and input value — in which case `value` will be set — or it can denote a subcommand or group, in which case it will contain a top-level key and another array of `options`.

    `value` and `options` are mutually exclusive.
    """

    let name: String
        """
        Name of the parameter
        """

    let type': ApplicationCommandOptionType
        """
        Value of application command option type
        """

    let value: (ApplicationCommandInteractionDataOptionValue | None)
        """
        Value of the option resulting from user input
        """

    let options: (Array[ApplicationCommandInteractionDataOption] val | None)
        """
        Present if this option is a group or subcommand
        """

    let focused: (Bool | None)
        """
        `true` if this option is the currently focused option for autocomplete
        """

    new val create(
        name': String,
        type'': ApplicationCommandOptionType,
        value': (ApplicationCommandInteractionDataOptionValue | None) = None,
        options': (Array[ApplicationCommandInteractionDataOption] val | None) = None,
        focused': (Bool | None) = None
    ) =>
        name = name'
        type' = type''
        value = value'
        options = options'
        focused = focused'

    new val from_json(obj: json.JsonObject) ? =>
        var name': (String | None) = None
        var type'': (ApplicationCommandOptionType | None) = None
        var value': (ApplicationCommandInteractionDataOptionValue | None) = None
        var options': (Array[ApplicationCommandInteractionDataOption] val | None) = None
        var focused': (Bool | None) = None

        for (key, value'') in obj.pairs() do
            match key
            | "name" => name' = value'' as String
            | "type" => type'' = ApplicationCommandOptionTypes.from((value'' as I64).u8())?
            | "value" =>
                match value''
                | let string: String => value' = string
                | let integer: I64 => value' = integer
                | let float: F64 => value' = float
                | let boolean: Bool => value' = boolean
                end
            | "options" => options' = _ApplicationCommandInteractionDataOptions(value'')?
            | "focused" => focused' = value'' as Bool
            end
        end

        name = name' as String
        type' = type'' as ApplicationCommandOptionType
        value = value'
        options = options'
        focused = focused'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("type", type'.value().i64())

        match value
        | let value': String => obj = obj.update("value", value')
        | let value': I64 => obj = obj.update("value", value')
        | let value': F64 => obj = obj.update("value", value')
        | let value': Bool => obj = obj.update("value", value')
        end

        match options
        | let options': Array[ApplicationCommandInteractionDataOption] val => obj = obj.update("options", _ApplicationCommandInteractionDataOptions.to_json(options'))
        end

        match focused
        | let focused': Bool => obj = obj.update("focused", focused')
        end

        obj

primitive _ApplicationCommandInteractionDataOptions
    fun apply(value: json.JsonValue): Array[ApplicationCommandInteractionDataOption] val ? =>
        """
        Decodes an array of application command interaction data options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[ApplicationCommandInteractionDataOption](array.size())
            for option in array.values() do options.push(ApplicationCommandInteractionDataOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[ApplicationCommandInteractionDataOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

primitive _InteractionContextTypes
    fun apply(value: json.JsonValue): Array[InteractionContextType] val ? =>
        """
        Decodes an array of interaction context types.
        """

        let array = value as json.JsonArray
        recover val
            let types = Array[InteractionContextType](array.size())
            for type' in array.values() do types.push(InteractionContextTypes.from((type' as I64).u8())?) end
            types
        end

    fun to_json(types: Array[InteractionContextType] val): json.JsonArray =>
        var array = json.JsonArray
        for type' in types.values() do array = array.push(type'.value().i64()) end
        array

class val ApplicationCommandData is Jsonable
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

    let type': ApplicationCommandType
        """
        the type of the invoked command
        """

    let resolved: (ResolvedData | None)
        """
        converted users + roles + channels + attachments
        """

    let options: (Array[ApplicationCommandInteractionDataOption] val | None)
        """
        the params + values from the user
        """

    let guild_id: (Snowflake | None)
        """
        the id of the guild the command is registered to
        """

    let target_id: (Snowflake | None)
        """
        id of the user or message targeted by a user or message command
        """

    new val create(
        id': Snowflake,
        name': String,
        type'': ApplicationCommandType,
        resolved': (ResolvedData | None) = None,
        options': (Array[ApplicationCommandInteractionDataOption] val | None) = None,
        guild_id': (Snowflake | None) = None,
        target_id': (Snowflake | None) = None
    ) =>
        id = id'
        name = name'
        type' = type''
        resolved = resolved'
        options = options'
        guild_id = guild_id'
        target_id = target_id'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var name': (String | None) = None
        var type'': (ApplicationCommandType | None) = None
        var resolved': (ResolvedData | None) = None
        var options': (Array[ApplicationCommandInteractionDataOption] val | None) = None
        var guild_id': (Snowflake | None) = None
        var target_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "type" => type'' = ApplicationCommandTypes.from((value as I64).u8())?
            | "resolved" => resolved' = ResolvedData.from_json(value as json.JsonObject)?
            | "options" => options' = _ApplicationCommandInteractionDataOptions(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "target_id" => target_id' = Snowflake.from_json(value)?
            end
        end

        id = id' as Snowflake
        name = name' as String
        type' = type'' as ApplicationCommandType
        resolved = resolved'
        options = options'
        guild_id = guild_id'
        target_id = target_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("name", name)
            .update("type", type'.value().i64())

        match resolved
        | let resolved': ResolvedData => obj = obj.update("resolved", resolved'.to_json())
        end

        match options
        | let options': Array[ApplicationCommandInteractionDataOption] val => obj = obj.update("options", _ApplicationCommandInteractionDataOptions.to_json(options'))
        end

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match target_id
        | let target_id': Snowflake => obj = obj.update("target_id", target_id'.to_json())
        end

        obj

class val MessageComponentData is Jsonable
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

    new val create(
        custom_id': String,
        component_type': ComponentType,
        values': (Array[String] val | None) = None,
        resolved': (ResolvedData | None) = None
    ) =>
        custom_id = custom_id'
        component_type = component_type'
        values = values'
        resolved = resolved'

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

class val ModalSubmitData is Jsonable
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

    new val create(custom_id': String, components': Array[Component] val) =>
        custom_id = custom_id'
        components = components'

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

class val ResolvedData is Jsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-object-resolved-data-structure

    If data for a Member is included, data for its corresponding User will also be included.
    """

    let users: (collections.Map[Snowflake, User] val | None)
        """
        the ids and User objects
        """

    let members: (collections.Map[Snowflake, PartialGuildMember] val | None)
        """
        the ids and partial Member objects

        Discord omits `user`, `deaf` and `mute` from these.
        """

    let roles: (collections.Map[Snowflake, Role] val | None)
        """
        the ids and Role objects
        """

    let channels: (collections.Map[Snowflake, PartialChannel] val | None)
        """
        the ids and partial Channel objects

        Partial Channel objects only have `id`, `name`, `type` and `permissions` fields. Threads will also have `thread_metadata` and `parent_id` fields.
        """

    let messages: (collections.Map[Snowflake, Message] val | None)
        """
        the ids and partial Message objects
        """

    let attachments: (collections.Map[Snowflake, MessageAttachment] val | None)
        """
        the ids and attachment objects
        """

    new val create(
        users': (collections.Map[Snowflake, User] val | None) = None,
        members': (collections.Map[Snowflake, PartialGuildMember] val | None) = None,
        roles': (collections.Map[Snowflake, Role] val | None) = None,
        channels': (collections.Map[Snowflake, PartialChannel] val | None) = None,
        messages': (collections.Map[Snowflake, Message] val | None) = None,
        attachments': (collections.Map[Snowflake, MessageAttachment] val | None) = None
    ) =>
        users = users'
        members = members'
        roles = roles'
        channels = channels'
        messages = messages'
        attachments = attachments'

    new val from_json(obj: json.JsonObject) ? =>
        var users': (collections.Map[Snowflake, User] val | None) = None
        var members': (collections.Map[Snowflake, PartialGuildMember] val | None) = None
        var roles': (collections.Map[Snowflake, Role] val | None) = None
        var channels': (collections.Map[Snowflake, PartialChannel] val | None) = None
        var messages': (collections.Map[Snowflake, Message] val | None) = None
        var attachments': (collections.Map[Snowflake, MessageAttachment] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "users" => users' = _ResolvedUsers(value)?
            | "members" => members' = _ResolvedMembers(value)?
            | "roles" => roles' = _ResolvedRoles(value)?
            | "channels" => channels' = _ResolvedChannels(value)?
            | "messages" => messages' = _ResolvedMessages(value)?
            | "attachments" => attachments' = _ResolvedAttachments(value)?
            end
        end

        users = users'
        members = members'
        roles = roles'
        channels = channels'
        messages = messages'
        attachments = attachments'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match users
        | let users': collections.Map[Snowflake, User] val => obj = obj.update("users", _ResolvedUsers.to_json(users'))
        end

        match members
        | let members': collections.Map[Snowflake, PartialGuildMember] val => obj = obj.update("members", _ResolvedMembers.to_json(members'))
        end

        match roles
        | let roles': collections.Map[Snowflake, Role] val => obj = obj.update("roles", _ResolvedRoles.to_json(roles'))
        end

        match channels
        | let channels': collections.Map[Snowflake, PartialChannel] val => obj = obj.update("channels", _ResolvedChannels.to_json(channels'))
        end

        match messages
        | let messages': collections.Map[Snowflake, Message] val => obj = obj.update("messages", _ResolvedMessages.to_json(messages'))
        end

        match attachments
        | let attachments': collections.Map[Snowflake, MessageAttachment] val => obj = obj.update("attachments", _ResolvedAttachments.to_json(attachments'))
        end

        obj

primitive _ResolvedUsers
    fun apply(value: json.JsonValue): collections.Map[Snowflake, User] val ? =>
        """
        Decodes a mapping of snowflakes to users.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, User](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = User.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, User] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, user) in map.pairs() do obj = obj.update(id.string(), user.to_json()) end
        obj

primitive _ResolvedRoles
    fun apply(value: json.JsonValue): collections.Map[Snowflake, Role] val ? =>
        """
        Decodes a mapping of snowflakes to roles.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, Role](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = Role.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, Role] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, role) in map.pairs() do obj = obj.update(id.string(), role.to_json()) end
        obj

primitive _ResolvedMembers
    fun apply(value: json.JsonValue): collections.Map[Snowflake, PartialGuildMember] val ? =>
        """
        Decodes a mapping of snowflakes to partial guild members.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, PartialGuildMember](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = PartialGuildMember.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, PartialGuildMember] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, member) in map.pairs() do obj = obj.update(id.string(), member.to_json()) end
        obj

primitive _ResolvedChannels
    fun apply(value: json.JsonValue): collections.Map[Snowflake, PartialChannel] val ? =>
        """
        Decodes a mapping of snowflakes to partial channels.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, PartialChannel](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = PartialChannel.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, PartialChannel] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, channel) in map.pairs() do obj = obj.update(id.string(), channel.to_json()) end
        obj

primitive _ResolvedMessages
    fun apply(value: json.JsonValue): collections.Map[Snowflake, Message] val ? =>
        """
        Decodes a mapping of snowflakes to messages.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, Message](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = Message.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, Message] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, message) in map.pairs() do obj = obj.update(id.string(), message.to_json()) end
        obj

primitive _ResolvedAttachments
    fun apply(value: json.JsonValue): collections.Map[Snowflake, MessageAttachment] val ? =>
        """
        Decodes a mapping of snowflakes to attachments.
        """

        let obj = value as json.JsonObject
        recover val
            let map = collections.Map[Snowflake, MessageAttachment](obj.size())
            for (key, value') in obj.pairs() do
                map(Snowflake.from_json(key)?) = MessageAttachment.from_json(value' as json.JsonObject)?
            end
            map
        end

    fun to_json(map: collections.Map[Snowflake, MessageAttachment] box): json.JsonObject =>
        var obj = json.JsonObject
        for (id, attachment) in map.pairs() do obj = obj.update(id.string(), attachment.to_json()) end
        obj

class val InteractionResponse is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-interaction-response-structure

    An app returns this to respond to an interaction. Discord never sends one, so this is serialised only — the callback data shapes are request bodies with no decoded form.
    """

    let type': InteractionCallbackType
        """
        the type of response
        """

    let data: (InteractionCallbackData | None)
        """
        an optional response message

        Which of the three shapes this holds is determined by `type` rather than by a tag on the data itself: messages for the message callback types, `choices` for `APPLICATION_COMMAND_AUTOCOMPLETE_RESULT`, and a modal for `MODAL`.
        """

    new val create(type'': InteractionCallbackType, data': (InteractionCallbackData | None) = None) =>
        type' = type''
        data = data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("type", type'.value().i64())

        match data
        | let data': InteractionCallbackMessageParams => obj = obj.update("data", data'.to_json())
        | let data': InteractionCallbackAutocompleteParams => obj = obj.update("data", data'.to_json())
        | let data': InteractionCallbackModalParams => obj = obj.update("data", data'.to_json())
        end

        obj

trait val InteractionCallbackType is _Enum[InteractionCallbackType, U8]
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-interaction-callback-type
    """
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

class val InteractionCallbackResponse is Jsonable
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

    new val create(interaction': InteractionCallback, resource': (InteractionCallbackResource | None) = None) =>
        interaction = interaction'
        resource = resource'

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

class val InteractionCallback is Jsonable
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

    new val create(
        id': Snowflake,
        type'': InteractionType,
        activity_instance_id': (String | None) = None,
        response_message_id': (Snowflake | None) = None,
        response_message_loading': (Bool | None) = None,
        response_message_ephemeral': (Bool | None) = None
    ) =>
        id = id'
        type' = type''
        activity_instance_id = activity_instance_id'
        response_message_id = response_message_id'
        response_message_loading = response_message_loading'
        response_message_ephemeral = response_message_ephemeral'

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

class val InteractionCallbackResource is Jsonable
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

    new val create(
        type'': InteractionCallbackType,
        activity_instance': (InteractionCallbackActivityInstanceResource | None) = None,
        message': (Message | None) = None
    ) =>
        type' = type''
        activity_instance = activity_instance'
        message = message'

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

class val InteractionCallbackActivityInstanceResource is Jsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-callback-interaction-callback-activity-instance-resource
    """

    let id: String
        """
        Instance ID of the Activity if one was launched or joined
        """

    new val create(id': String) =>
        id = id'

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

type InteractionCallbackData is (InteractionCallbackMessageParams | InteractionCallbackAutocompleteParams | InteractionCallbackModalParams)
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-interaction-callback-data-structures

    Which of the three shapes is expected is determined by the `type` of the interaction response rather than by a tag on the data itself.
    """

class val InteractionCallbackMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-messages

    Not all message fields are currently supported.
    """

    let tts: (Bool | None)
        """
        is the response TTS
        """

    let content: (String | None)
        """
        message content
        """

    let embeds: (Array[MessageEmbed] val | None)
        """
        supports up to 10 embeds
        """

    let allowed_mentions: (AllowedMentions | None)
        """
        allowed mentions object
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS`, `EPHEMERAL` and `IS_COMPONENTS_V2` can be set)
        """

    let components: (Array[Component] val | None)
        """
        message components
        """

    let attachments: (Array[MessageAttachmentParams] val | None)
        """
        attachment objects with `filename` and `description`
        """

    let poll: (PollParams | None)
        """
        details about the poll
        """

    new val create(
        tts': (Bool | None) = None,
        content': (String | None) = None,
        embeds': (Array[MessageEmbed] val | None) = None,
        allowed_mentions': (AllowedMentions | None) = None,
        flags': (Array[MessageFlag] val | None) = None,
        components': (Array[Component] val | None) = None,
        attachments': (Array[MessageAttachmentParams] val | None) = None,
        poll': (PollParams | None) = None
    ) =>
        tts = tts'
        content = content'
        embeds = embeds'
        allowed_mentions = allowed_mentions'
        flags = flags'
        components = components'
        attachments = attachments'
        poll = poll'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match tts
        | let tts': Bool => obj = obj.update("tts", tts')
        end

        match content
        | let content': String => obj = obj.update("content", content')
        end

        match embeds
        | let embeds': Array[MessageEmbed] val => obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions => obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        end

        match flags
        | let flags': Array[MessageFlag] val => obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        match components
        | let components': Array[Component] val => obj = obj.update("components", _Components.to_json(components'))
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val => obj = obj.update("attachments", _MessageAttachmentParams.to_json(attachments'))
        end

        match poll
        | let poll': PollParams => obj = obj.update("poll", poll'.to_json())
        end

        obj

class val InteractionCallbackAutocompleteParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-autocomplete
    """

    let choices: Array[ApplicationCommandOptionChoice] val
        """
        autocomplete choices (max of 25 choices)
        """

    new val create(choices': Array[ApplicationCommandOptionChoice] val) =>
        choices = choices'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("choices", _ApplicationCommandOptionChoices.to_json(choices))

class val InteractionCallbackModalParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object-modal
    """

    let custom_id: String
        """
        Developer-defined identifier for the modal, max 100 characters
        """

    let title: String
        """
        Title of the popup modal, max 45 characters
        """

    let components: Array[Component] val
        """
        Components that make up the modal
        """

    new val create(custom_id': String, title': String, components': Array[Component] val) =>
        custom_id = custom_id'
        title = title'
        components = components'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("custom_id", custom_id)
            .update("title", title)
            .update("components", _Components.to_json(components))

class val CreateInteractionResponseParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#create-interaction-response
    """

    let type': InteractionCallbackType
        """
        the type of response
        """

    let data: (InteractionCallbackData | None)
        """
        an optional response message

        The shape expected depends on `type`.
        """

    new val create(
        type'': InteractionCallbackType,
        data': (InteractionCallbackData | None) = None
    ) =>
        type' = type''
        data = data'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("type", type'.value().i64())

        match data
        | let data': InteractionCallbackMessageParams => obj = obj.update("data", data'.to_json())
        | let data': InteractionCallbackAutocompleteParams => obj = obj.update("data", data'.to_json())
        | let data': InteractionCallbackModalParams => obj = obj.update("data", data'.to_json())
        end

        obj

class val GetOriginalInteractionResponseParams
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#get-original-interaction-response

    Functions the same as Get Webhook Message.
    """

    let thread_id: (Snowflake | None)
        """
        id of the thread the message is in
        """

    new val create(thread_id': (Snowflake | None) = None) =>
        thread_id = thread_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake => query.push(("thread_id", thread_id'.string()))
        end

        consume query

class val UpdateOriginalInteractionResponseParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#edit-original-interaction-response

    Functions the same as Edit Webhook Message, and so takes both query string parameters and a JSON body.
    """

    let content: Nullable[String]
        """
        the message contents (up to 2000 characters)
        """

    let embeds: Nullable[Array[MessageEmbed] val]
        """
        array of up to 10 embeds
        """

    let allowed_mentions: Nullable[AllowedMentions]
        """
        allowed mentions for the message
        """

    let components: Nullable[Array[Component] val]
        """
        the components to include with the message
        """

    let attachments: Nullable[Array[MessageAttachmentParams] val]
        """
        attached files to keep and possible descriptions for new files
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS` and `IS_COMPONENTS_V2` can be set)
        """

    let thread_id: (Snowflake | None)
        """
        id of the thread the message is in
        """

    let with_components: (Bool | None)
        """
        whether to respect the `components` field of the request (defaults to `false`; when `false`, only components without custom_id are allowed)
        """

    new val create(
        content': Nullable[String] = None,
        embeds': Nullable[Array[MessageEmbed] val] = None,
        allowed_mentions': Nullable[AllowedMentions] = None,
        components': Nullable[Array[Component] val] = None,
        attachments': Nullable[Array[MessageAttachmentParams] val] = None,
        flags': (Array[MessageFlag] val | None) = None,
        thread_id': (Snowflake | None) = None,
        with_components': (Bool | None) = None
    ) =>
        content = content'
        embeds = embeds'
        allowed_mentions = allowed_mentions'
        components = components'
        attachments = attachments'
        flags = flags'
        thread_id = thread_id'
        with_components = with_components'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake => query.push(("thread_id", thread_id'.string()))
        end

        match with_components
        | let with_components': Bool => query.push(("with_components", with_components'.string()))
        end

        consume query

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        | Null => obj = obj.update("content", None)
        end

        match embeds
        | let embeds': Array[MessageEmbed] val => obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        | Null => obj = obj.update("embeds", None)
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions => obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        | Null => obj = obj.update("allowed_mentions", None)
        end

        match components
        | let components': Array[Component] val => obj = obj.update("components", _Components.to_json(components'))
        | Null => obj = obj.update("components", None)
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val => obj = obj.update("attachments", _MessageAttachmentParams.to_json(attachments'))
        | Null => obj = obj.update("attachments", None)
        end

        match flags
        | let flags': Array[MessageFlag] val => obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        obj

class val CreateFollowupMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#create-followup-message

    Functions the same as Execute Webhook, and so takes both query string parameters and a JSON body, but `wait` is always true. The `thread_id`, `avatar_url` and `username` parameters are not supported when using this endpoint for interaction followups.
    """

    let content: (String | None)
        """
        the message contents (up to 2000 characters)
        """

    let tts: (Bool | None)
        """
        true if this is a TTS message
        """

    let embeds: (Array[MessageEmbed] val | None)
        """
        array of up to 10 embeds
        """

    let allowed_mentions: (AllowedMentions | None)
        """
        allowed mentions for the message
        """

    let components: (Array[Component] val | None)
        """
        the components to include with the message
        """

    let attachments: (Array[MessageAttachmentParams] val | None)
        """
        attachment objects with `filename` and `description`
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS`, `EPHEMERAL` and `IS_COMPONENTS_V2` can be set)
        """

    let poll: (PollParams | None)
        """
        A poll!
        """

    let with_components: (Bool | None)
        """
        whether to respect the `components` field of the request (defaults to `false`; when `false`, only components without custom_id are allowed)
        """

    new val create(
        content': (String | None) = None,
        tts': (Bool | None) = None,
        embeds': (Array[MessageEmbed] val | None) = None,
        allowed_mentions': (AllowedMentions | None) = None,
        components': (Array[Component] val | None) = None,
        attachments': (Array[MessageAttachmentParams] val | None) = None,
        flags': (Array[MessageFlag] val | None) = None,
        poll': (PollParams | None) = None,
        with_components': (Bool | None) = None
    ) =>
        content = content'
        tts = tts'
        embeds = embeds'
        allowed_mentions = allowed_mentions'
        components = components'
        attachments = attachments'
        flags = flags'
        poll = poll'
        with_components = with_components'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_components
        | let with_components': Bool => query.push(("with_components", with_components'.string()))
        end

        consume query

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        end

        match tts
        | let tts': Bool => obj = obj.update("tts", tts')
        end

        match embeds
        | let embeds': Array[MessageEmbed] val => obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions => obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        end

        match components
        | let components': Array[Component] val => obj = obj.update("components", _Components.to_json(components'))
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val => obj = obj.update("attachments", _MessageAttachmentParams.to_json(attachments'))
        end

        match flags
        | let flags': Array[MessageFlag] val => obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        match poll
        | let poll': PollParams => obj = obj.update("poll", poll'.to_json())
        end

        obj

class val GetFollowupMessageParams
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#get-followup-message

    Functions the same as Get Webhook Message.
    """

    let thread_id: (Snowflake | None)
        """
        id of the thread the message is in
        """

    new val create(thread_id': (Snowflake | None) = None) =>
        thread_id = thread_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake => query.push(("thread_id", thread_id'.string()))
        end

        consume query

class val UpdateFollowupMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/receiving-and-responding#edit-followup-message

    Functions the same as Edit Webhook Message, and so takes both query string parameters and a JSON body.
    """

    let content: Nullable[String]
        """
        the message contents (up to 2000 characters)
        """

    let embeds: Nullable[Array[MessageEmbed] val]
        """
        array of up to 10 embeds
        """

    let allowed_mentions: Nullable[AllowedMentions]
        """
        allowed mentions for the message
        """

    let components: Nullable[Array[Component] val]
        """
        the components to include with the message
        """

    let attachments: Nullable[Array[MessageAttachmentParams] val]
        """
        attached files to keep and possible descriptions for new files
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS` and `IS_COMPONENTS_V2` can be set)
        """

    let thread_id: (Snowflake | None)
        """
        id of the thread the message is in
        """

    let with_components: (Bool | None)
        """
        whether to respect the `components` field of the request (defaults to `false`; when `false`, only components without custom_id are allowed)
        """

    new val create(
        content': Nullable[String] = None,
        embeds': Nullable[Array[MessageEmbed] val] = None,
        allowed_mentions': Nullable[AllowedMentions] = None,
        components': Nullable[Array[Component] val] = None,
        attachments': Nullable[Array[MessageAttachmentParams] val] = None,
        flags': (Array[MessageFlag] val | None) = None,
        thread_id': (Snowflake | None) = None,
        with_components': (Bool | None) = None
    ) =>
        content = content'
        embeds = embeds'
        allowed_mentions = allowed_mentions'
        components = components'
        attachments = attachments'
        flags = flags'
        thread_id = thread_id'
        with_components = with_components'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake => query.push(("thread_id", thread_id'.string()))
        end

        match with_components
        | let with_components': Bool => query.push(("with_components", with_components'.string()))
        end

        consume query

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        | Null => obj = obj.update("content", None)
        end

        match embeds
        | let embeds': Array[MessageEmbed] val => obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        | Null => obj = obj.update("embeds", None)
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions => obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        | Null => obj = obj.update("allowed_mentions", None)
        end

        match components
        | let components': Array[Component] val => obj = obj.update("components", _Components.to_json(components'))
        | Null => obj = obj.update("components", None)
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val => obj = obj.update("attachments", _MessageAttachmentParams.to_json(attachments'))
        | Null => obj = obj.update("attachments", None)
        end

        match flags
        | let flags': Array[MessageFlag] val => obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        obj
