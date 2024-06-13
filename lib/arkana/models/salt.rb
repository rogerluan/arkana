# frozen_string_literal: true

require_relative "type"

# Model used to hold the metadata for the salt bytes.
class Salt
  attr_reader :raw
  # Salt, formatted as a string of comma-separated hexadecimal numbers, e.g. "0x94, 0x11, 0x1b, 0x6, 0x49, 0, 0xa7"
  attr_reader :formatted

  def initialize(raw:)
    @raw = raw
    formatted_salt = raw.map do |element|
      # Warning: this might be specific to Swift implementation. When generating code for other languages, beware.
      format("%#x", element)
    end
    @formatted = formatted_salt.join(", ")
  end
end
