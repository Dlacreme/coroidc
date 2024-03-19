defmodule OIDCCore.Server.Callback do
  @moduledoc """
  """
  @behaviour OIDCCore.Server

  @server Application.compile_env(:oidc_core, OIDCCore.Server)

  @impl OIDCCore.Server
  def redirect_to_authentication(conn, opts \\ []) do
    @server.redirect_to_authentication(conn, opts)
  end

  @impl OIDCCore.Server
  def handle_error(conn, error, opts \\ []) do
    @server.handle_error(conn, error, opts)
  end
end
