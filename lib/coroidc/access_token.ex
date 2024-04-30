defmodule Coroidc.AccessToken do
  alias Coroidc.Crypto
  alias Coroidc.IdToken
  @allow_refresh_token Application.compile_env(:coroidc, :allow_refresh_token, false)

  defstruct type: "Bearer",
            token: Crypto.encoded_token(),
            client_id: nil,
            issued_at: DateTime.utc_now(),
            expires_in: Application.compile_env(:coroidc, :access_token_duration) || 86_400,
            user_id: nil,
            id_token: nil,
            scope: nil,
            refresh_token: nil,
            nonce: nil

  def with_refresh_token?(%__MODULE__{} = token)
      when @allow_refresh_token == true do
    Map.put(token, :refresh_token, Crypto.encoded_token())
  end

  def with_refresh_token?(token) do
    token
  end

  def generate_id_token(token) do
    Map.put(token, :id_token, IdToken.generate(token))
  end
end
