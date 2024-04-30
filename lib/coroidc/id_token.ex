defmodule Coroidc.IdToken do
  @moduledoc """
  """

  @issuer Application.compile_env(:coroidc, :issuer)

  def generate(client_id, user_id, expires_in, nonce \\ nil) do
    header = header()

    claims =
      claims(client_id, user_id, expires_in)
      |> maybe_add_nonce(nonce)

    JOSE.JWT.sign(header, %{"k" => "your_secret_key"}, claims)
    |> JOSE.JWS.compact()
  end

  defp header() do
    %{
      "alg" => "HS256",
      "typ" => "JWT"
    }
  end

  defp claims(client_id, user_id, expires_in) do
    %{
      "isser" => @issuer,
      "sub" => user_id,
      "aud" => client_id,
      "iat" => DateTime.utc_now() |> DateTime.to_unix(),
      "exp" => DateTime.utc_now() |> DateTime.add(expires_in) |> DateTime.to_unix()
    }
  end

  defp maybe_add_nonce(claims, nonce) when is_binary(nonce) do
    Map.merge(claims, %{"nonce" => nonce})
  end

  defp maybe_add_nonce(claims, _any) do
    claims
  end
end
