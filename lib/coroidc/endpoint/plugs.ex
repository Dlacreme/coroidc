defmodule Coroidc.Endpoint.Plugs do
  @moduledoc """
  Define plugs used in different endpoints.
  """
  import Plug.Conn

  def json_content(conn) do
    put_resp_content_type(conn, "application/json")
  end
end
