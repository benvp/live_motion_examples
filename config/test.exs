import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_motion_examples, LiveMotionExamplesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qYJgVN/xB8cfUIOwr1MY1O9CqQ9btSwBjyXolHGvSbVGhBE6uAPW+ed0A3zU6lir",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
