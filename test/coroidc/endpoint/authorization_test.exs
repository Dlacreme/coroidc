defmodule Coroidc.Endpoint.AuthorizationTest do
  use CoroidcTest.ConnCase
  alias Coroidc.Endpoint.Authorization

  setup do
    params = %{
      "client_id" => "00000",
      "redirect_uri" => "/callback",
      "response_type" => "code",
      "scope" => "openid email profile",
      "state" => "itsastate",
      "nonce" => "itsanonce"
    }

    {:ok, %{valid_params: params}}
  end

  describe "call/2" do
    test "call Coroidc.Server#redirect_to_authentication callback", %{valid_params: params} do
      conn = conn(:get, authorization_url(params))

      assert {:ok, :redirect_to_authentication} == Authorization.call(conn, [])
    end
  end

  describe "authorize/2" do
    test "redirect with a valid code & state + nonce", %{valid_params: params} do
      conn =
        conn(:get, authorization_url(params))
        |> Authorization.authorize("11111")

      location =
        get_header(conn, "location")

      assert conn.status == 302

      assert Regex.match?(
               ~r{/callback\?code=[A-Za-z0-9_-]+&state=itsastate&nonce=itsanonce},
               location
             )
    end
  end

  describe "#validate_oidc_parameters/1" do
    test "when oidc parameters are missing" do
      conn = conn(:get, authorization_url(%{}))

      assert {:error, "Missing parameters: client_id, redirect_uri, response_type, scope", 400} ==
               Authorization.call(conn, [])
    end

    test "when response_type is invalid", %{valid_params: params} do
      params = Map.put(params, "response_type", "nope")

      conn =
        conn(
          :get,
          authorization_url(params)
        )

      assert {:error, "invalid response_type", 400} ==
               Authorization.call(conn, [])
    end

    test "when client is not found", %{valid_params: params} do
      params = Map.put(params, "client_id", "unknown")
      conn = conn(:get, authorization_url(params))

      assert {:error, "invalid client_id", 400} ==
               Authorization.call(conn, [])
    end

    test "when redirect_uri is not defined", %{valid_params: params} do
      params = Map.put(params, "redirect_uri", "/")
      conn = conn(:get, authorization_url(params))

      assert {:error, "invalid redirect_uri", 400} ==
               Authorization.call(conn, [])
    end
  end

  defp authorization_url(params) do
    "/oauth2/authorization?" <> URI.encode_query(params)
  end
end
