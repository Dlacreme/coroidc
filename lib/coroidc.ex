defmodule Coroidc do
  @moduledoc """
  """

  @doc """
  Finalize the authorization for a given user
  """
  def authorize(conn, user_id) do
    Coroidc.Endpoint.Authorization.authorize(conn, user_id)
  end
end
