defmodule OIDCCore.Endpoints.AuthorizationTest do
  use OIDCCoreTest.ConnCase
  alias OIDCCore.Endpoints.Authorization

  describe "render" do
    test "display the login form" do
      conn =
        conn(:get, "/oauth2/authorization")
        |> Authorization.call([])

      assert conn.resp_body ==
               """
               <div>login page</div>
               """
    end
  end

  describe "attempt" do
    test "returns an error if email/password are invalid" do
      conn =
        conn(:post, "/oauth2/authorization")
        |> Authorization.call([])
    end
  end
end
