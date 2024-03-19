defmodule OIDCCore.Endpoint.Helpers do
  import Plug.Conn

  def redirect_to(conn, url) do
    conn
    |> put_resp_header("location", url)
    |> send_resp(302, "")
  end
end
