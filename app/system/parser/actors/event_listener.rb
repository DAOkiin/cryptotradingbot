module Actors
  class EventListener
    include Celluloid

    def on_binance_ws_kline(event)
      if event[:parsed]['k']['x']
        data = {}
        data[:source] = 'binance.ws.kline'
        data[:klines] = [event[:parsed]]
        data[:params] = event[:params]
        App::Container['transactions.new_klines'].call data
      end
    end

    def on_binance_rest_klines(event)
      puts "Get #{event[:klines].size} new klines from REST"
      data = {}
      data[:source] = 'binance.rest.kline'
      data[:klines] = event[:klines]
      data[:params] = event[:params]
      App::Container['transactions.new_klines'].call data
    end
  end
end
