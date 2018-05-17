require 'repository'

module App
  module Parser
    module Persistence
      module Repositories
        class Kline5m < Repository[:kline5m]
          commands :create, update: :by_pk, delete: :by_pk

          def all
            kline5m.as_hash
          end

          def by_id(id)
            kline5m.by_pk(id).one!
          end

          def count
            kline5m.count
          end

          def first
            kline5m.first
          end

          def last
            kline5m.last
          end
        end
      end
    end
  end
end
