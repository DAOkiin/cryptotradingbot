# auto_register: false

require "rom-repository"
require "parser/container"
require "parser/import"

module Parser
  class Repository < ROM::Repository::Root
    include Import.args["persistence.rom"]
  end
end
