defmodule Coroidc.Server.Placeholder do
  @behaviour Coroidc.Server

  @dialyzer {:no_return, redirect_to_authentication: 2}
  @impl Coroidc.Server
  def redirect_to_authentication(_conn, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, handle_error: 3}
  @impl Coroidc.Server
  def handle_error(_conn, _error, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, get_client: 2}
  @impl Coroidc.Server
  def get_client(_client_id, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, insert_code: 3}
  @impl Coroidc.Server
  def insert_code(_user_id, _code, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, get_code: 2}
  @impl Coroidc.Server
  def get_code(_code, _opts) do
    not_implemented()
  end

  defp not_implemented() do
    raise """
    You must implement Coroidc.Server and define the module in your config file.

    See Coroidc.Server for more information.
    """
  end
end
