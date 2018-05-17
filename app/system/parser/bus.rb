App::Container.finalize(:bus) do |container|
  start do
    require 'dry/events/publisher'

    class EventHandler
      include Dry::Events::Publisher[:bus]

      register_event('binance.ws.kline')
    end

    container.register('bus', EventHandler.new)
  end
end
