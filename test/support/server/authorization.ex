defmodule OIDCCoreTest.Server.Authorization do
  @behaviour OIDCCore.Server.Authorization

  def render(_conn) do
    """
    <div>login page</div>
    """
  end

  def attempt(conn, _params) do
    {:error, conn}
  end
end
