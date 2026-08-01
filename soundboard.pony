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
