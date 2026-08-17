use json = "json"

class val Webhook is Jsonable
    """
    https://docs.discord.com/developers/resources/webhook#webhook-object-webhook-structure

    Webhooks are a low-effort way to post messages to channels in Discord. They
    do not require a bot user or authentication to use.
    """

    let id: Snowflake
        """
        the id of the webhook
        """

    let type': WebhookType
        """
        the type of the webhook
        """

    let guild_id: (Snowflake | None)
        """
        the guild id this webhook is for, if any
        """

    let channel_id: (Snowflake | None)
        """
        the channel id this webhook is for, if any
        """

    let user: (User | None)
        """
        the user this webhook was created by (not returned when getting a
        webhook with its token)
        """

    let name: (String | None)
        """
        the default name of the webhook
        """

    let avatar: (String | None)
        """
        the default user avatar hash of the webhook
        """

    let token: (String | None)
        """
        the secure token of the webhook (returned for Incoming Webhooks)
        """

    let application_id: (Snowflake | None)
        """
        the bot/OAuth2 application that created this webhook
        """

    let source_guild: (PartialGuild | None)
        """
        the guild of the channel that this webhook is following

        This is a partial guild object: Discord sends only `id`, `name` and
        `icon`.
        """

    let source_channel: (PartialChannel | None)
        """
        the channel that this webhook is following

        This is a partial channel object: Discord sends only `id` and `name`.
        """

    let url: (String | None)
        """
        the url used for executing the webhook (returned by the webhooks OAuth2
        flow)
        """

    new val create(
        id': Snowflake,
        type'': WebhookType,
        guild_id': (Snowflake | None) = None,
        channel_id': (Snowflake | None) = None,
        user': (User | None) = None,
        name': (String | None) = None,
        avatar': (String | None) = None,
        token': (String | None) = None,
        application_id': (Snowflake | None) = None,
        source_guild': (PartialGuild | None) = None,
        source_channel': (PartialChannel | None) = None,
        url': (String | None) = None
    ) =>
        id = id'
        type' = type''
        guild_id = guild_id'
        channel_id = channel_id'
        user = user'
        name = name'
        avatar = avatar'
        token = token'
        application_id = application_id'
        source_guild = source_guild'
        source_channel = source_channel'
        url = url'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (Snowflake | None) = None
        var type'': (WebhookType | None) = None
        var guild_id': (Snowflake | None) = None
        var channel_id': (Snowflake | None) = None
        var user': (User | None) = None
        var name': (String | None) = None
        var avatar': (String | None) = None
        var token': (String | None) = None
        var application_id': (Snowflake | None) = None
        var source_guild': (PartialGuild | None) = None
        var source_channel': (PartialChannel | None) = None
        var url': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = WebhookTypes.from((value as I64).u8())?
            | "guild_id" =>
                match value
                | let string: String => guild_id' = Snowflake.from_json(string)?
                end
            | "channel_id" =>
                match value
                | let string: String =>
                    channel_id' = Snowflake.from_json(string)?
                end
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "name" =>
                match value | let string: String => name' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "token" => token' = value as String
            | "application_id" =>
                match value
                | let string: String =>
                    application_id' = Snowflake.from_json(string)?
                end
            | "source_guild" =>
                source_guild' =
                    PartialGuild.from_json(value as json.JsonObject)?
            | "source_channel" =>
                source_channel' =
                    PartialChannel.from_json(value as json.JsonObject)?
            | "url" => url' = value as String
            end
        end

        id = id' as Snowflake
        type' = type'' as WebhookType
        guild_id = guild_id'
        channel_id = channel_id'
        user = user'
        name = name'
        avatar = avatar'
        token = token'
        application_id = application_id'
        source_guild = source_guild'
        source_channel = source_channel'
        url = url'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update(
                "channel_id",
                match channel_id
                | let channel_id': Snowflake => channel_id'.to_json()
                end
            )
            .update("name", name)
            .update("avatar", avatar)
            .update(
                "application_id",
                match application_id
                | let application_id': Snowflake => application_id'.to_json()
                end
            )

        match guild_id
        | let guild_id': Snowflake =>
            obj = obj.update("guild_id", guild_id'.to_json())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match token
        | let token': String => obj = obj.update("token", token')
        end

        match source_guild
        | let source_guild': PartialGuild =>
            obj = obj.update("source_guild", source_guild'.to_json())
        end

        match source_channel
        | let source_channel': PartialChannel =>
            obj = obj.update("source_channel", source_channel'.to_json())
        end

        match url
        | let url': String => obj = obj.update("url", url')
        end

        obj

primitive _Webhooks
    fun apply(value: json.JsonValue): Array[Webhook] val ? =>
        """
        Decodes an array of webhooks.
        """

        let array = value as json.JsonArray
        recover val
            let webhooks = Array[Webhook](array.size())
            for webhook in array.values() do
                webhooks.push(Webhook.from_json(webhook as json.JsonObject)?)
            end
            webhooks
        end

    fun to_json(webhooks: Array[Webhook] val): json.JsonArray =>
        var array = json.JsonArray
        for webhook in webhooks.values() do
            array = array.push(webhook.to_json())
        end
        array

trait val WebhookType is _Enum[WebhookType, U8]
    """
    https://docs.discord.com/developers/resources/webhook#webhook-object-webhook-types
    """
primitive IncomingWebhookType is WebhookType
    """
    Incoming Webhooks can post messages to channels with a generated token
    """

    fun value(): U8 => 1
primitive ChannelFollowerWebhookType is WebhookType
    """
    Channel Follower Webhooks are internal webhooks used with Channel Following
    to post new messages into channels
    """

    fun value(): U8 => 2
primitive ApplicationWebhookType is WebhookType
    """
    Application webhooks are webhooks used with Interactions
    """

    fun value(): U8 => 3
primitive WebhookTypes
    fun from(value: U8): WebhookType ? =>
        match value
        | 1 => IncomingWebhookType
        | 2 => ChannelFollowerWebhookType
        | 3 => ApplicationWebhookType
        else error
        end

class val CreateWebhookParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#create-webhook-json-params

    Webhook names follow the naming restrictions that can be found in the
    Usernames and Nicknames documentation, with the following additional
    stipulations:

    - Webhook names cannot be: `clyde`, `discord`
    """

    let name: String
        """
        name of the webhook (1-80 characters)
        """

    let avatar: (ImageData | None)
        """
        image for the default webhook avatar
        """

    new val create(name': String, avatar': (ImageData | None) = None) =>
        name = name'
        avatar = avatar'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("name", name)

        match avatar
        | let avatar': ImageData => obj = obj.update("avatar", avatar')
        end

        obj

class val UpdateWebhookParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#modify-webhook-json-params

    All parameters to this endpoint are optional.
    """

    let name: (String | None)
        """
        the default name of the webhook
        """

    let avatar: Nullable[ImageData]
        """
        image for the default webhook avatar
        """

    let channel_id: (Snowflake | None)
        """
        the new channel id this webhook should be moved to
        """

    new val create(
        name': (String | None) = None,
        avatar': Nullable[ImageData] = None,
        channel_id': (Snowflake | None) = None
    ) =>
        name = name'
        avatar = avatar'
        channel_id = channel_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match avatar
        | let avatar': ImageData => obj = obj.update("avatar", avatar')
        | Null => obj = obj.update("avatar", None)
        end

        match channel_id
        | let channel_id': Snowflake =>
            obj = obj.update("channel_id", channel_id'.to_json())
        end

        obj

class val UpdateWebhookWithTokenParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#modify-webhook-with-token

    Same as Modify Webhook, except this call does not require authentication,
    does not accept a `channel_id` parameter in the body, and does not return a
    user in the webhook object.
    """

    let name: (String | None)
        """
        the default name of the webhook
        """

    let avatar: Nullable[ImageData]
        """
        image for the default webhook avatar
        """

    new val create(
        name': (String | None) = None,
        avatar': Nullable[ImageData] = None
    ) =>
        name = name'
        avatar = avatar'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        end

        match avatar
        | let avatar': ImageData => obj = obj.update("avatar", avatar')
        | Null => obj = obj.update("avatar", None)
        end

        obj

class val ExecuteWebhookParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#execute-webhook

    This endpoint takes both query string parameters and a JSON body.

    Note that when sending a message, you must provide a value for at least one
    of `content`, `embeds`, `components`, `file` or `poll`.
    """

    let content: (String | None)
        """
        the message contents (up to 2000 characters)
        """

    let username: (String | None)
        """
        override the default username of the webhook
        """

    let avatar_url: (String | None)
        """
        override the default avatar of the webhook
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

        Requires an application-owned webhook.
        """

    let attachments: (Array[MessageAttachmentParams] val | None)
        """
        attachment objects with `filename` and `description`
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS`,
        `SUPPRESS_NOTIFICATIONS` and `IS_COMPONENTS_V2` can be set)
        """

    let thread_name: (String | None)
        """
        name of thread to create (requires the webhook channel to be a forum or
        media channel)
        """

    let applied_tags: (Array[Snowflake] val | None)
        """
        array of tag ids to apply to the thread (requires the webhook channel to
        be a forum or media channel)
        """

    let poll: (PollParams | None)
        """
        A poll!
        """

    let thread_id: (Snowflake | None)
        """
        Send a message to the specified thread within a webhook's channel. The
        thread will automatically be unarchived.
        """

    let with_components: (Bool | None)
        """
        whether to respect the `components` field of the request (defaults to
        `false`; when `false`, only components without custom_id are allowed)
        """

    new val create(
        content': (String | None) = None,
        username': (String | None) = None,
        avatar_url': (String | None) = None,
        tts': (Bool | None) = None,
        embeds': (Array[MessageEmbed] val | None) = None,
        allowed_mentions': (AllowedMentions | None) = AllowedMentions.none(),
        components': (Array[Component] val | None) = None,
        attachments': (Array[MessageAttachmentParams] val | None) = None,
        flags': (Array[MessageFlag] val | None) = None,
        thread_name': (String | None) = None,
        applied_tags': (Array[Snowflake] val | None) = None,
        poll': (PollParams | None) = None,
        thread_id': (Snowflake | None) = None,
        with_components': (Bool | None) = None
    ) =>
        content = content'
        username = username'
        avatar_url = avatar_url'
        tts = tts'
        embeds = embeds'
        allowed_mentions = allowed_mentions'
        components = components'
        attachments = attachments'
        flags = flags'
        thread_name = thread_name'
        applied_tags = applied_tags'
        poll = poll'
        thread_id = thread_id'
        with_components = with_components'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        match with_components
        | let with_components': Bool =>
            query.push(("with_components", with_components'.string()))
        end

        consume query

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        end

        match username
        | let username': String => obj = obj.update("username", username')
        end

        match avatar_url
        | let avatar_url': String => obj = obj.update("avatar_url", avatar_url')
        end

        match tts
        | let tts': Bool => obj = obj.update("tts", tts')
        end

        match embeds
        | let embeds': Array[MessageEmbed] val =>
            obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions =>
            obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        end

        match components
        | let components': Array[Component] val =>
            obj = obj.update("components", _Components.to_json(components'))
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val =>
            obj =
                obj.update(
                    "attachments",
                    _MessageAttachmentParams.to_json(attachments')
                )
        end

        match flags
        | let flags': Array[MessageFlag] val =>
            obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        match thread_name
        | let thread_name': String =>
            obj = obj.update("thread_name", thread_name')
        end

        match applied_tags
        | let applied_tags': Array[Snowflake] val =>
            obj = obj.update("applied_tags", _Snowflakes.to_json(applied_tags'))
        end

        match poll
        | let poll': PollParams => obj = obj.update("poll", poll'.to_json())
        end

        obj

class val ExecuteSlackCompatibleWebhookParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#execute-slackcompatible-webhook

    Refer to Slack's documentation for more information. Discord does not
    support Slack's `channel`, `icon_emoji`, `mrkdwn`, or `mrkdwn_in`
    properties.

    The Slack-shaped payload is passed through verbatim as `payload`.
    """

    let payload: json.JsonObject
        """
        the Slack-compatible message payload
        """

    let thread_id: (Snowflake | None)
        """
        id of the thread to send the message in
        """

    new val create(
        payload': json.JsonObject,
        thread_id': (Snowflake | None) = None
    ) =>
        payload = payload'
        thread_id = thread_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        consume query

    fun to_json(): json.JsonObject => payload

class val ExecuteGithubCompatibleWebhookParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#execute-githubcompatible-webhook

    Add a new webhook to your GitHub repo (in the repo's settings), and use this
    endpoint as the "Payload URL." You can choose what events your Discord
    channel receives by choosing the "Let me select individual events" option
    and selecting individual events for the new webhook you're configuring.

    The GitHub event payload is passed through verbatim as `payload`.
    """

    let payload: json.JsonObject
        """
        the GitHub event payload
        """

    let thread_id: (Snowflake | None)
        """
        id of the thread to send the message in
        """

    new val create(
        payload': json.JsonObject,
        thread_id': (Snowflake | None) = None
    ) =>
        payload = payload'
        thread_id = thread_id'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match thread_id
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        consume query

    fun to_json(): json.JsonObject => payload

class val GetWebhookMessageParams
    """
    https://docs.discord.com/developers/resources/webhook#get-webhook-message-query-string-params
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
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        consume query

class val UpdateWebhookMessageParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/webhook#edit-webhook-message

    This endpoint takes both query string parameters and a JSON body. All JSON
    parameters are optional and nullable.
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

        Requires an application-owned webhook.
        """

    let attachments: Nullable[Array[MessageAttachmentParams] val]
        """
        attached files to keep and possible descriptions for new files
        """

    let flags: (Array[MessageFlag] val | None)
        """
        message flags combined as a bitfield (only `SUPPRESS_EMBEDS` and
        `IS_COMPONENTS_V2` can be set)
        """

    let thread_id: (Snowflake | None)
        """
        id of the thread the message is in
        """

    let with_components: (Bool | None)
        """
        whether to respect the `components` field of the request (defaults to
        `false`; when `false`, only components without custom_id are allowed)
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
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        match with_components
        | let with_components': Bool =>
            query.push(("with_components", with_components'.string()))
        end

        consume query

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match content
        | let content': String => obj = obj.update("content", content')
        | Null => obj = obj.update("content", None)
        end

        match embeds
        | let embeds': Array[MessageEmbed] val =>
            obj = obj.update("embeds", _MessageEmbeds.to_json(embeds'))
        | Null => obj = obj.update("embeds", None)
        end

        match allowed_mentions
        | let allowed_mentions': AllowedMentions =>
            obj = obj.update("allowed_mentions", allowed_mentions'.to_json())
        | Null => obj = obj.update("allowed_mentions", None)
        end

        match components
        | let components': Array[Component] val =>
            obj = obj.update("components", _Components.to_json(components'))
        | Null => obj = obj.update("components", None)
        end

        match attachments
        | let attachments': Array[MessageAttachmentParams] val =>
            obj =
                obj.update(
                    "attachments",
                    _MessageAttachmentParams.to_json(attachments')
                )
        | Null => obj = obj.update("attachments", None)
        end

        match flags
        | let flags': Array[MessageFlag] val =>
            obj = obj.update("flags", _MessageFlags.to_json(flags'))
        end

        obj

class val DeleteWebhookMessageParams
    """
    https://docs.discord.com/developers/resources/webhook#delete-webhook-message-query-string-params
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
        | let thread_id': Snowflake =>
            query.push(("thread_id", thread_id'.string()))
        end

        consume query
