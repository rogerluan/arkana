# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in arkana.gemspec
gemspec

gem "bundler", "< 2.5" # 2.4.x is the latest that supports Ruby 2.7, which is the minimum required by Arkana
gem "rake"
gem "rspec"
gem "rubocop"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "strscan", "~> 1", "< 3" # Required by REXML, which is a dependency of RuboCop. There's a bug on v3 preventing it from building on arm64
gem "tty-prompt"
