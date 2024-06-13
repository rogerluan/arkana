# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in arkana.gemspec
gemspec

gem "bundler", "< 2.5" # 2.4.x is the latest that supports Ruby 2.7, which is the minimum required by Arkana
gem "rake"
gem "rexml", "<3.2.7" # There's a bug preventing this from building on GHA arm64 CI. See: https://github.com/ruby/strscan/issues/104
gem "rspec"
gem "rubocop"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "tty-prompt"
