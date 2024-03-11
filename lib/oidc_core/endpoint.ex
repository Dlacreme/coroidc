defmodule OIDCCore.Endpoint do
  @moduledoc """
  Helpers for returning valid HTTP response.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn

      plug(OIDCCore.HTTP.JSONContent)
    end
  end
end
