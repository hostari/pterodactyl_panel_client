# pterodactyl_panel_client

Pterodactyl v1 API Client

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pterodactyl_panel_client:
       github: hostari/pterodactyl_panel_client
   ```

2. Run `shards install`

## Usage

```crystal
require "pterodactyl_panel_client"
```

Build a new Pterodactyl Panel Client
```crystal
client_sdk = Pterodactyl::Client::Sdk.new("p2.hostari.com", client_token: "ptlc_...")
application_sdk = Pterodactyl::Application::Sdk.new("p2.hostari.com", application_token: "ptla_...")
```

## Resource Methods

API Reference is available on [Dashflo](https://dashflo.net/docs/api/pterodactyl/v1/#req_802e27a56fe142c99db4106d8e8e8892)

### Client Resource Methods

These methods are scoped to the user accessing them (i.e. if you query for servers, you will only see your servers and not other's servers). You must authenticate using a token starting with `ptlc_` and this is generated when you create a user using the application resource method.

- list servers
- account => get account details
- account => update email
- network => list allocations
- network => assign allocation
- network => set allocation note
- network => set primary allocation
- network => unassign allocation
- backups => list backups
- backups => create backup
- backups => backup detaials
- backups => download backup
- backups => delete backup
- settings => rename server
- settings => reinstall server
- startup
  - list variables
  - update variable
- get server details
- get console details
- get resource usage
- send command
- change power state

### Application Resource Methods

To use these methods, you must authenticate using a token starting with `ptla_` which can be generated if you are an Admin on your Pterodactyl panel.

Create user
```crystal
client.create_user(email: "apiuser@example.com", username: "apiuser", first_name: "api", last_name: "user")
```

```json
{"object":"user","attributes":{"id":18,"external_id":null,"uuid":"f2d27757-38b5-4fa2-811a-b41397c0a470","username":"xaviapitest8","email":"xavi+apitest8@hostari.com","language":"en","root_admin":false,"2fa":false,"avatar_url":"https:\/\/www.gravatar.com\/avatar\/30532f3d3853d1c7949849dabe641fc2.jpg","admin_role_id":null,"role_name":null,"created_at":"2023-02-13T18:11:36+00:00","updated_at":"2023-02-13T18:11:36+00:00"},"meta":{"token":"ptlc_U1XFrTgLb8PLqoGNzyCoFFwRtbgiA3IyYzdegLfbXTe"}}
```

List locations
```crystal
client.list_locations
```

Get Location details
```crystal
client.get_location(1)
```

List servers
```crystal
client.list_servers
```

Get server details
```crystal
client.get_server(5)
```

Update server details
```crystal
client.update_server_details(5, name: "name of the server", user: 1, external_id: "external id of the server", description: "description of the server")
```

Update build
```crystal
client.update_server_build(5, allocation: 1, memory: 512, swap: 0, disk: 200, io: 500, cpu: 0, threads: nil, feature_limits: {"databases" => 5, "allocations" => 5, "backups" => 2})
```

Update startup
```crystal
client.update_server_startup(5, startup: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}", environment: {
    "SERVER_JARFILE": "server.jar",
    "VANILLA_VERSION": "latest"
  }, egg: 5, image: "quay.io/pterodactyl/core:java", skip_scripts: false)
```

Create server
```crystal
create_server_request = CreateServerRequest.new(
  name: "Building",
  user: 1,
  egg: 1,
  docker_image: "quay.io/pterodactyl/core:java",
  startup: "java -Xms128M -Xmx128M -jar server.jar",
  environment: {
    "BUNGEE_VERSION" => "latest",
    "SERVER_JARFILE" => "server.jar"
  },
  limits: {
    "memory": 128,
    "swap": 0,
    "disk": 512,
    "io": 500,
    "cpu": 100
  },
  feature_limits: {
    "databases": 5,
    "backups": 1
  },
  allocation: {
    "default": 17
  }
)
client.create_server(create_server_request)
```

Suspend server
```crystal
client.suspend_server(5)
```

Reinstall server
```crystal
client.reinstall_server(5)
```

Delete server
```crystal
client.delete_server(5) # defaults to force: false
client.delete_server(5, force: true)
```

List nests
```crystal
client.list_nests
```

Get nest details
```crystal
client.get_nest(1)
```

List eggs - *Retrieves a list of eggs given a nest id*
```crystal
client.get_eggs(1)
```

Get egg - *Get egg details given an egg id and nest id*
```crystal
client.get_egg(1, nest_id: 1)
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/hostari/pterodactyl_panel_client/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Xavi Ablaza](https://github.com/xaviablaza) - creator and maintainer
