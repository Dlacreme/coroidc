import Config

# You must implement and define the following behaviours.
config :oidc_core, OIDCCore.Server,
  error_page_url: "/oidc/error",
  authentication_form_url: "/oidc/login"

if config_env() == :test do
  import_config "test.exs"
end
