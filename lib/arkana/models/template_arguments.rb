# frozen_string_literal: true

require_relative "secret"

# A class that defines template arguments in a language-agnostic form.
class TemplateArguments
  # Generates template arguments for the given secrets and config specifications.
  def initialize(environment_secrets:, global_secrets:, config:, salt:)
    # The environments declared in the config file.
    @environments = config.environments
    # The salt used to encode all the secrets.
    @salt = salt
    # The encoded environment-specific secrets.
    @environment_secrets = environment_secrets
    # The encoded global secrets.
    @global_secrets = global_secrets
    # Name of the import statements (or the interfaces' prefixes).
    @import_name = config.import_name
    # Name of the pod that should be generated.
    @pod_name = config.pod_name
    # The top level namespace in which the keys will be generated. Often an enum.
    @namespace = config.namespace
    # Dart sources Path
    @result_path = config.result_path
    # Name of the kotlin package to be used for the generated code.
    @kotlin_package_name = config.kotlin_package_name
    # The kotlin JVM toolchain JDK version to be used in the generated build.gradle file.
    @kotlin_jvm_toolchain_version = config.kotlin_jvm_toolchain_version
    # The property declaration strategy declared in the config file.
    @swift_declaration_strategy = config.swift_declaration_strategy
    # Whether unit tests should be generated.
    @should_generate_unit_tests = config.should_generate_unit_tests
    # Whether cocoapods modules should cross import.
    @should_cocoapods_cross_import_modules = config.should_cocoapods_cross_import_modules
  end

  def environment_protocol_secrets(environment)
    @environment_secrets.select do |secret|
      secret.environment == environment
    end
  end

  # Generates a new test secret for a given key, using the salt stored.
  def generate_test_secret(key:)
    # Yes, we encode the key as the value because this is just for testing purposes
    encoded_value = Encoder.encode(key, @salt.raw)
    Secret.new(key: key, protocol_key: key, encoded_value: encoded_value, type: :string)
  end

  # Expose private `binding` method.
  # rubocop:disable Naming/AccessorMethodName
  def get_binding
    binding
  end
  # rubocop:enable Naming/AccessorMethodName
end
