defmodule OIDCCoreWeb do
  @moduledoc """
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder
      import Plug.Conn
      import OIDCCore.Endpoint.Helpers
    end
  end
end
