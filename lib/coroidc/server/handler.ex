defmodule Coroidc.Server.Handler do
  @moduledoc """
  Expose functions that deal with specific scenarios.
  """

  @doc """
  Redirect user to the login/signup form.

  All query parameters MUST BE PERSISTED UNTIL THE END.

  opts contains the following information:
  - client_id
  """
  @callback redirect_to_authentication(conn :: Plug.Conn.t(), opts :: Keyword.t()) ::
              Plug.Conn.t()

  @doc """
  Handle an error where 'error' is a meaningful error

  opts contains the following:
  - status: meaningful HTTP code
  """
  @callback handle_error(conn :: Plug.Conn.t(), error :: binary(), opts :: Keyword.t()) ::
              Plug.Conn.t()
end
