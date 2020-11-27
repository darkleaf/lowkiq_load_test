# frozen_string_literal: true

class Lformatter < Logger::Formatter
  def self.call(_severity, _time, _program_name, msg)
    "#{msg}\n"
  end
end