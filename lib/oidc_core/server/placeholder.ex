defmodule OIDCCore.Server.Placeholder do
  @behaviour OIDCCore.Server

  @dialyzer {:no_return, redirect_to_authentication: 2}
  @impl OIDCCore.Server
  def redirect_to_authentication(_conn, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, handle_error: 3}
  @impl OIDCCore.Server
  def handle_error(_conn, _error, _opts) do
    not_implemented()
  end

  defp not_implemented() do
    raise """
    You must implement OIDCCore.Server and define the module in your config file.

    See OIDCCore.Server for more information.
    """
  end
end
