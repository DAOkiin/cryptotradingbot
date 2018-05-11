require 'app/operation'
require 'parser/import'
require 'app/parser/entities/kline'

module App
  module Parser
    module Operations
      # Get klines from binance REST API
      # Return array of App::Parser::Entities::Kline objects
      # or error message if recived
      class GetKlines < App::Operation
        include App::Import[
          binance: 'exchanges.binance.rest',
          kline1m: 'persistence.repositories.kline1m'
        ]
        def call(data)
          puts "get_klines. #{data[:random21]}"
          open_time = kline1m.newest.close_time + 1
          pair = data[:c1] + data[:c2]
          options = { symbol: pair, interval: data[:interval], limit: 500, startTime: open_time }
          result = []
          puts 'Started parsing exchange klines'
          print "from #{DateTime.strptime(options[:startTime].to_s, '%Q').to_s}", "\r"
          begin
            responce = binance.klines(options)

            if responce.is_a? Array
              result += responce
              options[:startTime] = responce[-1][6] + 1
              $stdout.flush
              print "from #{DateTime.strptime(options[:startTime].to_s, '%Q').to_s}", "\r"
            else
              raise StandardError, responce
            end

            sleep 0.5
          rescue StandardError => e
            Airbrake.notify(e)
          end while responce.length == 500
          $stdout.flush
          print "\nAll done\n"
          if responce.is_a? Array
            puts result.size
            data[:rest_klines] += result
            data[:source] = 'binance.rest.kline'
            Success(data)
          else
            Failure(responce)
          end
        end
      end
    end
  end
end
