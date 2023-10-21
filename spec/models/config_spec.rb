# frozen_string_literal: true

RSpec.describe Config do
  subject { described_class.new(YAML.load_file(yaml_file)) }

  let(:yaml_file) { "spec/fixtures/arkana-fixture.yml" }

  describe ".new" do
    context "when the yaml file doesn't specify elements" do
      subject { described_class.new({}) }

      it "fallbacks each property to their respective default value" do
        expect(subject.environments).to be_empty
        expect(subject.environment_secrets).to be_empty
        expect(subject.global_secrets).to be_empty
        default_name = "ArkanaKeys"
        expect(subject.namespace).to eq default_name
        expect(subject.import_name).to eq default_name
        expect(subject.pod_name).to eq default_name
        expect(subject.result_path).to eq default_name
        expect(subject.flavors).to be_empty
        expect(subject.swift_declaration_strategy).to eq "let"
        expect(subject.should_generate_unit_tests).to be_truthy
        expect(subject.package_manager).to eq "spm"
        expect(subject.current_flavor).to be_nil
        expect(subject.dotenv_filepath).to be_nil
      end
    end

    context "when yaml configurations are provided" do
      it "correctlies assign each key/value pair to their respective property" do
        expect(subject.environments).to eq %w[Debug Release DebugPlusMore ReleasePlusMore]
        expect(subject.environment_secrets).to eq %w[ServiceKey Server]
        expect(subject.global_secrets).to eq %w[Domain Global]
        custom_name = "MySecrets"
        expect(subject.namespace).to eq custom_name
        expect(subject.import_name).to eq custom_name
        expect(subject.pod_name).to eq custom_name
        expect(subject.result_path).to eq custom_name
        expect(subject.flavors).to eq %w[CornFlakes FrootLoops]
        expect(subject.swift_declaration_strategy).to eq "lazy var"
        expect(subject.should_generate_unit_tests).to be_falsey
        expect(subject.package_manager).to eq "cocoapods"
        expect(subject.current_flavor).to be_nil
        expect(subject.dotenv_filepath).to be_nil
      end
    end

    context "when all_keys is empty" do
      subject { described_class.new({}) }

      it "raises an error" do
        expect { SwiftCodeGenerator.generate(template_arguments: template_arguments, config: config) }.to raise_error(StandardError)
      end
    end
  end

  describe `#environment_keys` do
    context "when there are no environments" do
      subject { super().environment_keys }

      let(:yaml_file) { "spec/fixtures/arkana-empty-environments-fixture.yml" }

      it { is_expected.to be_empty }
    end

    context "when there is one or more environments" do
      context "when there are no environment secrets" do
        subject { super().environment_keys }

        let(:yaml_file) { "spec/fixtures/arkana-empty-environment-secrets-fixture.yml" }

        it { is_expected.to be_empty }
      end

      context "when there is one or more environment secrets" do
        it "generates a new key for each environment + environment secret pair" do
          expect(subject.environment_keys.count).to eq(4 * 2) # There are 4 environments and 2 environment secrets
        end

        it "has all keys with a prefix of the environment secret name" do
          expect(subject.environment_keys).to be_all do |key|
            subject.environment_secrets.any? { |secret| key.start_with?(secret) }
          end
        end

        it "has all keys with a suffix of the capitalized environment name" do
          expect(subject.environment_keys).to be_all do |key|
            subject.environments.any? { |env| key.end_with?(env) }
          end
        end
      end
    end
  end

  describe ".include_environments" do
    context "when nil is passed" do
      it "includes all environments declared in the yaml file" do
        subject.include_environments(nil)
        expect(subject.environments).to match_array %w[Debug Release DebugPlusMore ReleasePlusMore]
      end
    end

    context "when 1 environment is passed" do
      it "onlies that environment in the environments" do
        subject.include_environments(["DebugPlusMore"])
        expect(subject.environments).to match_array %w[DebugPlusMore]
      end
    end

    context "when all environments are passed" do
      it "onlies that environment in the environments" do
        subject.include_environments(%w[Debug Release DebugPlusMore ReleasePlusMore])
        expect(subject.environments).to match_array %w[Debug Release DebugPlusMore ReleasePlusMore]
      end
    end

    context "when an empty array is passed" do
      it "causes the subject's environments to become empty" do
        subject.include_environments([])
        expect(subject.environments).to be_empty
      end
    end

    context "when a string that is not an environment is passed" do
      it "ignores that string and consider the other elements of the array passed, if any" do
        subject.include_environments(["I double dare you"])
        expect(subject.environments).to be_empty
      end
    end
  end

  describe `#all_keys` do
    it "is not empty" do
      expect(subject.all_keys).not_to be_empty
    end

    it "contains the contents of the global keys + environment keys" do
      expect(subject.all_keys).to eq(subject.global_secrets + subject.environment_keys)
    end

    describe "#count" do
      it "matches the number of environments times the number of environment secrets, plus the number of global secrets" do
        expect(subject.all_keys.count).to eq((subject.environments.count * subject.environment_secrets.count) + subject.global_secrets.count)
      end
    end
  end
end
