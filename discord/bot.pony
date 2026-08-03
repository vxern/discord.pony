class Bot
    let rest: Rest
    let gateway: Gateway

    new create(env: Env, rest_options: RestOptions) =>
        rest = Rest(env, rest_options)
        gateway = Gateway
