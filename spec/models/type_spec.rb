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

    context "when passing something that looks like a number" do
      context "when it contains leading zeros" do
        subject { described_class.new(string_value: "0001") }

        it "returns :string" do
          expect(subject).to eq :string
        end
      end

      context "when its string representation is the same as its integer representation" do
        subject { described_class.new(string_value: "1234567890") }

        it "returns :integer" do
          expect(subject).to eq :integer
        end
      end

      context "when its string representation is different from its integer representation" do
        subject { described_class.new(string_value: "1234567890.0") }

        it "returns :string" do
          expect(subject).to eq :string
        end
      end

      context "when it contains a decimal point" do
        subject { described_class.new(string_value: "3.14") }

        it "returns :string" do
          expect(subject).to eq :string
        end
      end

      context "when it contains a comma" do
        subject { described_class.new(string_value: "1,000") }

        it "returns :string" do
          expect(subject).to eq :string
        end
      end

      context "when it contains a massive number" do
        subject { described_class.new(string_value: "123456789012345678901234567890") }

        it "returns :string" do
          expect(subject).to eq :string
        end
      end
    end
  end
end
