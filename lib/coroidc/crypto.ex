defmodule Coroidc.Crypto do
  def encoded_token(n \\ 20) do
    Base.url_encode64(:crypto.strong_rand_bytes(n), padding: false)
  end
end
