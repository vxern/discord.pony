class ApplicationRoleConnectionMetadata
    """
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

    let name_localizations: (Map[Locale, String] | None)
        """
        translations of the name
        """

    let description: String
        """
        description of the metadata field (1-200 characters)
        """

    let description_localizations: (Map[Locale, String] | None)
        """
        translations of the description
        """

trait ApplicationRoleConnectionMetadataType
    fun value(): U8
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
