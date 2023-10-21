# frozen_string_literal: true

RSpec.describe SaltGenerator do
  describe ".generate" do
    subject { described_class.generate }

    describe "#raw" do
      it "returns an array of integers" do
        expect(subject.raw).to all(be_a(Integer))
      end

      it "has #{SaltGenerator::SALT_LENGTH} elements" do
        expect(subject.raw.count).to eq SaltGenerator::SALT_LENGTH
      end
    end
  end
end
