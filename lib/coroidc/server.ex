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
  your config file accordingly:

  	defmodule YourApp.CoroidcHandler do
  		@behaviour Coroidc.Server.Handler
  		# ...
  	end

  	defmodule YourApp.CoroidcRepo do
  		@behaviour Coroidc.Server.Repo
  		# ...
  	end

  	# Your config file
  	config :coroidc,
  		# ...
  		handler: YourApp.CoroidcHandler,
  		repo: YourApp.CoroidcRepo

  """

  alias Coroidc.Server.Handler
  alias Coroidc.Server.Repo
  @behaviour Handler
  @behaviour Repo

  @handler Application.compile_env(:coroidc, :handler)
  @repo Application.compile_env(:coroidc, :repo)

  @dialyzer {:nowarn_function, redirect_to_authentication: 2}
  @impl Handler
  def redirect_to_authentication(conn, opts \\ []) do
    @handler.redirect_to_authentication(conn, opts)
  end

  @dialyzer {:nowarn_function, handle_error: 3}
  @impl Handler
  def handle_error(conn, error, opts \\ []) do
    @handler.handle_error(conn, error, opts)
  end

  @dialyzer {:nowarn_function, get_client: 2}
  @impl Repo
  def get_client(client_id, opts \\ []) do
    @repo.get_client(client_id, opts)
  end

  @dialyzer {:nowarn_function, insert_code: 3}
  @impl Repo
  def insert_code(user_id, code, opts) do
    @repo.insert_code(user_id, code, opts)
  end

  @dialyzer {:nowarn_function, get_code: 2}
  @impl Repo
  def get_code(code, opts \\ []) do
    @repo.get_code(code, opts)
  end
end
