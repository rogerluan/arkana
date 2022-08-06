# frozen_string_literal: true

# Enumerable extensions and utilities.
module Enumerable
  # NOTE: This is a backport of Ruby 2.7 filter_map. This method can be deleted when the minimum target Ruby version is 2.7
  # We're not gating against redefining the method (e.g. via `unless Enumerable.method_defined? :filter_map`) because this
  # would reduce the code coverage when analysing code coverage on Ruby versions >= 2.7
  def filter_map
    return to_enum(:filter_map) unless block_given?

    each_with_object([]) do |item, res|
      processed = yield(item)
      res << processed if processed
    end
  end
end
