# Core OIDC Server

Coroidc is a core of an OpenID Connect Server. It does the heavy lifting for you so all you have to do is build the User Interface & implement the `Coroidc.Server` behaviour callbacks.

It's using Plug so you can use it with any HTTP framework.

## Usage

### Installation


```elixir
def deps do
  [
    {:coroidc, "~> 0.1.0"}
  ]
end
```

### Implement Coroidc.Server behaviour

```elixir
defmodule YourApp.OIDCServer do
    @behaviour Coroidc.Server

    ## This module is the interface between Coroidc and your
    ## own application. Coroidc is using the callbacks defined
    ## in this module handle specific scenarios or to fetch
    ## data from your database.
    ##
    ## See Coroidc.Server for more details
end
```

### Define your module in your config file

```elixir
config :coroidc, Coroidc.Server, YourApp.OIDCServer
```

### Use the available Plugs in your router

```elixir
get("/.well-known/openid-configuration", Coroidc.Endpoint.Discovery, :any)
get("/oauth2/authorize", Coroidc.Endpoint.Authorization, :any)
```

### Callback

In some scenario, such as in the Authorization, you must give back the hand to Coroidc. The main module exposes function for this purpose:
```elixir
def sign_in_success(conn, user) do
    Coroidc.authorize_user(conn, user.id)
end
```

## Example

You can see a working example on https://github.com/dlacreme/oidcs
