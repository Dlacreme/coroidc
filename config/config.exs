import Config

# You must implement OIDCCore.Server behaviour
# and define the module used here.
config :oidc_core, OIDCCore.Server, OIDCCore.Server.Placeholder

if config_env() == :test do
  config :oidc_core, OIDCCore.Server, OIDCCoreTest.Server
end
