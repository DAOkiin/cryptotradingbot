require 'app/transaction'

module App
  module Parser
    module Transactions
      class PersistUpdatedData
        include App::Transaction
        step :get_unsaved_data, with: 'operations.redis.get_unsaved_data'
        step :construct_klines, with: 'operations.construct_klines'
        step :persist_klines, with: 'operations.persist.kline1m'
        step :change_cache_status, with: 'operations.redis.cache_status'
      end
    end
  end
end
