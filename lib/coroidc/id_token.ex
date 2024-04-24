defmodule Coroidc.IdToken do
  @moduledoc """
  """

  def generate(user) do
    header = header()
    claims = claims(user)

    JOSE.JWT.sign(header, %{"k" => "your_secret_key"}, claims)
    |> JOSE.JWS.compact()
  end

  defp header() do
    %{
      "alg" => "HS256",
      "typ" => "JWT"
    }
  end

  defp claims(user) do
    %{
      "sub" => user.id,
      "iat" => DateTime.utc_now() |> DateTime.to_unix(),
      "exp" => DateTime.utc_now() |> DateTime.add(3600) |> DateTime.to_unix()
    }
  end
end
