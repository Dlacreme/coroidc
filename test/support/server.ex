defmodule CoroidcTest.Server do
  @behaviour Coroidc.Server

  @impl Coroidc.Server
  def redirect_to_authentication(_conn, _opts) do
    raise "not implemented"
  end

  @impl Coroidc.Server
  def handle_error(_conn, _error, _opts) do
    raise "not implemented"
  end
end
