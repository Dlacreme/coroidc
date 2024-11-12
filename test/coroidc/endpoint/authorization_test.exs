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
      conn =
        conn(:get, authorization_url(params))

      assert {:callback, :redirect_to_authentication, []} == Authorization.call(conn, [])
    end
  end

  describe "authorize/3" do
    test "redirect with a valid code & state + nonce", %{valid_params: params} do
      conn =
        conn(:get, authorization_url(params))
        |> Authorization.authorize("11111")

      location =
        get_header(conn, "location")

      assert conn.status == 302

      assert Regex.match?(
               ~r{/callback\?code=([A-Za-z0-9_-]|%[0-9A-Fa-f])+&state=itsastate&nonce=itsanonce},
               location
             )
    end

    test "return an error if fail to insert code", %{valid_params: params} do
      conn =
        conn(:get, authorization_url(params))

      assert {:callback, :handle_error, [message: "db not available", status: 500]} ==
               Authorization.authorize(conn, "11111", code: "error")
    end
  end

  describe "#validate_parameters/1" do
    test "when oidc parameters are missing" do
      conn = conn(:get, authorization_url(%{}))

      assert {:callback, :handle_error,
              [
                message: "Missing parameters: client_id, redirect_uri, response_type, scope",
                status: 400
              ]}

      Authorization.call(conn, [])
    end

    test "when response_type is invalid", %{valid_params: params} do
      params = Map.put(params, "response_type", "nope")

      conn =
        conn(
          :get,
          authorization_url(params)
        )

      assert {:callback, :handle_error, [message: "invalid response_type", status: 400]} ==
               Authorization.call(conn, [])
    end

    test "when client is not found", %{valid_params: params} do
      params = Map.put(params, "client_id", "unknown")
      conn = conn(:get, authorization_url(params))

      assert {:callback, :handle_error, [message: "invalid client_id", status: 400]} ==
               Authorization.call(conn, [])
    end

    test "when redirect_uri is not defined", %{valid_params: params} do
      params = Map.put(params, "redirect_uri", "/")
      conn = conn(:get, authorization_url(params))

      assert {:callback, :handle_error, [message: "invalid redirect_uri", status: 400]} ==
               Authorization.call(conn, [])
    end

    test "when scope is missing", %{valid_params: params} do
      params = Map.delete(params, "scope")
      conn = conn(:get, authorization_url(params))

      assert {:callback, :handle_error, [message: "Missing parameters: scope", status: 400]} ==
               Authorization.call(conn, [])
    end

    test "when scope is invalid", %{valid_params: params} do
      params = Map.put(params, "scope", "invalid_scope")
      conn = conn(:get, authorization_url(params))

      assert {:callback, :handle_error, [message: "invalid scopes :invalid_scope", status: 400]} ==
               Authorization.call(conn, [])
    end
  end

  defp authorization_url(params) do
    "/oauth2/authorization?" <> URI.encode_query(params)
  end
end
