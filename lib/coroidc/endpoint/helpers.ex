defmodule Coroidc.Endpoint.Helpers do
  import Plug.Conn
  alias Coroidc.Server.Callback, as: ServerCallback

  def redirect_to(conn, url) do
    conn
    |> put_resp_header("location", url)
    |> send_resp(302, "")
  end

  def validate_required_params(params, required_params) do
    missing_params =
      Enum.filter(required_params, fn param ->
        Map.get(params, param) == nil
      end)

    if missing_params == [] do
      :ok
    else
      {:error, "Missing parameters: #{Enum.join(missing_params, ", ")}", 400}
    end
  end

  @doc """
  """
  def get_client_from_params(params) do
    client_id = Map.fetch!(params, "client_id")

    case ServerCallback.get_client(client_id) do
      nil -> {:error, "invalid client_id", 400}
      %Coroidc.Client{} = client -> {:ok, client}
      _any -> {:error, "invalid format for client", 500}
    end
  end

  @doc """
  Returns a specific headers

  Header name must be a binary (not an atom)
  """
  def get_header(conn, header_name, default \\ nil) when is_binary(header_name) do
    case Enum.find(conn.req_headers, fn {key, _value} -> key == header_name end) do
      nil -> default
      {_k, value} -> value
    end
  end
end
