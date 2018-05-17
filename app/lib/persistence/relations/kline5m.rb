module Persistence
  module Relations
    class Kline5m < ROM::Relation[:sql]
      schema(:kline5m, infer: true)
    end
  end
end
