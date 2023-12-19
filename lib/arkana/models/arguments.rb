# frozen_string_literal: true

require "optparse"

# Model that parses and documents the CLI options, using `OptionParser`.
class Arguments
  # @returns [string]
  attr_reader :config_filepath
  # @returns [string]
  attr_reader :dotenv_filepath
  # @returns [string]
  attr_reader :flavor
  # @returns [Array<string>]
  attr_reader :include_environments
  # @returns [string]
  attr_reader :lang

  def initialize
    # Default values
    @config_filepath = ".arkana.yml"
    @dotenv_filepath = ".env" if File.exist?(".env")
    @flavor = nil
    @include_environments = nil
    @lang = "swift"

    OptionParser.new do |opt|
      opt.on("-c", "--config-filepath /path/to/your/.arkana.yml", "Path to your config file. Defaults to '.arkana.yml'") do |o|
        @config_filepath = o
      end
      opt.on("-e", "--dotenv-filepath /path/to/your/.env", "Path to your dotenv file. Defaults to '.env' if one exists.") do |o|
        @dotenv_filepath = o
      end
      opt.on("-f", "--flavor FrostedFlakes", "Flavors are useful, for instance, when generating secrets for white-label projects. See the README for more information") do |o|
        @flavor = o
      end
      opt.on("-i", "--include-environments debug,release", "Optionally pass the environments that you want Arkana to generate secrets for. Useful if you only want to build a certain environment, e.g. just Debug in local machines, while only building Staging and Release in CI. Separate the keys using a comma, without spaces. When ommitted, Arkana generate secrets for all environments.") do |o|
        @include_environments = o.split(",")
      end
      opt.on("-l", "--lang kotlin", "Language to produce keys for, e.g. kotlin, swift. Defaults to swift. See the README for more information") do |o|
        @lang = o
      end
    end.parse!
  end
end
