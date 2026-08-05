use collections = "collections"
use json = "json"

trait val Locale is _Enum[Locale, String]
primitive LocaleIndonesian is Locale
    fun value(): String => "id"
primitive LocaleDanish is Locale
    fun value(): String => "da"
primitive LocaleGerman is Locale
    fun value(): String => "de"
primitive LocaleEnglishUK is Locale
    fun value(): String => "en-GB"
primitive LocaleEnglishUS is Locale
    fun value(): String => "en-US"
primitive LocaleSpanishES is Locale
    fun value(): String => "es-ES"
primitive LocaleSpanishLATAM is Locale
    fun value(): String => "es-419"
primitive LocaleFrench is Locale
    fun value(): String => "fr"
primitive LocaleCroatian is Locale
    fun value(): String => "hr"
primitive LocaleItalian is Locale
    fun value(): String => "it"
primitive LocaleLithuanian is Locale
    fun value(): String => "lt"
primitive LocaleHungarian is Locale
    fun value(): String => "hu"
primitive LocaleDutch is Locale
    fun value(): String => "nl"
primitive LocaleNorwegian is Locale
    fun value(): String => "no"
primitive LocalePolish is Locale
    fun value(): String => "pl"
primitive LocalePortugueseBR is Locale
    fun value(): String => "pt-BR"
primitive LocaleRomanian is Locale
    fun value(): String => "ro"
primitive LocaleFinnish is Locale
    fun value(): String => "fi"
primitive LocaleSwedish is Locale
    fun value(): String => "sv-SE"
primitive LocaleVietnamese is Locale
    fun value(): String => "vi"
primitive LocaleTurkish is Locale
    fun value(): String => "tr"
primitive LocaleCzech is Locale
    fun value(): String => "cs"
primitive LocaleGreek is Locale
    fun value(): String => "el"
primitive LocaleBulgarian is Locale
    fun value(): String => "bg"
primitive LocaleRussian is Locale
    fun value(): String => "ru"
primitive LocaleUkrainian is Locale
    fun value(): String => "uk"
primitive LocaleHindi is Locale
    fun value(): String => "hi"
primitive LocaleThai is Locale
    fun value(): String => "th"
primitive LocaleChineseCN is Locale
    fun value(): String => "zh-CN"
primitive LocaleJapanese is Locale
    fun value(): String => "ja"
primitive LocaleChineseTW is Locale
    fun value(): String => "zh-TW"
primitive LocaleKorean is Locale
    fun value(): String => "ko"
primitive Locales
    fun from(v: String): Locale ? =>
        match v
        | "id" => LocaleIndonesian
        | "da" => LocaleDanish
        | "de" => LocaleGerman
        | "en-GB" => LocaleEnglishUK
        | "en-US" => LocaleEnglishUS
        | "es-ES" => LocaleSpanishES
        | "es-419" => LocaleSpanishLATAM
        | "fr" => LocaleFrench
        | "hr" => LocaleCroatian
        | "it" => LocaleItalian
        | "lt" => LocaleLithuanian
        | "hu" => LocaleHungarian
        | "nl" => LocaleDutch
        | "no" => LocaleNorwegian
        | "pl" => LocalePolish
        | "pt-BR" => LocalePortugueseBR
        | "ro" => LocaleRomanian
        | "fi" => LocaleFinnish
        | "sv-SE" => LocaleSwedish
        | "vi" => LocaleVietnamese
        | "tr" => LocaleTurkish
        | "cs" => LocaleCzech
        | "el" => LocaleGreek
        | "bg" => LocaleBulgarian
        | "ru" => LocaleRussian
        | "uk" => LocaleUkrainian
        | "hi" => LocaleHindi
        | "th" => LocaleThai
        | "zh-CN" => LocaleChineseCN
        | "ja" => LocaleJapanese
        | "zh-TW" => LocaleChineseTW
        | "ko" => LocaleKorean
        else error
        end

primitive _Localizations
    fun apply(value: json.JsonValue): (collections.Map[Locale, String] val | None) ? =>
        """
        Decodes a localisation dictionary.
        """

        match value
        | let obj: json.JsonObject =>
            recover val
                let map = collections.Map[Locale, String](obj.size())
                for (key, value') in obj.pairs() do
                    match (Locales.from(key)?, value')
                    | (let locale: Locale, let string: String) => map(locale) = string
                    end
                end
                map
            end
        end

    fun to_json(map: collections.Map[Locale, String] box): json.JsonObject =>
        var obj = json.JsonObject
        for (locale, string) in map.pairs() do obj = obj.update(locale.value(), string) end
        obj
