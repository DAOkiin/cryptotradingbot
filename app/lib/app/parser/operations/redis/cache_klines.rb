require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Redis
        # Save kline to redis with binance:BTCUSDT:kline1m:120390128309 name
        class CacheKlines < App::Operation
          include App::Import[
            redis: 'redis.binance'
          ]
          def call(data)
            unless data[:klines].empty?
              pair = data[:klines][0].pair
              interval = data[:klines][0].interval
              begin
                data[:klines].each do |k|
                  open_time = k.open_time.to_s
                  pref = pair + ':' + 'kline' + interval + ':' + open_time
                  redis.set(pref, k.to_h.to_json)
                end
              puts "[OK] Successfully cached #{data[:klines].size} klines"
              rescue NoMethodError => e
                puts e
              end
            end
            Success(data)
          end
        end
      end
    end
  end
end
