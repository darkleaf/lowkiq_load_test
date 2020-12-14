# frozen_string_literal: true

Lowkiq.poll_interval = 1
Lowkiq.client_pool_size = 500
Lowkiq.pool_timeout = 5
Lowkiq.threads_per_node = 100

# Dir["#{Rails.root}/app/workers/*.rb"].each do |file|
#   require_dependency file
# end

Manager
Processor

Lowkiq.on_server_init = lambda do
  puts "Lowkiq Server Started..."
end
