# frozen_string_literal: true

module Logger
  module App
    def lowkiq_bb
      logger.info(msg)
    end

    def logger(logger)
      $logger ||= begin
        l = Logger.new(Rails.root.join("log/#{logger}.log"))
        l.formatter = MockLogFormatter
      end
    end
  end
end
