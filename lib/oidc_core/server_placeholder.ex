defmodule OIDCCore.ServerPlaceholder do
  @moduledoc """
  Define all the behaviours that should be implemented
  by the client application.
  """
  @behaviour OIDCCore.Server.Authorization

  def render(_conn) do
    raise_error("OIDCCore.Server.Authorization#render")
  end

  def attempt(_conn, _params) do
    raise_error("OIDCCore.Server.Authorization#attempt")
  end

  defp raise_error(target) do
    raise """
    Error. You must properly implement and configure #{target}
    """
  end
end
