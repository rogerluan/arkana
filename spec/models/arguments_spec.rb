# frozen_string_literal: true

require "arkana/models/arguments"

RSpec.describe Arguments do
  before { ARGV.replace([]) }
  subject { Arguments.new }

  describe "#config_filepath" do
    context "when the option is ommitted in ARGV" do
      it "should default to the default value" do
        expect(subject.config_filepath).to eq ".arkana.yml"
      end
    end

    context "when the option is passed in ARGV" do
      let(:expected_path) { "rspec/file/path" }
      before { ARGV.replace(["--config-filepath", expected_path]) }

      it "should return the argument passed" do
        expect(subject.config_filepath).to eq expected_path
      end
    end
  end

  describe "#dotenv_filepath" do
    context "when the option is ommitted in ARGV" do
      describe "when .env file exists" do
        it "should default to the default value" do
          expect(File).to receive(:exist?).with(".env").and_return(true)
          expect(subject.dotenv_filepath).to eq ".env"
        end
      end

      describe "when .env file doesn't exist" do
        it "should be nil" do
          expect(File).to receive(:exist?).with(".env").and_return(false)
          expect(subject.dotenv_filepath).to be_nil
        end
      end
    end

    context "when the option is passed in ARGV" do
      let(:expected_path) { "rspec/file/path" }
      before { ARGV.replace(["--dotenv-filepath", expected_path]) }

      it "should return the argument passed" do
        expect(subject.dotenv_filepath).to eq expected_path
      end
    end
  end

  describe "#flavor" do
    context "when the option is ommitted in ARGV" do
      it "should default to nil" do
        expect(subject.flavor).to be_nil
      end
    end

    context "when the option is passed in ARGV" do
      let(:expected_flavor) { "some_flavor" }
      before { ARGV.replace(["--flavor", expected_flavor]) }

      it "should return the argument passed" do
        expect(subject.flavor).to eq expected_flavor
      end
    end
  end
end
