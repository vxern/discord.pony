use collections = "collections"
use json = "json"

class val Webhook
    """
    https://docs.discord.com/developers/resources/webhook#webhook-object-webhook-structure

    Webhooks are a low-effort way to post messages to channels in Discord. They do not require a bot user or authentication to use.
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
        the user this webhook was created by (not returned when getting a webhook with its token)
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

    // TODO(vxern): Add `source_guild` (partial guild object; the guild of the channel that this webhook is following) once a partial variant of `Guild` is implemented. Discord sends only `id`, `name` and `icon`, so `Guild` — which requires far more — cannot decode it.

    // TODO(vxern): Add `source_channel` (partial channel object; the channel that this webhook is following) once a partial variant of `Channel` is implemented. Discord sends only `id` and `name`, so `Channel` — which requires `type` — cannot decode it.

    let url: (String | None)
        """
        the url used for executing the webhook (returned by the webhooks OAuth2 flow)
        """

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
        var url': (String | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = Snowflake.from_json(value)?
            | "type" => type'' = WebhookTypes.from((value as I64).u8())?
            | "guild_id" =>
                match value | let string: String => guild_id' = Snowflake.from_json(string)? end
            | "channel_id" =>
                match value | let string: String => channel_id' = Snowflake.from_json(string)? end
            | "user" => user' = User.from_json(value as json.JsonObject)?
            | "name" =>
                match value | let string: String => name' = string end
            | "avatar" =>
                match value | let string: String => avatar' = string end
            | "token" => token' = value as String
            | "application_id" =>
                match value | let string: String => application_id' = Snowflake.from_json(string)? end
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
        url = url'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("id", id.to_json())
            .update("type", type'.value().i64())
            .update("channel_id", match channel_id | let channel_id': Snowflake => channel_id'.to_json() end)
            .update("name", name)
            .update("avatar", avatar)
            .update("application_id", match application_id | let application_id': Snowflake => application_id'.to_json() end)

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        match token
        | let token': String => obj = obj.update("token", token')
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
            for webhook in array.values() do webhooks.push(Webhook.from_json(webhook as json.JsonObject)?) end
            webhooks
        end

    fun to_json(webhooks: Array[Webhook] val): json.JsonArray =>
        var array = json.JsonArray
        for webhook in webhooks.values() do array = array.push(webhook.to_json()) end
        array

trait val WebhookType is (collections.Hashable & Equatable[WebhookType])
    """
    https://docs.discord.com/developers/resources/webhook#webhook-object-webhook-types
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: WebhookType): Bool => value() == that.value()
primitive IncomingWebhookType is WebhookType
    """
    Incoming Webhooks can post messages to channels with a generated token
    """

    fun value(): U8 => 1
primitive ChannelFollowerWebhookType is WebhookType
    """
    Channel Follower Webhooks are internal webhooks used with Channel Following to post new messages into channels
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
