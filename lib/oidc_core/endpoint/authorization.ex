defmodule OIDCCore.Endpoint.Authorization do
  @moduledoc """
  The authorization module check the OIDC parameters
  and if everything is correct gives back the hand to the
  host application to authenticate the user.
  """
  use OIDCCore.Endpoint
  alias OIDCCore.Server.Callback, as: ServerCallback

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    case validate_oidc_parameters(conn) do
      {:ok, conn} ->
        conn
        |> ServerCallback.redirect_to_authentication()

      {:error, message} ->
        conn
        |> ServerCallback.handle_error(message, http_code: 400)
    end
  end

  defp validate_oidc_parameters(conn) do
    with {:ok, conn} <- validate_required_parameters(conn) do
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
      {:ok, conn}
    else
      {:error, "Missing parameters: #{Enum.join(missing_params, ", ")}"}
    end
  end
end
