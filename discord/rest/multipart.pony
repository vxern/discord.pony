use courier = "courier"

class val FileUpload
    let filename: String
    let content: Array[U8] val
    let content_type: String

    new val create(
        filename': String,
        content': Array[U8] val,
        content_type': String = _MultipartConstants.content_type()
    ) =>
        filename = filename'
        content = content'
        content_type = content_type'

class val _Multipart
    let content_type: String
    let body: Array[U8] val

    new val payload(payload': String, files: Array[FileUpload] val) =>
        let form = courier.MultipartFormData
        form.field(_MultipartConstants.payload_field_name(), payload')

        for (index, file) in files.pairs() do
            form.file(
                _MultipartConstants.file_field_name(index),
                file.filename,
                file.content_type,
                file.content
            )
        end

        content_type = form.content_type()
        body = form.body()

    new val fields(
        fields': Array[(String, String)] val,
        file_field_name: String,
        file: FileUpload
    ) =>
        let form = courier.MultipartFormData

        for (name, value) in fields'.values() do
            form.field(name, value)
        end

        form.file(
            file_field_name, file.filename, file.content_type, file.content
        )

        content_type = form.content_type()
        body = form.body()

primitive _MultipartConstants
    fun content_type(): String => "application/octet-stream"

    fun payload_field_name(): String => "payload_json"

    fun file_field_name(index: USize): String =>
        "files[" + index.string() + "]"

    fun sticker_file_field_name(): String => "file"
