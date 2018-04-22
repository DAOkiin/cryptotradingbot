require "app/api/view/controller"

module App
  module Api
    module Views
      class Welcome < App::Api::View::Controller
        configure do |config|
          config.template = "welcome"
        end
      end
    end
  end
end
