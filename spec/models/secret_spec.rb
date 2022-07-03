# frozen_string_literal: true

RSpec.describe Secret do
  let(:environment) { "TestEnv" }
  let(:key) { "#{protocol_key}#{environment}" }
  let(:protocol_key) { "LoremIpsum" }
  let(:encoded_value) { SecureRandom.base64(12) }
  let(:type) { :string }
  subject { Secret.new(key: key, protocol_key: protocol_key, encoded_value: encoded_value, type: type) }

  describe ".new" do
    it "should have all the properties properly assigned" do
      expect(subject.key).to eq key
      expect(subject.protocol_key).to eq protocol_key
      expect(subject.encoded_value).to eq encoded_value
      expect(subject.type).to eq type
    end
  end

  describe `#environment` do
    subject { super().environment }

    context "when key is equal to protocol_key" do
      let(:key) { protocol_key }

      it "should return :global" do
        expect(subject).to eq :global
      end
    end

    context "when 'protocol_key' is a prefix of the 'key'" do
      it "should return the remaining suffix (which is the environment)" do
        expect(subject).to eq environment
      end
    end

    context "when protocol_key doesn't have a prefix equal to key" do
      let(:key) { "bar#{environment}" }
      let(:protocol_key) { "foo" }

      it "should raise" do
        expect { subject }.to raise_error(/Precondition failure: the protocol_key '#{protocol_key}' is not the same as the key '#{key}' nor is its prefix. This state shouldn't be possible./)
      end
    end
  end
end
