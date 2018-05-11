require 'app/operation'
require 'parser/import'

module App
  module Parser
    module Operations
      module Persist
        # Save kline to Postgres
        class Kline1m < App::Operation
          include App::Import[
            kline1m: 'persistence.repositories.kline1m'
          ]
          def call(params)
            kline1m.create params[:klines]
            params[:persisted] = true
            Success(params)
          end
        end
      end
    end
  end
end
