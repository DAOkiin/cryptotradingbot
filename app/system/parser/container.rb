require "dry/web/container"
require "dry/system/components"

module App
  class Container < Dry::Web::Container
    configure do
      config.name = :parser
      config.listeners = true
      config.default_namespace = "app.parser"
      config.logger = Dry::Monitor::Logger.new(config.root.join(config.log_dir).join("#{config.name}_#{config.env}.log").realpath)
      config.auto_register = %w[lib/app/parser]
    end

    load_paths! "lib"
  end
end

require_relative 'exchanges'
