defmodule OIDCCore.Endpoints.Authorization do
  use OIDCCore.Endpoints

  @server Application.compile_env(:oidc_core, OIDCCore.Server)[:authorization]

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    case conn.method do
      "GET" ->
        render_login_page(conn)

      "POST" ->
        attemp_sign_in(conn)
    end
  end

  defp render_login_page(conn) do
    send_resp(conn, 200, @server.render(conn))
  end

  defp attemp_sign_in(conn) do
    IO.inspect(conn, label: "wtf?")

    case @server.attempt(conn, %{}) do
      {:ok, user} -> IO.inspect(user, label: "login user")
      {:error, conn} -> render_login_page(conn)
    end
  end
end
