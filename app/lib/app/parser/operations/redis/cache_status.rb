require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Redis
        # Set cache persistence status
        class CacheStatus < App::Operation
          include App::Import[
            redis: 'redis.binance'
          ]
          def call(params)
            puts params
            responce = redis.set('persist', params[:persisted] == true)
            if responce == 'OK'
              Success(params)
            else
              Failure(responce)
            end
          end
        end
      end
    end
  end
end
