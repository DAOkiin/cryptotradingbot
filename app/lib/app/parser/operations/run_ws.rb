require 'app/operation'
require "parser/import"

module App
  module Parser
    module Operations
      # Run celluloid supervisor that contain WebSocket client from binance gem
      class RunWs < App::Operation
        include App::Import[
          client: 'exchanges.binance.ws',
          supervisor: 'celluloid.supervisor',
          event_listener: 'celluloid.event_listener',
          bus: 'bus'
        ]
        def call(params)
          bus.subscribe(event_listener)
          supervisor[:ws].async.start_ws(params, client)
          Success(params)
        end
      end
    end
  end
end
