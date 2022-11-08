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
      INTEGER
    else
      STRING
    end
  end
end
