import Config

# You must implement and define the following behaviours.
config :oidc_core, OIDCCore.Server, authorization: OIDCCore.ServerPlaceholder

if config_env() == :test do
  import_config "test.exs"
end
