require 'app/transaction'

module App
  module Parser
    module Transactions
      # Construct Klines entities from raw data and save them in redis
      class NewKlines
        include App::Transaction
        step :construct_klines, with: 'operations.construct_klines'
        step :filter_klines, with: 'operations.filter_klines'
        step :cache_klines, with: 'operations.redis.cache_klines'
        step :persist_klines, with: 'operations.persist.kline1m'
        step :transaction_result

        def transaction_result(result)
          puts result
          Success(nil)
        end
      end
    end
  end
end
