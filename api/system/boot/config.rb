App::Container.finalize(:config) do |container|
  require "app/config"
  container.register "config", App::Config.load(container.root, "application", container.config.env)
end
