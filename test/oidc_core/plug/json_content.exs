defmodule OIDCCore.Plug.JSONContentTest do
  use OIDCCoreTest.ConnCase
  alias OIDCCore.Plug.JSONContent

  test "set the correct headers" do
    conn =
      conn(:get, "/")
      |> JSONContent.call([])

    assert get_resp_header(conn, "content-type") ==
             ["application/json; charset=utf-8"]
  end
end
