# frozen_string_literal: true

require "erb"
require "fileutils"
require_relative "helpers/string"

# Responsible for generating Swift source and test files.
module SwiftCodeGenerator
  # Generates Swift code and test files for the given template arguments.
  def self.generate(template_arguments:, config:)
    interface_swift_package_dir = File.join(config.result_path, "#{config.import_name}Interfaces")
    set_up_interfaces_swift_package(interface_swift_package_dir, template_arguments, config)

    swift_package_dir = File.join(config.result_path, config.import_name)
    set_up_swift_package(swift_package_dir, template_arguments, config)
  end

  def self.set_up_interfaces_swift_package(path, template_arguments, config)
    dirname = File.dirname(__FILE__)
    readme_template = File.read("#{dirname}/templates/interfaces_readme.erb")
    package_template = File.read("#{dirname}/templates/interfaces_package.swift.erb")
    podspec_template = File.read("#{dirname}/templates/interfaces.podspec.erb")
    sources_dir = File.join(path, "Sources")
    source_template = File.read("#{dirname}/templates/arkana_protocol.swift.erb")
    FileUtils.mkdir_p(path)
    FileUtils.mkdir_p(sources_dir)
    render(podspec_template, template_arguments, File.join(path, "#{config.pod_name.capitalize_first_letter}Interfaces.podspec")) if config.package_manager == "cocoapods"
    render(readme_template, template_arguments, File.join(path, "README.md"))
    render(package_template, template_arguments, File.join(path, "Package.swift"))
    render(source_template, template_arguments, File.join(sources_dir, "#{config.import_name}Interfaces.swift"))
  end

  def self.set_up_swift_package(path, template_arguments, config)
    dirname = File.dirname(__FILE__)
    readme_template = File.read("#{dirname}/templates/readme.erb")
    package_template = File.read("#{dirname}/templates/package.swift.erb")
    sources_dir = File.join(path, "Sources")
    source_template = File.read("#{dirname}/templates/arkana.swift.erb")
    tests_dir = File.join(path, "Tests") if config.should_generate_unit_tests
    tests_template = File.read("#{dirname}/templates/arkana_tests.swift.erb")
    podspec_template = File.read("#{dirname}/templates/arkana.podspec.erb")
    FileUtils.mkdir_p(path)
    FileUtils.mkdir_p(sources_dir)
    FileUtils.mkdir_p(tests_dir) if config.should_generate_unit_tests
    render(readme_template, template_arguments, File.join(path, "README.md"))
    render(package_template, template_arguments, File.join(path, "Package.swift"))
    render(podspec_template, template_arguments, File.join(path, "#{config.pod_name.capitalize_first_letter}.podspec")) if config.package_manager == "cocoapods"
    render(source_template, template_arguments, File.join(sources_dir, "#{config.import_name}.swift"))
    render(tests_template, template_arguments, File.join(tests_dir, "#{config.import_name}Tests.swift")) if config.should_generate_unit_tests
  end

  def self.render(template, template_arguments, destination_file)
    renderer = ERB.new(template, trim_mode: ">") # Don't automatically add newlines at the end of each template tag
    result = renderer.result(template_arguments.get_binding)
    File.write(destination_file, result)
  end
end
