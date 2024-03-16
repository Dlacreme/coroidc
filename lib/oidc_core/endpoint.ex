defmodule OIDCCore.Endpoint do
  @moduledoc """
  Helpers for returning valid HTTP response.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn
      import OIDCCore.Endpoint.Helpers

      #      plug(OIDCCore.Plug.JSONContent)

      # plug(Plug.Parsers,
      # parsers: [:urlencoded, :multipart, :json],
      # json_decoder: Jason
      # )

      # plug(OIDCCore.Plug.ParamBuilder)
    end
  end
end
