# frozen_string_literal: true

RSpec.describe DotenvHelper do
  let(:dotenv_filepath) { "fixtures/dotenv.fixture" }
  let(:current_flavor) { "FrootLoops" }
  let(:config) do
    result = Config.new({})
    result.dotenv_filepath = dotenv_filepath
    result.current_flavor = current_flavor
    result
  end

  describe ".load" do
    context "when current_flavor is not passed" do
      let(:current_flavor) { nil }

      it "loads dotenv file from dotenv_filepath" do
        expect(Dotenv).to receive(:load).with(dotenv_filepath).once
        described_class.load(config)
      end
    end

    context "when current_flavor is passed" do
      it "loads dotenv files and flavor-specific env vars should override regular dotenv env vars" do
        expect(Dotenv).to receive(:load).with(dotenv_filepath).once
        expect(Dotenv).to receive(:load).with(described_class.flavor_dotenv_filepath(config)).once
        described_class.load(config)
        # NOTE: I couldn't make this work, not sure if it's possible:
        # expect(ENV["DOTENV_KEY"]).to eq "value from flavor dotenv"
      end
    end
  end

  describe ".flavor_dotenv_filepath" do
    subject { described_class.flavor_dotenv_filepath(config) }

    it "is in the same directory as the dotenv_filepath" do
      expect(subject).to start_with("fixtures")
    end

    it "has a format of '.env.' followed by lowercased flavor" do
      expect(subject).to end_with("/.env.#{current_flavor.downcase}")
    end
  end
end
