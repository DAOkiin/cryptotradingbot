module Test
  module WebHelpers
    module_function

    def app
      Api::Web.app
    end
  end
end
