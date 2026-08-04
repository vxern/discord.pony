use collections = "collections"
use json = "json"

trait val Component is Jsonable
    """
    https://docs.discord.com/developers/components/reference#component-object

    Components allow you to style and structure your messages, modals, and interactions. They are interactive elements that can create rich user experiences in your Discord applications.

    Components are a field on the message object and modal. You can use them when creating messages or responding to an interaction, like an application command.

    Every component carries a `type` and an optional `id`. The `id` is used to identify components in the response from an interaction. It must be unique within the message and is generated sequentially if left empty. Generation of `id`s won't use another `id` that exists in the message if you have one defined for another component. Sending components with an `id` of `0` is allowed but will be treated as empty and replaced by the API.
    """

    fun component_type(): ComponentType
        """
        The type of the component
        """

trait val ComponentType is (collections.Hashable & Equatable[ComponentType])
    """
    https://docs.discord.com/developers/components/reference#component-object-component-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ComponentType): Bool => value() == that.value()
primitive ActionRowComponentType is ComponentType
    """
    Container to display a row of interactive components

    Layout component, usable in messages.
    """

    fun value(): U8 => 1
primitive ButtonComponentType is ComponentType
    """
    Button object

    Interactive component, usable in messages.
    """

    fun value(): U8 => 2
primitive StringSelectComponentType is ComponentType
    """
    Select menu for picking from defined text options

    Interactive component, usable in messages and modals.
    """

    fun value(): U8 => 3
primitive TextInputComponentType is ComponentType
    """
    Text input object

    Interactive component, usable in modals.
    """

    fun value(): U8 => 4
primitive UserSelectComponentType is ComponentType
    """
    Select menu for users

    Interactive component, usable in messages and modals.
    """

    fun value(): U8 => 5
primitive RoleSelectComponentType is ComponentType
    """
    Select menu for roles

    Interactive component, usable in messages and modals.
    """

    fun value(): U8 => 6
primitive MentionableSelectComponentType is ComponentType
    """
    Select menu for mentionables (users *and* roles)

    Interactive component, usable in messages and modals.
    """

    fun value(): U8 => 7
primitive ChannelSelectComponentType is ComponentType
    """
    Select menu for channels

    Interactive component, usable in messages and modals.
    """

    fun value(): U8 => 8
primitive SectionComponentType is ComponentType
    """
    Container to display text alongside an accessory component

    Layout component, usable in messages.
    """

    fun value(): U8 => 9
primitive TextDisplayComponentType is ComponentType
    """
    Markdown text

    Content component, usable in messages and modals.
    """

    fun value(): U8 => 10
primitive ThumbnailComponentType is ComponentType
    """
    Small image that can be used as an accessory

    Content component, usable in messages.
    """

    fun value(): U8 => 11
primitive MediaGalleryComponentType is ComponentType
    """
    Display images and other media

    Content component, usable in messages.
    """

    fun value(): U8 => 12
primitive FileComponentType is ComponentType
    """
    Displays an attached file

    Content component, usable in messages.
    """

    fun value(): U8 => 13
primitive SeparatorComponentType is ComponentType
    """
    Component to add vertical padding between other components

    Layout component, usable in messages.
    """

    fun value(): U8 => 14
primitive ContainerComponentType is ComponentType
    """
    Container that visually groups a set of components

    Layout component, usable in messages.
    """

    fun value(): U8 => 17
primitive LabelComponentType is ComponentType
    """
    Container associating a label and description with a component

    Layout component, usable in modals.
    """

    fun value(): U8 => 18
primitive FileUploadComponentType is ComponentType
    """
    Component for uploading files

    Interactive component, usable in modals.
    """

    fun value(): U8 => 19
primitive RadioGroupComponentType is ComponentType
    """
    Single-choice set of options

    Interactive component, usable in modals.
    """

    fun value(): U8 => 21
primitive CheckboxGroupComponentType is ComponentType
    """
    Multi-selectable group of checkboxes

    Interactive component, usable in modals.
    """

    fun value(): U8 => 22
primitive CheckboxComponentType is ComponentType
    """
    Single checkbox for yes/no choice

    Interactive component, usable in modals.
    """

    fun value(): U8 => 23
primitive ComponentTypes
    fun from(value: U8): ComponentType ? =>
        match value
        | 1 => ActionRowComponentType
        | 2 => ButtonComponentType
        | 3 => StringSelectComponentType
        | 4 => TextInputComponentType
        | 5 => UserSelectComponentType
        | 6 => RoleSelectComponentType
        | 7 => MentionableSelectComponentType
        | 8 => ChannelSelectComponentType
        | 9 => SectionComponentType
        | 10 => TextDisplayComponentType
        | 11 => ThumbnailComponentType
        | 12 => MediaGalleryComponentType
        | 13 => FileComponentType
        | 14 => SeparatorComponentType
        | 17 => ContainerComponentType
        | 18 => LabelComponentType
        | 19 => FileUploadComponentType
        | 21 => RadioGroupComponentType
        | 22 => CheckboxGroupComponentType
        | 23 => CheckboxComponentType
        else error
        end

primitive Components
    fun from_json(obj: json.JsonObject): Component ? =>
        """
        Decodes a component, dispatching on its `type` field.
        """

        match ComponentTypes.from((obj("type")? as I64).u8())?
        | ActionRowComponentType => ActionRowComponent.from_json(obj)?
        | ButtonComponentType => ButtonComponent.from_json(obj)?
        | StringSelectComponentType => StringSelectComponent.from_json(obj)?
        | TextInputComponentType => TextInputComponent.from_json(obj)?
        | UserSelectComponentType => UserSelectComponent.from_json(obj)?
        | RoleSelectComponentType => RoleSelectComponent.from_json(obj)?
        | MentionableSelectComponentType => MentionableSelectComponent.from_json(obj)?
        | ChannelSelectComponentType => ChannelSelectComponent.from_json(obj)?
        | SectionComponentType => SectionComponent.from_json(obj)?
        | TextDisplayComponentType => TextDisplayComponent.from_json(obj)?
        | ThumbnailComponentType => ThumbnailComponent.from_json(obj)?
        | MediaGalleryComponentType => MediaGalleryComponent.from_json(obj)?
        | FileComponentType => FileComponent.from_json(obj)?
        | SeparatorComponentType => SeparatorComponent.from_json(obj)?
        | ContainerComponentType => ContainerComponent.from_json(obj)?
        | LabelComponentType => LabelComponent.from_json(obj)?
        | FileUploadComponentType => FileUploadComponent.from_json(obj)?
        | RadioGroupComponentType => RadioGroupComponent.from_json(obj)?
        | CheckboxGroupComponentType => CheckboxGroupComponent.from_json(obj)?
        | CheckboxComponentType => CheckboxComponent.from_json(obj)?
        else error
        end

primitive _Components
    fun apply(value: json.JsonValue): Array[Component] val ? =>
        """
        Decodes an array of components.
        """

        let array = value as json.JsonArray
        recover val
            let components = Array[Component](array.size())
            for component in array.values() do components.push(Components.from_json(component as json.JsonObject)?) end
            components
        end

    fun to_json(components: Array[Component] val): json.JsonArray =>
        var array = json.JsonArray
        for component in components.values() do array = array.push(component.to_json()) end
        array

primitive _ComponentJson
    fun apply(type': ComponentType, id: (U32 | None)): json.JsonObject =>
        """
        Builds the `type` and `id` fields that every component carries.
        """

        var obj = json.JsonObject.update("type", type'.value().i64())

        match id
        | let id': U32 => obj = obj.update("id", id'.i64())
        end

        obj

class val ActionRowComponent is Component
    """
    https://docs.discord.com/developers/components/reference#action-row

    An Action Row is a top-level layout component.

    Action Rows can contain one of the following:
    - Up to 5 contextually grouped buttons
    - A single select component (string select, user select, role select, mentionable select, or channel select)

    `LabelComponent` is recommended for use over an Action Row in modals. Action Rows with Text Inputs in modals are now deprecated.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let components: Array[ActionRowChildComponent] val
        """
        Up to 5 interactive button components or a single select component
        """

    new val create(id': (U32 | None) = None, components': Array[ActionRowChildComponent] val) =>
        id = id'
        components = components'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var components': (Array[ActionRowChildComponent] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "components" => components' = _ActionRowChildComponents(value)?
            end
        end

        id = id'
        components = components' as Array[ActionRowChildComponent] val

    fun component_type(): ComponentType => ActionRowComponentType

    fun to_json(): json.JsonObject =>
        _ComponentJson(component_type(), id)
            .update("components", _ActionRowChildComponents.to_json(components))

// https://docs.discord.com/developers/components/reference#action-row-action-row-child-components
//
// An Action Row can contain up to 5 Buttons, or a single String Select, User Select, Role Select, Mentionable Select or Channel Select.
type ActionRowChildComponent is (ButtonComponent | StringSelectComponent | UserSelectComponent | RoleSelectComponent | MentionableSelectComponent | ChannelSelectComponent)

primitive _ActionRowChildComponents
    fun apply(value: json.JsonValue): Array[ActionRowChildComponent] val ? =>
        """
        Decodes an array of action row child components.
        """

        let array = value as json.JsonArray
        recover val
            let components = Array[ActionRowChildComponent](array.size())
            for component in array.values() do
                components.push(Components.from_json(component as json.JsonObject)? as ActionRowChildComponent)
            end
            components
        end

    fun to_json(components: Array[ActionRowChildComponent] val): json.JsonArray =>
        var array = json.JsonArray
        for component in components.values() do array = array.push(component.to_json()) end
        array

class val ButtonComponent is Component
    """
    https://docs.discord.com/developers/components/reference#button

    A Button is an interactive component that can only be used in messages. It creates clickable elements that users can interact with, sending an interaction to your app when clicked.

    Buttons must be placed inside an Action Row or a Section's `accessory` field.

    Buttons come in various styles to convey different types of actions. These styles also define what fields are valid for a button.
    - Non-link and non-premium buttons **must** have a `custom_id`, and cannot have a `url` or a `sku_id`.
    - Link buttons **must** have a `url`, and cannot have a `custom_id`.
    - Link buttons do not send an interaction to your app when clicked.
    - Premium buttons **must** contain a `sku_id`, and cannot have a `custom_id`, `label`, `url`, or `emoji`.
    - Premium buttons do not send an interaction to your app when clicked.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let style: ButtonStyle
        """
        A button style
        """

    let label: (String | None)
        """
        Text that appears on the button; max 80 characters
        """

    let emoji: (Emoji | None)
        """
        `name`, `id`, and `animated`
        """

    let custom_id: (String | None)
        """
        Developer-defined identifier for the button; 1-100 characters
        """

    let sku_id: (Snowflake | None)
        """
        Identifier for a purchasable SKU, only available when using premium-style buttons
        """

    let url: (String | None)
        """
        URL for link-style buttons; max 512 characters
        """

    let disabled: (Bool | None)
        """
        Whether the button is disabled (defaults to `false`)
        """

    new val create(
        id': (U32 | None) = None,
        style': ButtonStyle,
        label': (String | None) = None,
        emoji': (Emoji | None) = None,
        custom_id': (String | None) = None,
        sku_id': (Snowflake | None) = None,
        url': (String | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        style = style'
        label = label'
        emoji = emoji'
        custom_id = custom_id'
        sku_id = sku_id'
        url = url'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var style': (ButtonStyle | None) = None
        var label': (String | None) = None
        var emoji': (Emoji | None) = None
        var custom_id': (String | None) = None
        var sku_id': (Snowflake | None) = None
        var url': (String | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "style" => style' = ButtonStyles.from((value as I64).u8())?
            | "label" => label' = value as String
            | "emoji" => emoji' = Emoji.from_json(value as json.JsonObject)?
            | "custom_id" => custom_id' = value as String
            | "sku_id" => sku_id' = Snowflake.from_json(value)?
            | "url" => url' = value as String
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        style = style' as ButtonStyle
        label = label'
        emoji = emoji'
        custom_id = custom_id'
        sku_id = sku_id'
        url = url'
        disabled = disabled'

    fun component_type(): ComponentType => ButtonComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("style", style.value().i64())

        match label
        | let label': String => obj = obj.update("label", label')
        end

        match emoji
        | let emoji': Emoji => obj = obj.update("emoji", emoji'.to_json())
        end

        match custom_id
        | let custom_id': String => obj = obj.update("custom_id", custom_id')
        end

        match sku_id
        | let sku_id': Snowflake => obj = obj.update("sku_id", sku_id'.to_json())
        end

        match url
        | let url': String => obj = obj.update("url", url')
        end

        match disabled
        | let disabled': Bool => obj = obj.update("disabled", disabled')
        end

        obj

trait val ButtonStyle is (collections.Hashable & Equatable[ButtonStyle])
    """
    https://docs.discord.com/developers/components/reference#button-button-styles
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ButtonStyle): Bool => value() == that.value()
primitive PrimaryButtonStyle is ButtonStyle
    """
    The most important or recommended action in a group of options

    Requires `custom_id`.
    """

    fun value(): U8 => 1
primitive SecondaryButtonStyle is ButtonStyle
    """
    Alternative or supporting actions

    Requires `custom_id`.
    """

    fun value(): U8 => 2
primitive SuccessButtonStyle is ButtonStyle
    """
    Positive confirmation or completion actions

    Requires `custom_id`.
    """

    fun value(): U8 => 3
primitive DangerButtonStyle is ButtonStyle
    """
    An action with irreversible consequences

    Requires `custom_id`.
    """

    fun value(): U8 => 4
primitive LinkButtonStyle is ButtonStyle
    """
    Navigates to a URL

    Requires `url`.
    """

    fun value(): U8 => 5
primitive PremiumButtonStyle is ButtonStyle
    """
    Purchase

    Requires `sku_id`.
    """

    fun value(): U8 => 6
primitive ButtonStyles
    fun from(value: U8): ButtonStyle ? =>
        match value
        | 1 => PrimaryButtonStyle
        | 2 => SecondaryButtonStyle
        | 3 => SuccessButtonStyle
        | 4 => DangerButtonStyle
        | 5 => LinkButtonStyle
        | 6 => PremiumButtonStyle
        else error
        end

class val StringSelectComponent is Component
    """
    https://docs.discord.com/developers/components/reference#string-select

    A String Select is an interactive component that allows users to select one or more provided `options`.

    String Selects can be configured for both single-select and multi-select behavior. When a user finishes making their choice(s) your app receives an interaction.

    String Selects are available in messages and modals. They must be placed inside an Action Row in messages and a Label in modals.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the select menu; 1-100 characters
        """

    let options: Array[SelectOption] val
        """
        Specified choices in a select menu; max 25
        """

    let placeholder: (String | None)
        """
        Placeholder text if nothing is selected or default; max 150 characters
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen (defaults to 1); min 0, max 25

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen (defaults to 1); max 25
        """

    let required: (Bool | None)
        """
        Whether the string select is required to answer in a modal (defaults to `true`)

        Only available in modals. It is ignored in messages.
        """

    let disabled: (Bool | None)
        """
        Whether select menu is disabled in a message (defaults to `false`)

        Using this in a modal will result in an error. Modals can not currently have disabled components in them.
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        options': Array[SelectOption] val,
        placeholder': (String | None) = None,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        options = options'
        placeholder = placeholder'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var options': (Array[SelectOption] val | None) = None
        var placeholder': (String | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "options" => options' = _SelectOptions(value)?
            | "placeholder" => placeholder' = value as String
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        options = options' as Array[SelectOption] val
        placeholder = placeholder'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    fun component_type(): ComponentType => StringSelectComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)
            .update("options", _SelectOptions.to_json(options))

        match placeholder
        | let placeholder': String => obj = obj.update("placeholder", placeholder')
        end

        match min_values
        | let min_values': USize => obj = obj.update("min_values", min_values'.i64())
        end

        match max_values
        | let max_values': USize => obj = obj.update("max_values", max_values'.i64())
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        match disabled
        | let disabled': Bool => obj = obj.update("disabled", disabled')
        end

        obj

class val SelectOption is Jsonable
    """
    https://docs.discord.com/developers/components/reference#string-select-select-option-structure
    """

    let label: String
        """
        User-facing name of the option; max 100 characters
        """

    let value: String
        """
        Dev-defined value of the option; max 100 characters
        """

    let description: (String | None)
        """
        Additional description of the option; max 100 characters
        """

    let emoji: (Emoji | None)
        """
        `id`, `name`, and `animated`
        """

    let default: (Bool | None)
        """
        Will show this option as selected by default
        """

    new val create(
        label': String,
        value': String,
        description': (String | None) = None,
        emoji': (Emoji | None) = None,
        default': (Bool | None) = None
    ) =>
        label = label'
        value = value'
        description = description'
        emoji = emoji'
        default = default'

    new val from_json(obj: json.JsonObject) ? =>
        var label': (String | None) = None
        var value': (String | None) = None
        var description': (String | None) = None
        var emoji': (Emoji | None) = None
        var default': (Bool | None) = None

        for (key, entry) in obj.pairs() do
            match key
            | "label" => label' = entry as String
            | "value" => value' = entry as String
            | "description" => description' = entry as String
            | "emoji" => emoji' = Emoji.from_json(entry as json.JsonObject)?
            | "default" => default' = entry as Bool
            end
        end

        label = label' as String
        value = value' as String
        description = description'
        emoji = emoji'
        default = default'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("label", label)
            .update("value", value)

        match description
        | let description': String => obj = obj.update("description", description')
        end

        match emoji
        | let emoji': Emoji => obj = obj.update("emoji", emoji'.to_json())
        end

        match default
        | let default': Bool => obj = obj.update("default", default')
        end

        obj

primitive _SelectOptions
    fun apply(value: json.JsonValue): Array[SelectOption] val ? =>
        """
        Decodes an array of select options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[SelectOption](array.size())
            for option in array.values() do options.push(SelectOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[SelectOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

class val TextInputComponent is Component
    """
    https://docs.discord.com/developers/components/reference#text-input

    Text Input is an interactive component that allows users to enter free-form text responses in modals. It supports both short, single-line inputs and longer, multi-line paragraph inputs.

    Text Inputs can only be used within modals and must be placed inside a Label.

    The `label` field on a Text Input is deprecated in favour of `label` and `description` on the Label component, and so is not modelled here.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        Developer-defined identifier for the input; 1-100 characters
        """

    let style: TextInputStyle
        """
        The Text Input Style
        """

    let min_length: (USize | None)
        """
        Minimum input length for a text input; min 0, max 4000
        """

    let max_length: (USize | None)
        """
        Maximum input length for a text input; min 1, max 4000
        """

    let required: (Bool | None)
        """
        Whether this component is required to be filled (defaults to `true`)
        """

    let value: (String | None)
        """
        Pre-filled value for this component; max 4000 characters
        """

    let placeholder: (String | None)
        """
        Custom placeholder text if the input is empty; max 100 characters
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        style': TextInputStyle,
        min_length': (USize | None) = None,
        max_length': (USize | None) = None,
        required': (Bool | None) = None,
        value': (String | None) = None,
        placeholder': (String | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        style = style'
        min_length = min_length'
        max_length = max_length'
        required = required'
        value = value'
        placeholder = placeholder'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var style': (TextInputStyle | None) = None
        var min_length': (USize | None) = None
        var max_length': (USize | None) = None
        var required': (Bool | None) = None
        var value': (String | None) = None
        var placeholder': (String | None) = None

        for (key, entry) in obj.pairs() do
            match key
            | "id" => id' = (entry as I64).u32()
            | "custom_id" => custom_id' = entry as String
            | "style" => style' = TextInputStyles.from((entry as I64).u8())?
            | "min_length" => min_length' = (entry as I64).usize()
            | "max_length" => max_length' = (entry as I64).usize()
            | "required" => required' = entry as Bool
            | "value" => value' = entry as String
            | "placeholder" => placeholder' = entry as String
            end
        end

        id = id'
        custom_id = custom_id' as String
        style = style' as TextInputStyle
        min_length = min_length'
        max_length = max_length'
        required = required'
        value = value'
        placeholder = placeholder'

    fun component_type(): ComponentType => TextInputComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)
            .update("style", style.value().i64())

        match min_length
        | let min_length': USize => obj = obj.update("min_length", min_length'.i64())
        end

        match max_length
        | let max_length': USize => obj = obj.update("max_length", max_length'.i64())
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        match value
        | let value': String => obj = obj.update("value", value')
        end

        match placeholder
        | let placeholder': String => obj = obj.update("placeholder", placeholder')
        end

        obj

trait val TextInputStyle is (collections.Hashable & Equatable[TextInputStyle])
    """
    https://docs.discord.com/developers/components/reference#text-input-text-input-styles
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: TextInputStyle): Bool => value() == that.value()
primitive ShortTextInputStyle is TextInputStyle
    """
    Single-line input
    """

    fun value(): U8 => 1
primitive ParagraphTextInputStyle is TextInputStyle
    """
    Multi-line input
    """

    fun value(): U8 => 2
primitive TextInputStyles
    fun from(value: U8): TextInputStyle ? =>
        match value
        | 1 => ShortTextInputStyle
        | 2 => ParagraphTextInputStyle
        else error
        end

class val UserSelectComponent is Component
    """
    https://docs.discord.com/developers/components/reference#user-select

    A User Select is an interactive component that allows users to select one or more users in a message or modal. Options are automatically populated based on the server's available users.

    User Selects are available in messages and modals. They must be placed inside an Action Row in messages and a Label in modals.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the select menu; 1-100 characters
        """

    let placeholder: (String | None)
        """
        Placeholder text if nothing is selected; max 150 characters
        """

    let default_values: (Array[SelectDefaultValue] val | None)
        """
        List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen (defaults to 1); min 0, max 25

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen (defaults to 1); max 25
        """

    let required: (Bool | None)
        """
        Whether the user select is required to answer in a modal (defaults to `true`)

        Only available in modals. It is ignored in messages.
        """

    let disabled: (Bool | None)
        """
        Whether select menu is disabled in a message (defaults to `false`)

        Using this in a modal will result in an error. Modals can not currently have disabled components in them.
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        placeholder': (String | None) = None,
        default_values': (Array[SelectDefaultValue] val | None) = None,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var placeholder': (String | None) = None
        var default_values': (Array[SelectDefaultValue] val | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "placeholder" => placeholder' = value as String
            | "default_values" => default_values' = _SelectDefaultValues(value)?
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    fun component_type(): ComponentType => UserSelectComponentType

    fun to_json(): json.JsonObject =>
        _SelectJson(_ComponentJson(component_type(), id), custom_id, placeholder, default_values, min_values, max_values, required, disabled)

class val RoleSelectComponent is Component
    """
    https://docs.discord.com/developers/components/reference#role-select

    A Role Select is an interactive component that allows users to select one or more roles in a message or modal. Options are automatically populated based on the server's available roles.

    Role Selects are available in messages and modals. They must be placed inside an Action Row in messages and a Label in modals.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the select menu; 1-100 characters
        """

    let placeholder: (String | None)
        """
        Placeholder text if nothing is selected; max 150 characters
        """

    let default_values: (Array[SelectDefaultValue] val | None)
        """
        List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen (defaults to 1); min 0, max 25

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen (defaults to 1); max 25
        """

    let required: (Bool | None)
        """
        Whether the role select is required to answer in a modal (defaults to `true`)

        Only available in modals. It is ignored in messages.
        """

    let disabled: (Bool | None)
        """
        Whether select menu is disabled in a message (defaults to `false`)

        Using this in a modal will result in an error. Modals can not currently have disabled components in them.
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        placeholder': (String | None) = None,
        default_values': (Array[SelectDefaultValue] val | None) = None,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var placeholder': (String | None) = None
        var default_values': (Array[SelectDefaultValue] val | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "placeholder" => placeholder' = value as String
            | "default_values" => default_values' = _SelectDefaultValues(value)?
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    fun component_type(): ComponentType => RoleSelectComponentType

    fun to_json(): json.JsonObject =>
        _SelectJson(_ComponentJson(component_type(), id), custom_id, placeholder, default_values, min_values, max_values, required, disabled)

class val MentionableSelectComponent is Component
    """
    https://docs.discord.com/developers/components/reference#mentionable-select

    A Mentionable Select is an interactive component that allows users to select one or more mentionables (users *and* roles) in a message or modal. Options are automatically populated based on the server's available mentionables.

    Mentionable Selects are available in messages and modals. They must be placed inside an Action Row in messages and a Label in modals.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the select menu; 1-100 characters
        """

    let placeholder: (String | None)
        """
        Placeholder text if nothing is selected; max 150 characters
        """

    let default_values: (Array[SelectDefaultValue] val | None)
        """
        List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen (defaults to 1); min 0, max 25

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen (defaults to 1); max 25
        """

    let required: (Bool | None)
        """
        Whether the mentionable select is required to answer in a modal (defaults to `true`)

        Only available in modals. It is ignored in messages.
        """

    let disabled: (Bool | None)
        """
        Whether select menu is disabled in a message (defaults to `false`)

        Using this in a modal will result in an error. Modals can not currently have disabled components in them.
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        placeholder': (String | None) = None,
        default_values': (Array[SelectDefaultValue] val | None) = None,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var placeholder': (String | None) = None
        var default_values': (Array[SelectDefaultValue] val | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "placeholder" => placeholder' = value as String
            | "default_values" => default_values' = _SelectDefaultValues(value)?
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    fun component_type(): ComponentType => MentionableSelectComponentType

    fun to_json(): json.JsonObject =>
        _SelectJson(_ComponentJson(component_type(), id), custom_id, placeholder, default_values, min_values, max_values, required, disabled)

class val ChannelSelectComponent is Component
    """
    https://docs.discord.com/developers/components/reference#channel-select

    A Channel Select is an interactive component that allows users to select one or more channels in a message or modal. Options are automatically populated based on the server's available channels and can be filtered by channel types.

    Channel Selects are available in messages and modals. They must be placed inside an Action Row in messages and a Label in modals.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the select menu; 1-100 characters
        """

    let channel_types: (Array[ChannelType] val | None)
        """
        List of channel types to include in the channel select component
        """

    let placeholder: (String | None)
        """
        Placeholder text if nothing is selected; max 150 characters
        """

    let default_values: (Array[SelectDefaultValue] val | None)
        """
        List of default values for auto-populated select menu components; number of default values must be in the range defined by `min_values` and `max_values`
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen (defaults to 1); min 0, max 25

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen (defaults to 1); max 25
        """

    let required: (Bool | None)
        """
        Whether the channel select is required to answer in a modal (defaults to `true`)

        Only available in modals. It is ignored in messages.
        """

    let disabled: (Bool | None)
        """
        Whether select menu is disabled in a message (defaults to `false`)

        Using this in a modal will result in an error. Modals can not currently have disabled components in them.
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        channel_types': (Array[ChannelType] val | None) = None,
        placeholder': (String | None) = None,
        default_values': (Array[SelectDefaultValue] val | None) = None,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None,
        disabled': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        channel_types = channel_types'
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var channel_types': (Array[ChannelType] val | None) = None
        var placeholder': (String | None) = None
        var default_values': (Array[SelectDefaultValue] val | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None
        var disabled': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "channel_types" => channel_types' = _ChannelTypes(value)?
            | "placeholder" => placeholder' = value as String
            | "default_values" => default_values' = _SelectDefaultValues(value)?
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            | "disabled" => disabled' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        channel_types = channel_types'
        placeholder = placeholder'
        default_values = default_values'
        min_values = min_values'
        max_values = max_values'
        required = required'
        disabled = disabled'

    fun component_type(): ComponentType => ChannelSelectComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)

        match channel_types
        | let channel_types': Array[ChannelType] val => obj = obj.update("channel_types", _ChannelTypes.to_json(channel_types'))
        end

        _SelectJson(obj, custom_id, placeholder, default_values, min_values, max_values, required, disabled)

primitive _SelectJson
    fun apply(obj': json.JsonObject, custom_id: String, placeholder: (String | None), default_values: (Array[SelectDefaultValue] val | None), min_values: (USize | None), max_values: (USize | None), required: (Bool | None), disabled: (Bool | None)): json.JsonObject =>
        """
        Encodes the fields shared by the auto-populated select menu components.
        """

        var obj = obj'.update("custom_id", custom_id)

        match placeholder
        | let placeholder': String => obj = obj.update("placeholder", placeholder')
        end

        match default_values
        | let default_values': Array[SelectDefaultValue] val => obj = obj.update("default_values", _SelectDefaultValues.to_json(default_values'))
        end

        match min_values
        | let min_values': USize => obj = obj.update("min_values", min_values'.i64())
        end

        match max_values
        | let max_values': USize => obj = obj.update("max_values", max_values'.i64())
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        match disabled
        | let disabled': Bool => obj = obj.update("disabled", disabled')
        end

        obj

class val SelectDefaultValue is Jsonable
    """
    https://docs.discord.com/developers/components/reference#user-select-select-default-value-structure

    Shared across the user, role, mentionable and channel selects for specifying pre-selected defaults.
    """

    let id: Snowflake
        """
        ID of a user, role, or channel
        """

    let type': SelectDefaultValueType
        """
        Type of value that `id` represents
        """

    new val create(id': Snowflake, type'': SelectDefaultValueType) =>
        id = id'
        type' = type''

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (SelectDefaultValueType | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = SelectDefaultValueTypes.from(value as String)?
            end
        end

        id = id' as Snowflake
        type' = type'' as SelectDefaultValueType

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value())

trait val SelectDefaultValueType is (collections.Hashable & Equatable[SelectDefaultValueType])
    """
    https://docs.discord.com/developers/components/reference#user-select-select-default-value-structure
    """

    fun value(): String

    fun hash(): USize => value().hash()

    fun eq(that: SelectDefaultValueType): Bool => value() == that.value()
primitive UserSelectDefaultValueType is SelectDefaultValueType
    fun value(): String => "user"
primitive RoleSelectDefaultValueType is SelectDefaultValueType
    fun value(): String => "role"
primitive ChannelSelectDefaultValueType is SelectDefaultValueType
    fun value(): String => "channel"
primitive SelectDefaultValueTypes
    fun from(value: String): SelectDefaultValueType ? =>
        match value
        | "user" => UserSelectDefaultValueType
        | "role" => RoleSelectDefaultValueType
        | "channel" => ChannelSelectDefaultValueType
        else error
        end

primitive _SelectDefaultValues
    fun apply(value: json.JsonValue): Array[SelectDefaultValue] val ? =>
        """
        Decodes an array of select default values.
        """

        let array = value as json.JsonArray
        recover val
            let values = Array[SelectDefaultValue](array.size())
            for entry in array.values() do values.push(SelectDefaultValue.from_json(entry as json.JsonObject)?) end
            values
        end

    fun to_json(values: Array[SelectDefaultValue] val): json.JsonArray =>
        var array = json.JsonArray
        for value in values.values() do array = array.push(value.to_json()) end
        array

class val SectionComponent is Component
    """
    https://docs.discord.com/developers/components/reference#section

    A Section is a top-level layout component that allows you to contextually associate content with an accessory component. The typical use-case is to contextually associate text content with an accessory.

    Sections are currently only available in messages.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let components: Array[SectionChildComponent] val
        """
        One to three child components representing the content of the section that is contextually associated to the accessory
        """

    let accessory: SectionAccessoryComponent
        """
        A component that is contextually associated to the content of the section
        """

    new val create(
        id': (U32 | None) = None,
        components': Array[SectionChildComponent] val,
        accessory': SectionAccessoryComponent
    ) =>
        id = id'
        components = components'
        accessory = accessory'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var components': (Array[SectionChildComponent] val | None) = None
        var accessory': (SectionAccessoryComponent | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "components" => components' = _SectionChildComponents(value)?
            | "accessory" => accessory' = Components.from_json(value as json.JsonObject)? as SectionAccessoryComponent
            end
        end

        id = id'
        components = components' as Array[SectionChildComponent] val
        accessory = accessory' as SectionAccessoryComponent

    fun component_type(): ComponentType => SectionComponentType

    fun to_json(): json.JsonObject =>
        _ComponentJson(component_type(), id)
            .update("components", _SectionChildComponents.to_json(components))
            .update("accessory", accessory.to_json())

// https://docs.discord.com/developers/components/reference#section-section-child-components
//
// Don't hardcode `components` to contain only text components. Discord may add other components in the future.
type SectionChildComponent is TextDisplayComponent

// https://docs.discord.com/developers/components/reference#section-section-accessory-components
//
// `accessory` may be expanded to include other components in the future.
type SectionAccessoryComponent is (ButtonComponent | ThumbnailComponent)

primitive _SectionChildComponents
    fun apply(value: json.JsonValue): Array[SectionChildComponent] val ? =>
        """
        Decodes an array of section child components.
        """

        let array = value as json.JsonArray
        recover val
            let components = Array[SectionChildComponent](array.size())
            for component in array.values() do
                components.push(Components.from_json(component as json.JsonObject)? as SectionChildComponent)
            end
            components
        end

    fun to_json(components: Array[SectionChildComponent] val): json.JsonArray =>
        var array = json.JsonArray
        for component in components.values() do array = array.push(component.to_json()) end
        array

class val TextDisplayComponent is Component
    """
    https://docs.discord.com/developers/components/reference#text-display

    A Text Display is a top-level content component that allows you to add markdown formatted text, including mentions (users, roles, etc) and emojis. The behavior of this component is extremely similar to the `content` field of a message, but allows you to add multiple text components, controlling the layout of your message.

    When sent in a message, pingable mentions (@user, @role, etc) present in this component will ping and send notifications based on the value of the allowed mention object set in `message.allowed_mentions`.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let content: String
        """
        Text that will be displayed similar to a message
        """

    new val create(id': (U32 | None) = None, content': String) =>
        id = id'
        content = content'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var content': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "content" => content' = value as String
            end
        end

        id = id'
        content = content' as String

    fun component_type(): ComponentType => TextDisplayComponentType

    fun to_json(): json.JsonObject =>
        _ComponentJson(component_type(), id)
            .update("content", content)

class val ThumbnailComponent is Component
    """
    https://docs.discord.com/developers/components/reference#thumbnail

    A Thumbnail is a content component that displays visual media in a small form-factor. It is intended as an accessory to other content, and is primarily usable with sections. The media displayed is defined by the unfurled media item structure, which supports both uploaded media and externally hosted media.

    Thumbnails are currently only available in messages as an accessory in a section.

    Thumbnails currently only support images, including animated formats like GIF and WEBP. Videos are not supported at this time.

    To use this component, you need to send the message flag `1 << 15` (`IsComponentsV2MessageFlag`), which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let media: UnfurledMediaItem
        """
        A url or attachment provided as an unfurled media item
        """

    let description: (String | None)
        """
        Alt text for the media, max 1024 characters
        """

    let spoiler: (Bool | None)
        """
        Whether the thumbnail should be a spoiler (or blurred out). Defaults to `false`
        """

    new val create(
        id': (U32 | None) = None,
        media': UnfurledMediaItem,
        description': (String | None) = None,
        spoiler': (Bool | None) = None
    ) =>
        id = id'
        media = media'
        description = description'
        spoiler = spoiler'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var media': (UnfurledMediaItem | None) = None
        var description': (String | None) = None
        var spoiler': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "media" => media' = UnfurledMediaItem.from_json(value as json.JsonObject)?
            | "description" =>
                match value | let string: String => description' = string end
            | "spoiler" => spoiler' = value as Bool
            end
        end

        id = id'
        media = media' as UnfurledMediaItem
        description = description'
        spoiler = spoiler'

    fun component_type(): ComponentType => ThumbnailComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("media", media.to_json())
            .update("description", description)

        match spoiler
        | let spoiler': Bool => obj = obj.update("spoiler", spoiler')
        end

        obj

class val MediaGalleryComponent is Component
    """
    https://docs.discord.com/developers/components/reference#media-gallery

    A Media Gallery is a top-level content component that allows you to display 1-10 media attachments in an organized gallery format. Each item can have optional descriptions and can be marked as spoilers.

    Media Galleries are currently only available in messages.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let items: Array[MediaGalleryItem] val
        """
        1 to 10 media gallery items
        """

    new val create(id': (U32 | None) = None, items': Array[MediaGalleryItem] val) =>
        id = id'
        items = items'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var items': (Array[MediaGalleryItem] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "items" => items' = _MediaGalleryItems(value)?
            end
        end

        id = id'
        items = items' as Array[MediaGalleryItem] val

    fun component_type(): ComponentType => MediaGalleryComponentType

    fun to_json(): json.JsonObject =>
        _ComponentJson(component_type(), id)
            .update("items", _MediaGalleryItems.to_json(items))

class val MediaGalleryItem is Jsonable
    """
    https://docs.discord.com/developers/components/reference#media-gallery-media-gallery-item-structure
    """

    let media: UnfurledMediaItem
        """
        A url or attachment provided as an unfurled media item
        """

    let description: (String | None)
        """
        Alt text for the media, max 1024 characters
        """

    let spoiler: (Bool | None)
        """
        Whether the media should be a spoiler (or blurred out). Defaults to `false`
        """

    new val create(media': UnfurledMediaItem, description': (String | None) = None, spoiler': (Bool | None) = None) =>
        media = media'
        description = description'
        spoiler = spoiler'

    new val from_json(obj: json.JsonObject) ? =>
        var media': (UnfurledMediaItem | None) = None
        var description': (String | None) = None
        var spoiler': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "media" => media' = UnfurledMediaItem.from_json(value as json.JsonObject)?
            | "description" =>
                match value | let string: String => description' = string end
            | "spoiler" => spoiler' = value as Bool
            end
        end

        media = media' as UnfurledMediaItem
        description = description'
        spoiler = spoiler'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("media", media.to_json())
            .update("description", description)

        match spoiler
        | let spoiler': Bool => obj = obj.update("spoiler", spoiler')
        end

        obj

primitive _MediaGalleryItems
    fun apply(value: json.JsonValue): Array[MediaGalleryItem] val ? =>
        """
        Decodes an array of media gallery items.
        """

        let array = value as json.JsonArray
        recover val
            let items = Array[MediaGalleryItem](array.size())
            for item in array.values() do items.push(MediaGalleryItem.from_json(item as json.JsonObject)?) end
            items
        end

    fun to_json(items: Array[MediaGalleryItem] val): json.JsonArray =>
        var array = json.JsonArray
        for item in items.values() do array = array.push(item.to_json()) end
        array

class val FileComponent is Component
    """
    https://docs.discord.com/developers/components/reference#file

    A File is a top-level content component that allows you to display an uploaded file as an attachment to the message and reference it in the component. Each file component can only display 1 attached file, but you can upload multiple files and add them to different file components within your payload.

    Files are currently only available in messages.

    The File component only supports using the `attachment://` protocol in the unfurled media item.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let file: UnfurledMediaItem
        """
        This unfurled media item is unique in that it **only** supports attachment references using the `attachment://<filename>` syntax
        """

    let spoiler: (Bool | None)
        """
        Whether the media should be a spoiler (or blurred out). Defaults to `false`
        """

    let name: (String | None)
        """
        The name of the file

        This field is ignored and provided by the API as part of the response.
        """

    let size: (USize | None)
        """
        The size of the file in bytes

        This field is ignored and provided by the API as part of the response.
        """

    new val create(
        id': (U32 | None) = None,
        file': UnfurledMediaItem,
        spoiler': (Bool | None) = None,
        name': (String | None) = None,
        size': (USize | None) = None
    ) =>
        id = id'
        file = file'
        spoiler = spoiler'
        name = name'
        size = size'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var file': (UnfurledMediaItem | None) = None
        var spoiler': (Bool | None) = None
        var name': (String | None) = None
        var size': (USize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "file" => file' = UnfurledMediaItem.from_json(value as json.JsonObject)?
            | "spoiler" => spoiler' = value as Bool
            | "name" => name' = value as String
            | "size" => size' = (value as I64).usize()
            end
        end

        id = id'
        file = file' as UnfurledMediaItem
        spoiler = spoiler'
        name = name'
        size = size'

    fun component_type(): ComponentType => FileComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("file", file.to_json())

        match spoiler
        | let spoiler': Bool => obj = obj.update("spoiler", spoiler')
        end

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match size
        | let size': USize => obj = obj.update("size", size'.i64())
        end

        obj

class val SeparatorComponent is Component
    """
    https://docs.discord.com/developers/components/reference#separator

    A Separator is a top-level layout component that adds vertical padding and visual division between other components.

    Separators are currently only available in messages.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let divider: (Bool | None)
        """
        Whether a visual divider should be displayed in the component. Defaults to `true`
        """

    let spacing: (SeparatorSpacingSize | None)
        """
        Size of separator padding. Defaults to `SmallSeparatorSpacingSize`
        """

    new val create(
        id': (U32 | None) = None,
        divider': (Bool | None) = None,
        spacing': (SeparatorSpacingSize | None) = None
    ) =>
        id = id'
        divider = divider'
        spacing = spacing'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var divider': (Bool | None) = None
        var spacing': (SeparatorSpacingSize | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "divider" => divider' = value as Bool
            | "spacing" => spacing' = SeparatorSpacingSizes.from((value as I64).u8())?
            end
        end

        id = id'
        divider = divider'
        spacing = spacing'

    fun component_type(): ComponentType => SeparatorComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)

        match divider
        | let divider': Bool => obj = obj.update("divider", divider')
        end

        match spacing
        | let spacing': SeparatorSpacingSize => obj = obj.update("spacing", spacing'.value().i64())
        end

        obj

trait val SeparatorSpacingSize is (collections.Hashable & Equatable[SeparatorSpacingSize])
    """
    https://docs.discord.com/developers/components/reference#separator-separator-structure
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: SeparatorSpacingSize): Bool => value() == that.value()
primitive SmallSeparatorSpacingSize is SeparatorSpacingSize
    """
    Small padding
    """

    fun value(): U8 => 1
primitive LargeSeparatorSpacingSize is SeparatorSpacingSize
    """
    Large padding
    """

    fun value(): U8 => 2
primitive SeparatorSpacingSizes
    fun from(value: U8): SeparatorSpacingSize ? =>
        match value
        | 1 => SmallSeparatorSpacingSize
        | 2 => LargeSeparatorSpacingSize
        else error
        end

class val ContainerComponent is Component
    """
    https://docs.discord.com/developers/components/reference#container

    A Container is a top-level layout component. Containers offer the ability to visually encapsulate a collection of components and have an optional customizable accent color bar.

    Containers are currently only available in messages.

    To use this component in messages you must send the message flag `1 << 15` (`IsComponentsV2MessageFlag`) which can be activated on a per-message basis.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let components: Array[ContainerChildComponent] val
        """
        Child components that are encapsulated within the Container
        """

    let accent_color: (I64 | None)
        """
        Color for the accent on the container as RGB from `0x000000` to `0xFFFFFF`
        """

    let spoiler: (Bool | None)
        """
        Whether the container should be a spoiler (or blurred out). Defaults to `false`
        """

    new val create(
        id': (U32 | None) = None,
        components': Array[ContainerChildComponent] val,
        accent_color': (I64 | None) = None,
        spoiler': (Bool | None) = None
    ) =>
        id = id'
        components = components'
        accent_color = accent_color'
        spoiler = spoiler'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var components': (Array[ContainerChildComponent] val | None) = None
        var accent_color': (I64 | None) = None
        var spoiler': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "components" => components' = _ContainerChildComponents(value)?
            | "accent_color" =>
                match value | let integer: I64 => accent_color' = integer end
            | "spoiler" => spoiler' = value as Bool
            end
        end

        id = id'
        components = components' as Array[ContainerChildComponent] val
        accent_color = accent_color'
        spoiler = spoiler'

    fun component_type(): ComponentType => ContainerComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("components", _ContainerChildComponents.to_json(components))
            .update("accent_color", accent_color)

        match spoiler
        | let spoiler': Bool => obj = obj.update("spoiler", spoiler')
        end

        obj

// https://docs.discord.com/developers/components/reference#container-container-child-components
type ContainerChildComponent is (ActionRowComponent | TextDisplayComponent | SectionComponent | MediaGalleryComponent | SeparatorComponent | FileComponent)

primitive _ContainerChildComponents
    fun apply(value: json.JsonValue): Array[ContainerChildComponent] val ? =>
        """
        Decodes an array of container child components.
        """

        let array = value as json.JsonArray
        recover val
            let components = Array[ContainerChildComponent](array.size())
            for component in array.values() do
                components.push(Components.from_json(component as json.JsonObject)? as ContainerChildComponent)
            end
            components
        end

    fun to_json(components: Array[ContainerChildComponent] val): json.JsonArray =>
        var array = json.JsonArray
        for component in components.values() do array = array.push(component.to_json()) end
        array

class val LabelComponent is Component
    """
    https://docs.discord.com/developers/components/reference#label

    A Label is a top-level layout component. Labels wrap modal components with text as a label and optional description.

    The `description` may display above or below the `component` depending on the platform.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let label: String
        """
        The label text; max 45 characters
        """

    let description: (String | None)
        """
        An optional description text for the label; max 100 characters
        """

    let component: LabelChildComponent
        """
        The component within the label
        """

    new val create(
        id': (U32 | None) = None,
        label': String,
        description': (String | None) = None,
        component': LabelChildComponent
    ) =>
        id = id'
        label = label'
        description = description'
        component = component'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var label': (String | None) = None
        var description': (String | None) = None
        var component': (LabelChildComponent | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "label" => label' = value as String
            | "description" => description' = value as String
            | "component" => component' = Components.from_json(value as json.JsonObject)? as LabelChildComponent
            end
        end

        id = id'
        label = label' as String
        description = description'
        component = component' as LabelChildComponent

    fun component_type(): ComponentType => LabelComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("label", label)
            .update("component", component.to_json())

        match description
        | let description': String => obj = obj.update("description", description')
        end

        obj

// https://docs.discord.com/developers/components/reference#label-label-child-components
type LabelChildComponent is (TextInputComponent | StringSelectComponent | UserSelectComponent | RoleSelectComponent | MentionableSelectComponent | ChannelSelectComponent | FileUploadComponent | RadioGroupComponent | CheckboxGroupComponent | CheckboxComponent)

class val FileUploadComponent is Component
    """
    https://docs.discord.com/developers/components/reference#file-upload

    File Upload is an interactive component that allows users to upload files in modals. File Uploads can be configured to have a minimum and maximum number of files between 0 and 10, along with `required` for if the upload is required to submit the modal. The max file size a user can upload is based on the user's upload limit in that channel.

    File Uploads are available on modals. They must be placed inside a Label.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        ID for the file upload; 1-100 characters
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be uploaded (defaults to 1); min 0, max 10

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be uploaded (defaults to 1); max 10
        """

    let required: (Bool | None)
        """
        Whether the file upload requires files to be uploaded before submitting the modal (defaults to `true`)
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        min_values = min_values'
        max_values = max_values'
        required = required'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        min_values = min_values'
        max_values = max_values'
        required = required'

    fun component_type(): ComponentType => FileUploadComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)

        match min_values
        | let min_values': USize => obj = obj.update("min_values", min_values'.i64())
        end

        match max_values
        | let max_values': USize => obj = obj.update("max_values", max_values'.i64())
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        obj

class val RadioGroupComponent is Component
    """
    https://docs.discord.com/developers/components/reference#radio-group

    A Radio Group is an interactive component for selecting exactly one option from a defined list. Radio Groups are available in modals and must be placed inside a Label.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        Developer-defined identifier for the input; 1-100 characters
        """

    let options: Array[RadioGroupOption] val
        """
        List of options to show; min 2, max 10
        """

    let required: (Bool | None)
        """
        Whether a selection is required to submit the modal (defaults to `true`)
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        options': Array[RadioGroupOption] val,
        required': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        options = options'
        required = required'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var options': (Array[RadioGroupOption] val | None) = None
        var required': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "options" => options' = _RadioGroupOptions(value)?
            | "required" => required' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        options = options' as Array[RadioGroupOption] val
        required = required'

    fun component_type(): ComponentType => RadioGroupComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)
            .update("options", _RadioGroupOptions.to_json(options))

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        obj

class val RadioGroupOption is Jsonable
    """
    https://docs.discord.com/developers/components/reference#radio-group-option-structure
    """

    let value: String
        """
        Dev-defined value of the option; max 100 characters
        """

    let label: String
        """
        User-facing label of the option; max 100 characters
        """

    let description: (String | None)
        """
        Optional description for the option; max 100 characters
        """

    let default: (Bool | None)
        """
        Shows the option as selected by default
        """

    new val create(
        value': String,
        label': String,
        description': (String | None) = None,
        default': (Bool | None) = None
    ) =>
        value = value'
        label = label'
        description = description'
        default = default'

    new val from_json(obj: json.JsonObject) ? =>
        var value': (String | None) = None
        var label': (String | None) = None
        var description': (String | None) = None
        var default': (Bool | None) = None

        for (key, entry) in obj.pairs() do
            match key
            | "value" => value' = entry as String
            | "label" => label' = entry as String
            | "description" => description' = entry as String
            | "default" => default' = entry as Bool
            end
        end

        value = value' as String
        label = label' as String
        description = description'
        default = default'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("value", value)
            .update("label", label)

        match description
        | let description': String => obj = obj.update("description", description')
        end

        match default
        | let default': Bool => obj = obj.update("default", default')
        end

        obj

primitive _RadioGroupOptions
    fun apply(value: json.JsonValue): Array[RadioGroupOption] val ? =>
        """
        Decodes an array of radio group options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[RadioGroupOption](array.size())
            for option in array.values() do options.push(RadioGroupOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[RadioGroupOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

class val CheckboxGroupComponent is Component
    """
    https://docs.discord.com/developers/components/reference#checkbox-group

    A Checkbox Group is an interactive component for selecting one or many options via checkboxes. Checkbox Groups are available in modals and must be placed inside a Label.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        Developer-defined identifier for the input; 1-100 characters
        """

    let options: Array[CheckboxGroupOption] val
        """
        List of options to show; min 1, max 10
        """

    let min_values: (USize | None)
        """
        Minimum number of items that must be chosen; min 0, max 10 (defaults to 1)

        Must be either omitted or at least `1` if `required` is omitted or `true`.
        """

    let max_values: (USize | None)
        """
        Maximum number of items that can be chosen; min 1, max 10 (defaults to the number of options)
        """

    let required: (Bool | None)
        """
        Whether selecting within the group is required (defaults to `true`)
        """

    new val create(
        id': (U32 | None) = None,
        custom_id': String,
        options': Array[CheckboxGroupOption] val,
        min_values': (USize | None) = None,
        max_values': (USize | None) = None,
        required': (Bool | None) = None
    ) =>
        id = id'
        custom_id = custom_id'
        options = options'
        min_values = min_values'
        max_values = max_values'
        required = required'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var options': (Array[CheckboxGroupOption] val | None) = None
        var min_values': (USize | None) = None
        var max_values': (USize | None) = None
        var required': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "options" => options' = _CheckboxGroupOptions(value)?
            | "min_values" => min_values' = (value as I64).usize()
            | "max_values" => max_values' = (value as I64).usize()
            | "required" => required' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        options = options' as Array[CheckboxGroupOption] val
        min_values = min_values'
        max_values = max_values'
        required = required'

    fun component_type(): ComponentType => CheckboxGroupComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)
            .update("options", _CheckboxGroupOptions.to_json(options))

        match min_values
        | let min_values': USize => obj = obj.update("min_values", min_values'.i64())
        end

        match max_values
        | let max_values': USize => obj = obj.update("max_values", max_values'.i64())
        end

        match required
        | let required': Bool => obj = obj.update("required", required')
        end

        obj

class val CheckboxGroupOption is Jsonable
    """
    https://docs.discord.com/developers/components/reference#checkbox-group-option-structure
    """

    let value: String
        """
        Dev-defined value of the option; max 100 characters
        """

    let label: String
        """
        User-facing label of the option; max 100 characters
        """

    let description: (String | None)
        """
        Optional description for the option; max 100 characters
        """

    let default: (Bool | None)
        """
        Shows the option as selected by default
        """

    new val create(
        value': String,
        label': String,
        description': (String | None) = None,
        default': (Bool | None) = None
    ) =>
        value = value'
        label = label'
        description = description'
        default = default'

    new val from_json(obj: json.JsonObject) ? =>
        var value': (String | None) = None
        var label': (String | None) = None
        var description': (String | None) = None
        var default': (Bool | None) = None

        for (key, entry) in obj.pairs() do
            match key
            | "value" => value' = entry as String
            | "label" => label' = entry as String
            | "description" => description' = entry as String
            | "default" => default' = entry as Bool
            end
        end

        value = value' as String
        label = label' as String
        description = description'
        default = default'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("value", value)
            .update("label", label)

        match description
        | let description': String => obj = obj.update("description", description')
        end

        match default
        | let default': Bool => obj = obj.update("default", default')
        end

        obj

primitive _CheckboxGroupOptions
    fun apply(value: json.JsonValue): Array[CheckboxGroupOption] val ? =>
        """
        Decodes an array of checkbox group options.
        """

        let array = value as json.JsonArray
        recover val
            let options = Array[CheckboxGroupOption](array.size())
            for option in array.values() do options.push(CheckboxGroupOption.from_json(option as json.JsonObject)?) end
            options
        end

    fun to_json(options: Array[CheckboxGroupOption] val): json.JsonArray =>
        var array = json.JsonArray
        for option in options.values() do array = array.push(option.to_json()) end
        array

class val CheckboxComponent is Component
    """
    https://docs.discord.com/developers/components/reference#checkbox

    A Checkbox is a single interactive component for simple yes/no style questions. Checkboxes are available in modals and must be placed inside a Label.

    While you can't set a checkbox as required, you can use a Checkbox Group with a single option and `required` to achieve similar functionality.
    """

    let id: (U32 | None)
        """
        Optional identifier for component
        """

    let custom_id: String
        """
        Developer-defined identifier for the input; 1-100 characters
        """

    let default: (Bool | None)
        """
        Whether the checkbox is selected by default
        """

    new val create(id': (U32 | None) = None, custom_id': String, default': (Bool | None) = None) =>
        id = id'
        custom_id = custom_id'
        default = default'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (U32 | None) = None
        var custom_id': (String | None) = None
        var default': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).u32()
            | "custom_id" => custom_id' = value as String
            | "default" => default' = value as Bool
            end
        end

        id = id'
        custom_id = custom_id' as String
        default = default'

    fun component_type(): ComponentType => CheckboxComponentType

    fun to_json(): json.JsonObject =>
        var obj = _ComponentJson(component_type(), id)
            .update("custom_id", custom_id)

        match default
        | let default': Bool => obj = obj.update("default", default')
        end

        obj

class val UnfurledMediaItem is Jsonable
    """
    https://docs.discord.com/developers/components/reference#unfurled-media-item

    An Unfurled Media Item is a piece of media, represented by a URL, that is used within a component. It can be constructed via either uploading media to Discord, or by referencing external media via **a direct link** to the asset.

    While the structure below is the full representation of an Unfurled Media Item, **only the `url` field is settable by developers** when making requests that utilize this structure. All other fields will be automatically populated by Discord.
    """

    let url: String
        """
        Supports arbitrary urls and `attachment://<filename>` references
        """

    let proxy_url: (String | None)
        """
        The proxied url of the media item

        This field is ignored and provided by the API as part of the response.
        """

    let height: (USize | None)
        """
        The height of the media item (if image or video)

        This field is ignored and provided by the API as part of the response.
        """

    let width: (USize | None)
        """
        The width of the media item (if image or video)

        This field is ignored and provided by the API as part of the response.
        """

    let placeholder: (String | None)
        """
        Thumbhash placeholder (if image or video)

        This field is ignored and provided by the API as part of the response.
        """

    let placeholder_version: (USize | None)
        """
        Version of the placeholder (if image or video)

        This field is ignored and provided by the API as part of the response.
        """

    let content_type: (String | None)
        """
        The media type of the content

        This field is ignored and provided by the API as part of the response.
        """

    let flags: (Array[UnfurledMediaItemFlag] val | None)
        """
        Unfurled media item flags combined as a bitfield

        This field is ignored and provided by the API as part of the response.
        """

    let attachment_id: (Snowflake | None)
        """
        The id of the uploaded attachment

        This field is ignored and provided by the API as part of the response, and is only present if the media item was uploaded as an attachment.
        """

    new val create(
        url': String,
        proxy_url': (String | None) = None,
        height': (USize | None) = None,
        width': (USize | None) = None,
        placeholder': (String | None) = None,
        placeholder_version': (USize | None) = None,
        content_type': (String | None) = None,
        flags': (Array[UnfurledMediaItemFlag] val | None) = None,
        attachment_id': (Snowflake | None) = None
    ) =>
        url = url'
        proxy_url = proxy_url'
        height = height'
        width = width'
        placeholder = placeholder'
        placeholder_version = placeholder_version'
        content_type = content_type'
        flags = flags'
        attachment_id = attachment_id'

    new val from_json(obj: json.JsonObject) ? =>
        var url': (String | None) = None
        var proxy_url': (String | None) = None
        var height': (USize | None) = None
        var width': (USize | None) = None
        var placeholder': (String | None) = None
        var placeholder_version': (USize | None) = None
        var content_type': (String | None) = None
        var flags': (Array[UnfurledMediaItemFlag] val | None) = None
        var attachment_id': (Snowflake | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "url" => url' = value as String
            | "proxy_url" => proxy_url' = value as String
            | "height" =>
                match value | let integer: I64 => height' = integer.usize() end
            | "width" =>
                match value | let integer: I64 => width' = integer.usize() end
            | "placeholder" => placeholder' = value as String
            | "placeholder_version" => placeholder_version' = (value as I64).usize()
            | "content_type" => content_type' = value as String
            | "flags" => flags' = _UnfurledMediaItemFlags((value as I64).u64())
            | "attachment_id" => attachment_id' = Snowflake.from_json(value)?
            end
        end

        url = url' as String
        proxy_url = proxy_url'
        height = height'
        width = width'
        placeholder = placeholder'
        placeholder_version = placeholder_version'
        content_type = content_type'
        flags = flags'
        attachment_id = attachment_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("url", url)

        match proxy_url
        | let proxy_url': String => obj = obj.update("proxy_url", proxy_url')
        end

        match height
        | let height': USize => obj = obj.update("height", height'.i64())
        end

        match width
        | let width': USize => obj = obj.update("width", width'.i64())
        end

        match placeholder
        | let placeholder': String => obj = obj.update("placeholder", placeholder')
        end

        match placeholder_version
        | let placeholder_version': USize => obj = obj.update("placeholder_version", placeholder_version'.i64())
        end

        match content_type
        | let content_type': String => obj = obj.update("content_type", content_type')
        end

        match flags
        | let flags': Array[UnfurledMediaItemFlag] val => obj = obj.update("flags", _UnfurledMediaItemFlags.to_json(flags'))
        end

        match attachment_id
        | let attachment_id': Snowflake => obj = obj.update("attachment_id", attachment_id'.to_json())
        end

        obj

trait val UnfurledMediaItemFlag is (collections.Hashable & Equatable[UnfurledMediaItemFlag])
    """
    https://docs.discord.com/developers/components/reference#unfurled-media-item-unfurled-media-item-flags
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: UnfurledMediaItemFlag): Bool => value() == that.value()
primitive IsAnimatedUnfurledMediaItemFlag is UnfurledMediaItemFlag
    """
    This image is animated
    """

    fun value(): U8 => 0
primitive UnfurledMediaItemFlags
    fun from(value: U8): UnfurledMediaItemFlag ? =>
        match value
        | 0 => IsAnimatedUnfurledMediaItemFlag
        else error
        end

primitive _UnfurledMediaItemFlags
    fun apply(bits: U64): Array[UnfurledMediaItemFlag] val =>
        recover val
            let flags = Array[UnfurledMediaItemFlag]
            var shift: U8 = 0
            while shift < 64 do
                if (bits and (U64(1) << shift.u64())) != 0 then
                    try flags.push(UnfurledMediaItemFlags.from(shift)?) end
                end
                shift = shift + 1
            end
            flags
        end

    fun to_json(flags: Array[UnfurledMediaItemFlag] val): I64 =>
        var bits: U64 = 0
        for flag in flags.values() do bits = bits or (U64(1) << flag.value().u64()) end
        bits.i64()
