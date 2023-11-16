# frozen_string_literal: true

# A namespace that defines language-agnostic variable types.
module Type
  STRING = :string
  BOOLEAN = :boolean
  INTEGER = :integer

  def self.new(string_value:)
    case string_value
      when "true", "false"
        BOOLEAN
      when /^\d+$/
        # Handles cases like "0001" which should be interpreted as strings
        return STRING if string_value.to_i.to_s != string_value
        # Handle int overflow
        return STRING if string_value.to_i > 2**31 - 1
        return INTEGER
      else
        STRING
    end
  end
end
