defmodule Coroidc.Code do
  alias Coroidc.Crypto

  defstruct code: Crypto.encoded_token(),
            client_id: nil,
            issued_at: DateTime.utc_now(),
            expires_in: Application.compile_env(:coroidc, :authorization_code_duration) || 3600,
            user_id: nil,
            scope: nil,
            redirect_uri: nil
end
