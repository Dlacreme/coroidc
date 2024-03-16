defmodule OIDCCore.Endpoint.Helpers do
  import Plug.Conn

  @error_url Application.compile_env(:oidc_core, OIDCCore.Server)[
               :error_page_url
             ]

  def redirect_to(conn, url) do
    conn
    |> put_resp_header("location", url)
    |> send_resp(302, "")
  end

  def redirect_to_error(conn, code, message) do
    body = """
    <html>
      <body onload="document.forms[0].submit()">
        <form action="#{@error_url}" method="post">
          <input type="hidden" name="code" value="#{code}">
          <input type="hidden" name="message" value="#{message}">
        </form>
      </body>
    </html>
    """

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, body)
  end
end
