defmodule Coroidc.Endpoint.Authorization do
  @moduledoc """
  The authorization module check the OIDC parameters
  and if everything is correct gives back the hand to the
  host application to authenticate the user.
  """
  use Coroidc.Endpoint
  alias Coroidc.Code

  @required_params ~w(client_id redirect_uri response_type scope)

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    with {:ok, conn, client} <- validate_params(conn) do
      ServerCallback.redirect_to_authentication(conn, client_id: client.id)
    else
      {:error, reason, status} ->
        ServerCallback.handle_error(conn, reason, status: status)
    end
  end

  def authorize(conn, user_id, opts \\ []) do
    conn = fetch_query_params(conn)

    with :ok <- validate_user_id(user_id),
         {:ok, conn, client} <- validate_params(conn) do
      case Map.fetch!(conn.query_params, "response_type") do
        "code" ->
          authorize_with_code(conn, client.id, user_id, opts)

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
         {:ok, client} <-
           get_client_from_params(conn.query_params),
         :ok <- validate_redirect_uri(conn, client),
         :ok <- validate_scope(conn, client) do
      {:ok, conn, client}
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

  defp validate_scope(conn, client) do
    invalid_scopes =
      Map.fetch!(conn.query_params, "scope")
      |> String.split(" ")
      |> Enum.filter(&(&1 not in client.available_scopes))

    if length(invalid_scopes) == 0 do
      :ok
    else
      {:error, "invalid scopes :" <> Enum.join(invalid_scopes, ", "), 400}
    end
  end

  defp validate_user_id(user_id) do
    if is_binary(user_id) and not is_nil(user_id) do
      :ok
    else
      {:error, "invalid user id", 500}
    end
  end

  defp authorize_with_code(conn, client_id, user_id, opts) do
    code = %Code{
      code: Keyword.get(opts, :code, Coroidc.Crypto.encoded_token()),
      client_id: client_id,
      user_id: user_id,
      scope: Map.fetch!(conn.query_params, "scope"),
      redirect_uri: Map.fetch!(conn.query_params, "redirect_uri")
    }

    case ServerCallback.insert_code(code) do
      {:ok, code} -> redirect_to_client(conn, code.code)
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
