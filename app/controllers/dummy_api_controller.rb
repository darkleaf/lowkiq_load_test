=begin

curl -XPOST 'http://localhost:7871/dummy_api/generate_load' -d '{
 "a_id": 1,
 "int_id": 2,
 "string1": "str1",
 "string2": "str2",
 "string3": "str3",

}'


=end

class DummyApiController < ApplicationController
  def generate_load
    start_time = Time.now.to_f * 1000
    $logger.info("Starting DummyApiController generate_load method, uuid: #{request.uuid}, at: #{start_time}")
    Manager.perform_async(message)
    end_time = Time.now.to_f * 1000
    $logger.info("Completing DummyApiController generate_load method, uuid: #{request.uuid}, at: #{end_time}, resp_time: #{end_time - start_time}")
    render json: { message: 'Accepted' }, status: :accepted
  end

  private

  def message
    [
      {
        id: key,
        payload: payload,
        score: timestamp.to_time.to_i
      }
    ]
  end

  def key
    string3 ||= params[:string3]
    hash = Digest::SHA2.hexdigest("#{params[:int_id]}:#{params[:string1]}:#{params[:string2]}:#{string3}")
    "#{params[:a_id]}:#{hash}"
  end

  def payload
    # Payload will have more fields. For this example, I used minimum fields.
    {
      a_id: params[:a_id],
      int_id: params[:int_id],
      string1: params[:string1],
      string2: params[:string2],
      string3: params[:string3],
      timestamp: timestamp,
      request_id: request.uuid,
      enqueued_at: Time.now.to_f * 1000
    }.to_h.symbolize_keys
  end

  def timestamp
    @timestamp ||= begin
      DateTime.parse(params[:timestamp])
    rescue
      Time.now.iso8601
    end
  end

end
