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
    if client_id == "unknown" do
      nil
    else
      %Coroidc.Client{
        id: client_id,
        secret: client_id <> "-secret",
        redirect_uris: ["/callback"]
      }
    end
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
  def validate_code(code, _opts) do
    case code do
      "error" -> :error
      "redirect_uri" -> {:ok, "redirect_uri"}
      _any -> :ok
    end
  end

  @impl Coroidc.Server.Repo
  def insert_session_from_code(code, _opts) do
    case code do
      "error" -> {:error, "unknown error"}
      "refresh_token" -> {:ok, "access_token", 123, "refresh_token"}
      _any -> {:ok, "access_token", 123}
    end
  end
end
