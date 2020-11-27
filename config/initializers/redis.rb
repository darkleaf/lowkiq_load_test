# frozen_string_literal: true

config = YAML.load_file("#{Rails.root}/config/redis.yml")[Rails.env].with_indifferent_access
connection = Redis.new(config)

$redis = Redis::Namespace.new(config[:namespace][:others], redis: connection, warning: false)

if Rails.env.production?
  Lowkiq.redis = -> { Redis.new(config) }
else
  $lowkiq_redis = Redis::Namespace.new(config[:namespace][:lowkiq], redis: Redis.new(config), warning: false)
  Lowkiq.redis = -> { $lowkiq_redis }
end
