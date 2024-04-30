import Config

config :coroidc,
  issuer: "https://dev.coroidc.com",
  handler: CoroidcDev.Server,
  repo: CoroidcDev.Server,
  # 1 hour
  authorization_code_duration: 3600,
  # 24 hours
  access_token_duration: 86_400,
  allow_refresh_token: true
