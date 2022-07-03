# frozen_string_literal: true

# Utilities to reduce the amount of boilerplate code in `.swift.erb` template files.
module SwiftTemplateHelper
  def self.swift_type(type)
    case type
    when :string then "String"
    when :boolean then "Bool"
    else raise "Unknown variable type '#{type}' received.'"
    end
  end
end
