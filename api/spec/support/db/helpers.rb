module Test
  module DatabaseHelpers
    module_function

    def rom
      Api::Container["persistence.rom"]
    end

    def db
      Api::Container["persistence.db"]
    end
  end
end
