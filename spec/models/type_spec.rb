# frozen_string_literal: true

RSpec.describe Type do
  describe ".new" do
    context "when passing a 'true' string" do
      subject { described_class.new(string_value: "true") }

      it "returns :boolean" do
        expect(subject).to eq :boolean
      end
    end

    context "when passing a 'false' string" do
      subject { described_class.new(string_value: "false") }

      it "returns :boolean" do
        expect(subject).to eq :boolean
      end
    end

    context "when passing anything that is not 'true' or 'false' string" do
      subject { described_class.new(string_value: "lorem ipsum") }

      it "returns :string" do
        expect(subject).to eq :string
      end
    end
  end
end
