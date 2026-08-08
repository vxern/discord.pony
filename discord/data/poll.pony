use json = "json"

class val Poll is Jsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-object-poll-object-structure

    A poll is a message feature that allows users to vote on a set of answers.

    The poll object has a lot of levels and nested structures. It was also
    designed to support future extensibility, so some fields may appear to be
    more complex than necessary.
    """

    let question: PollMedia
        """
        The question of the poll. Only `text` is supported.
        """

    let answers: Array[PollAnswer] val
        """
        Each of the answers available in the poll.
        """

    let expiry: (ISO8601 | None)
        """
        The time when the poll ends.

        `expiry` is marked as nullable to support non-expiring polls in the
        future, but all polls have an expiry currently.
        """

    let allow_multiselect: Bool
        """
        Whether a user can select multiple answers
        """

    let layout_type: PollLayoutType
        """
        The layout type of the poll
        """

    let results: (PollResults | None)
        """
        The results of the poll
        """

    new val create(
        question': PollMedia,
        answers': Array[PollAnswer] val,
        expiry': (ISO8601 | None) = None,
        allow_multiselect': Bool,
        layout_type': PollLayoutType,
        results': (PollResults | None) = None
    ) =>
        question = question'
        answers = answers'
        expiry = expiry'
        allow_multiselect = allow_multiselect'
        layout_type = layout_type'
        results = results'

    new val from_json(obj: json.JsonObject) ? =>
        var question': (PollMedia | None) = None
        var answers': (Array[PollAnswer] val | None) = None
        var expiry': (ISO8601 | None) = None
        var allow_multiselect': (Bool | None) = None
        var layout_type': (PollLayoutType | None) = None
        var results': (PollResults | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "question" =>
                question' = PollMedia.from_json(value as json.JsonObject)?
            | "answers" => answers' = _PollAnswers(value)?
            | "expiry" =>
                match value | let string: String => expiry' = string end
            | "allow_multiselect" => allow_multiselect' = value as Bool
            | "layout_type" =>
                layout_type' = PollLayoutTypes.from((value as I64).u8())?
            | "results" =>
                results' = PollResults.from_json(value as json.JsonObject)?
            end
        end

        question = question' as PollMedia
        answers = answers' as Array[PollAnswer] val
        expiry = expiry'
        allow_multiselect = allow_multiselect' as Bool
        layout_type = layout_type' as PollLayoutType
        results = results'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("question", question.to_json())
            .update("answers", _PollAnswers.to_json(answers))
            .update("expiry", expiry)
            .update("allow_multiselect", allow_multiselect)
            .update("layout_type", layout_type.value().i64())

        match results
        | let results': PollResults =>
            obj = obj.update("results", results'.to_json())
        end

        obj

trait val PollLayoutType is _Enum[PollLayoutType, U8]
    """
    https://docs.discord.com/developers/resources/poll#layout-type
    """
primitive DefaultPollLayoutType is PollLayoutType
    """
    The, uhm, default layout type.
    """

    fun value(): U8 => 1
primitive PollLayoutTypes
    fun from(value: U8): PollLayoutType ? =>
        match value
        | 1 => DefaultPollLayoutType
        else error
        end

class val PollMedia is Jsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-media-object-poll-media-object-structure

    The poll media object is a common object that backs both the question and
    answers. The intention is that it allows us to extensibly add new ways to
    display things in the future. For now, `question` only supports `text`,
    while answers can have an optional `emoji`.
    """

    let text: (String | None)
        """
        The text of the field

        `text` should always be non-null for both questions and answers, but
        this is subject to changes.
        """

    let emoji: (Emoji | None)
        """
        The emoji of the field

        When creating a poll answer with an emoji, one only needs to send either
        the `id` (custom emoji) or `name` (default emoji) as the only field.
        """

    new val create(
        text': (String | None) = None,
        emoji': (Emoji | None) = None
    ) =>
        text = text'
        emoji = emoji'

    new val from_json(obj: json.JsonObject) ? =>
        var text': (String | None) = None
        var emoji': (Emoji | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "text" =>
                match value | let string: String => text' = string end
            | "emoji" =>
                match value
                | let obj': json.JsonObject => emoji' = Emoji.from_json(obj')?
                end
            end
        end

        text = text'
        emoji = emoji'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject

        match text
        | let text': String => obj = obj.update("text", text')
        end

        match emoji
        | let emoji': Emoji => obj = obj.update("emoji", emoji'.to_json())
        end

        obj

class val PollAnswer is Jsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-answer-object-poll-answer-object-structure

    The `answer_id` is a number that labels each answer. As an implementation
    detail, it currently starts at 1 for the first answer and goes up
    sequentially. We recommend against depending on this sequence.
    """

    let answer_id: USize
        """
        The ID of the answer

        Only sent as part of responses from Discord's API/Gateway.
        """

    let poll_media: PollMedia
        """
        The data of the answer
        """

    new val create(answer_id': USize, poll_media': PollMedia) =>
        answer_id = answer_id'
        poll_media = poll_media'

    new val from_json(obj: json.JsonObject) ? =>
        var answer_id': (USize | None) = None
        var poll_media': (PollMedia | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "answer_id" => answer_id' = (value as I64).usize()
            | "poll_media" =>
                poll_media' = PollMedia.from_json(value as json.JsonObject)?
            end
        end

        answer_id = answer_id' as USize
        poll_media = poll_media' as PollMedia

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("answer_id", answer_id.i64())
            .update("poll_media", poll_media.to_json())

primitive _PollAnswers
    fun apply(value: json.JsonValue): Array[PollAnswer] val ? =>
        """
        Decodes an array of poll answers.
        """

        let array = value as json.JsonArray
        recover val
            let answers = Array[PollAnswer](array.size())
            for answer in array.values() do
                answers.push(PollAnswer.from_json(answer as json.JsonObject)?)
            end
            answers
        end

    fun to_json(answers: Array[PollAnswer] val): json.JsonArray =>
        var array = json.JsonArray
        for answer in answers.values() do
            array = array.push(answer.to_json())
        end
        array

class val PollResults is Jsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-results-object-poll-results-object-structure

    In a nutshell, this contains the number of votes for each answer.

    Due to the intricacies of counting at scale, while a poll is in progress the
    results may not be perfectly accurate. They usually are accurate, and
    shouldn't deviate significantly -- it's just difficult to make guarantees.

    To compensate for this, after a poll is finished there is a background job
    which performs a final, accurate tally of votes. This tally has concluded
    once `is_finalized` is true.

    Answers which have no votes are not present in the `answer_counts` array.
    """

    let is_finalized: Bool
        """
        Whether the votes have been precisely counted
        """

    let answer_counts: Array[PollAnswerCount] val
        """
        The counts for each answer
        """

    new val create(
        is_finalized': Bool,
        answer_counts': Array[PollAnswerCount] val
    ) =>
        is_finalized = is_finalized'
        answer_counts = answer_counts'

    new val from_json(obj: json.JsonObject) ? =>
        var is_finalized': (Bool | None) = None
        var answer_counts': (Array[PollAnswerCount] val | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "is_finalized" => is_finalized' = value as Bool
            | "answer_counts" => answer_counts' = _PollAnswerCounts(value)?
            end
        end

        is_finalized = is_finalized' as Bool
        answer_counts = answer_counts' as Array[PollAnswerCount] val

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("is_finalized", is_finalized)
            .update("answer_counts", _PollAnswerCounts.to_json(answer_counts))

class val PollAnswerCount is Jsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-results-object-poll-answer-count-object-structure
    """

    let id: USize
        """
        The `answer_id`
        """

    let count: USize
        """
        The number of votes for this answer
        """

    let me_voted: Bool
        """
        Whether the current user voted for this answer
        """

    new val create(id': USize, count': USize, me_voted': Bool) =>
        id = id'
        count = count'
        me_voted = me_voted'

    new val from_json(obj: json.JsonObject) ? =>
        var id': (USize | None) = None
        var count': (USize | None) = None
        var me_voted': (Bool | None) = None

        for (key, value) in obj.pairs() do
            match key
            | "id" => id' = (value as I64).usize()
            | "count" => count' = (value as I64).usize()
            | "me_voted" => me_voted' = value as Bool
            end
        end

        id = id' as USize
        count = count' as USize
        me_voted = me_voted' as Bool

    fun to_json(): json.JsonObject =>
        json.JsonObject
            .update("id", id.i64())
            .update("count", count.i64())
            .update("me_voted", me_voted)

primitive _PollAnswerCounts
    fun apply(value: json.JsonValue): Array[PollAnswerCount] val ? =>
        """
        Decodes an array of poll answer counts.
        """

        let array = value as json.JsonArray
        recover val
            let counts = Array[PollAnswerCount](array.size())
            for count in array.values() do
                counts.push(
                    PollAnswerCount.from_json(count as json.JsonObject)?
                )
            end
            counts
        end

    fun to_json(counts: Array[PollAnswerCount] val): json.JsonArray =>
        var array = json.JsonArray
        for count in counts.values() do array = array.push(count.to_json()) end
        array

class val GetAnswerVotersParams
    """
    https://docs.discord.com/developers/resources/poll#get-answer-voters-query-string-params
    """

    let after: (Snowflake | None)
        """
        Get users after this user ID
        """

    let limit: (USize | None)
        """
        Max number of users to return (1-100), defaults to 25
        """

    new val create(
        after': (Snowflake | None) = None,
        limit': (USize | None) = None
    ) =>
        after = after'
        limit = limit'

    fun to_query(): _RequestQuery =>
        let query = recover iso Array[(String, String)] end

        match after
        | let after': Snowflake => query.push(("after", after'.string()))
        end

        match limit
        | let limit': USize => query.push(("limit", limit'.string()))
        end

        consume query

class val PollAnswerParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-answer-object

    An answer of a poll being created. Unlike a poll answer returned by the API,
    `answer_id` is assigned by Discord and so is not sent.
    """

    let poll_media: PollMedia
        """
        The data of the answer
        """

    new val create(poll_media': PollMedia) =>
        poll_media = poll_media'

    fun to_json(): json.JsonObject =>
        json.JsonObject.update("poll_media", poll_media.to_json())

primitive _PollAnswerParams
    fun to_json(answers: Array[PollAnswerParams] val): json.JsonArray =>
        var array = json.JsonArray
        for answer in answers.values() do
            array = array.push(answer.to_json())
        end
        array

class val PollParams is ToJsonable
    """
    https://docs.discord.com/developers/resources/poll#poll-create-request-object-poll-create-request-object-structure

    This is the request object used when creating a poll across the different
    endpoints. It is similar but not exactly identical to the main poll object.
    The main difference is that the request has `duration` which eventually
    becomes `expiry`.
    """

    let question: PollMedia
        """
        The question of the poll. Only `text` is supported.
        """

    let answers: Array[PollAnswerParams] val
        """
        Each of the answers available in the poll, up to 10
        """

    let duration: (USize | None)
        """
        Number of hours the poll should be open for, up to 32 days. Defaults to
        24
        """

    let allow_multiselect: (Bool | None)
        """
        Whether a user can select multiple answers. Defaults to false
        """

    let layout_type: (PollLayoutType | None)
        """
        The layout type of the poll. Defaults to... DEFAULT!
        """

    new val create(
        question': PollMedia,
        answers': Array[PollAnswerParams] val,
        duration': (USize | None) = None,
        allow_multiselect': (Bool | None) = None,
        layout_type': (PollLayoutType | None) = None
    ) =>
        question = question'
        answers = answers'
        duration = duration'
        allow_multiselect = allow_multiselect'
        layout_type = layout_type'

    fun to_json(): json.JsonObject =>
        var obj = json.JsonObject
            .update("question", question.to_json())
            .update("answers", _PollAnswerParams.to_json(answers))

        match duration
        | let duration': USize => obj = obj.update("duration", duration'.i64())
        end

        match allow_multiselect
        | let allow_multiselect': Bool =>
            obj = obj.update("allow_multiselect", allow_multiselect')
        end

        match layout_type
        | let layout_type': PollLayoutType =>
            obj = obj.update("layout_type", layout_type'.value().i64())
        end

        obj
