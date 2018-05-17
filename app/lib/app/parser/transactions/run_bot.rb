require 'app/transaction'

module App
  module Parser
    module Transactions
      class RunBot
        include App::Transaction

        step :clear_cache
        step :get_pairs, with: 'operations.get_pairs'
        step :cache_all_kline1m, with: 'operations.cache_all_kline1m'
        step :run_ws, with: 'operations.run_ws'
        step :get_klines, with: 'operations.get_klines'
        step :transaction_result

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

        def transaction_result(result)
          puts '[OK] Successfully completed synchronization'
          Success(nil)
        end
      end
    end
  end
end
