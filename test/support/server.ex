defmodule CoroidcTest.Server do
  @behaviour Coroidc.Server

  @impl Coroidc.Server
  def redirect_to_authentication(_conn, _opts) do
    {:callback, :redirect_to_authentication, []}
  end

  @impl Coroidc.Server
  def handle_error(_conn, error, opts) do
    {:callback, :handle_error, Keyword.put_new(opts, :message, error)}
  end

  @impl Coroidc.Server
  def get_client(client_id, _opts) do
    if client_id == "unknown" do
      nil
    else
      %Coroidc.Client{
        client_id: client_id,
        client_secret: client_id <> "-secret",
        redirect_uris: ["/callback"]
      }
    end
  end

  @impl Coroidc.Server
  def insert_code(_user_id, code, _opts) do
    if code == "error" do
      {:error, "db not available"}
    else
      :ok
    end
  end
end
