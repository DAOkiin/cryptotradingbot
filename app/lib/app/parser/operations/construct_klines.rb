require 'app/operation'
require 'parser/import'
require 'app/parser/entities/kline'

module App
  module Parser
    module Operations
      # Construct App::Parser::Entities::Kline objects from array of hashes
      # Need :source, :c1, :c2, interval
      class ConstructKlines < App::Operation
        def call(data)
          case data[:source]
          when 'binance.ws.kline'
            result = binance_ws(data)
          when 'binance.rest.kline'
            result = binance_rest(data)
          when 'redis'
            result = from_redis(data)
          end
          data[:klines] = result
          result.first.is_a?(App::Parser::Entities::Kline) ? Success(data) : Failure(result)
        end

        private

        def binance_ws(data)
          symbol = data[:params][:c1] + data[:params][:c2]
          data[:klines].map do |kline|
            k = kline['k']
            App::Parser::Entities::Kline[{
              open_time: k['t'],
              open: BigDecimal.new(k['o']),
              high: BigDecimal.new(k['h']),
              low: BigDecimal.new(k['l']),
              close: BigDecimal.new(k['c']),
              volume: BigDecimal.new(k['v']),
              close_time: k['T'],
              symbol1: data[:params][:c1],
              symbol2: data[:params][:c2],
              pair: symbol,
              interval: data[:params][:interval]
            }]
          end
        end

        def binance_rest(data)
          pair = data[:params][:c1] + data[:params][:c2]
          result = data[:klines].map do |k|
            App::Parser::Entities::Kline[{
              open_time: k[0],
              open: BigDecimal.new(k[1]),
              high: BigDecimal.new(k[2]),
              low: BigDecimal.new(k[3]),
              close: BigDecimal.new(k[4]),
              volume: BigDecimal.new(k[5]),
              close_time: k[6],
              symbol1: data[:params][:c1],
              symbol2: data[:params][:c2],
              pair: pair,
              interval: data[:params][:interval]
            }]
          end
          result
        end

        def from_redis(data)
          data[:klines].map do |k|
            App::Parser::Entities::Kline[{
              open_time: k['open_time'],
              open: BigDecimal.new(k['open']),
              high: BigDecimal.new(k['high']),
              low: BigDecimal.new(k['low']),
              close: BigDecimal.new(k['close']),
              volume: BigDecimal.new(k['volume']),
              close_time: k['close_time'],
              symbol1: k['symbol1'],
              symbol2: k['symbol2'],
              pair: k['pair'],
              interval: k['interval']
            }]
          end
        end
      end
    end
  end
end
