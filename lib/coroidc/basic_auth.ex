defmodule Coroidc.BasicAuth do
  import Coroidc.Endpoint.Helpers

  def validate_authorization_header(conn, client)
      when is_struct(client, Coroidc.Client) do
    with {:ok, authorization} <- get_authorization_header(conn),
         {:ok, cred} <- parse_authorization(authorization),
         :ok <- test_credentials(cred, client) do
      :ok
    end
  end

  defp get_authorization_header(conn) do
    case get_header(conn, "authorization") do
      nil -> {:error, "missing authorization header", 401}
      authorization -> {:ok, authorization}
    end
  end

  defp parse_authorization("Basic " <> cred) do
    {:ok, cred}
  end

  defp parse_authorization(_any) do
    {:error, "invalid authorization header", 401}
  end

  defp test_credentials(cred, client) do
    with {:ok, decoded_cred} <- Base.decode64(cred, padding: false) |> IO.inspect(),
         [id, secret] <- String.split(decoded_cred, ":"),
         true <- id == client.id,
         true <- secret == client.secret do
      :ok
    else
      _any -> {:error, "invalid credentials", 401}
    end
  end
end
