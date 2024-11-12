defmodule Coroidc.RsaStore do
  @moduledoc """
  Store private keys & certificate on ETS.
  """

  @ets_table :coroidc_rsa_store

  @doc """
  Create a new ETS table if required
  """
  def init_safely() do
    try do
      :ets.new(@ets_table, [:set, :protected, :named_table])
    rescue
      _ -> @ets_table
    end
  end

  @doc """
  Set a private key using 'key'
  """
  def set_private_key(key, private_key) when is_binary(private_key) do
    :ets.insert(@ets_table, {{key, :private_key}, private_key})
    :ok
  end

  @doc """
  Return a private key
  """
  def get_private_key(key) do
    [{_key, private_key}] = :ets.lookup(@ets_table, {key, :private_key})
    private_key
  end

  @doc """
  Add a new certificate for key. You can only have 4 certificates simoultaneously.
  You must use the same key than the one used with 'set_private_key'
  """
  def add_certificate(key, cert) when is_binary(cert) do
    certs =
      [cert | get_certificates(key)]
      |> Enum.take(4)

    :ets.insert(@ets_table, {{key, :certificates}, certs})
    certs
  end

  @doc """
  Return all certificates available
  """
  def get_certificates(key) do
    [{{_key}, certs}] = :ets.lookup(@ets_table, {key, :certificates})
    certs
  end
end
