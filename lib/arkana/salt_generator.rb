# frozen_string_literal: true

require "securerandom" unless defined?(SecureRandom)
require_relative "models/salt"

# Responsible for generating the salt.
module SaltGenerator
  SALT_LENGTH = 64

  # Generates and returns a new Salt object.
  #
  # @return [Salt] the salt that was just generated.
  def self.generate
    chars = SecureRandom.random_bytes(SALT_LENGTH).chars # Convert array of random bytes to array of characters
    codepoints = chars.map(&:ord) # Convert each character to its codepoint representation
    Salt.new(raw: codepoints)
  end
end
