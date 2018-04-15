# auto_register: false

require "rom-repository"
require "api/container"
require "api/import"

module Api
  class Repository < ROM::Repository::Root
    include Import.args["persistence.rom"]
  end
end
