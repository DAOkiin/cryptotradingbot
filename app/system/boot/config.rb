App::Container.finalize(:config) do |container|
  require "app/config"
  env = ENV['RAKE_ENV'] ? ENV['RAKE_ENV'].to_sym : :development
  container.register "config", App::Config.load(container.root, "application", env)
end
