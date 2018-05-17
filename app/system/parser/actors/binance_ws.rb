module Actors
  class BinanceWs
    include ::Celluloid

    def start_ws(params, client, methods = {})
      EM.run do
        # Create event handlers
        methods[:open]  ||= proc { print "\nconnected\n" }
        methods[:close] ||= proc { print "\nclosed\n" }
        methods[:error] ||= proc { |e|
          Airbrake.notify('WebSocket closed', e)
          print "\nWS closed\n"
        }
        methods[:message] ||= proc { |e|
          data = JSON.parse(e.data)
          App::Container['bus'].publish("binance.ws.#{data['e']}",  message: e,
                                                                    parsed: data,
                                                                    params: params)
        }
        symbol = params[:c1] + params[:c2]
        interval = params[:interval]
        # # kline takes an additional named parameter
        client.kline symbol: symbol, interval: interval, methods: methods
      end
    end
  end
end
