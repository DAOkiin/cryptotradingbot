App::Container.finalize(:exchanges) do |container|
  start do
    require 'binance'
    key = App::Container['config'].binance_key
    secret = App::Container['config'].binance_secret
    container.register('exchanges.binance.rest', Binance::Client::REST.new(api_key: key, secret_key: secret))
  end
end
