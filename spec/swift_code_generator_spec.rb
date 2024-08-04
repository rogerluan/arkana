# frozen_string_literal: true

RSpec.describe SwiftCodeGenerator do
  let(:config) { Config.new(YAML.load_file("spec/fixtures/arkana-fixture.yml")) }
  let(:salt) { SaltGenerator.generate }
  let(:environment_secrets) do
    Encoder.encode!(
      keys: config.environment_keys,
      salt: salt,
      current_flavor: config.current_flavor,
      environments: config.environments,
      should_infer_types: config.should_infer_types,
    )
  end

  let(:global_secrets) do
    Encoder.encode!(
      keys: config.global_secrets,
      salt: salt,
      current_flavor: config.current_flavor,
      environments: config.environments,
      should_infer_types: config.should_infer_types,
    )
  end

  let(:template_arguments) do
    TemplateArguments.new(
      environment_secrets: environment_secrets,
      global_secrets: global_secrets,
      config: config,
      salt: salt,
    )
  end

  before do
    config.all_keys.each do |key|
      allow(ENV).to receive(:[]).with(key).and_return("value")
    end
    allow(ENV).to receive(:[]).with("ARKANA_RUNNING_CI_INTEGRATION_TESTS").and_return(true)
  end

  after { FileUtils.rm_rf(config.result_path) }

  describe ".generate" do
    let(:swift_package_dir) { File.join(config.result_path, config.import_name) }
    let(:interface_swift_package_dir) { File.join(config.result_path, "#{config.import_name}Interfaces") }

    def path(...)
      Pathname.new(File.join(...))
    end

    it "generates all necessary directories and files" do
      described_class.generate(template_arguments: template_arguments, config: config)
      expect(Pathname.new(config.result_path)).to be_directory
      expect(path(swift_package_dir, "README.md")).to be_file
      expect(path(swift_package_dir, "Package.swift")).to be_file
      expect(path(swift_package_dir, "Sources", "#{config.import_name}.swift")).to be_file
      expect(path(interface_swift_package_dir, "README.md")).to be_file
      expect(path(interface_swift_package_dir, "Package.swift")).to be_file
      expect(path(interface_swift_package_dir, "Sources", "#{config.import_name}Interfaces.swift")).to be_file
    end

    context "when 'config.package_manager'" do
      context "when is 'cocoapods'" do
        before do
          allow(config).to receive(:package_manager).and_return("cocoapods")
          described_class.generate(template_arguments: template_arguments, config: config)
        end

        it "generates podspec files" do
          expect(path(swift_package_dir, "#{config.pod_name.capitalize_first_letter}.podspec")).to be_file
          expect(path(interface_swift_package_dir, "#{config.pod_name.capitalize_first_letter}Interfaces.podspec")).to be_file
        end
      end

      context "when is not 'cocoapods'" do
        before do
          allow(config).to receive(:package_manager).and_return("spm")
          described_class.generate(template_arguments: template_arguments, config: config)
        end

        it "does not generate podspec files" do
          expect(path(swift_package_dir, "#{config.pod_name.capitalize_first_letter}.podspec")).not_to be_file
          expect(path(interface_swift_package_dir, "#{config.pod_name.capitalize_first_letter}Interfaces.podspec")).not_to be_file
        end
      end
    end

    context "when 'config.should_generate_unit_tests' is true" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(true)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "generates test folder and files" do
        expect(path(swift_package_dir, "Tests", "#{config.import_name}Tests.swift")).to be_file
      end

      it "contains '.testTarget(' in Package.swift" do
        expect(File.read(path(swift_package_dir, "Package.swift"))).to match(/\.testTarget\(/)
      end
    end

    context "when 'config.should_generate_unit_tests' is false" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(false)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "does not generate test folder or files" do
        expect(path(swift_package_dir, "Tests", "#{config.import_name}Tests.swift")).not_to be_file
        expect(path(swift_package_dir, "Tests")).not_to be_directory
      end

      it "does not contain '.testTarget(' in Package.swift" do
        expect(File.read(path(swift_package_dir, "Package.swift"))).not_to match(/\.testTarget\(/)
      end
    end
  end
end
