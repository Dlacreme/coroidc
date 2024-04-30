defmodule Coroidc.Endpoint.Token do
  use Coroidc.Endpoint

  alias Coroidc.BasicAuth
  alias Coroidc.Code
  alias Coroidc.AccessToken

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn = disable_cache(conn)

    case Map.get(conn.body_params, "grant_type", nil) do
      "authorization_code" ->
        authorization_code(conn)

      nil ->
        ServerCallback.handle_error(conn, "grant_type is missing", status: 400)

      other ->
        ServerCallback.handle_error(conn, "grant_type '#{other}' is not supported", status: 400)
    end
  end

  defp authorization_code(conn) do
    with {:ok, conn} <- validate_params(conn, ~w(client_id code)),
         {:ok, code} <- get_code_from_params(conn),
         {:ok, code} <- consume_code(conn, code),
         {:ok, %AccessToken{} = access_token} <- create_access_token(code) do
      case ServerCallback.insert_access_token(access_token) do
        {:ok, access_token} ->
          IO.inspect(access_token)

        {:error, reason} ->
          ServerCallback.handle_error(conn, reason, status: 500)
      end
    else
      {:error, reason, status} ->
        ServerCallback.handle_error(conn, reason, status: status)
    end
  end

  defp validate_params(conn, required_params) do
    with :ok <- validate_request_method(conn),
         :ok <- validate_content_type(conn),
         :ok <- validate_required_params(conn.body_params, required_params),
         :ok <- validate_grant_type(conn),
         {:ok, client} <- get_client_from_params(conn.body_params),
         :ok <- BasicAuth.validate_authorization_header(conn, client) do
      {:ok, conn}
    end
  end

  defp validate_request_method(conn) do
    if conn.method == "POST" do
      :ok
    else
      {:error, "expect POST query only", 400}
    end
  end

  defp validate_content_type(conn) do
    content_type =
      get_header(conn, "content-type")

    if content_type == "application/x-www-form-urlencoded" do
      :ok
    else
      {:error, "must be x-www-form-urlencoded", 400}
    end
  end

  defp validate_grant_type(conn) do
    grant_type = Map.fetch!(conn.body_params, "grant_type")

    if grant_type == "authorization_code" do
      :ok
    else
      {:error, "invalid grant_type", 400}
    end
  end

  defp get_code_from_params(conn) do
    code = Map.fetch!(conn.body_params, "code")
    {:ok, code}
  end

  defp consume_code(conn, code) do
    case ServerCallback.consume_code(code) do
      {:ok, %Code{redirect_uri: nil} = code} ->
        {:ok, code}

      {:ok, %Code{redirect_uri: authorized_redirect_uri} = code} ->
        with :ok <- valid_redirect_uri?(conn, authorized_redirect_uri) do
          {:ok, code}
        end

      _any ->
        {:error, "invalid code", 400}
    end
  end

  defp valid_redirect_uri?(conn, authorized_redirect_uri) do
    with {:ok, redirect_uri} <- Map.fetch(conn.body_params, "redirect_uri"),
         true <- redirect_uri == authorized_redirect_uri do
      :ok
    else
      _any -> {:error, "redirect_uri mismatch", 400}
    end
  end

  defp create_access_token(code) when is_struct(code, Coroidc.Code) do
    info = Map.take(code, [:client_id, :user_id, :scope])

    %AccessToken{}
    |> Map.merge(info)
    |> AccessToken.with_refresh_token?()
    |> AccessToken.generate_id_token()
  end
end
