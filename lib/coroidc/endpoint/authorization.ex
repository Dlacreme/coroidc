defmodule Coroidc.Endpoint.Authorization do
  @moduledoc """
  The authorization module check the OIDC parameters
  and if everything is correct gives back the hand to the
  host application to authenticate the user.
  """
  use Coroidc.Endpoint

  @required_params ~w(client_id redirect_uri response_type scope)

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    with {:ok, conn} <- validate_params(conn) do
      ServerCallback.redirect_to_authentication(conn)
    else
      {:error, reason, status} ->
        ServerCallback.handle_error(conn, reason, status: status)
    end
  end

  def authorize(conn, user_id, opts \\ []) do
    conn = fetch_query_params(conn)

    with :ok <- validate_user_id(user_id),
         {:ok, conn} <- validate_params(conn) do
      case Map.fetch!(conn.query_params, "response_type") do
        "code" ->
          authorize_with_code(conn, user_id, opts)

        "jwt" ->
          raise "JWT response_type not implemented"
      end
    else
      {:error, reason, status} ->
        ServerCallback.handle_error(conn, reason, status: status)
    end
  end

  defp validate_params(conn) do
    with :ok <- validate_required_params(conn.query_params, @required_params),
         :ok <- validate_response_type(conn),
         {:ok, client} <- get_client_from_params(conn.query_params),
         :ok <- validate_redirect_uri(conn, client) do
      {:ok, conn}
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

  defp authorize_with_code(conn, user_id, opts) do
    code = Keyword.get(opts, :code, Base.url_encode64(:crypto.strong_rand_bytes(20)))

    default_expire_at = DateTime.utc_now() |> DateTime.add(3600, :second)

    case ServerCallback.insert_code(user_id, code,
           default_expired_at: default_expire_at,
           redirect_uri: Map.fetch!(conn.query_params, "redirect_uri")
         ) do
      :ok -> redirect_to_client(conn, code)
      {:error, reason} -> ServerCallback.handle_error(conn, reason, status: 500)
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
