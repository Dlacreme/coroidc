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
          authorize_with_code(conn, user_id)

        "jwt" ->
          raise "JWT response_type not implemented"
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

  defp authorize_with_code(conn, user_id) do
    code =
      :crypto.strong_rand_bytes(20)
      |> Base.url_encode64(padding: false)

    default_expire_at = DateTime.utc_now() |> DateTime.add(3600, :second)

    case ServerCallback.insert_code(user_id, code, default_expire_at: default_expire_at) do
      :ok -> redirect_to_client(conn, code)
      {:error, reason} -> ServerCallback.handle_error(conn, reason, http_code: 500)
    end
  end

  defp redirect_to_client(conn, code) do
    redirect_uri = Map.fetch!(conn.query_params, "redirect_uri")

    params = %{
      code: code,
      state: Map.get(conn.query_params, "state", nil),
      nonce: Map.get(conn.query_params, "nonce", nil)
    }

    redirect_to(conn, build_redirect_url(redirect_uri, params))
  end

  defp build_redirect_url(redirect_uri, params) do
    query = URI.encode_query(params)

    URI.parse(redirect_uri)
    |> URI.append_query(query)
    |> URI.to_string()
  end
end
