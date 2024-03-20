import Config

# You must implement Coroidc.Server behaviour
# and define the module used here.
config :coroidc, Coroidc.Server, Coroidc.Server.Placeholder

if config_env() == :test do
  config :coroidc, Coroidc.Server, CoroidcTest.Server
end
