require "app/parser/view/controller"

module App
  module Parser
    module Views
      class Welcome < View::Controller
        configure do |config|
          config.template = "welcome"
        end
      end
    end
  end
end
