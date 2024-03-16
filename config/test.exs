import Config

config :oidc_core, OIDCCore.Server,
  error_page_url: "/test/error",
  authentication_form_url: "/test/login"
