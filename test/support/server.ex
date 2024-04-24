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
  def insert_code(_user_id, code, _opts) do
    if code == "error" do
      {:error, "db not available"}
    else
      :ok
    end
  end

  @impl Coroidc.Server.Repo
  def revoke_code(_code, _opts) do
    :ok
  end

  @impl Coroidc.Server.Repo
  def get_user_id_from_code(code, _opts) do
    case code do
      "error" -> :error
      "redirect_uri" -> {:ok, "user_id"}
    end
  end

  def insert_session(user_id, _opts) do
    case user_id do
      "error" -> {:error, "unknown error"}
      "refresh_token" -> {:ok, "access_token", 123, "refresh_token"}
      _any -> {:ok, "access_token", 123}
    end
  end
end
