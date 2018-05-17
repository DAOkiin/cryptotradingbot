require 'app/transaction'

module App
  module Parser
    module Transactions
      # Construct Klines entities from raw data and save them in redis
      class CacheKlines
        include App::Transaction
        step :construct_klines, with: 'operations.construct_klines'
        step :cache_klines, with: 'operations.redis.save_klines'
      end
    end
  end
end
