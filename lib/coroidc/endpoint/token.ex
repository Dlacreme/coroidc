defmodule Coroidc.Endpoint.Token do
  use Coroidc.Endpoint

  alias Coroidc.BasicAuth

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    json_decoder: Jason
  )

  @required_params ~w(client_id code grant_type)

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    with {:ok, conn} <- validate_params(conn),
         conn <- disable_cache(conn) do
      case Map.fetch!(conn.body_params, "grant_type") do
        "authorization_code" -> authorization_code(conn)
      end
    else
      {:error, reason, status} ->
        ServerCallback.handle_error(conn, reason, status: status)
    end
  end

  defp authorization_code(conn) do
  end

  defp validate_params(conn) do
    with :ok <- validate_request_method(conn),
         :ok <- validate_content_type(conn),
         :ok <- validate_required_params(conn.body_params, @required_params),
         :ok <- validate_grant_type(conn),
         {:ok, client} <- get_client_from_params(conn.body_params),
         :ok <- BasicAuth.validate_authorization_header(conn, client),
         {:ok, code} <- get_code_from_params(conn),
         :ok <- validate_code(conn, code) do
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

  defp validate_code(conn, code) do
    case ServerCallback.get_code(code) do
      :ok ->
        :ok

      {:ok, authorized_redirect_uri} ->
        validate_redirect_uri(conn, authorized_redirect_uri)

      _any ->
        {:error, "invalid code", 400}
    end
  end

  defp validate_redirect_uri(conn, authorized_redirect_uri) do
    with {:ok, redirect_uri} <- Map.fetch(conn.body_params, "redirect_uri"),
         true <- redirect_uri == authorized_redirect_uri do
      :ok
    else
      _any -> {:error, "redirect_uri mismatch", 400}
    end
  end
end
