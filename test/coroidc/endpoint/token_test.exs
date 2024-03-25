defmodule Coroidc.Endpoint.TokenTest do
  use CoroidcTest.ConnCase
  alias Coroidc.Endpoint.Token

  setup do
    params = %{
      "client_id" => "toto",
      "redirect_uri" => "/callback",
      "grant_type" => "authorization_code",
      "code" => "valid_code"
    }

    {:ok, %{valid_params: params}}
  end

  describe "call/2" do
    test "trade a code for token", %{valid_params: params} do
      conn =
        token_conn(params)
        |> Token.call([])
    end
  end

  describe "#validate_params" do
    test "it validate the request_method", %{valid_params: params} do
      conn = conn(:put, "/oauth2/token", params)

      assert {:callback, :handle_error, [message: "expect POST query only", status: 400]} ==
               Token.call(conn, [])
    end

    test "it validate the content_type", %{valid_params: params} do
      conn = conn(:post, "/oauth2/token", params)

      assert {:callback, :handle_error, [message: "must be x-www-form-urlencoded", status: 400]} ==
               Token.call(conn, [])
    end

    test "it validate the required_params" do
      conn = token_conn(%{})

      assert {:callback, :handle_error,
              [
                message: "Missing parameters: client_id, code, grant_type",
                status: 400
              ]} ==
               Token.call(conn, [])
    end

    test "it validate the grant_type", %{valid_params: params} do
      params = Map.put(params, "grant_type", "none")
      conn = token_conn(params)

      assert {:callback, :handle_error,
              [
                message: "invalid grant_type",
                status: 400
              ]} == Token.call(conn, [])
    end

    test "it validate the authorization header", %{valid_params: params} do
      conn =
        conn(:post, "/oauth2/token", params)
        |> put_req_header("content-type", "application/x-www-form-urlencoded")

      assert {:callback, :handle_error,
              [
                message: "missing authorization header",
                status: 401
              ]} == Token.call(conn, [])
    end
  end

  defp token_conn(params) do
    creds = Base.encode64("toto:toto-secret", padding: false)

    conn(:post, "/oauth2/token", params)
    |> put_req_header("content-type", "application/x-www-form-urlencoded")
    |> put_req_header("authorization", "Basic " <> creds)
  end
end
