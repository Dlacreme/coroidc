defmodule Coroidc.Server.Placeholder do
  @moduledoc """
  This module should never be used - it's used compile
  the project but will raise an exception if used.

  The server implementing Coroidc should implement it's own
  Coroidc.Server.Handler and Coroidc.Server.Repo behaviours and edit
  their config accordingly.
  """

  @behaviour Coroidc.Server.Handler
  @behaviour Coroidc.Server.Repo

  @dialyzer {:no_return, redirect_to_authentication: 2}
  @impl Coroidc.Server.Handler
  def redirect_to_authentication(_conn, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, handle_error: 3}
  @impl Coroidc.Server.Handler
  def handle_error(_conn, _error, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, get_client: 2}
  @impl Coroidc.Server.Repo
  def get_client(_client_id, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, insert_code: 3}
  @impl Coroidc.Server.Repo
  def insert_code(_user_id, _code, _opts) do
    not_implemented()
  end

  @dialyzer {:no_return, get_code: 2}
  @impl Coroidc.Server.Repo
  def get_code(_code, _opts) do
    not_implemented()
  end

  defp not_implemented() do
    raise """
    You must implement Coroidc.Server.Repo and define the module in your config file.

    See Coroidc.Server.Repo for more information.
    """
  end
end
