# Configure plutonium

Plutonium.configure do |config|
  config.load_defaults 1.0

  # Shell variant: :modern (icon rail), :plain (no rail), or :classic (legacy).
  config.shell = :modern
  config.assets.stylesheet = "application"
  config.assets.script = "application"
  config.assets.logo = "logo.svg"
  # Configure plutonium above.
end
