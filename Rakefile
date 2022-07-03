# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

desc "Generates Swift source code and run its unit tests."
task :test_swift do
  sh("bin/arkana --config-filepath spec/fixtures/swift-tests.yml")
  Dir.chdir("tests/MySecrets") do
    sh("swift test")
  end
  FileUtils.rm_rf('tests')
end
