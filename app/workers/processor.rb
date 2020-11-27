# frozen_string_literal: true

module Processor
  extend Lowkiq::Worker

  self.queue_name = 'Processor'
  self.max_retry_count = 25
  self.shards_count = 75
  self.batch_size = 30

  def self.retry_in(count)
    fibonacci(count)
  end

  def self.perform(batch)
    batch.each do |id, payloads|
      # set_current_account(payloads[0][:a_id])
      payloads.each do |payload|
        puts payload.to_s
        start_time = Time.now.to_f * 1000
        $logger.info("Starting Processor perform method, uuid: #{payload[:request_id]}, at: #{start_time}")
        # Business requirement
        sleep(0.1)
        end_time = Time.now.to_f * 1000
        $logger.info("Completing Processor perform method, uuid: #{payload[:request_id]}, at: #{end_time}, p_time: #{end_time - start_time}")
      end
      # reset_current_account
    end
  ensure
    # reset_current_account
  end

  def self.fibonacci(num)
    return num if (0..1).include?(num)

    (fibonacci(num - 1) + fibonacci(num - 2))
  end
end
