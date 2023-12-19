# frozen_string_literal: true

RSpec.describe Arkana do
  describe ".run" do
    let(:config_filepath) { "spec/fixtures/arkana-fixture.yml" }
    let(:arguments) { Arguments.new }
    let(:config) { ConfigParser.parse(arguments) }

    before { ARGV.replace(["--config-filepath", config_filepath]) }

    context "when one or more env vars are missing" do
      it "raises error" do
        expect { described_class.run(arguments) }.to raise_error(/Secret '(?:.*)' was declared but couldn't be found in the environment variables nor in the specified dotenv file./)
      end
    end

    context "when all env vars declared can be found" do
      before do
        config.all_keys.each do |key|
          allow(ENV).to receive(:[]).with(key).and_return("lorem ipsum")
        end
      end

      it "calls SwiftCodeGenerator.generate" do
        expect(SwiftCodeGenerator).to receive(:generate)
        described_class.run(arguments)
      end
    end

    context "when only a subset of environments is included" do
      before do
        ARGV.replace([
          "--config-filepath",
          config_filepath,
          "--include-environments",
          "debug,release,debugPlusMore",
        ])

        config.all_keys.each do |key|
          allow(ENV).to receive(:[]).with(key).and_return("lorem ipsum")
        end
        allow(ENV).to receive(:[]).with("ServiceKeyReleasePlusMore").and_return(nil)
        allow(ENV).to receive(:[]).with("ServerReleasePlusMore").and_return(nil)
      end

      it "does not error out when it cant find a missing env var that wasnt included in the list of environments" do
        expect { described_class.run(arguments) }.not_to raise_error
      end
    end

    context "when kotlin is specified as the language" do
      let(:lang) { "kotlin" }

      before do
        ARGV << "--lang" << lang

        config.all_keys.each do |key|
          allow(ENV).to receive(:[]).with(key).and_return("lorem ipsum")
        end
      end

      it "calls KotlinCodeGenerator.generate" do
        expect(KotlinCodeGenerator).to receive(:generate)
        described_class.run(arguments)
      end
    end
  end
end
