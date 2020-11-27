# frozen_string_literal: true

module Manager
  extend Lowkiq::Worker

  self.queue_name = 'Manager'
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
        start_time = Time.now.to_f * 1000
        $logger.info("Starting Manager perform method, uuid: #{payload[:request_id]}, at: #{start_time}")
        # find record in redis with key as id
        # create / update object in mysql based on existence of key in redis
        puts payload.to_s
        object_id = create_or_update(payload)
        Processor.perform_async(message(payload, object_id))
        end_time = Time.now.to_f * 1000
        $logger.info("Completing Manager perform method, uuid: #{payload[:request_id]}, at: #{end_time}, p_time: #{end_time - start_time}")
      end
      # reset_current_account
    end
  ensure
    # reset_current_account
  end

  private

  def self.create_or_update(_payload)
    # Business requirement here. Mocked with object id.
    Random.rand(100000)
  end

  def self.message(payload, object_id)
    [
      {
        id: "ALT_PROC:#{object_id}",
        payload: {
            a_id: payload[:a_id],
            object_id: object_id,
            request_id: payload[:request_id]
        },
        score: Time.now.to_i
      }
    ]
  end

  def self.fibonacci(num)
    return num if (0..1).include?(num)

    (fibonacci(num - 1) + fibonacci(num - 2))
  end

end
