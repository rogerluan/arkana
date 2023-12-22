# frozen_string_literal: true

require "arkana/helpers/string"

# The encoder is responsible for finding the env vars for given keys, encoding them, and creating Secrets based on the generated data.
module Encoder
  # Fetches values of each key from ENV, and encodes them using the given salt.
  #
  # @return [Secret[]] an array of Secret objects, which contain their keys and encoded values.
  def self.encode!(keys:, salt:, current_flavor:, environments:)
    keys.map do |key|
      secret = find_secret!(key: key, current_flavor: current_flavor)
      encoded_value = encode(secret, salt.raw)
      secret_type = Type.new(string_value: secret)
      protocol_key = protocol_key(key: key, environments: environments)
      Secret.new(key: key, protocol_key: protocol_key, encoded_value: encoded_value, type: secret_type)
    end
  end

  # Encodes the given string, using the given cipher.
  def self.encode(string, cipher)
    bytes = string.encode("utf-8")
    result = []
    (0...bytes.length).each do |index|
      byte = bytes[index].ord # Convert to its codepoint representation
      result << (byte ^ cipher[index % cipher.length]) # XOR operation with a value of the cipher array.
    end

    encoded_key = []
    result.each do |element|
      # Warning: this might be specific to Swift implementation. When generating code for other languages, beware.
      encoded_key << format("%#x", element) # Format the binary number to "0xAB" format.
    end

    encoded_key.join(", ")
  end

  def self.find_secret!(key:, current_flavor:)
    flavor_key = "#{current_flavor.capitalize_first_letter}#{key}" if current_flavor
    secret = ENV[flavor_key] if flavor_key
    secret ||= ENV[key] || raise("Secret '#{flavor_key || key}' was declared but couldn't be found in the environment variables nor in the specified dotenv file.")
    secret
  end

  def self.protocol_key(key:, environments:)
    environments.filter_map do |env|
      key.delete_suffix(env) if key.end_with?(env)
    end.first || key
  end
end
