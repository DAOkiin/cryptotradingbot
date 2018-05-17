require 'app/operation'
require "parser/import"

module App
  module Parser
    module Operations
      class FilterKlines < App::Operation
        include App::Import[
          redis: 'redis.binance'
        ]
        def call(data)
          prefix = data[:klines][0].pair + ':' + 'kline' + data[:klines][0].interval + ':'

          # Remove last kline if its close time is greater than the current time
          data[:klines].pop if data[:klines][-1].close_time > DateTime.now.strftime('%Q').to_i

          # Remove all existed klines
          data[:klines].delete_if { |kline| redis.exists(prefix + kline.open_time.to_s) }

          Success(data)
        end
      end
    end
  end
end
