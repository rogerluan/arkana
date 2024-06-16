# frozen_string_literal: true

RSpec.describe DartCodeGenerator do
  let(:config) { Config.new(YAML.load_file("spec/fixtures/arkana-fixture.yml")) }
  let(:salt) { SaltGenerator.generate }
  let(:environment_secrets) do
    Encoder.encode!(
      keys: config.environment_keys,
      salt: salt,
      current_flavor: config.current_flavor,
      environments: config.environments,
    )
  end

  let(:global_secrets) do
    Encoder.encode!(
      keys: config.global_secrets,
      salt: salt,
      current_flavor: config.current_flavor,
      environments: config.environments,
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

  after do
    FileUtils.rm_rf(File.join("lib", config.result_path))
    FileUtils.rm_rf(File.join("test"))
  end

  describe ".generate" do
    let(:dart_module_dir) { config.result_path.downcase }
    let(:dart_sources_dir) { File.join("lib", dart_module_dir) }
    let(:dart_tests_dir) { File.join("test", dart_module_dir) }

    def path(...)
      Pathname.new(File.join(...))
    end

    it "generates all necessary directories and files" do
      described_class.generate(template_arguments: template_arguments, config: config)
      expect(path(dart_sources_dir, "#{config.namespace.downcase}_environment.dart")).to be_file
      expect(path(dart_sources_dir, "#{config.namespace.downcase}.dart")).to be_file
    end

    context "when 'config.should_generate_unit_tests' is true" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(true)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "generates test folder and files" do
        expect(path(dart_tests_dir, "#{config.namespace.downcase}_test.dart")).to be_file
      end
    end

    context "when 'config.should_generate_unit_tests' is false" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(false)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "does not generate test folder or files" do
        expect(path(dart_tests_dir, "#{config.namespace.downcase}_test.dart")).not_to be_file
        expect(Pathname.new(dart_tests_dir)).not_to be_directory
      end
    end
  end
end
