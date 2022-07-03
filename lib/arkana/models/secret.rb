# frozen_string_literal: true

require_relative "type"

# Model used to hold the metadata for a secret, such as its env var key, its protocol key, its type, and encoded value.
class Secret
  # @returns [string]
  attr_accessor :key
  # The same string as the key, except without the "environment" suffix.
  # Used in the declaration of the protocol that defines the environment secrets.
  # @returns [string]
  attr_accessor :protocol_key
  # Encoded value, formatted as a string of comma-separated hexadecimal numbers, e.g. "0x94, 0x11, 0x1b, 0x6, 0x49, 0, 0xa7"
  # @returns [string]
  attr_reader :encoded_value
  # The type of the variable, as a language-agnostic enum.
  # @returns [Type]
  attr_reader :type

  def initialize(key:, protocol_key:, encoded_value:, type:)
    @key = key
    @protocol_key = protocol_key
    @encoded_value = encoded_value
    @type = type
  end

  def environment
    return :global if key == protocol_key
    return key.delete_prefix(protocol_key) if key.start_with?(protocol_key)

    raise("Precondition failure: the protocol_key '#{protocol_key}' is not the same as the key '#{key}' nor is its prefix. This state shouldn't be possible.")
  end
end
