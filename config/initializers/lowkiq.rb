# frozen_string_literal: true

Lowkiq.poll_interval = 1
Lowkiq.client_pool_size = 500
Lowkiq.pool_timeout = 5
Lowkiq.threads_per_node = 100

# handles worker shards across multiple process threads
Lowkiq.build_splitter = -> () do
  Lowkiq.build_by_node_splitter(
    ENV.fetch('LOWKIQ_NUMBER_OF_NODES').to_i,
    ENV.fetch('LOWKIQ_NODE_NUMBER').to_i
  )
end if Rails.env.production? || Rails.env.staging?

Dir["#{Rails.root}/app/workers/*.rb"].each do |file|
  require_dependency file
end

Lowkiq.on_server_init = lambda do
  puts "Lowkiq Server Started..."
end