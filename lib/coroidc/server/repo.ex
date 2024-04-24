defmodule Coroidc.Server.Repo do
  @moduledoc """
  Expose functions to fetch data from your database.
  """

  @doc """
  Retrieve a client as a valid %Coroidc.Client struct
  or nil if missing.
  """
  @callback get_client(client_id :: binary(), opts :: Keyword.t()) ::
              Coroidc.Client.t() | nil

  @doc """
  Register a code

  opts contains:
  - default_expired_at: a default expirate_at UTC Datetime (1 hour)
  - redirect_uri: the redirect_uri used by the client. Used to confirm the code in the /token endpoint
  """
  @callback insert_code(
              user_id :: binary(),
              code :: binary(),
              opts :: Keyword.t()
            ) ::
              :ok | {:error, any()}

  @doc """
  Validate a VALID and NOT EXPIRED code and optionnally returns the
  linked redirect_uri.
  If redirect_uri is not provided, it ignore the security check.
  """
  @callback validate_code(code :: binary(), opts :: Keyword.t()) ::
              :ok | {:ok, redirect_uri :: binary()} | :error

  @doc """
  Create a new session using a code and returns an access_token along with
  the `expires_in` (in seconds).
  Optionnaly, you can also provide a refresh_token.
  """
  @callback insert_session_from_code(code :: binary(), opts :: Keyword.t()) ::
              {:ok, access_token :: binary(), expires_in :: number()}
              | {:ok, access_token :: binary(), expires_in :: number(), refresh_token :: binary()}
              | {:error, any()}
end
