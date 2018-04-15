require "bundler/setup"

begin
  require "pry-byebug"
rescue LoadError
end

require_relative "api/container"

Api::Container.finalize!

require "api/web"
