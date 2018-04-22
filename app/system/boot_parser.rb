require "bundler/setup"

begin
  require "pry-byebug"
rescue LoadError
end

require_relative "parser/container"

App::Container.finalize!

