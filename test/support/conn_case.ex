defmodule CoroidcTest.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Plug.Test
      import Plug.Conn
      import CoroidcTest.ConnHelpers
    end
  end
end
