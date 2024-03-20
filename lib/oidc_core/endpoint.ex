defmodule OIDCCore.Endpoint do
  @moduledoc """
  This module define all the plugs.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn
      import OIDCCore.Endpoint.Helpers
    end
  end
end
