# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "tty-prompt"
require "tmpdir"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

desc "Generates Swift source code and run its unit tests."
task :test_swift do
  config_file_default = File.absolute_path("spec/fixtures/swift-tests.yml")
  config_file_no_infer_types = File.absolute_path("spec/fixtures/swift-tests-with-no-infer-types.yml")
  config_file_array = [config_file_default, config_file_no_infer_types]
  dotenv_file = File.absolute_path("spec/fixtures/.env.fruitloops")
  config_file_array.each do |config_file|
    with_temp_dir do |temp_dir|
      puts "Current working directory: #{temp_dir}"
      sh("ARKANA_RUNNING_CI_INTEGRATION_TESTS=true arkana --config-filepath #{config_file} --dotenv-filepath #{dotenv_file} --include-environments dev,staging")
      Dir.chdir("tests/MySecrets")
      sh("swift test")
    end
  end
end

desc "Generates Kotlin source code and run its unit tests."
task :test_kotlin do
  config_file_default = File.absolute_path("spec/fixtures/kotlin-tests.yml")
  config_file_no_infer_types = File.absolute_path("spec/fixtures/kotlin-tests-with-no-infer-types.yml")
  config_file_array = [config_file_default, config_file_no_infer_types]
  dotenv_file = File.absolute_path("spec/fixtures/.env.fruitloops")
  directory_to_copy = File.absolute_path("spec/fixtures/kotlin")
  config_file_array.each do |config_file|
    with_temp_dir do |temp_dir|
      puts "Current working directory: #{temp_dir}"
      FileUtils.copy_entry(directory_to_copy, "tests")
      sh("ARKANA_RUNNING_CI_INTEGRATION_TESTS=true arkana --lang kotlin --config-filepath #{config_file} --dotenv-filepath #{dotenv_file} --include-environments dev,staging")
      Dir.chdir("tests")
      sh("./gradlew test")
    end
  end
end

desc "Sets lib version to the semantic version given, and push it to remote."
task :bump, [:v] do |_t, args|
  version = args[:v] || raise("A version is required. Pass it like `rake bump[1.2.3]`")
  next unless TTY::Prompt.new.yes?("Would you like to set the new version of the app to be '#{version}'?")

  version_filename = "lib/arkana/version.rb"
  version_file_contents = File.read(version_filename)
  new_version_file_contents = version_file_contents.gsub(/VERSION = "(?:.*)"/, "VERSION = \"#{version}\"")
  File.open(version_filename, "w") { |file| file.puts new_version_file_contents }
  sh("bundle install")
  sh("git add #{version_filename} Gemfile.lock")
  sh("git commit -m 'Bump app version to v#{version}.'")
  sh("git push origin")
end

# Utilities

# Run tests in a different folder because when running in the same root folder as the gem,
# there can be "relative_require" that happen to work in the test but wouldn't work when installing the gem in a different project.
def with_temp_dir
  Dir.mktmpdir do |temp_dir|
    Dir.chdir(temp_dir) do
      yield temp_dir
    end
  end
end
