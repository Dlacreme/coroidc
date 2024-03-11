defmodule OIDC.Endpoint do
  @moduledoc """
  Helpers for returning valid HTTP response.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn

      plug(OIDC.HTTP.JSONContent)
    end
  end
end
