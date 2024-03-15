defmodule OIDCCore.Server.Authorization do
  @moduledoc """
  This module implements the sign in process.

  render/1 is called to render the authentication form and
  attempt/2 actually test the credentials provided by the user.

  If the attempt is successful, attempt/2 must return the user to authentication.
  Otherwise it returns a conn that will be used to render the login page.
  """

  @doc """
  Renders the login form
  """
  @callback render(conn :: Plug.Conn.t()) :: binary() | {:error, Plug.Conn.t()}

  @doc """
  Test user credentials
  """
  @callback attempt(conn :: Plug.Conn.t(), params :: Map) ::
              {:ok, user :: any()} | {:error, Plug.Conn.t()}
end
