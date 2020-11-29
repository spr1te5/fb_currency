Sidekiq.configure_client do |config|
  config.redis = {
    namespace: Figaro.env.app_namespace,
    size: Figaro.env.sidekiq_pool_size.to_i,
    url: Figaro.env.sidekiq_redis_url
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    namespace: Figaro.env.app_namespace,
    size: Figaro.env.sidekiq_pool_size.to_i,
    url: Figaro.env.sidekiq_redis_url
  }
end