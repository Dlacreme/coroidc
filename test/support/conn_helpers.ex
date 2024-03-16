defmodule OIDCCoreTest.ConnHelpers do
  @moduledoc """
  Provider helper to easily introspect a conn
  """

  def get_header(conn, header_name, default \\ nil) when is_binary(header_name) do
    case Enum.find(conn.resp_headers, fn {key, _value} -> key == header_name end) do
      nil -> default
      {_k, value} -> value
    end
  end
end
