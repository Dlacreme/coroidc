defmodule OIDCCore.Plug.ParamBuilder do
  use Plug.Builder
  def init(opts \\ []), do: opts

  def call(conn, _opts) do
    conn
  end
end
