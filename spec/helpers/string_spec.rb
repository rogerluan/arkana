# frozen_string_literal: true

RSpec.describe String do
  describe "#camel_case" do
    subject { "FooBar" }

    it "should lowercase the first letter" do
      expect(subject.camel_case).to eq "fooBar"
    end
  end

  describe "#capitalize_first_letter" do
    subject { "fOOBaR" }

    it "should capitalize the first letter and not change anything else in the rest of the string" do
      expect(subject.capitalize_first_letter).to eq "FOOBaR"
    end
  end
end
