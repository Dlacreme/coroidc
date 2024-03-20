defmodule OIDCCore.Endpoint.Discovery do
  use OIDCCore.Endpoint

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> send_resp(
      200,
      Jason.encode!(%{
        "hello" => "World"
      })
    )
  end
end
