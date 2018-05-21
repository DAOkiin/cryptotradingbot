require 'celluloid/current'

require_relative 'actors/binance_ws'
require_relative 'actors/event_listener'

App::Container.finalize(:celluloid) do |container|
  start do

    class Root < Celluloid::Supervision::Container
      supervise type: Actors::EventListener, as: :event_listener
      supervise type: Actors::BinanceWs, as: :ws
    end

    container.register('celluloid.supervisor', Root.run!)
    container.register('celluloid.event_listener', Celluloid::Actor[:event_listener])
  end
end
