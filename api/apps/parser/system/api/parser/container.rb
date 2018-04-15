require "pathname"
require "dry/web/container"
require "dry/system/components"

module Api
  module Parser
    class Container < Dry::Web::Container
      require root.join("system/api/container")
      import core: Api::Container

      configure do |config|
        config.root = Pathname(__FILE__).join("../../..").realpath.dirname.freeze
        config.logger = Api::Container[:logger]
        config.default_namespace = "api.parser"
        config.auto_register = %w[lib/api/parser]
      end

      load_paths! "lib"
    end
  end
end
