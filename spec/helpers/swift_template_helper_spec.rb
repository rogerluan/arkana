# frozen_string_literal: true

require "arkana/helpers/swift_template_helper"

RSpec.describe SwiftTemplateHelper do
  describe ".swift_type" do
    subject { SwiftTemplateHelper.swift_type(type) }

    context "when type is :string" do
      let(:type) { :string }

      it "should be Swift type String" do
        expect(subject).to eq "String"
      end
    end

    context "when type is :boolean" do
      let(:type) { :boolean }

      it "should be Swift type Bool" do
        expect(subject).to eq "Bool"
      end
    end

    context "when type is unknown" do
      let(:type) { :bananas }

      it "should raise error" do
        expect { subject }.to raise_error(/Unknown variable type '#{type}' received.'/)
      end
    end
  end
end
