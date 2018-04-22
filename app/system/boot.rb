require "bundler/setup"

begin
  require "pry-byebug"
rescue LoadError
end

require_relative "api/container"

App::Container.finalize!

require "api/web"
