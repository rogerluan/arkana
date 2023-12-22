# frozen_string_literal: true

RSpec.describe KotlinCodeGenerator do
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

  after { FileUtils.rm_rf(config.result_path) }

  describe ".generate" do
    let(:kotlin_module_dir) { config.result_path }
    let(:kotlin_sources_dir) { File.join(kotlin_module_dir, "src", "main", config.kotlin_sources_path, config.kotlin_package_name.split(".")) }
    let(:kotlin_tests_dir) { File.join(kotlin_module_dir, "src", "test", config.kotlin_sources_path, config.kotlin_package_name.split(".")) }

    def path(...)
      Pathname.new(File.join(...))
    end

    it "generates all necessary directories and files" do
      described_class.generate(template_arguments: template_arguments, config: config)
      expect(Pathname.new(config.result_path)).to be_directory
      expect(path(kotlin_module_dir, "README.md")).to be_file
      expect(path(kotlin_module_dir, "build.gradle.kts")).to be_file
      expect(path(kotlin_sources_dir,  "#{config.namespace}Environment.kt")).to be_file
      expect(path(kotlin_sources_dir,  "#{config.namespace}.kt")).to be_file
    end

    context "when 'config.should_generate_gradle_build_file'" do
      context "when is 'true'" do
        before do
          allow(config).to receive(:should_generate_gradle_build_file).and_return(true)
          described_class.generate(template_arguments: template_arguments, config: config)
        end

        it "generates gradle build file" do
          expect(path(kotlin_module_dir, "build.gradle.kts")).to be_file
        end
      end

      context "when is 'false'" do
        before do
          allow(config).to receive(:should_generate_gradle_build_file).and_return(false)
          described_class.generate(template_arguments: template_arguments, config: config)
        end

        it "generates gradle build file" do
          expect(path(kotlin_module_dir, "build.gradle.kts")).not_to be_file
        end
      end
    end

    context "when 'config.should_generate_unit_tests' is true" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(true)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "generates test folder and files" do
        expect(path(kotlin_tests_dir, "#{config.namespace}Test.kt")).to be_file
      end
    end

    context "when 'config.should_generate_unit_tests' is false" do
      before do
        allow(config).to receive(:should_generate_unit_tests).and_return(false)
        described_class.generate(template_arguments: template_arguments, config: config)
      end

      it "does not generate test folder or files" do
        expect(path(kotlin_tests_dir, "#{config.namespace}Test.kt")).not_to be_file
        expect(Pathname.new(kotlin_tests_dir)).not_to be_directory
      end
    end
  end
end
