require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Redis
        # Save kline to redis with binance:BTCUSDT:kline1m:120390128309 name
        class SaveKlines < App::Operation
          include App::Import[
            redis: 'redis.binance'
          ]
          def call(data)
            puts "Caching #{data[:klines].size} klines"
            pair = data[:klines].first.pair
            interval = data[:klines].first.interval
            begin
              data[:klines].size.times do
                k = data[:klines].pop
                open_time = k.open_time.to_s
                pref = pair + ':' + 'kline' + interval + ':' + open_time
                redis.set(pref, k.to_h.to_json)
              end
            rescue NoMethodError => e
              puts e
            end
            Success(data)
          end
        end
      end
    end
  end
end
