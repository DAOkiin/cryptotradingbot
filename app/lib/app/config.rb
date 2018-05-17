require "types"
require "yaml"

module App
  class Config < Dry::Struct
    RequiredString = Types::Strict::String.constrained(min_size: 1)

    attribute :database_url, RequiredString
    attribute :session_secret, RequiredString

    attribute :errbit_host, RequiredString
    attribute :errbit_projectkey, RequiredString

    attribute :binance_key, RequiredString
    attribute :binance_secret, RequiredString

    def self.load(root, name, env)
      path = root.join("config").join("#{name}.yml")
      yaml = File.exist?(path) ? YAML.load_file(path) : {}

      config = schema.keys.each_with_object({}) { |key, memo|
        value = ENV.fetch(
          key.to_s.upcase,
          yaml.fetch(env.to_s, {})[key.to_s]
        )

        memo[key] = value
      }

      new(config)
    end
  end
end
