App::Container.finalize(:celluloid) do |container|
  start do
    require 'celluloid'

    class WSContainer
      include Celluloid
      trap_exit :actor_died

      def actor_died(actor, reason)
        puts "Oh no! #{actor.inspect} has died because of a #{reason.class}"
      end

      def start_ws(params, client, methods = {})
        puts "celluloid.start_ws. #{params[:random31]}"
        EM.run do
          # Create event handlers
          methods[:open] ||=    proc { print "\nconnected\n" }
          methods[:message] ||= proc { |e| puts e.data }
          methods[:error] ||=   proc { |e| Airbrake.notify(e) }
          methods[:close] ||=   proc { print "\nclosed\n" }

          symbol = params[:c1] + params[:c2]
          interval = params[:interval]
          # # kline takes an additional named parameter
          client.kline symbol: symbol, interval: interval, methods: methods
        end
      end
    end

    class EventListener
      include Celluloid

      def on_binance_ws_kline(event)
        data = JSON.parse(event[:message].data)
        if data['e'] == 'kline'
          if data['k']['x']
            event[:params][:source] = 'binance.ws.kline'
            event[:params][:ws_klines] += [data['k']]
            App::Container['transactions.cache_klines'].call(event[:params])
            App::Container['transactions.persist_cached_data'].call event[:params]
          end
        else
          Airbrake.notify('Invalid WS data', data)
        end
      end
    end

    class Root < Celluloid::SupervisionGroup
      supervise EventListener, as: :event_listener
      supervise WSContainer, as: :ws
    end

    container.register('celluloid.supervisor', Root.run!)
    container.register('celluloid.event_listener', EventListener.new)
  end
end
