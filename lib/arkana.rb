# frozen_string_literal: true

require_relative "arkana/config_parser"
require_relative "arkana/encoder"
require_relative "arkana/helpers/dotenv_helper"
require_relative "arkana/helpers/ui"
require_relative "arkana/models/template_arguments"
require_relative "arkana/salt_generator"
require_relative "arkana/swift_code_generator"
require_relative "arkana/kotlin_code_generator"
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
        should_infer_types: config.should_infer_types,
      )
      global_secrets = Encoder.encode!(
        keys: config.global_secrets,
        salt: salt,
        current_flavor: config.current_flavor,
        environments: config.environments,
        should_infer_types: config.should_infer_types,
      )
    rescue StandardError => e
      # TODO: Improve this by creating an Env/Debug helper
      UI.warn("Something went wrong when parsing and encoding your secrets.")
      UI.warn("Current Flavor: #{config.current_flavor}")
      UI.warn("Dotenv Filepath: #{config.dotenv_filepath}")
      UI.warn("Config Filepath: #{arguments.config_filepath}")
      UI.crash(e.message)
    end
    template_arguments = TemplateArguments.new(
      environment_secrets: environment_secrets,
      global_secrets: global_secrets,
      config: config,
      salt: salt,
    )

    generator = case config.current_lang.downcase
      when "swift" then SwiftCodeGenerator
      when "kotlin" then KotlinCodeGenerator
      else UI.crash("Unknown output lang selected: #{config.current_lang}")
    end

    generator.method(:generate).call(
      template_arguments: template_arguments,
      config: config,
    )
  end
end
