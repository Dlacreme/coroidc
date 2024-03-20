defmodule Coroidc.Server do
  @moduledoc """
  Exposes all the callbacks & function to implement
  """

  @doc """
  Redirect user to the login/signup form.

  All query parameters MUST BE PERSISTED UNTIL THE END.
  """
  @callback redirect_to_authentication(conn :: Plug.Conn.t(), opts :: Keyword.t()) ::
              Plug.Conn.t()

  @doc """
  Handle an error where 'error' is a meaningful error

  opts may contain the following:
  - http_code: meaningful HTTP code
  """
  @callback handle_error(conn :: Plug.Conn.t(), error :: binary(), opts :: Keyword.t()) ::
              Plug.Conn.t()
end
