defmodule CoroidcDev.Server do
  @behaviour Coroidc.Server.Handler
  @behaviour Coroidc.Server.Repo

  @impl Coroidc.Server.Handler
  def redirect_to_authentication(_conn, _opts) do
    {:callback, :redirect_to_authentication, []}
  end

  @impl Coroidc.Server.Handler
  def handle_error(_conn, error, opts) do
    {:callback, :handle_error, Keyword.put_new(opts, :message, error)}
  end

  @impl Coroidc.Server.Repo
  def get_client(client_id, _opts) do
    %Coroidc.Client{
      id: client_id,
      secret: client_id <> "-secret",
      redirect_uris: ["/callback"]
    }
  end

  @impl Coroidc.Server.Repo
  def insert_code(_user_id, code, _opts) do
    :ok
  end

  @impl Coroidc.Server.Repo
  def revoke_code(_code, _opts) do
    :ok
  end

  @impl Coroidc.Server.Repo
  def get_user_id_from_code(code, _opts) do
    {:ok, "user_id"}
  end

  @impl Coroidc.Server.Repo
  def insert_session(user_id, _opts) do
    "refresh_token" -> {:ok, "access_token", 123, "refresh_token"}
  end
end
