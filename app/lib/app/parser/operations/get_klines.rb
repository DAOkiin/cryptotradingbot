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
          kline1m: 'persistence.repositories.kline1m',
          construct_kline: 'operations.construct_klines',
          bus: 'bus'
        ]
        def call(params)
          begin
            open_time = kline1m.newest.close_time + 1
          rescue ROM::TupleCountMismatchError
            open_time = 1
          end
          pair = params[:c1] + params[:c2]
          options = { symbol: pair, interval: params[:interval], limit: 500, startTime: open_time }

          puts 'Started parsing exchange klines'
          puts "from #{DateTime.strptime(options[:startTime].to_s, '%Q').to_s}"
          begin
            responce = binance.klines(options)
            if responce.is_a? Array
              Celluloid::Actor[:event_listener].async.on_binance_rest_klines({klines: responce, params: params})
              options[:startTime] = responce[-1][6] + 1
              $stdout.flush
              puts "from #{DateTime.strptime(options[:startTime].to_s, '%Q').to_s}"
            else
              raise StandardError, responce
            end
            sleep 0.5
          rescue StandardError => e
            Airbrake.notify(e)
          end while responce.length == 500

          $stdout.flush
          if responce.is_a? Array
            Success(params)
          else
            Failure(responce)
          end
        end
      end
    end
  end
end
