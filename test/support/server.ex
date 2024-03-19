defmodule OIDCCoreTest.Server do
  @behaviour OIDCCore.Server

  @impl OIDCCore.Server
  def redirect_to_authentication(_conn, _opts) do
    raise "not implemented"
  end

  @impl OIDCCore.Server
  def handle_error(_conn, _error, _opts) do
    raise "not implemented"
  end
end
