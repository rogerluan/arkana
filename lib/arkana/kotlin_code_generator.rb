# frozen_string_literal: true

require "erb" unless defined?(Erb)
require "fileutils" unless defined?(FileUtils)
require_relative "helpers/string"

# Responsible for generating Kotlin source and test files.
module KotlinCodeGenerator
  # Generates Kotlin code and test files for the given template arguments.
  def self.generate(template_arguments:, config:)
    kotlin_module_dir = config.result_path
    kotlin_sources_dir = File.join(kotlin_module_dir, "src", "main", config.kotlin_sources_path, config.kotlin_package_name.split("."))
    kotlin_tests_dir = File.join(kotlin_module_dir, "src", "test", config.kotlin_sources_path, config.kotlin_package_name.split("."))

    if config.should_generate_gradle_build_file
      set_up_kotlin_module(kotlin_module_dir, template_arguments)
    end

    set_up_kotlin_interfaces(kotlin_sources_dir, template_arguments, config)
    set_up_kotlin_classes(kotlin_sources_dir, kotlin_tests_dir, template_arguments, config)
  end

  def self.set_up_kotlin_module(path, template_arguments)
    dirname = File.dirname(__FILE__)
    sources_dir = path
    readme_template = File.read("#{dirname}/templates/readme.erb")
    source_template = File.read("#{dirname}/templates/kotlin/build.gradle.kts.erb")
    FileUtils.mkdir_p(path)
    render(readme_template, template_arguments, File.join(path, "README.md"))
    render(source_template, template_arguments, File.join(sources_dir, "build.gradle.kts"))
  end

  def self.set_up_kotlin_interfaces(path, template_arguments, config)
    dirname = File.dirname(__FILE__)
    sources_dir = path
    source_template = File.read("#{dirname}/templates/kotlin/arkana_protocol.kt.erb")
    FileUtils.mkdir_p(path)
    render(source_template, template_arguments, File.join(sources_dir, "#{config.namespace}Environment.kt"))
  end

  def self.set_up_kotlin_classes(sources_dir, tests_dir, template_arguments, config)
    dirname = File.dirname(__FILE__)
    source_template = File.read("#{dirname}/templates/kotlin/arkana.kt.erb")
    tests_template = File.read("#{dirname}/templates/kotlin/arkana_tests.kt.erb")
    FileUtils.mkdir_p(sources_dir)
    FileUtils.mkdir_p(tests_dir) if config.should_generate_unit_tests
    render(source_template, template_arguments, File.join(sources_dir, "#{config.namespace}.kt"))
    render(tests_template, template_arguments, File.join(tests_dir, "#{config.namespace}Test.kt")) if config.should_generate_unit_tests
  end

  def self.render(template, template_arguments, destination_file)
    renderer = ERB.new(template, trim_mode: ">") # Don't automatically add newlines at the end of each template tag
    result = renderer.result(template_arguments.get_binding)
    File.write(destination_file, result)
  end
end
