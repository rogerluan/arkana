# frozen_string_literal: true

# Utilities to reduce the amount of boilerplate code in `.swift.erb` template files.
module SwiftTemplateHelper
  def self.swift_type(type)
    case type
      when :string then "String"
      when :boolean then "Bool"
      when :integer then "Int"
      else raise "Unknown variable type '#{type}' received.'"
    end
  end

  def self.protocol_getter(declaration_strategy)
    case declaration_strategy
      when "lazy var" then "mutating get"
      when "var", "let" then "get"
      else raise "Unknown declaration strategy '#{declaration_strategy}' received.'"
    end
  end
end
