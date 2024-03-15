defmodule OIDCCore.Endpoints.DiscoveryTest do
  use OIDCCoreTest.ConnCase
  alias OIDCCore.Endpoints.Discovery

  describe "call/2" do
    test "returns a valid openid configuration" do
      conn =
        conn(:get, "/.well-known/openid-configuration")
        |> Discovery.call([])

      refute Jason.decode!(conn.resp_body) == openid_configuration(:valid)
    end
  end

  defp openid_configuration(:valid) do
    %{
      "issuer" => "http://example.com",
      "userinfo_endpoint" => "http://example.com/oauth2/v1/userinfo",
      "authorization_endpoint" => "",
      "token_endpoint" => "",
      "end_session_endpoint" => "",
      "introspection_endpoint" => "",
      "jwks_uri" => "",
      "subject_types_supported" => ["public"],
      "claims_supported" => ["iss", "aud", "sub", "nonce", "exp", "iat", "email"],
      "id_token_signing_alg_values_supported" => ["RS256"],
      "response_types_supported" => ["code"],
      "scopes_supported" => ["openid", "email"],
      "token_endpoint_auth_methods_supported" => ["client_secret_post", "client_secret_basic"]
    }
  end
end
