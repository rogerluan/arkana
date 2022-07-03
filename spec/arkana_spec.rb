# frozen_string_literal: true

RSpec.describe Arkana do
  describe ".run" do
    let(:config_filepath) { "spec/fixtures/arkana-fixture.yml" }
    let(:arguments) { Arguments.new }
    let(:config) { ConfigParser.parse(arguments) }
    before { ARGV.replace(["--config-filepath", config_filepath]) }

    context "when one or more env vars are missing" do
      it "should raise error" do
        expect { Arkana.run(arguments) }.to raise_error(/Secret '(?:.*)' was declared but couldn't be found in the environment variables nor in the specified dotenv file./)
      end
    end

    context "when all env vars declared can be found" do
      before do
        config.all_keys.each do |key|
          allow(ENV).to receive(:[]).with(key).and_return("lorem ipsum")
        end
      end

      it "should call SwiftCodeGenerator.generate" do
        expect(SwiftCodeGenerator).to receive(:generate)
        Arkana.run(arguments)
      end
    end
  end
end
