defmodule Coroidc.Endpoint.AuthorizationTest do
  use CoroidcTest.ConnCase
  alias Coroidc.Endpoint.Authorization

  describe "call" do
    test "redirect to the login url" do
      params = %{
        "client_id" => "1",
        "redirect_uri" => "2",
        "response_type" => "3",
        "scope" => "4"
      }

      url = authorization_url(params)

      # redirect to the url provided in the configuration
      conn =
        conn(:get, url)
        |> Authorization.call([])

      assert conn.status === 302

      redirected_to = get_header(conn, "location")
      assert redirected_to =~ "/test/login"

      assert URI.parse(redirected_to).query
             |> URI.decode_query() == params
    end

    test "redirects to error page with meaningful errors" do
      url = authorization_url(%{})

      conn =
        conn(:get, url)
        |> Authorization.call([])

      assert conn.resp_body =~
               ~s(value="400")

      assert conn.resp_body =~
               ~s(value="Missing parameters: client_id, redirect_uri, response_type, scope")
    end
  end

  defp authorization_url(params) do
    "/oauth2/authorization?" <> URI.encode_query(params)
  end
end
