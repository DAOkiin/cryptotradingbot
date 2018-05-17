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
          def call(data)
            if kline1m.create(data[:klines])
              Success("[OK] Successfully persisted #{data[:klines].size} klines")
            else
              Failure('[ERROR] Something gone wrong when persist klines')
            end
          end
        end
      end
    end
  end
end
