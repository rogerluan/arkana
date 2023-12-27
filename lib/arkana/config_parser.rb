# frozen_string_literal: true

require "yaml" unless defined?(YAML)
require_relative "models/config"
require_relative "helpers/ui"

# The config parser is responsible for parsing user CLI arguments, reading the config file and returning a `Config` object.
module ConfigParser
  # Parses the config file defined by the user (if any), returning a Config object.
  #
  # @return [Config] the config parsed from the user's options.
  def self.parse(arguments)
    yaml = YAML.load_file(arguments.config_filepath)
    config = Config.new(yaml)
    config.include_environments(arguments.include_environments)
    config.current_flavor = arguments.flavor
    config.current_lang = arguments.lang
    config.dotenv_filepath = arguments.dotenv_filepath
    UI.warn("Dotenv file was specified but couldn't be found at '#{config.dotenv_filepath}'") if config.dotenv_filepath && !File.exist?(config.dotenv_filepath)
    config
  end
end
