# frozen_string_literal: true

# Utilities to reduce the amount of boilerplate code in `.kt.erb` template files.
module KotlinTemplateHelper
  def self.kotlin_type(type)
    case type
      when :string then "String"
      when :boolean then "Boolean"
      when :integer then "Int"
      else raise "Unknown variable type '#{type}' received.'"
    end
  end

  def self.kotlin_decode_function(type)
    case type
      when :string then "decode"
      when :boolean then "decodeBoolean"
      when :integer then "decodeInt"
      else raise "Unknown variable type '#{type}' received.'"
    end
  end
end
