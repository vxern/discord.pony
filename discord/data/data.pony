"""
Discord's API object model: the types the REST and gateway packages send and
receive, such as `Snowflake`, `Message`, `Guild`, `User` and `GatewayIntent`.

Objects that cross the wire implement `Jsonable`, so each one decodes with a
`from_json` constructor and encodes with `to_json`. Enumerations follow the
same shape: a trait with one primitive per value, and a `from` function on a
companion primitive that maps Discord's wire representation back to it,
erroring on values this library does not know.

Pony does not re-export across package boundaries, so `use "discord/data"`
alongside whichever of `discord`, `discord/rest` or `discord/gateway` you
work with.
"""
