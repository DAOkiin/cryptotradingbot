require 'app/transaction'

module App
  module Parser
    module Transactions
      class RunBot
        include App::Transaction

        step :clear_cache
        step :set_cache_status, with: 'operations.redis.cache_status'
        step :get_pairs, with: 'operations.get_pairs'
        step :run_ws, with: 'operations.run_ws'
        step :get_klines, with: 'operations.get_klines'
        step :cache_klines, with: 'transactions.cache_klines'
        step :persist_new_data, with: 'transactions.persist_updated_data'
        # step :synchronize, with: 'operations.synchronize'
        # step :run_indicators, with: 'operations.run_indicators'
        # step :run_test_strategies, with: 'operations.run_test_strategies'

        def clear_cache(params)
          params = Hash.new([]) if params.empty?
          redis_responce = App::Container['redis'].flushall
          if redis_responce == 'OK'
            print "\nCache cleared\n"
            Success(params)
          else
            Airbrake.notify("Failed to clear redis, #{redis_responce}")
            Failure(redis_responce)
          end
        end
      end
    end
  end
end
