require 'app/operation'
require "parser/import"
require "app/parser/entities/kline"

module App
  module Parser
    module Operations
      class GetKlines < App::Operation
        include App::Import[
          binance: 'exchanges.binance.rest'
        ]
        def call(symbol1, symbol2, interval = '1m', limit = 500, start_time = nil)
          pair = symbol1 + symbol2
          options = { symbol: pair, interval: interval, limit: limit }
          options[:startTime] = start_time if start_time
          responce = binance.klines(options)

          if responce.is_a? Array
            Success(
              responce.map do |k|
                App::Parser::Entities::Kline[{
                  open_time: k[0],
                  open: BigDecimal.new(k[1]),
                  high: BigDecimal.new(k[2]),
                  low: BigDecimal.new(k[3]),
                  close: BigDecimal.new(k[4]),
                  volume: BigDecimal.new(k[5]),
                  close_time: k[6],
                  symbol1: symbol1,
                  symbol2: symbol2,
                  pair: pair
                }]
              end
            )
          else
            Failure(responce)
          end
        end
      end
    end
  end
end
