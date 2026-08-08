use json = "json"

class val AuthorizationInformation is Jsonable
    """
    https://docs.discord.com/developers/topics/oauth2#get-current-authorization-information-response-structure
    """

    let application: PartialApplication
        """
        the current application
        """

    let scopes: Array[String] val
        """
        the scopes the user has authorized the application for
        """

    let expires: ISO8601
        """
        when the access token expires
        """

    let user: (User | None)
        """
        the user who has authorized, if the user has authorized with the
        `identify` scope
        """

    new val create(
        application': PartialApplication,
        scopes': Array[String] val,
        expires': ISO8601,
        user': (User | None) = None
    ) =>
        application = application'
        scopes = scopes'
        expires = expires'
        user = user'

    new val from_json(obj: json.JsonObject) ? =>
        var application': (PartialApplication | None) = None
        var scopes': (Array[String] val | None) = None
        var expires': (ISO8601 | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "application" =>
                application' =
                    PartialApplication.from_json(value as json.JsonObject)?
            | "scopes" => scopes' = _Strings(value)?
            | "expires" => expires' = value as String
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        application = application' as PartialApplication
        scopes = scopes' as Array[String] val
        expires = expires' as ISO8601
        user = user'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("application", application.to_json())
            .update("scopes", _Strings.to_json(scopes))
            .update("expires", expires)

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        obj
