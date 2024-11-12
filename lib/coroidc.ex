defmodule Coroidc do
  @moduledoc """
  Coroidc is an OpenID Connect Server Skeleton.

  It's built using Plug so you can interface it with
  the HTTP framework of your choice.

  Coroidc doesn't have any Database not user interface to
  give you complete freedom. Instead, it exposes the plug
  your must use for each OpenID endpoints and define
  behaviours your must implement to finalize the
  OpenID server.

  See Coroidc.Server for more details about the
  Behaviours your must implement.

  See Coroidc.Endpoint for more details about the
  Endpoints your must define in your Router.


  Coroidc expect the following configuration:

  	config :coroidc,
  		issuer: "https://your.issuer.com",
  		handler: YourApp.Coroidc.ServerHandler.Implementation
  		repo: YourApp.Coroidc.ServerRepo.Implementation

  You can find a working implementation of Coroidc on
  https://github.com/dlacreme/oidcs

  This is still an early project and should be used in production.
  """

  @doc """
  Finalize the authorization for a given user

  Available options:
  - code_duration: 3600 seconds. the duration of the code for the authorization_code flow
  """
  def authorize(
        conn,
        user_id,
        opts \\ []
      ) do
    Coroidc.Endpoint.Authorization.authorize(conn, user_id, opts)
  end
end
