class Bot
    let rest: Rest
    let gateway: Gateway

    new create(options: RestOptions = RestOptions) =>
        rest = Rest(options)
        gateway = Gateway
