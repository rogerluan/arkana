# frozen_string_literal: true

# Utilities to reduce the amount of boilerplate code in `.dart.erb` template files.
module DartTemplateHelper
  def self.dart_type(type)
    case type
      when :string then "String"
      when :boolean then "bool"
      when :integer then "int"
      else raise "Unknown variable type '#{type}' received."
    end
  end

  def self.dart_decode_function(type)
    case type
      when :string then "decode"
      when :boolean then "decodeBoolean"
      when :integer then "decodeInt"
      else raise "Unknown variable type '#{type}' received."
    end
  end

  def self.relative_path_to_source(src)
    slash_count = src.count("/")
    padding = src.empty? ? 1 : 2
    "../" * (slash_count + padding)
  end
end
