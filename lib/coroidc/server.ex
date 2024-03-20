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
  - status: meaningful HTTP code
  """
  @callback handle_error(conn :: Plug.Conn.t(), error :: binary(), opts :: Keyword.t()) ::
              Plug.Conn.t()

  @doc """
  Retrieve a client as a valid %Coroidc.Client struct
  or nil if missing.
  """
  @callback get_client(client_id :: binary(), opts :: Keyword.t()) ::
              Coroidc.Client.t() | nil

  @doc """
  Register a code

  opts contains a default expirate_at UTC Datetime (1 hour)
  """
  @callback insert_code(user_id :: binary(), code :: binary(), opts :: Keyword.t()) ::
              :ok | {:error, any()}
end
