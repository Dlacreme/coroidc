import Config

# You must implement Coroidc.Server behaviour
# and define the module used here.
config :coroidc,
  issuer: "https://demo.coroidc.com",
  handler: Coroidc.Server.Placeholder,
  repo: Coroidc.Server.Placeholder

if config_env() == :test do
  config :coroidc,
    issuer: "https://test.coroidc.com",
    handler: CoroidcTest.Server,
    repo: CoroidcTest.Server
end
