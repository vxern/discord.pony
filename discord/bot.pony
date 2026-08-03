class Bot
    let rest: Rest
    let gateway: Gateway

    new create(env: Env, token: String) =>
        rest = Rest(RestOptions(token))
        gateway = Gateway
