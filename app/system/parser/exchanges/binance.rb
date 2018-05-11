App::Container.finalize(:exchanges) do |container|
  start do
    require 'binance'
    key = App::Container['config'].binance_key
    secret = App::Container['config'].binance_secret
    container.register('exchanges.binance.rest', Binance::Client::REST.new(api_key: key, secret_key: secret))
    container.register('exchanges.binance.ws', Binance::Client::WebSocket.new)
  end
end
