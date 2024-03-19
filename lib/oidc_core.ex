defmodule OIDCCore do
  @moduledoc """
  """

  @doc """
  Finalize the authorization and create a session for the
  user.
  """
  def authorize(_conn, user_id) do
    IO.inspect(user_id, label: "user authenticated")
    raise "not implemented"
  end
end
