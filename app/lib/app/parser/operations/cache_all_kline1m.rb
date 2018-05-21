require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      # Save all kline to redis
      class CacheAllKline1m < App::Operation
        include App::Import[
          kline1m: 'persistence.repositories.kline1m',
          redis: 'redis.binance'
        ]
        def call(params)
          puts params
          print "\nLoad all kline1m from DB. Wait for a while..."
          all_klines = {1 => kline1m.last.to_h} # kline1m.all or select only last {1 => kline1m.last.to_h}
          print "\nDone. Loaded #{all_klines.size} records from Postgres"

          print "\nCache all klines in redis..."
          prefix = params[:c1] + params[:c2] + ':' + 'kline' + params[:interval] + ':'
          memo = 0
          all_klines.each_value do |kline|
            memo += 1
            k_name = prefix + kline[:open_time].to_s
            redis.set(k_name, kline.to_json)
          end
          print "\nDone. Cached #{memo} klines\n"

          Success(params)
        end
      end
    end
  end
end
