require "bundler/setup"

begin
  require "pry-byebug"
rescue LoadError
end

require_relative "api/container"
require_relative "parser/container"

Api::Container.finalize!
Parser::Container.finalize!

require "api/web"
