# frozen_string_literal: true

require_relative "arkana/config_parser"
require_relative "arkana/encoder"
require_relative "arkana/helpers/dotenv_helper"
require_relative "arkana/models/template_arguments"
require_relative "arkana/salt_generator"
require_relative "arkana/swift_code_generator"
require_relative "arkana/version"

# Top-level namespace for Arkana's execution entry point. When ran from CLI, `Arkana.run` is what is invoked.
module Arkana
  def self.run(arguments)
    config = ConfigParser.parse(arguments)
    salt = SaltGenerator.generate
    DotenvHelper.load(config)

    begin
      environment_secrets = Encoder.encode!(
        keys: config.environment_keys,
        salt: salt,
        current_flavor: config.current_flavor,
        environments: config.environments,
      )
      global_secrets = Encoder.encode!(
        keys: config.global_secrets,
        salt: salt,
        current_flavor: config.current_flavor,
        environments: config.environments,
      )
    rescue StandardError => e
      # TODO: Improve this by creating an Env/Debug helper
      puts("Something went wrong when parsing and encoding your secrets.")
      puts("Current Flavor: #{config.current_flavor}")
      puts("Dotenv Filepath: #{config.dotenv_filepath}")
      puts("Config Filepath: #{arguments.config_filepath}")
      raise e
    end
    template_arguments = TemplateArguments.new(
      environment_secrets: environment_secrets,
      global_secrets: global_secrets,
      config: config,
      salt: salt,
    )
    SwiftCodeGenerator.generate(
      template_arguments: template_arguments,
      config: config,
    )
  end
end
