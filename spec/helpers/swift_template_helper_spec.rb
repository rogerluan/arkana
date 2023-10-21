# frozen_string_literal: true

require "arkana/helpers/swift_template_helper"

RSpec.describe SwiftTemplateHelper do
  describe ".swift_type" do
    subject { described_class.swift_type(type) }

    context "when type is :string" do
      let(:type) { :string }

      it "is Swift type String" do
        expect(subject).to eq "String"
      end
    end

    context "when type is :boolean" do
      let(:type) { :boolean }

      it "is Swift type Bool" do
        expect(subject).to eq "Bool"
      end
    end

    context "when type is :integer" do
      let(:type) { :integer }

      it "is Swift type Int" do
        expect(subject).to eq "Int"
      end
    end

    context "when type is unknown" do
      let(:type) { :bananas }

      it "raises error" do
        expect { subject }.to raise_error(/Unknown variable type '#{type}' received.'/)
      end
    end
  end

  describe ".protocol_getter" do
    subject { described_class.protocol_getter(declaration_strategy) }

    context "when declaration strategy is 'var'" do
      let(:declaration_strategy) { "var" }

      it "returns 'get'" do
        expect(subject).to eq "get"
      end
    end

    context "when declaration strategy is 'let'" do
      let(:declaration_strategy) { "let" }

      it "returns 'get'" do
        expect(subject).to eq "get"
      end
    end

    context "when declaration strategy is 'lazy var'" do
      let(:declaration_strategy) { "lazy var" }

      it "returns 'mutating get'" do
        expect(subject).to eq "mutating get"
      end
    end

    context "when declaration strategy is unknown" do
      let(:declaration_strategy) { :bananas }

      it "raises error" do
        expect { subject }.to raise_error(/Unknown declaration strategy '#{declaration_strategy}' received.'/)
      end
    end
  end
end
