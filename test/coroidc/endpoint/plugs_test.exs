defmodule Coroidc.Endpoint.PlugsTest do
  alias Coroidc.Endpoint.Plugs

  describe "json_content/1" do
    test "set the correct headers" do
      conn =
        conn(:get, "/")
        |> Plugs.json_content()

      assert get_resp_header(conn, "content-type") ==
               ["application/json; charset=utf-8"]
    end
  end
end
