require 'repository'

module App
  module Parser
    module Persistence
      module Repositories
        class Kline1m < Repository[:kline1m]
          commands :create, update: :by_pk, delete: :by_pk

          def all
            kline1m.as_hash
          end

          def by_id(id)
            kline1m.by_pk(id).one!
          end

          def count
            kline1m.count
          end

          def first
            kline1m.first
          end

          def last
            kline1m.last
          end

          def newest
            kline1m.where(open_time: kline1m.max(:open_time)).one!
          end

          def where(params)
            kline1m.where params
          end

          def where_big(val)
            kline1m.where {open_time > val}
          end
        end
      end
    end
  end
end
