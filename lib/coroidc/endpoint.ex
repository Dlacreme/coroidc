defmodule Coroidc.Endpoint do
  @moduledoc """
  This module define all the plugs.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      use Plug.Builder

      import Plug.Conn
      import Coroidc.Endpoint.Helpers

      alias Coroidc.Server.Callback, as: ServerCallback
    end
  end
end
