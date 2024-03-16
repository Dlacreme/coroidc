defmodule OIDCCore.Endpoint.Authorization do
  @moduledoc """
  The authorization module check the OIDC parameters
  and if everything is correct gives back the hand to the
  host application to authenticate the user.
  """
  use OIDCCore.Endpoint

  @authentication_form_url Application.compile_env(:oidc_core, OIDCCore.Server)[
                             :authentication_form_url
                           ]

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    case validate_oidc_parameters(conn) do
      {:ok, conn} ->
        conn
        |> redirect_to(build_url(@authentication_form_url, conn.query_params))

      {:error, message} ->
        redirect_to_error(conn, 400, message)
    end
  end

  @doc """
  Once the user successfully logged-in we redirect
  them to the client application.
  """

  #  def callback(conn, user_id) when is_binary(user_id) do
  # end

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

  defp build_url(location, params) do
    URI.parse(location)
    |> URI.append_query(URI.encode_query(params))
    |> URI.to_string()
  end
end
