require 'app/operation'
require "parser/import"

module App
  module Parser
    module Operations
      class GetPairs < App::Operation
        def call(params)
          if params.length.zero?
            params = Hash.new([])
            params[:c1] = 'BTC'
            params[:c2] = 'USDT'
            params[:interval] = '1m'
            params[:limit] = 1
            params[:start_time] = nil
          end

          Success(params)
        end
      end
    end
  end
end
