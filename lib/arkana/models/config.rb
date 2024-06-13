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
  # @returns [string]
  attr_reader :kotlin_package_name
  # @returns [string]
  attr_reader :kotlin_sources_path
  # @returns [string[]]
  attr_reader :flavors
  # @returns [string]
  attr_reader :swift_declaration_strategy
  # @returns [boolean]
  attr_reader :should_generate_unit_tests
  # @returns [string]
  attr_reader :package_manager
  # @returns [boolean]
  attr_reader :should_cocoapods_cross_import_modules
  # @returns [boolean]
  attr_reader :should_generate_gradle_build_file
  # @returns [int]
  attr_reader :kotlin_jvm_toolchain_version
  # @returns [boolean]
  attr_reader :is_kotlin_multiplatform_module

  # @returns [string]
  attr_accessor :current_flavor
  # @returns [string]
  attr_accessor :dotenv_filepath
  # @returns [string]
  attr_accessor :current_lang

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
    @kotlin_package_name = yaml["kotlin_package_name"] || "com.arkanakeys"
    @kotlin_sources_path = yaml["kotlin_sources_path"] || "kotlin"
    @flavors = yaml["flavors"] || []
    @swift_declaration_strategy = yaml["swift_declaration_strategy"] || "let"
    @should_generate_unit_tests = yaml["should_generate_unit_tests"]
    @should_generate_unit_tests = true if @should_generate_unit_tests.nil?
    @package_manager = yaml["package_manager"] || "spm"
    @should_cocoapods_cross_import_modules = yaml["should_cocoapods_cross_import_modules"]
    @should_cocoapods_cross_import_modules = true if @should_cocoapods_cross_import_modules.nil?
    @should_generate_gradle_build_file = yaml["should_generate_gradle_build_file"]
    @should_generate_gradle_build_file = true if @should_generate_gradle_build_file.nil?
    @kotlin_jvm_toolchain_version = yaml["kotlin_jvm_toolchain_version"] || 11
    @is_kotlin_multiplatform_module = yaml["is_kotlin_multiplatform_module"]
    @is_kotlin_multiplatform_module = false if @should_generate_gradle_build_file.nil?
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

  def include_environments(environments)
    return unless environments

    @environments = @environments.select { |e| environments.map(&:downcase).include?(e.downcase) }
  end
end
