defmodule Coroidc.Server.Callback do
  @moduledoc """
  """
  @behaviour Coroidc.Server

  @server Application.compile_env(:coroidc, Coroidc.Server)

  @impl Coroidc.Server
  def redirect_to_authentication(conn, opts \\ []) do
    @server.redirect_to_authentication(conn, opts)
  end

  @impl Coroidc.Server
  def handle_error(conn, error, opts \\ []) do
    @server.handle_error(conn, error, opts)
  end
end
