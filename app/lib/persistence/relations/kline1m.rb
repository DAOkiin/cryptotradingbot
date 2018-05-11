module Persistence
  module Relations
    class Kline1m < ROM::Relation[:sql]
      schema(:kline1m, infer: true)
    end
  end
end
