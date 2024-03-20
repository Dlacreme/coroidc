defmodule Coroidc.Endpoint.Authorization do
  @moduledoc """
  The authorization module check the OIDC parameters
  and if everything is correct gives back the hand to the
  host application to authenticate the user.
  """
  use Coroidc.Endpoint
  alias Coroidc.Server.Callback, as: ServerCallback

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    with {:ok, conn} <- validate_oidc_parameters(conn) do
      ServerCallback.redirect_to_authentication(conn)
    end
  end

  def authorize(conn, user_id) do
    with :ok <- validate_user_id(user_id),
         {:ok, conn} <- validate_oidc_parameters(conn) do
      case Map.fetch!(conn.query_params, "response_type") do
        "code" ->
          nil
      end
    end
  end

  defp validate_oidc_parameters(conn) do
    conn = fetch_query_params(conn)

    with :ok <- validate_required_parameters(conn),
         :ok <- validate_response_type(conn),
         {:ok, client} <- get_client(conn),
         :ok <- validate_redirect_uri(conn, client) do
      {:ok, conn}
    end
  end

  defp validate_required_parameters(conn) do
    required_params = ~w(client_id redirect_uri response_type scope)

    missing_params =
      Enum.filter(required_params, fn param ->
        Map.get(conn.query_params, param) == nil
      end)

    if missing_params == [] do
      :ok
    else
      {:error, "Missing parameters: #{Enum.join(missing_params, ", ")}", 400}
    end
  end

  defp validate_response_type(conn) do
    response_type = Map.fetch!(conn.query_params, "response_type")

    if response_type in ["code", "jwt"] do
      :ok
    else
      {:error, "invalid response_type", 400}
    end
  end

  defp get_client(conn) do
    client_id = Map.fetch!(conn.query_params, "client_id")

    case ServerCallback.get_client(client_id) do
      nil -> {:error, "invalid client_id", 400}
      %Coroidc.Client{} = client -> {:ok, client}
      _any -> {:error, "invalid format for client", 500}
    end
  end

  defp validate_redirect_uri(conn, client) do
    redirect_uri = Map.fetch!(conn.query_params, "redirect_uri")

    if redirect_uri in client.redirect_uris do
      :ok
    else
      {:error, "invalid redirect_uri", 400}
    end
  end

  defp validate_user_id(user_id) do
    if is_binary(user_id) and not is_nil(user_id) do
      :ok
    else
      {:error, "invalid user id", 500}
    end
  end
end
