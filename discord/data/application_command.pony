use collections = "collections"
use json = "json"

trait val ApplicationCommandType is _Enum[ApplicationCommandType, U8]
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-types
    """
primitive ChatInputApplicationCommandType is ApplicationCommandType
    """
    Slash commands; a text-based command that shows up when a user types /
    """

    fun value(): U8 => 1
primitive UserApplicationCommandType is ApplicationCommandType
    """
    A UI-based command that shows up when you right click or tap on a user
    """

    fun value(): U8 => 2
primitive MessageApplicationCommandType is ApplicationCommandType
    """
    A UI-based command that shows up when you right click or tap on a message
    """

    fun value(): U8 => 3
primitive PrimaryEntryPointApplicationCommandType is ApplicationCommandType
    """
    A UI-based command that represents the primary way to invoke an app's Activity
    """

    fun value(): U8 => 4
primitive ApplicationCommandTypes
    fun from(value: U8): ApplicationCommandType ? =>
        match value
        | 1 => ChatInputApplicationCommandType
        | 2 => UserApplicationCommandType
        | 3 => MessageApplicationCommandType
        | 4 => PrimaryEntryPointApplicationCommandType
        else error
        end

trait val ApplicationCommandHandlerType is _Enum[ApplicationCommandHandlerType, U8]
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-entry-point-command-handler-types

    Determines whether the interaction is handled by the app's interactions handler or by Discord.
    """
primitive AppHandlerApplicationCommandHandlerType is ApplicationCommandHandlerType
    """
    The app handles the interaction using an interaction token
    """

    fun value(): U8 => 1
primitive DiscordLaunchActivityApplicationCommandHandlerType is ApplicationCommandHandlerType
    """
    Discord handles the interaction by launching an Activity and sending a follow-up message without coordinating with the app
    """

    fun value(): U8 => 2
primitive ApplicationCommandHandlerTypes
    fun from(value: U8): ApplicationCommandHandlerType ? =>
        match value
        | 1 => AppHandlerApplicationCommandHandlerType
        | 2 => DiscordLaunchActivityApplicationCommandHandlerType
        else error
        end

trait val ApplicationCommandOptionType is _Enum[ApplicationCommandOptionType, U8]
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-type
    """
primitive SubCommandApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 1
primitive SubCommandGroupApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 2
primitive StringApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 3
primitive IntegerApplicationCommandOptionType is ApplicationCommandOptionType
    """
    Any integer between -2^53 and 2^53
    """

    fun value(): U8 => 4
primitive BooleanApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 5
primitive UserApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 6
primitive ChannelApplicationCommandOptionType is ApplicationCommandOptionType
    """
    Includes all channel types + categories
    """

    fun value(): U8 => 7
primitive RoleApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 8
primitive MentionableApplicationCommandOptionType is ApplicationCommandOptionType
    """
    Includes users and roles
    """

    fun value(): U8 => 9
primitive NumberApplicationCommandOptionType is ApplicationCommandOptionType
    """
    Any double between -2^53 and 2^53
    """

    fun value(): U8 => 10
primitive AttachmentApplicationCommandOptionType is ApplicationCommandOptionType
    fun value(): U8 => 11
primitive ApplicationCommandOptionTypes
    fun from(value: U8): ApplicationCommandOptionType ? =>
        match value
        | 1 => SubCommandApplicationCommandOptionType
        | 2 => SubCommandGroupApplicationCommandOptionType
        | 3 => StringApplicationCommandOptionType
        | 4 => IntegerApplicationCommandOptionType
        | 5 => BooleanApplicationCommandOptionType
        | 6 => UserApplicationCommandOptionType
        | 7 => ChannelApplicationCommandOptionType
        | 8 => RoleApplicationCommandOptionType
        | 9 => MentionableApplicationCommandOptionType
        | 10 => NumberApplicationCommandOptionType
        | 11 => AttachmentApplicationCommandOptionType
        else error
        end

type ApplicationCommandOptionChoiceValue is (String | I64 | F64)
    """
    The value of an application command option choice, whose type must match the type of the option it belongs to.
    """

class val ApplicationCommandOptionChoice is Jsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-choice-structure

    If you specify `choices` for an option, they are the only valid values for a user to pick.
    """

    let name: String
        """
        1-100 character choice name
        """

    let value: ApplicationCommandOptionChoiceValue
        """
        Value for the choice, up to 100 characters if string
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    new val create(
        name': String,
        value': ApplicationCommandOptionChoiceValue,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None
    ) =>
        name = name'
        value = value'
        name_localizations = name_localizations'

    new val from_json(obj: json.JsonObject) ? =>
        var name': (String | None) = None
        var value': (ApplicationCommandOptionChoiceValue | None) = None
        var name_localizations': (collections.Map[Locale, String] val | None) = None

        for (key, value'') in obj.pairs() do
            match key
            | "name" => name' = value'' as String
            | "value" =>
                match value''
                | let string: String => value' = string
                | let integer: I64 => value' = integer
                | let float: F64 => value' = float
                end
            | "name_localizations" => name_localizations' = _Localizations(value'')?
            end
        end

        name = name' as String
        value = value' as ApplicationCommandOptionChoiceValue
        name_localizations = name_localizations'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("value", value)

        match name_localizations
        | let name_localizations': collections.Map[Locale, String] val => obj = obj.update("name_localizations", _Localizations.to_json(name_localizations'))
        | Null => obj = obj.update("name_localizations", None)
        end

        obj

primitive _ApplicationCommandOptionChoices
    fun apply(value: json.JsonValue): Array[ApplicationCommandOptionChoice] val ? =>
        """
        Decodes an array of application command option choices.
        """

        let array = value as json.JsonArray
        recover val
            let choices = Array[ApplicationCommandOptionChoice](array.size())
            for choice in array.values() do choices.push(ApplicationCommandOptionChoice.from_json(choice as json.JsonObject)?) end
            choices
        end

    fun to_json(choices: Array[ApplicationCommandOptionChoice] val): json.JsonArray =>
        var array = json.JsonArray
        for choice in choices.values() do array = array.push(choice.to_json()) end
        array

class val ApplicationCommandOption is Jsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-structure

    Required options must be listed before optional options.
    """

    let type': ApplicationCommandOptionType
        """
        Type of option
        """

    let name: String
        """
        1-32 character name
        """

    let description: String
        """
        1-100 character description
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `description` field. Values follow the same restrictions as `description`
        """

    let required: (Bool | None)
        """
        Whether the parameter is required or optional. Default `false`
        """

    let choices: (Array[ApplicationCommandOptionChoice] val | None)
        """
        Choices for the user to pick from, max 25
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        If the option is a subcommand or subcommand group type, these nested options will be the parameters or subcommands respectively; up to 25
        """

    let channel_types: (Array[ChannelType] val | None)
        """
        The channels shown will be restricted to these types
        """

    let min_value: ((I64 | F64) | None)
        """
        The minimum value permitted
        """

    let max_value: ((I64 | F64) | None)
        """
        The maximum value permitted
        """

    let min_length: (USize | None)
        """
        The minimum allowed length (minimum of `0`, maximum of `6000`)
        """

    let max_length: (USize | None)
        """
        The maximum allowed length (minimum of `1`, maximum of `6000`)
        """

    let autocomplete: (Bool | None)
        """
        If autocomplete interactions are enabled for this option

        May not be set to true if `choices` are present.
        """

    new val create(
        type'': ApplicationCommandOptionType,
        name': String,
        description': String,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        required': (Bool | None) = None,
        choices': (Array[ApplicationCommandOptionChoice] val | None) = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        channel_types': (Array[ChannelType] val | None) = None,
        min_value': ((I64 | F64) | None) = None,
        max_value': ((I64 | F64) | None) = None,
        min_length': (USize | None) = None,
        max_length': (USize | None) = None,
        autocomplete': (Bool | None) = None
    ) =>
        type' = type''
        name = name'
        description = description'
        name_localizations = name_localizations'
        description_localizations = description_localizations'
        required = required'
        choices = choices'
        options = options'
        channel_types = channel_types'
        min_value = min_value'
        max_value = max_value'
        min_length = min_length'
        max_length = max_length'
        autocomplete = autocomplete'

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (ApplicationCommandOptionType | None) = None
        var name': (String | None) = None
        var description': (String | None) = None
        var name_localizations': (collections.Map[Locale, String] val | None) = None
        var description_localizations': (collections.Map[Locale, String] val | None) = None
        var required': (Bool | None) = None
        var choices': (Array[ApplicationCommandOptionChoice] val | None) = None
        var options': (Array[ApplicationCommandOption] val | None) = None
        var channel_types': (Array[ChannelType] val | None) = None
        var min_value': ((I64 | F64) | None) = None
        var max_value': ((I64 | F64) | None) = None
        var min_length': (USize | None) = None
        var max_length': (USize | None) = None
        var autocomplete': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "type" => type'' = ApplicationCommandOptionTypes.from((value as I64).u8())?
            | "name" => name' = value as String
            | "description" => description' = value as String
            | "name_localizations" => name_localizations' = _Localizations(value)?
            | "description_localizations" => description_localizations' = _Localizations(value)?
            | "required" => required' = value as Bool
            | "choices" => choices' = _ApplicationCommandOptionChoices(value)?
            | "options" => options' = _ApplicationCommandOptions(value)?
            | "channel_types" => channel_types' = _ChannelTypes(value)?
            | "min_value" =>
                match value
                | let integer: I64 => min_value' = integer
                | let float: F64 => min_value' = float
                end
            | "max_value" =>
                match value
                | let integer: I64 => max_value' = integer
                | let float: F64 => max_value' = float
                end
            | "min_length" => min_length' = (value as I64).usize()
            | "max_length" => max_length' = (value as I64).usize()
            | "autocomplete" => autocomplete' = value as Bool
            end
        end

        type' = type'' as ApplicationCommandOptionType
        name = name' as String
        description = description' as String
        name_localizations = name_localizations'
        description_localizations = description_localizations'
        required = required'
        choices = choices'
        options = options'
        channel_types = channel_types'
        min_value = min_value'
        max_value = max_value'
        min_length = min_length'
        max_length = max_length'
        autocomplete = autocomplete'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("type", type'.value().i64())
            .update("name", name)
            .update("description", description)

        match name_localizations
        | let name_localizations': collections.Map[Locale, String] val => obj = obj.update("name_localizations", _Localizations.to_json(name_localizations'))
        | Null => obj = obj.update("name_localizations", None)
        end

        match description_localizations
        | let description_localizations': collections.Map[Locale, String] val => obj = obj.update("description_localizations", _Localizations.to_json(description_localizations'))
        | Null => obj = obj.update("description_localizations", None)
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        match choices
        | let choices': Array[ApplicationCommandOptionChoice] val => obj = obj.update("choices", _ApplicationCommandOptionChoices.to_json(choices'))
        end

        match options
        | let options': Array[ApplicationCommandOption] val => obj = obj.update("options", _ApplicationCommandOptions.to_json(options'))
        end

        match channel_types
        | let channel_types': Array[ChannelType] val =>
            var types = json.JsonArray
            for channel_type in channel_types'.values() do types = types.push(channel_type.value().i64()) end
            obj = obj.update("channel_types", types)
        end

        match min_value
        | let min_value': I64 => obj = obj.update("min_value", min_value')
        | let min_value': F64 => obj = obj.update("min_value", min_value')
        end

        match max_value
        | let max_value': I64 => obj = obj.update("max_value", max_value')
        | let max_value': F64 => obj = obj.update("max_value", max_value')
        end

        match min_length
        | let min_length': USize => obj = obj.update("min_length", min_length'.i64())
        end

        match max_length
        | let max_length': USize => obj = obj.update("max_length", max_length'.i64())
        end

        match autocomplete
        | let autocomplete': Bool => obj = obj.update("autocomplete", autocomplete')
        end

        obj

primitive _ApplicationCommandOptions
    fun apply(value: json.JsonValue): Array[ApplicationCommandOption] val ? =>
        """
        Decodes an array of application command options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[ApplicationCommandOption](array.size())
            for option in array.values() do options.push(ApplicationCommandOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[ApplicationCommandOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

class val ApplicationCommand is Jsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-structure

    Application commands are native ways to interact with apps in the Discord client.

    The deprecated `dm_permission` and `default_permission` fields are not modelled; `contexts` supersedes the former and `default_member_permissions` the latter.
    """

    let id: Snowflake
        """
        Unique ID of command
        """

    let type': (ApplicationCommandType | None)
        """
        Type of command, defaults to `1`
        """

    let application_id: Snowflake
        """
        ID of the parent application
        """

    let guild_id: (Snowflake | None)
        """
        Guild ID of the command, if not global
        """

    let name: String
        """
        Name of command, 1-32 characters
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for `name` field. Values follow the same restrictions as `name`
        """

    let description: String
        """
        Description for `CHAT_INPUT` commands, 1-100 characters. Empty string for `USER` and `MESSAGE` commands
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for `description` field. Values follow the same restrictions as `description`
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        Parameters for the command, max of 25

        Only available for `CHAT_INPUT` commands.
        """

    let default_member_permissions: Nullable[Array[Permission] val]
        """
        Set of permissions represented as a bit set
        """

    let nsfw: (Bool | None)
        """
        Indicates whether the command is age-restricted, defaults to `false`
        """

    let integration_types: (Array[ApplicationIntegrationType] val | None)
        """
        Installation contexts where the command is available, only for globally-scoped commands. Defaults to your app's configured contexts
        """

    let contexts: (Array[InteractionContextType] val | None)
        """
        Interaction context(s) where the command can be used, only for globally-scoped commands
        """

    let version: Snowflake
        """
        Autoincrementing version identifier updated during substantial record changes
        """

    let handler: (ApplicationCommandHandlerType | None)
        """
        Determines whether the interaction is handled by the app's interactions handler or by Discord

        Only available for `PRIMARY_ENTRY_POINT` commands.
        """

    new val create(
        id': Snowflake,
        application_id': Snowflake,
        name': String,
        description': String,
        version': Snowflake,
        type'': (ApplicationCommandType | None) = None,
        guild_id': (Snowflake | None) = None,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        default_member_permissions': Nullable[Array[Permission] val] = None,
        nsfw': (Bool | None) = None,
        integration_types': (Array[ApplicationIntegrationType] val | None) = None,
        contexts': (Array[InteractionContextType] val | None) = None,
        handler': (ApplicationCommandHandlerType | None) = None
    ) =>
        id = id'
        type' = type''
        application_id = application_id'
        guild_id = guild_id'
        name = name'
        name_localizations = name_localizations'
        description = description'
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        nsfw = nsfw'
        integration_types = integration_types'
        contexts = contexts'
        version = version'
        handler = handler'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (ApplicationCommandType | None) = None
        var application_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var name': (String | None) = None
        var name_localizations': (collections.Map[Locale, String] val | None) = None
        var description': (String | None) = None
        var description_localizations': (collections.Map[Locale, String] val | None) = None
        var options': (Array[ApplicationCommandOption] val | None) = None
        var default_member_permissions': (Array[Permission] val | None) = None
        var nsfw': (Bool | None) = None
        var integration_types': (Array[ApplicationIntegrationType] val | None) = None
        var contexts': (Array[InteractionContextType] val | None) = None
        var version': (Snowflake | None) = None
        var handler': (ApplicationCommandHandlerType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = ApplicationCommandTypes.from((value as I64).u8())?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "name" => name' = value as String
            | "name_localizations" => name_localizations' = _Localizations(value)?
            | "description" => description' = value as String
            | "description_localizations" => description_localizations' = _Localizations(value)?
            | "options" => options' = _ApplicationCommandOptions(value)?
            | "default_member_permissions" =>
                match value | let string: String => default_member_permissions' = _Permissions(string)? end
            | "nsfw" => nsfw' = value as Bool
            | "integration_types" => integration_types' = _ApplicationIntegrationTypes(value)?
            | "contexts" =>
                match value | let array: json.JsonArray => contexts' = _InteractionContextTypes(array)? end
            | "version" => version' = Snowflake.from_json(value)?
            | "handler" => handler' = ApplicationCommandHandlerTypes.from((value as I64).u8())?
            end
        end

        id = id' as Snowflake
        type' = type''
        application_id = application_id' as Snowflake
        guild_id = guild_id'
        name = name' as String
        name_localizations = name_localizations'
        description = description' as String
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        nsfw = nsfw'
        integration_types = integration_types'
        contexts = contexts'
        version = version' as Snowflake
        handler = handler'

    fun to_json(): json.JsonObject =>
        var obj = _ApplicationCommandJson(
            name,
            name_localizations,
            description,
            description_localizations,
            options,
            default_member_permissions,
            integration_types,
            contexts,
            type',
            nsfw,
            handler)
            .update("id", id.to_json())
            .update("application_id", application_id.to_json())
            .update("version", version.to_json())

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        obj

primitive _ApplicationCommands
    fun apply(value: json.JsonValue): Array[ApplicationCommand] val ? =>
        """
        Decodes an array of application commands.
        """

        let array = value as json.JsonArray
        recover val
            let commands = Array[ApplicationCommand](array.size())
            for command in array.values() do commands.push(ApplicationCommand.from_json(command as json.JsonObject)?) end
            commands
        end

    fun to_json(commands: Array[ApplicationCommand] val): json.JsonArray =>
        var array = json.JsonArray
        for command in commands.values() do array = array.push(command.to_json()) end
        array


trait val ApplicationCommandPermissionType is _Enum[ApplicationCommandPermissionType, U8]
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-permissions-object-application-command-permission-type
    """
primitive RoleApplicationCommandPermissionType is ApplicationCommandPermissionType
    fun value(): U8 => 1
primitive UserApplicationCommandPermissionType is ApplicationCommandPermissionType
    fun value(): U8 => 2
primitive ChannelApplicationCommandPermissionType is ApplicationCommandPermissionType
    fun value(): U8 => 3
primitive ApplicationCommandPermissionTypes
    fun from(value: U8): ApplicationCommandPermissionType ? =>
        match value
        | 1 => RoleApplicationCommandPermissionType
        | 2 => UserApplicationCommandPermissionType
        | 3 => ChannelApplicationCommandPermissionType
        else error
        end

class val ApplicationCommandPermission is Jsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-permissions-object-application-command-permissions-structure

    Application command permissions allow you to enable or disable commands for specific users, roles, or channels within a guild.
    """

    let id: Snowflake
        """
        ID of the role, user, or channel. It can also be a permission constant.
        """

    let type': ApplicationCommandPermissionType
        """
        role (`1`), user (`2`), or channel (`3`)
        """

    let permission: Bool
        """
        `true` to allow, `false` to disallow
        """

    new val create(id': Snowflake, type'': ApplicationCommandPermissionType, permission': Bool) =>
        id = id'
        type' = type''
        permission = permission'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (ApplicationCommandPermissionType | None) = None
        var permission': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = ApplicationCommandPermissionTypes.from((value as I64).u8())?
            | "permission" => permission' = value as Bool
            end
        end

        id = id' as Snowflake
        type' = type'' as ApplicationCommandPermissionType
        permission = permission' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("permission", permission)

primitive _ApplicationCommandPermissions
    fun apply(value: json.JsonValue): Array[ApplicationCommandPermission] val ? =>
        """
        Decodes an array of application command permissions.
        """

        let array = value as json.JsonArray
        recover val
            let permissions = Array[ApplicationCommandPermission](array.size())
            for permission in array.values() do permissions.push(ApplicationCommandPermission.from_json(permission as json.JsonObject)?) end
            permissions
        end

    fun to_json(permissions: Array[ApplicationCommandPermission] val): json.JsonArray =>
        var array = json.JsonArray
        for permission in permissions.values() do array = array.push(permission.to_json()) end
        array

class val GuildApplicationCommandPermissions is Jsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#application-command-permissions-object-guild-application-command-permissions-structure

    Returned when fetching the permissions for an app's command(s) in a guild.

    When the `id` field is the application ID instead of a command ID, the permissions apply to all commands that do not contain explicit overwrites.
    """

    let id: Snowflake
        """
        ID of the command or the application ID
        """

    let application_id: Snowflake
        """
        ID of the application the command belongs to
        """

    let guild_id: Snowflake
        """
        ID of the guild
        """

    let permissions: Array[ApplicationCommandPermission] val
        """
        Permissions for the command in the guild, max of 100
        """

    new val create(
        id': Snowflake,
        application_id': Snowflake,
        guild_id': Snowflake,
        permissions': Array[ApplicationCommandPermission] val
    ) =>
        id = id'
        application_id = application_id'
        guild_id = guild_id'
        permissions = permissions'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var application_id': (Snowflake | None) = None
        var guild_id': (Snowflake | None) = None
        var permissions': (Array[ApplicationCommandPermission] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "application_id" => application_id' = Snowflake.from_json(value)?
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "permissions" => permissions' = _ApplicationCommandPermissions(value)?
            end
        end

        id = id' as Snowflake
        application_id = application_id' as Snowflake
        guild_id = guild_id' as Snowflake
        permissions = permissions' as Array[ApplicationCommandPermission] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("application_id", application_id.to_json())
            .update("guild_id", guild_id.to_json())
            .update("permissions", _ApplicationCommandPermissions.to_json(permissions))

primitive _GuildApplicationCommandPermissions
    fun apply(value: json.JsonValue): Array[GuildApplicationCommandPermissions] val ? =>
        """
        Decodes an array of guild application command permissions.
        """

        let array = value as json.JsonArray
        recover val
            let permissions = Array[GuildApplicationCommandPermissions](array.size())
            for entry in array.values() do permissions.push(GuildApplicationCommandPermissions.from_json(entry as json.JsonObject)?) end
            permissions
        end

    fun to_json(permissions: Array[GuildApplicationCommandPermissions] val): json.JsonArray =>
        var array = json.JsonArray
        for entry in permissions.values() do array = array.push(entry.to_json()) end
        array


class val GetGlobalApplicationCommandsParams
    """
    https://docs.discord.com/developers/interactions/application-commands#get-global-application-commands-query-string-params
    """

    let with_localizations: (Bool | None)
        """
        Whether to include full localization dictionaries (`name_localizations` and `description_localizations`) in the returned objects, instead of the `name_localized` and `description_localized` fields. Default `false`.
        """

    new val create(with_localizations': (Bool | None) = None) =>
        with_localizations = with_localizations'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_localizations
        | let with_localizations': Bool => query.push(("with_localizations", with_localizations'.string()))
        end

        consume query

class val CreateGlobalApplicationCommandParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#create-global-application-command-json-params

    Creating a command with the same name as an existing command for your application will overwrite the old command.
    """

    let name: String
        """
        Name of command, 1-32 characters
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    let description: (String | None)
        """
        1-100 character description for `CHAT_INPUT` commands
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `description` field. Values follow the same restrictions as `description`
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        the parameters for the command
        """

    let default_member_permissions: Nullable[Array[Permission] val]
        """
        Set of permissions represented as a bit set
        """

    let integration_types: (Array[ApplicationIntegrationType] val | None)
        """
        Installation contexts where the command is available, only for globally-scoped commands. Defaults to your app's configured contexts
        """

    let contexts: (Array[InteractionContextType] val | None)
        """
        Interaction context(s) where the command can be used, only for globally-scoped commands. By default, all interaction context types included for new commands.
        """

    let type': (ApplicationCommandType | None)
        """
        Type of command, defaults `1` if not set
        """

    let nsfw: (Bool | None)
        """
        Indicates whether the command is age-restricted
        """

    let handler: (ApplicationCommandHandlerType | None)
        """
        Determines whether the interaction is handled by the app's interactions handler or by Discord

        Only available for `PRIMARY_ENTRY_POINT` commands.
        """

    new val create(
        name': String,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description': (String | None) = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        default_member_permissions': Nullable[Array[Permission] val] = None,
        integration_types': (Array[ApplicationIntegrationType] val | None) = None,
        contexts': (Array[InteractionContextType] val | None) = None,
        type'': (ApplicationCommandType | None) = None,
        nsfw': (Bool | None) = None,
        handler': (ApplicationCommandHandlerType | None) = None
    ) =>
        name = name'
        name_localizations = name_localizations'
        description = description'
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        integration_types = integration_types'
        contexts = contexts'
        type' = type''
        nsfw = nsfw'
        handler = handler'

    fun to_json(): json.JsonObject =>
        _ApplicationCommandJson(
            name,
            name_localizations,
            description,
            description_localizations,
            options,
            default_member_permissions,
            integration_types,
            contexts,
            type',
            nsfw,
            handler)

class val UpdateGlobalApplicationCommandParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#edit-global-application-command-json-params

    All parameters for this endpoint are optional.
    """

    let name: (String | None)
        """
        Name of command, 1-32 characters
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    let description: (String | None)
        """
        1-100 character description
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `description` field. Values follow the same restrictions as `description`
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        the parameters for the command
        """

    let default_member_permissions: Nullable[Array[Permission] val]
        """
        Set of permissions represented as a bit set
        """

    let integration_types: (Array[ApplicationIntegrationType] val | None)
        """
        Installation contexts where the command is available, only for globally-scoped commands
        """

    let contexts: (Array[InteractionContextType] val | None)
        """
        Interaction context(s) where the command can be used, only for globally-scoped commands
        """

    let nsfw: (Bool | None)
        """
        Indicates whether the command is age-restricted
        """

    new val create(
        name': (String | None) = None,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description': (String | None) = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        default_member_permissions': Nullable[Array[Permission] val] = None,
        integration_types': (Array[ApplicationIntegrationType] val | None) = None,
        contexts': (Array[InteractionContextType] val | None) = None,
        nsfw': (Bool | None) = None
    ) =>
        name = name'
        name_localizations = name_localizations'
        description = description'
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        integration_types = integration_types'
        contexts = contexts'
        nsfw = nsfw'

    fun to_json(): json.JsonObject =>
        var obj = _ApplicationCommandJson(
            None,
            name_localizations,
            description,
            description_localizations,
            options,
            default_member_permissions,
            integration_types,
            contexts,
            None,
            nsfw,
            None)

        match name
        | let name': String => obj = obj.update("name", name')
        end

        obj

class val BulkOverwriteGlobalApplicationCommandsParams is ToJsonableArray
    """
    https://docs.discord.com/developers/interactions/application-commands#bulk-overwrite-global-application-commands

    This endpoint takes a JSON array of application command params. Commands that do not already exist will count toward the daily application command create limit.
    """

    let commands: Array[CreateGlobalApplicationCommandParams] val
        """
        the full set of commands the application should end up with
        """

    new val create(commands': Array[CreateGlobalApplicationCommandParams] val) =>
        commands = commands'

    fun to_json(): json.JsonArray =>
        var array = json.JsonArray
        for command in commands.values() do array = array.push(command.to_json()) end
        array

class val GetGuildApplicationCommandsParams
    """
    https://docs.discord.com/developers/interactions/application-commands#get-guild-application-commands-query-string-params
    """

    let with_localizations: (Bool | None)
        """
        Whether to include full localization dictionaries (`name_localizations` and `description_localizations`) in the returned objects, instead of the `name_localized` and `description_localized` fields. Default `false`.
        """

    new val create(with_localizations': (Bool | None) = None) =>
        with_localizations = with_localizations'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match with_localizations
        | let with_localizations': Bool => query.push(("with_localizations", with_localizations'.string()))
        end

        consume query

class val CreateGuildApplicationCommandParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#create-guild-application-command-json-params

    Creating a command with the same name as an existing command for your application will overwrite the old command.
    """

    let name: String
        """
        Name of command, 1-32 characters
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    let description: (String | None)
        """
        1-100 character description for `CHAT_INPUT` commands
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `description` field. Values follow the same restrictions as `description`
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        Parameters for the command
        """

    let default_member_permissions: Nullable[Array[Permission] val]
        """
        Set of permissions represented as a bit set
        """

    let type': (ApplicationCommandType | None)
        """
        Type of command, defaults `1` if not set
        """

    let nsfw: (Bool | None)
        """
        Indicates whether the command is age-restricted
        """

    new val create(
        name': String,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description': (String | None) = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        default_member_permissions': Nullable[Array[Permission] val] = None,
        type'': (ApplicationCommandType | None) = None,
        nsfw': (Bool | None) = None
    ) =>
        name = name'
        name_localizations = name_localizations'
        description = description'
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        type' = type''
        nsfw = nsfw'

    fun to_json(): json.JsonObject =>
        _ApplicationCommandJson(
            name,
            name_localizations,
            description,
            description_localizations,
            options,
            default_member_permissions,
            None,
            None,
            type',
            nsfw,
            None)

class val UpdateGuildApplicationCommandParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#edit-guild-application-command-json-params

    All parameters for this endpoint are optional.
    """

    let name: (String | None)
        """
        Name of command, 1-32 characters
        """

    let name_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `name` field. Values follow the same restrictions as `name`
        """

    let description: (String | None)
        """
        1-100 character description
        """

    let description_localizations: Nullable[collections.Map[Locale, String] val]
        """
        Localization dictionary for the `description` field. Values follow the same restrictions as `description`
        """

    let options: (Array[ApplicationCommandOption] val | None)
        """
        Parameters for the command
        """

    let default_member_permissions: Nullable[Array[Permission] val]
        """
        Set of permissions represented as a bit set
        """

    let nsfw: (Bool | None)
        """
        Indicates whether the command is age-restricted
        """

    new val create(
        name': (String | None) = None,
        name_localizations': Nullable[collections.Map[Locale, String] val] = None,
        description': (String | None) = None,
        description_localizations': Nullable[collections.Map[Locale, String] val] = None,
        options': (Array[ApplicationCommandOption] val | None) = None,
        default_member_permissions': Nullable[Array[Permission] val] = None,
        nsfw': (Bool | None) = None
    ) =>
        name = name'
        name_localizations = name_localizations'
        description = description'
        description_localizations = description_localizations'
        options = options'
        default_member_permissions = default_member_permissions'
        nsfw = nsfw'

    fun to_json(): json.JsonObject =>
        var obj = _ApplicationCommandJson(
            None,
            name_localizations,
            description,
            description_localizations,
            options,
            default_member_permissions,
            None,
            None,
            None,
            nsfw,
            None)

        match name
        | let name': String => obj = obj.update("name", name')
        end

        obj

class val BulkOverwriteGuildApplicationCommandsParams is ToJsonableArray
    """
    https://docs.discord.com/developers/interactions/application-commands#bulk-overwrite-guild-application-commands

    This endpoint takes a JSON array of application command params. This will overwrite all types of application commands: slash commands, user commands, and message commands.
    """

    let commands: Array[CreateGuildApplicationCommandParams] val
        """
        the full set of commands the application should end up with in the guild
        """

    new val create(commands': Array[CreateGuildApplicationCommandParams] val) =>
        commands = commands'

    fun to_json(): json.JsonArray =>
        var array = json.JsonArray
        for command in commands.values() do array = array.push(command.to_json()) end
        array

class val UpdateApplicationCommandPermissionsParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#edit-application-command-permissions-json-params

    This endpoint will overwrite existing permissions for the command in that guild and requires a Bearer token with the `applications.commands.permissions.update` scope.
    """

    let permissions: Array[ApplicationCommandPermission] val
        """
        Permissions for the command in the guild (max of 100)
        """

    new val create(permissions': Array[ApplicationCommandPermission] val) =>
        permissions = permissions'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("permissions", _ApplicationCommandPermissions.to_json(permissions))

class val GuildApplicationCommandPermissionsParams is ToJsonable
    """
    https://docs.discord.com/developers/interactions/application-commands#batch-edit-application-command-permissions

    A partial guild application command permissions object; a single entry of the array body sent to Batch Edit Application Command Permissions.
    """

    let id: Snowflake
        """
        ID of the command
        """

    let permissions: Array[ApplicationCommandPermission] val
        """
        Permissions for the command in the guild (max of 100)
        """

    new val create(id': Snowflake, permissions': Array[ApplicationCommandPermission] val) =>
        id = id'
        permissions = permissions'

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("permissions", _ApplicationCommandPermissions.to_json(permissions))

class val BatchUpdateApplicationCommandPermissionsParams is ToJsonableArray
    """
    https://docs.discord.com/developers/interactions/application-commands#batch-edit-application-command-permissions

    This endpoint takes a JSON array of partial guild application command permissions objects.
    """

    let permissions: Array[GuildApplicationCommandPermissionsParams] val
        """
        the per-command permissions the guild should end up with
        """

    new val create(permissions': Array[GuildApplicationCommandPermissionsParams] val) =>
        permissions = permissions'

    fun to_json(): json.JsonArray =>
        var array = json.JsonArray
        for entry in permissions.values() do array = array.push(entry.to_json()) end
        array

primitive _ApplicationCommandJson
    """
    Serialises the fields shared by the application command create and edit endpoints, omitting those left unset.
    """

    fun apply(
        name: (String | None),
        name_localizations: Nullable[collections.Map[Locale, String] val],
        description: (String | None),
        description_localizations: Nullable[collections.Map[Locale, String] val],
        options: (Array[ApplicationCommandOption] val | None),
        default_member_permissions: Nullable[Array[Permission] val],
        integration_types: (Array[ApplicationIntegrationType] val | None),
        contexts: (Array[InteractionContextType] val | None),
        type': (ApplicationCommandType | None),
        nsfw: (Bool | None),
        handler: (ApplicationCommandHandlerType | None)
    ): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match name_localizations
        | let name_localizations': collections.Map[Locale, String] val => obj = obj.update("name_localizations", _Localizations.to_json(name_localizations'))
        | Null => obj = obj.update("name_localizations", None)
        end

        match description
        | let description': String => obj = obj.update("description", description')
        end

        match description_localizations
        | let description_localizations': collections.Map[Locale, String] val => obj = obj.update("description_localizations", _Localizations.to_json(description_localizations'))
        | Null => obj = obj.update("description_localizations", None)
        end

        match options
        | let options': Array[ApplicationCommandOption] val => obj = obj.update("options", _ApplicationCommandOptions.to_json(options'))
        end

        match default_member_permissions
        | let default_member_permissions': Array[Permission] val => obj = obj.update("default_member_permissions", _Permissions.to_json(default_member_permissions'))
        | Null => obj = obj.update("default_member_permissions", None)
        end

        match integration_types
        | let integration_types': Array[ApplicationIntegrationType] val =>
            var types = json.JsonArray
            for integration_type in integration_types'.values() do types = types.push(integration_type.value().i64()) end
            obj = obj.update("integration_types", types)
        end

        match contexts
        | let contexts': Array[InteractionContextType] val =>
            var types = json.JsonArray
            for context in contexts'.values() do types = types.push(context.value().i64()) end
            obj = obj.update("contexts", types)
        end

        match type'
        | let type'': ApplicationCommandType => obj = obj.update("type", type''.value().i64())
        end

        match nsfw
        | let nsfw': Bool => obj = obj.update("nsfw", nsfw')
        end

        match handler
        | let handler': ApplicationCommandHandlerType => obj = obj.update("handler", handler'.value().i64())
        end

        obj
