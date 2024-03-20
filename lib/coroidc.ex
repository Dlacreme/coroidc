defmodule Coroidc do
  @moduledoc """
  """

  @doc """
  Finalize the authorization and create a session for the
  user.
  """
  def authorize(conn, user_id) do
    Coroidc.Endpoint.Authorization.authorize(conn, user_id)
  end
end
