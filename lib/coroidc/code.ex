defmodule Coroidc.Code do
  defstruct code: nil,
            client_id: nil,
            issued_at: DateTime.utc_now(),
            expires_in: 3600,
            user_id: nil,
            scopes: nil
end
