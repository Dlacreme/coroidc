import Config

config :coroidc,
  issuer: "https://test.coroidc.com",
  handler: CoroidcTest.Server,
  repo: CoroidcTest.Server,
  allow_refresh_token: false
