# frozen_string_literal: true

require "erb"
require "fileutils"
require_relative "helpers/string"

# Responsible for generating Kotlin source and test files.
module KotlinCodeGenerator
  # Generates Kotlin code and test files for the given template arguments.
  def self.generate(template_arguments:, config:)
    kotlin_module_dir = config.result_path
    kotlin_sources_dir = File.join(kotlin_module_dir, config.kotlin_sources_path, config.kotlin_package_name.split("."))

    if config.should_generate_gradle_build_file
      set_up_kotlin_module(kotlin_module_dir, template_arguments)
    end

    set_up_kotlin_interfaces(kotlin_sources_dir, template_arguments, config)
    set_up_kotlin_classes(kotlin_sources_dir, template_arguments, config)
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

  def self.set_up_kotlin_classes(path, template_arguments, config)
    dirname = File.dirname(__FILE__)
    sources_dir = path
    source_template = File.read("#{dirname}/templates/kotlin/arkana.kt.erb")
    FileUtils.mkdir_p(path)
    FileUtils.mkdir_p(sources_dir)
    render(source_template, template_arguments, File.join(sources_dir, "#{config.namespace}.kt"))
  end

  def self.render(template, template_arguments, destination_file)
    renderer = ERB.new(template, trim_mode: ">") # Don't automatically add newlines at the end of each template tag
    result = renderer.result(template_arguments.get_binding)
    File.write(destination_file, result)
  end
end
