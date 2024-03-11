defmodule OIDC.HTTP.JSONContentTest do
  use OIDCTest.ConnCase
  alias OIDC.HTTP.JSONContent

  test "set the correct headers" do
    conn =
      conn(:get, "/")
      |> JSONContent.call([])

    assert get_resp_header(conn, "content-type") ==
             ["application/json; charset=utf-8"]
  end
end
