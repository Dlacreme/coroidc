defmodule OIDCCore.Endpoints do
  @moduledoc """
  Helpers for returning valid HTTP response.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn

      plug(OIDCCore.Plugs.JSONContent)

      plug(Plug.Parsers,
        parsers: [:urlencoded, :multipart, :json],
        json_decoder: Jason
      )

      plug(OIDCCore.Plugs.ParamBuilder)
    end
  end
end
