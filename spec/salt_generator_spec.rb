# frozen_string_literal: true

RSpec.describe SaltGenerator do
  describe ".generate" do
    subject { SaltGenerator.generate }

    describe "#raw" do
      it "should return an array of integers" do
        expect(subject.raw).to all(be_kind_of(Integer))
      end

      it "should have #{SaltGenerator::SALT_LENGTH} elements" do
        expect(subject.raw.count).to eq SaltGenerator::SALT_LENGTH
      end
    end
  end
end
