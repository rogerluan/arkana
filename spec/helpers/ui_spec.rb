# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:enable Style/FrozenStringLiteralComment

RSpec.describe UI do
  let(:message) { "lorem ipsum" }
  let(:logger) { Logger.new($stdout) }

  describe ".crash" do
    it "should raise and print red message" do
      expect(message).to receive(:red)
      expect(UI).to receive(:logger).and_return(logger)
      expect(logger).to receive(:fatal)
      expect { UI.crash(message) }.to raise_error(message)
    end
  end

  describe ".debug" do
    it "should print cyan message" do
      expect(message).to receive(:cyan)
      expect(UI).to receive(:logger).and_return(logger)
      expect(logger).to receive(:debug)
      UI.debug(message)
    end
  end

  describe ".success" do
    it "should print green message" do
      expect(message).to receive(:green)
      expect(UI).to receive(:logger).and_return(logger)
      expect(logger).to receive(:info)
      UI.success(message)
    end
  end

  describe ".warn" do
    it "should print yellow message" do
      expect(message).to receive(:yellow)
      expect(UI).to receive(:logger).and_return(logger)
      expect(logger).to receive(:warn)
      UI.warn(message)
    end
  end

  describe "any action" do
    it "should instantiate logger" do
      UI.success("Test ran successfully (hopefully)")
    end
  end
end
