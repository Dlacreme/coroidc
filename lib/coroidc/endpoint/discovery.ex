defmodule Coroidc.Endpoint.Discovery do
  use Coroidc.Endpoint

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
