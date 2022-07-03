# frozen_string_literal: true

# String extensions and utilities.
class String
  # Returns a string converted from an assumed PascalCase, to camelCase.
  def camel_case
    return self if empty?

    copy = dup
    copy[0] = copy[0].downcase
    copy
  end

  # Returns a string with its first character capitalized.
  def capitalize_first_letter
    return self if empty?

    copy = dup
    copy[0] = copy[0].upcase
    copy
  end
end
