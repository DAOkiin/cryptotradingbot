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
          message = proc { |e|
            App::Container['bus'].publish('binance.ws.kline', message: e,
                                                              params: params)
          }
          close = proc { |e|
            Airbrake.notify("WebSocket closed because of #{e.inspect}")
            print "\nWS closed\n"
          }

          methods = { message: message, close: close }
          supervisor[:ws].async.start_ws(params, client, methods)
          bus.subscribe(event_listener)
          Success(params)
        end
      end
    end
  end
end
