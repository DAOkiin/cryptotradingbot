# auto_register: false

require 'rom-repository'
require 'parser/import'

class Repository < ROM::Repository::Root
  include App::Import.args['persistence.rom']
end
