defmodule OIDCTest do
  use ExUnit.Case
  doctest OIDC

  test "greets the world" do
    assert OIDC.hello() == :world
  end
end
