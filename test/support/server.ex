defmodule CoroidcTest.Server do
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
  def get_client(client_id) do
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
  def insert_code(code) do
    if code.code == "error" do
      {:error, "db not available"}
    else
      code
    end
  end

  @impl Coroidc.Server.Repo
  def consume_code(code) do
    case code do
      "error" -> {:error, "server error"}
      "expired" -> {:error, "code expired"}
      _c -> {:ok, %Coroidc.Code{code: code}}
    end
  end

  @impl Coroidc.Server.Repo
  def insert_access_token(access_token) do
    case access_token.token do
      "error" -> {:error, "unknown error"}
      t -> {:ok, t}
    end
  end
end
