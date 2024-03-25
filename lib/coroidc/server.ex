defmodule Coroidc.Server do
  @moduledoc """
  This module is the bridge between Coroidc and
  your own OpenID server. It exposes 2 behaviours
  that you should properly implement:

  - Coroidc.Server.Handler: this is how Coroidc will
  give you back the hand when required.

  - Coroidc.Server.Repo: this is how Coroidc will fetch
  data from your database.

  Once properly implemented and tested, you must edit
  your config file to let Coroidc knows your module
  names.

  See Coroidc.ex for more information.
  """

  alias Coroidc.Server.Handler
  alias Coroidc.Server.Repo
  @behaviour Handler
  @behaviour Repo

  @handler Application.compile_env(:coroidc, :handler)
  @repo Application.compile_env(:coroidc, :repo)

  @impl Handler
  def redirect_to_authentication(conn, opts \\ []) do
    @handler.redirect_to_authentication(conn, opts)
  end

  @impl Handler
  def handle_error(conn, error, opts \\ []) do
    @handler.handle_error(conn, error, opts)
  end

  @impl Repo
  def get_client(client_id, opts \\ []) do
    @repo.get_client(client_id, opts)
  end

  @impl Repo
  def insert_code(user_id, code, opts) do
    @repo.insert_code(user_id, code, opts)
  end

  @impl Repo
  def get_code(code, opts \\ []) do
    @repo.get_code(code, opts)
  end
end
