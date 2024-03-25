defmodule Coroidc.Client do
  @moduledoc """
  Define an OpenID client.
  """
  defstruct id: nil, secret: nil, redirect_uris: []
end
