defmodule Coroidc.Server.Repo do
  @moduledoc """
  Expose functions to fetch and insert data from your database.
  """

  @doc """
  Retrieve a client as a valid %Coroidc.Client struct
  or nil if missing.
  """
  @callback get_client(client_id :: binary()) ::
              Coroidc.Client.t() | nil

  @doc """
  Register a new code
  """
  @callback insert_code(code :: Coroidc.Code.t()) ::
              :ok | {:error, reason :: binary()}

  @doc """
  Consume a code to return it's meta data
  """
  @callback consume_code(code :: binary()) ::
              {:ok, Coroid.Code.t()} | {:error, reason :: binary()}

  @doc """
  Insert a new access token
  """
  @callback insert_access_token(access_token :: Coroidc.AccessToken.t()) ::
              {:ok, access_token :: Coroidc.AccessToken.t()} | {:error, reason :: binary()}
end
