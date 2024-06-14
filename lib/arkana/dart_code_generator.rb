# frozen_string_literal: true

require "erb" unless defined?(Erb)
require "fileutils" unless defined?(FileUtils)
require_relative "helpers/string"

# Responsible for generating Dart source and test files.
module DartCodeGenerator
  # Generates Dart code and test files for the given template arguments.
  def self.generate(template_arguments:, config:)
    dart_sources_dir = File.join("lib", config.result_path.downcase)
    dart_tests_dir = File.join("test", config.result_path.downcase)
    set_up_dart_interfaces(dart_sources_dir, template_arguments, config)
    set_up_dart_classes(dart_sources_dir, dart_tests_dir, template_arguments, config)
  end

  def self.set_up_dart_interfaces(path, template_arguments, config)
    dirname = File.dirname(__FILE__)
    sources_dir = path
    source_template = File.read("#{dirname}/templates/dart/arkana_protocol.dart.erb")
    FileUtils.mkdir_p(path)
    render(source_template, template_arguments, File.join(sources_dir, "#{config.namespace.downcase}_environment.dart"))
  end

  def self.set_up_dart_classes(sources_dir, tests_dir, template_arguments, config)
    dirname = File.dirname(__FILE__)
    source_template = File.read("#{dirname}/templates/dart/arkana.dart.erb")
    tests_template = File.read("#{dirname}/templates/dart/arkana_tests.dart.erb")
    FileUtils.mkdir_p(sources_dir)
    if config.should_generate_unit_tests
        FileUtils.mkdir_p(tests_dir)
    end
    render(source_template, template_arguments, File.join(sources_dir, "#{config.namespace.downcase}.dart"))
    if config.should_generate_unit_tests
        render(tests_template, template_arguments, File.join(tests_dir, "#{config.namespace.downcase}_test.dart"))
    end
  end

  def self.render(template, template_arguments, destination_file)
    renderer = ERB.new(template, trim_mode: ">") # Don't automatically add newlines at the end of each template tag
    result = renderer.result(template_arguments.get_binding)
    File.write(destination_file, result)
  end
end
