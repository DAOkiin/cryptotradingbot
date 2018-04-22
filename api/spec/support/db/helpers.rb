module Test
  module DatabaseHelpers
    module_function

    def rom
      App::Container["persistence.rom"]
    end

    def db
      App::Container["persistence.db"]
    end
  end
end
