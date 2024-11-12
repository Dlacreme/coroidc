defmodule Coroidc.RsaTest do
  use ExUnit.Case, async: true

  describe "verify_certificate/2" do
    case PublicKey.verify(cert, public_key) do
      :ok -> {:ok, "Certificate is valid"}
      {:error, reason} -> {:error, "Certificate is invalid: #{reason}"}
    end
  end
end
