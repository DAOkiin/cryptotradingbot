require 'app/transaction'

module App
  module Parser
    module Transactions
      class PersistCachedData
        include App::Transaction
        step :check_cache_status, with: 'operations.redis.check_status'
        step :construct_klines, with: 'operations.construct_klines'
        step :persist_cached_data, with: 'operations.persist.kline1m'
      end
    end
  end
end
