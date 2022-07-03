# frozen_string_literal: true

RSpec.describe Encoder do
  let(:salt) { SaltGenerator.generate }
  let(:environments) { [] }
  let(:current_flavor) { nil }
  subject { Encoder.encode!(keys: keys, salt: salt, current_flavor: current_flavor, environments: environments) }

  describe ".encode!" do
    context "when keys is empty" do
      let(:keys) { [] }

      it "should return empty array" do
        expect(subject.map(&:key)).to be_empty
      end
    end

    context "when keys is not empty" do
      let(:existing_key) { "existing" }
      let(:existing_value) { "existing" }

      context "when the ENV contains all keys" do
        let(:existing_key2) { "existing2" }
        let(:existing_value2) { "true" }
        let(:keys) { [existing_key, existing_key2] }

        before do
          allow(ENV).to receive(:[]).with(existing_key).and_return(existing_value)
          allow(ENV).to receive(:[]).with(existing_key2).and_return(existing_value2)
        end

        it "should not raise error" do
          expect { subject }.to_not raise_error
        end

        it "should return array with matching keys, values that are not the same as the stored value, and types" do
          expect(subject[0].key).to eq existing_key
          expect(subject[1].key).to eq existing_key2

          expect(subject[0].encoded_value).to_not eq existing_value
          expect(subject[1].encoded_value).to_not eq existing_value2

          expect(subject[0].type).to eq :string
          expect(subject[1].type).to eq :boolean
        end
      end

      context "when the ENV doesn't contain one of the keys" do
        let(:missing_key) { "missing" }
        let(:keys) { [existing_key, missing_key] }

        before do
          allow(ENV).to receive(:[]).with(existing_key).and_return(existing_value)
          allow(ENV).to receive(:[]).with(missing_key).and_return(nil)
        end

        it "should raise error" do
          expect { subject }.to raise_error(/Secret '(?:.*)' was declared but couldn't be found in the environment variables nor in the specified dotenv file./)
        end
      end
    end
  end

  describe "#find_secret!" do
    let(:key) { "LoremIpsum" }
    subject { Encoder.find_secret!(key: key, current_flavor: current_flavor) }

    context "when current_flavor is passed" do
      let(:current_flavor) { "Ipsum" }
      let(:flavor_key) { "#{current_flavor.capitalize_first_letter}#{key}" }

      context "when ENV contains the flavor-specific key" do
        let(:value) { "value" }
        before { allow(ENV).to receive(:[]).with(flavor_key).and_return(value) }

        it "should return the value from ENV" do
          expect(subject).to eq value
        end
      end

      context "when ENV doesn't contain the flavor-specific key" do
        before { allow(ENV).to receive(:[]).with(flavor_key).and_return(nil) }

        context "when ENV contains the key" do
          let(:value) { "value" }
          before { allow(ENV).to receive(:[]).with(key).and_return(value) }

          it "should return the value from ENV" do
            expect(subject).to eq value
          end
        end

        context "when ENV doesn't contain the key" do
          before { allow(ENV).to receive(:[]).with(key).and_return(nil) }

          it "should raise" do
            expect { subject }.to raise_error(/Secret '#{flavor_key}' was declared but couldn't be found in the environment variables nor in the specified dotenv file./)
          end
        end
      end
    end

    context "when current_flavor is nil" do
      let(:current_flavor) { nil }

      context "when ENV contains the key" do
        let(:value) { "value" }
        before { allow(ENV).to receive(:[]).with(key).and_return(value) }

        it "should return the value from ENV" do
          expect(subject).to eq value
        end
      end

      context "when ENV doesn't contain the key" do
        before { allow(ENV).to receive(:[]).with(key).and_return(nil) }

        it "should raise" do
          expect { subject }.to raise_error(/Secret '#{key}' was declared but couldn't be found in the environment variables nor in the specified dotenv file./)
        end
      end
    end
  end

  describe "#protocol_key" do
    let(:key) { "LoremIpsum" }
    subject { Encoder.protocol_key(key: key, environments: environment ? [environment] : []) }

    context "when the key passed has a suffix of one of the environments" do
      let(:environment) { "Ipsum" }

      it "should return the key without the environment suffix" do
        expect(subject).to eq key.delete_suffix(environment)
      end
    end

    context "when the key passed doesn't have a suffix of one of the environments" do
      let(:environment) { "Dolor" }

      it "should return the same key passed" do
        expect(subject).to eq key
      end
    end

    context "when no environments are passed" do
      let(:environment) { nil }

      it "should return the same key passed" do
        expect(subject).to eq key
      end
    end
  end
end
