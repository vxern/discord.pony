use "./rest"
use "./gateway"

class Bot
    let rest: Rest
    let gateway: Gateway

    new create(
        env: Env,
        rest_options: RestOptions,
        gateway_options: GatewayOptions
    ) =>
        rest = Rest(env, rest_options)
        gateway = Gateway(env, gateway_options, rest.routes)

    fun dispose() =>
        rest.dispose()
        gateway.dispose()
