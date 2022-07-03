# frozen_string_literal: true

RSpec.describe Type do
  describe ".new" do
    context "when passing a 'true' string" do
      subject { Type.new(string_value: "true") }

      it "should return :boolean" do
        expect(subject).to eq :boolean
      end
    end

    context "when passing a 'false' string" do
      subject { Type.new(string_value: "false") }

      it "should return :boolean" do
        expect(subject).to eq :boolean
      end
    end

    context "when passing anything that is not 'true' or 'false' string" do
      subject { Type.new(string_value: "lorem ipsum") }

      it "should return :string" do
        expect(subject).to eq :string
      end
    end
  end
end
