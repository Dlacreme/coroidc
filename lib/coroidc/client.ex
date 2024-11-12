defmodule Coroidc.Client do
  @moduledoc """
  Define an OpenID client.
  """
  defstruct id: nil,
            secret: nil,
            redirect_uris: [],
            available_scopes: ["openid", "profile", "email"]
end
