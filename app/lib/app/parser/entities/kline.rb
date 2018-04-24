# auto_register: false

require "types"

module App
  module Parser
    module Entities
      class Kline < Dry::Struct
        attribute :open_time, Types::Strict::Int
        attribute :open, Types::Strict::Decimal
        attribute :high, Types::Strict::Decimal
        attribute :low, Types::Strict::Decimal
        attribute :close, Types::Strict::Decimal
        attribute :volume, Types::Strict::Decimal
        attribute :close_time, Types::Strict::Int
        attribute :symbol1, Types::Strict::String
        attribute :symbol2, Types::Strict::String
        attribute :pair, Types::Strict::String
      end
    end
  end
end
