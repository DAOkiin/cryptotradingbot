require "pathname"
require "dry/web/container"
require "dry/system/components"

module App
  module Parser
    class Container < Dry::Web::Container
      require root.join("system/app/container")
      import core: App::Container

      configure do |config|
        config.root = Pathname(__FILE__).join("../../..").realpath.dirname.freeze
        config.logger = App::Container[:logger]
        config.default_namespace = "app.parser"
        config.auto_register = %w[lib/app/parser]
      end

      load_paths! "lib"
    end
  end
end
