defmodule OIDCCore.Plugs.JSONContentTest do
  use OIDCCoreTest.ConnCase
  alias OIDCCore.Plugs.JSONContent

  test "set the correct headers" do
    conn =
      conn(:get, "/")
      |> JSONContent.call([])

    assert get_resp_header(conn, "content-type") ==
             ["application/json; charset=utf-8"]
  end
end
