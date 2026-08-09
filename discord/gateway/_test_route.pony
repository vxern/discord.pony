use "../data"
use "pony_test"
use random = "random"

class iso _StressRouteGuild is UnitTest
    fun name(): String => "stress/shard/route_guild"

    fun apply(h: TestHelper) ? =>
        let rand = random.Rand(0x0ad, 0x2)

        for count in [as USize: 1; 2; 7; 64].values() do
            var index: USize = 0

            while index < 20_000 do
                let guild = Snowflake(rand.u64())
                let owner = GatewayShardFor(guild, count)

                let events: Array[GatewaySendableEvent] = [
                    GatewayRequestGuildMembersEvent(guild)
                    GatewayVoiceStateUpdateEvent(guild, None, false, false)
                    GatewayRequestChannelInfoEvent(guild, ["name"])
                ]

                for event in events.values() do
                    let routed = _GatewayRoute(event, count)

                    h.assert_eq[USize](
                        1,
                        routed.size(),
                        "a guild event must go to exactly one shard, not "
                        + routed.size().string()
                    )

                    (let id, let carried) = routed(0)?

                    h.assert_eq[USize](
                        owner,
                        id,
                        "a guild event went to shard " + id.string()
                        + " instead of " + owner.string()
                    )

                    h.assert_true(
                        carried is event,
                        "a guild event was rewritten on the way out"
                    )
                end

                index = index + 1
            end
        end

class iso _StressRouteBroadcast is UnitTest
    fun name(): String => "stress/shard/route_broadcast"

    fun apply(h: TestHelper) ? =>
        let presence = GatewayPresenceUpdateEvent(
            GatewayPresenceUpdate(None, [], OnlineStatusType, false)
        )

        for count in [as USize: 1; 2; 16; 250].values() do
            let routed = _GatewayRoute(presence, count)

            h.assert_eq[USize](
                count,
                routed.size(),
                "a presence update must reach every shard"
            )

            var index: USize = 0

            while index < count do
                (let id, let carried) = routed(index)?

                h.assert_eq[USize](index, id, "a shard was skipped")
                h.assert_true(
                    carried is presence,
                    "the presence update was rewritten on the way out"
                )

                index = index + 1
            end
        end

class iso _StressRouteSoundboard is UnitTest
    fun name(): String => "stress/shard/route_soundboard"

    fun apply(h: TestHelper) ? =>
        let rand = random.Rand(0x50a, 0x3)

        for count in [as USize: 1; 2; 5; 32].values() do
            var round: USize = 0

            while round < 500 do
                let guilds = recover val
                    let picked = Array[Snowflake]
                    let total = 1 + rand.int(40).usize()

                    var index: USize = 0

                    while index < total do
                        picked.push(Snowflake(rand.u64()))
                        index = index + 1
                    end

                    picked
                end

                let routed = _GatewayRoute(
                    GatewayRequestSoundboardSoundsEvent(guilds), count
                )

                let shards_seen = Array[USize]

                var delivered: USize = 0

                for (id, event) in routed.values() do
                    for other in shards_seen.values() do
                        h.assert_true(
                            other != id,
                            "shard " + id.string() + " was sent two requests "
                            + "when one would carry both guilds"
                        )
                    end

                    shards_seen.push(id)

                    let sounds = event as GatewayRequestSoundboardSoundsEvent

                    h.assert_true(
                        sounds.guild_ids.size() > 0,
                        "a shard was sent an empty guild list"
                    )

                    for guild in sounds.guild_ids.values() do
                        h.assert_eq[USize](
                            id,
                            GatewayShardFor(guild, count),
                            "guild " + guild.string()
                            + " went to the wrong shard"
                        )

                        var asked = false

                        for wanted in guilds.values() do
                            if wanted == guild then
                                asked = true
                                break
                            end
                        end

                        h.assert_true(
                            asked,
                            "a guild appeared that was never asked for"
                        )
                    end

                    delivered = delivered + sounds.guild_ids.size()
                end

                h.assert_eq[USize](
                    guilds.size(),
                    delivered,
                    "the split lost or duplicated guilds: " + delivered.string()
                    + " went out of " + guilds.size().string()
                )

                round = round + 1
            end
        end
