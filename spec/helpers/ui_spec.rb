# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:enable Style/FrozenStringLiteralComment

RSpec.describe UI do
  let(:message) { "lorem ipsum" }
  let(:logger) { Logger.new($stdout) }

  describe ".crash" do
    it "raises and print red message" do
      expect(message).to receive(:red)
      expect(described_class).to receive(:logger).and_return(logger)
      expect(logger).to receive(:fatal)
      expect { described_class.crash(message) }.to raise_error(message)
    end
  end

  describe ".debug" do
    it "prints cyan message" do
      expect(message).to receive(:cyan)
      expect(described_class).to receive(:logger).and_return(logger)
      expect(logger).to receive(:debug)
      described_class.debug(message)
    end
  end

  describe ".success" do
    it "prints green message" do
      expect(message).to receive(:green)
      expect(described_class).to receive(:logger).and_return(logger)
      expect(logger).to receive(:info)
      described_class.success(message)
    end
  end

  describe ".warn" do
    it "prints yellow message" do
      expect(message).to receive(:yellow)
      expect(described_class).to receive(:logger).and_return(logger)
      expect(logger).to receive(:warn)
      described_class.warn(message)
    end
  end

  describe "any action" do
    it "instantiates logger" do
      expect { described_class.success("Test ran successfully (hopefully)") }.not_to raise_error
    end
  end
end
