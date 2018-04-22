# auto_register: false

require "slim"
require "dry/view/controller"
require "api/container"

module App
  module Api
    module View
      class Controller < Dry::View::Controller
        configure do |config|
          config.paths = [Container.root.join("web/templates")]
          config.context = Container["api.view.context"]
          config.layout = "application"
        end
      end
    end
  end
end
