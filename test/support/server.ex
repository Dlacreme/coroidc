defmodule CoroidcTest.Server do
  @behaviour Coroidc.Server.Handler
  @behaviour Coroidc.Server.Repo

  @impl Coroidc.Server.Handler
  def redirect_to_authentication(conn, _opts) do
    conn
  end

  @impl Coroidc.Server.Handler
  def handle_error(conn, _error, _opts) do
    conn
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
  def insert_code(_user_id, _code, _opts) do
    :ok
  end

  @impl Coroidc.Server.Repo
  def get_code(_code, _opts) do
    :ok
  end
end
