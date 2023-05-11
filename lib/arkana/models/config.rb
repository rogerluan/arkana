# frozen_string_literal: true

# Model used to hold all the configuration set up by the user (both from CLI arguments and from the config file).
class Config
  # @returns [string[]]
  attr_reader :environments
  # @returns [string[]]
  attr_reader :global_secrets
  # @returns [string[]]
  attr_reader :environment_secrets
  # @returns [string]
  attr_reader :import_name
  # @returns [string]
  attr_reader :namespace
  # @returns [string]
  attr_reader :pod_name
  # @returns [string]
  attr_reader :result_path
  # @returns [string[]]
  attr_reader :flavors
  # @returns [string]
  attr_reader :swift_declaration_strategy
  # @returns [boolean]
  attr_reader :should_generate_unit_tests
  # @returns [string]
  attr_reader :package_manager
  # @returns [boolean]
  attr_reader :should_cross_import_modules

  # @returns [string]
  attr_accessor :current_flavor
  # @returns [string]
  attr_accessor :dotenv_filepath

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def initialize(yaml)
    @environments = (yaml["environments"] || []).map(&:capitalize_first_letter)
    @environment_secrets = yaml["environment_secrets"] || []
    @global_secrets = yaml["global_secrets"] || []
    default_name = "ArkanaKeys"
    @namespace = yaml["namespace"] || default_name
    @import_name = yaml["import_name"] || default_name
    @pod_name = yaml["pod_name"] || default_name
    @result_path = yaml["result_path"] || default_name
    @flavors = yaml["flavors"] || []
    @swift_declaration_strategy = yaml["swift_declaration_strategy"] || "let"
    @should_generate_unit_tests = yaml["should_generate_unit_tests"]
    @should_generate_unit_tests = true if @should_generate_unit_tests.nil?
    @package_manager = yaml["package_manager"] || "spm"
    @should_cross_import_modules = yaml["should_cross_import_modules"]
    @should_cross_import_modules = true if @should_cross_import_modules.nil?
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  # TODO: Consider renaming this and environment_secrets, cuz they're confusing.
  def environment_keys
    result = environment_secrets.map do |k|
      environments.map { |e| k + e }
    end
    result.flatten
  end

  def all_keys
    global_secrets + environment_keys
  end
end
