use json = "json"

class val SoundboardSound
    """
    https://docs.discord.com/developers/resources/soundboard#soundboard-sound-object-soundboard-sound-structure

    Users can play soundboard sounds in voice channels, triggering a Voice Channel Effect Send Gateway event for users connected to the voice channel.

    There is a set of default sounds available to all users. Soundboard sounds can also be created in a guild; users will be able to use the sounds in the guild, and Nitro subscribers can use them in all guilds.
    """

    let name: String
        """
        the name of this sound
        """

    let sound_id: Snowflake
        """
        the id of this sound
        """

    let volume: F64
        """
        the volume of this sound, from 0 to 1
        """

    let emoji_id: (Snowflake | None)
        """
        the id of this sound's custom emoji
        """

    let emoji_name: (String | None)
        """
        the unicode character of this sound's standard emoji
        """

    let guild_id: (Snowflake | None)
        """
        the id of the guild this sound is in
        """

    let available: Bool
        """
        whether this sound can be used, may be false due to loss of Server Boosts
        """

    let user: (User | None)
        """
        the user who created this sound
        """

    new val from_json(obj: json.JsonObject) ? =>
        var name': (String | None) = None
        var sound_id': (Snowflake | None) = None
        var volume': (F64 | None) = None
        var emoji_id': (Snowflake | None) = None
        var emoji_name': (String | None) = None
        var guild_id': (Snowflake | None) = None
        var available': (Bool | None) = None
        var user': (User | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "name" => name' = value as String
            | "sound_id" => sound_id' = Snowflake.from_json(value)?
            | "volume" =>
                // A whole-numbered volume such as `1` arrives as an integer rather than as a float.
                match value
                | let float: F64 => volume' = float
                | let integer: I64 => volume' = integer.f64()
                end
            | "emoji_id" =>
                match value | let string: String => emoji_id' = Snowflake.from_json(string)? end
            | "emoji_name" =>
                match value | let string: String => emoji_name' = string end
            | "guild_id" => guild_id' = Snowflake.from_json(value)?
            | "available" => available' = value as Bool
            | "user" => user' = User.from_json(value as json.JsonObject)?
            end
        end

        name = name' as String
        sound_id = sound_id' as Snowflake
        volume = volume' as F64
        emoji_id = emoji_id'
        emoji_name = emoji_name'
        guild_id = guild_id'
        available = available' as Bool
        user = user'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("sound_id", sound_id.to_json())
            .update("volume", volume)
            .update("emoji_id", match emoji_id | let emoji_id': Snowflake => emoji_id'.to_json() end)
            .update("emoji_name", emoji_name)
            .update("available", available)

        match guild_id
        | let guild_id': Snowflake => obj = obj.update("guild_id", guild_id'.to_json())
        end

        match user
        | let user': User => obj = obj.update("user", user'.to_json())
        end

        obj

primitive _SoundboardSounds
    fun apply(value: json.JsonValue): Array[SoundboardSound] val ? =>
        """
        Decodes an array of soundboard sounds.
        """

        let array = value as json.JsonArray
        recover val
            let sounds = Array[SoundboardSound](array.size())
            for sound in array.values() do sounds.push(SoundboardSound.from_json(sound as json.JsonObject)?) end
            sounds
        end

    fun to_json(sounds: Array[SoundboardSound] val): json.JsonArray =>
        var array = json.JsonArray
        for sound in sounds.values() do array = array.push(sound.to_json()) end
        array

type SoundData is String
    """
    https://docs.discord.com/developers/resources/soundboard#create-guild-soundboard-sound

    A soundboard sound uploaded to the API as a base64-encoded data URI, of the
    form `data:audio/{mpeg,ogg};base64,{data}`. Maximum of 512 KiB and 5.2
    seconds.
    """

class val SendSoundboardSoundParams
    """
    https://docs.discord.com/developers/resources/soundboard#send-soundboard-sound-json-params
    """

    let sound_id: Snowflake
        """
        the id of the soundboard sound to play
        """

    let source_guild_id: (Snowflake | None)
        """
        the id of the guild the soundboard sound is from, required to play sounds from different servers
        """

    new val create(sound_id': Snowflake, source_guild_id': (Snowflake | None) = None) =>
        sound_id = sound_id'
        source_guild_id = source_guild_id'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject.update("sound_id", sound_id.to_json())

        match source_guild_id
        | let source_guild_id': Snowflake => obj = obj.update("source_guild_id", source_guild_id'.to_json())
        end

        obj

class val CreateGuildSoundboardSoundParams
    """
    https://docs.discord.com/developers/resources/soundboard#create-guild-soundboard-sound-json-params

    Soundboard sounds have a max file size of 512kb and a max duration of 5.2 seconds.
    """

    let name: String
        """
        name of the soundboard sound (2-32 characters)
        """

    let sound: SoundData
        """
        the mp3 or ogg sound data, base64 encoded, similar to image data
        """

    let volume: Nullable[F64]
        """
        the volume of the soundboard sound, from 0 to 1, defaults to 1
        """

    let emoji_id: Nullable[Snowflake]
        """
        the id of the custom emoji for the soundboard sound
        """

    let emoji_name: Nullable[String]
        """
        the unicode character of a standard emoji for the soundboard sound
        """

    new val create(
        name': String,
        sound': SoundData,
        volume': Nullable[F64] = None,
        emoji_id': Nullable[Snowflake] = None,
        emoji_name': Nullable[String] = None
    ) =>
        name = name'
        sound = sound'
        volume = volume'
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("name", name)
            .update("sound", sound)

        match volume
        | let volume': F64 => obj = obj.update("volume", volume')
        | Null => obj = obj.update("volume", None)
        end

        match emoji_id
        | let emoji_id': Snowflake => obj = obj.update("emoji_id", emoji_id'.to_json())
        | Null => obj = obj.update("emoji_id", None)
        end

        match emoji_name
        | let emoji_name': String => obj = obj.update("emoji_name", emoji_name')
        | Null => obj = obj.update("emoji_name", None)
        end

        obj

class val UpdateGuildSoundboardSoundParams
    """
    https://docs.discord.com/developers/resources/soundboard#modify-guild-soundboard-sound-json-params

    All parameters to this endpoint are optional.
    """

    let name: Nullable[String]
        """
        name of the soundboard sound (2-32 characters)
        """

    let volume: Nullable[F64]
        """
        the volume of the soundboard sound, from 0 to 1
        """

    let emoji_id: Nullable[Snowflake]
        """
        the id of the custom emoji for the soundboard sound
        """

    let emoji_name: Nullable[String]
        """
        the unicode character of a standard emoji for the soundboard sound
        """

    new val create(
        name': Nullable[String] = None,
        volume': Nullable[F64] = None,
        emoji_id': Nullable[Snowflake] = None,
        emoji_name': Nullable[String] = None
    ) =>
        name = name'
        volume = volume'
        emoji_id = emoji_id'
        emoji_name = emoji_name'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match name
        | let name': String => obj = obj.update("name", name')
        | Null => obj = obj.update("name", None)
        end

        match volume
        | let volume': F64 => obj = obj.update("volume", volume')
        | Null => obj = obj.update("volume", None)
        end

        match emoji_id
        | let emoji_id': Snowflake => obj = obj.update("emoji_id", emoji_id'.to_json())
        | Null => obj = obj.update("emoji_id", None)
        end

        match emoji_name
        | let emoji_name': String => obj = obj.update("emoji_name", emoji_name')
        | Null => obj = obj.update("emoji_name", None)
        end

        obj
