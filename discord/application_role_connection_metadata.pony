use collections = "collections"
use json = "json"

class val ApplicationRoleConnectionMetadata
    """
    https://docs.discord.com/developers/resources/application-role-connection-metadata#application-role-connection-metadata-object-application-role-connection-metadata-structure

    A representation of role connection metadata for an application.

    When a guild has added a bot and that bot has configured its role_connections_verification_url (in the developer portal), the application will render as a potential verification method in the guild’s role verification configuration.

    If an application has configured role connection metadata, its metadata will appear in the role verification configuration when the application has been added as a verification method to the role.

    When a user connects their account using the bot’s role_connections_verification_url, the bot will update a user’s role connection with metadata using the OAuth2 role_connections.write scope.
    """

    let type': ApplicationRoleConnectionMetadataType
        """
        type of metadata value
        """

    let key: String
        """
        dictionary key for the metadata field (must be a-z, 0-9, or _ characters; 1-50 characters)
        """

    let name: String
        """
        name of the metadata field (1-100 characters)
        """

    let name_localizations: (collections.Map[Locale, String] | None)
        """
        translations of the name
        """

    let description: String
        """
        description of the metadata field (1-200 characters)
        """

    let description_localizations: (collections.Map[Locale, String] | None)
        """
        translations of the description
        """

    new val from_json(obj: json.JsonObject) ? =>
        var type'': (ApplicationRoleConnectionMetadataType | None) = None
        var key': (String | None) = None
        var name': (String | None) = None
        var description': (String | None) = None
        var name_localizations': (collections.Map[Locale, String] | None) = None
        var description_localizations': (collections.Map[Locale, String] | None) = None

        for (k, v) in obj.pairs() do
            match k
            | "type" => type'' = ApplicationRoleConnectionMetadataTypes.from((v as I64).u8())?
            | "key" => key' = v as String
            | "name" => name' = v as String
            | "description" => description' = v as String
            | "name_localizations" => name_localizations' = _Localizations(v)?
            | "description_localizations" => description_localizations' = _Localizations(v)?
            end
        end

        type' = type'' as ApplicationRoleConnectionMetadataType
        key = key' as String
        name = name' as String
        description = description' as String
        name_localizations = name_localizations'
        description_localizations = description_localizations'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("type", type'.value().i64())
            .update("key", key)
            .update("name", name)
            .update("description", description)

        match name_localizations
        | let m: collections.Map[Locale, String] box =>
            obj = obj.update("name_localizations", _Localizations.to_json(m))
        end

        match description_localizations
        | let m: collections.Map[Locale, String] box =>
            obj = obj.update("description_localizations", _Localizations.to_json(m))
        end

        obj

trait val ApplicationRoleConnectionMetadataType is (collections.Hashable & Equatable[ApplicationRoleConnectionMetadataType])
    """
    https://docs.discord.com/developers/resources/application-role-connection-metadata#application-role-connection-metadata-object-application-role-connection-metadata-type
    """

    fun value(): U8

    fun hash(): USize => value().hash()

    fun eq(that: ApplicationRoleConnectionMetadataType): Bool => value() == that.value()
primitive IntegerLessThanOrEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is less than or equal to the guild’s configured value (integer)
    """

    fun value(): U8 => 1
primitive IntegerGreaterThanOrEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is greater than or equal to the guild’s configured value (integer)
    """

    fun value(): U8 => 2
primitive IntegerEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is equal to the guild’s configured value (integer)
    """

    fun value(): U8 => 3
primitive IntegerNotEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is not equal to the guild’s configured value (integer)
    """

    fun value(): U8 => 4
primitive DateTimeLessThanOrEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (ISO8601 string) is less than or equal to the guild’s configured value (integer; days before current date)
    """

    fun value(): U8 => 5
primitive DateTimeGreaterThanOrEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (ISO8601 string) is greater than or equal to the guild’s configured value (integer; days before current date)
    """

    fun value(): U8 => 6
primitive BooleanEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is equal to the guild’s configured value (integer; 1)
    """

    fun value(): U8 => 7
primitive BooleanNotEqualApplicationRoleConnectionMetadataType is ApplicationRoleConnectionMetadataType
    """
    the metadata value (integer) is not equal to the guild’s configured value (integer; 1)
    """

    fun value(): U8 => 8
primitive ApplicationRoleConnectionMetadataTypes
    fun from(v: U8): ApplicationRoleConnectionMetadataType ? =>
        match v
        | 1 => IntegerLessThanOrEqualApplicationRoleConnectionMetadataType
        | 2 => IntegerGreaterThanOrEqualApplicationRoleConnectionMetadataType
        | 3 => IntegerEqualApplicationRoleConnectionMetadataType
        | 4 => IntegerNotEqualApplicationRoleConnectionMetadataType
        | 5 => DateTimeLessThanOrEqualApplicationRoleConnectionMetadataType
        | 6 => DateTimeGreaterThanOrEqualApplicationRoleConnectionMetadataType
        | 7 => BooleanEqualApplicationRoleConnectionMetadataType
        | 8 => BooleanNotEqualApplicationRoleConnectionMetadataType
        else error
        end