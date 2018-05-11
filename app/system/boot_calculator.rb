require "bundler/setup"

begin
  require "pry-byebug"
rescue LoadError
end

require_relative "calculator/container"

App::Container.finalize!

