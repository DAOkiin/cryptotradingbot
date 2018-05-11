require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Redis
        # Check if cache persisted
        class CheckStatus < App::Operation
          include App::Import[
            redis: 'redis.binance'
          ]
          def call(params)
            responce = redis.get 'persist'
            responce == 'true' ? Success(params) : Failure(responce)
          end
        end
      end
    end
  end
end
