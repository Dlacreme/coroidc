defmodule Coroidc.IdToken do
  @moduledoc """
  """

  @issuer Application.compile_env(:coroidc, :issuer)

  def generate(code) when is_struct(code, Coroidc.AccessToken) do
    claims =
      claims(code)
      |> maybe_add_nonce(code.nonce)

    JOSE.JWT.sign(%{"k" => "your_secret_key"}, header(), claims)
    |> JOSE.JWS.compact()
  end

  defp header() do
    %{
      "alg" => "HS256",
      "typ" => "JWT"
    }
  end

  defp claims(code) do
    %{
      "isser" => @issuer,
      "sub" => code.user_id,
      "aud" => code.client_id,
      "iat" => code.issued_at |> DateTime.to_unix(),
      "exp" => code.issued_at |> DateTime.add(code.expires_in) |> DateTime.to_unix()
    }
  end

  defp maybe_add_nonce(claims, nonce) when is_binary(nonce) do
    Map.merge(claims, %{"nonce" => nonce})
  end

  defp maybe_add_nonce(claims, _any) do
    claims
  end
end
