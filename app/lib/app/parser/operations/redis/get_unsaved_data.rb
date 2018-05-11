require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Redis
        # Check if cache persisted
        class GetUnsavedData < App::Operation
          include App::Import[
            redis: 'redis',
            kline1m: 'persistence.repositories.kline1m'
          ]
          def call(params)
            pair = params[:c1] + params[:c2]
            last_open_time = kline1m.newest.open_time
            all_cached_keys = redis.keys "binance:#{pair}:kline#{params[:interval]}:*"
            unsaved_keys = all_cached_keys.map do |key|
              key if key.split(':')[-1].to_i > last_open_time
            end.compact

            params[:klines] = redis.mget(unsaved_keys).map{ |kline| JSON.parse(kline) }
            params[:source] = 'redis'
            Success(params)
          end
        end
      end
    end
  end
end
