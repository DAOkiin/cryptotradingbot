App::Container.finalize(:redis) do |container|
  start do
    require 'redis'
    require 'redis-namespace'
    redis = Redis.new
    container.register('redis', redis)
    container.register('redis.binance', Redis::Namespace.new(:binance, :redis => redis))
    # container.register('redis.binance', Redis::Namespace.new(:binance, :redis => redis_connection))
  end
end
