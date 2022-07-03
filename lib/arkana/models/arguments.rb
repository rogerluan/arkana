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

  def initialize
    # Default values
    @config_filepath = ".arkana.yml"
    @dotenv_filepath = ".env" if File.exist?(".env")
    @flavor = nil

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
    end.parse!
  end
end
