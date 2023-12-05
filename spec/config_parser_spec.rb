# frozen_string_literal: true

RSpec.describe ConfigParser do
  subject { described_class.parse(Arguments.new) }

  describe "#parse" do
    before { ARGV.replace(["--config-filepath", "spec/fixtures/arkana-fixture.yml"]) }

    describe "when yaml file exists" do
      it "does not fail" do
        expect { described_class.parse(Arguments.new) }.not_to raise_error
      end
    end

    describe "when yaml file doesn't exist" do
      let(:invalid_path) { "path/to/limbo" }

      before { ARGV.replace(["--config-filepath", invalid_path]) }

      it "raises an error with user friendly message" do
        expect { described_class.parse(Arguments.new) }.to raise_error(/No such file or directory (?:.*) #{invalid_path}/)
      end
    end

    describe "#current_flavor" do
      describe "when flavor is specified in arguments" do
        let(:flavor) { "frootloops" }

        before { ARGV << "--flavor" << flavor }

        it "is the same as the flavor specified" do
          expect(subject.current_flavor).to eq flavor
        end
      end

      describe "when flavor is not specified in arguments" do
        it "is nil" do
          expect(subject.current_flavor).to be_nil
        end
      end
    end

    describe "#current_lang" do
      describe "when language is specified in arguments" do
        let(:lang) { "kotlin" }

        before { ARGV << "--lang" << lang }

        it "is the same as the language specified" do
          expect(subject.current_lang).to eq lang
        end
      end

      describe "when flavor is not specified in arguments" do
        it "is nil" do
          expect(subject.current_flavor).to be_nil
        end
      end
    end

    describe "#dotenv_filepath" do
      context "when dotenv_filepath is specified" do
        context "when it exists" do
          let(:dotenv_filepath) { "spec/fixtures/dotenv.fixture" }

          before { ARGV << "--dotenv-filepath" << dotenv_filepath }

          it "does not log a warning and not raise an error" do
            expect(UI).not_to receive(:warn)
            expect { subject }.not_to raise_error
          end
        end

        context "when it doesn't exist" do
          let(:dotenv_filepath) { "path/to/limbo" }

          before { ARGV << "--dotenv-filepath" << dotenv_filepath }

          it "logs a warning and not raise an error" do
            expect(UI).to receive(:warn).with("Dotenv file was specified but couldn't be found at '#{dotenv_filepath}'")
            expect { subject }.not_to raise_error
          end
        end
      end

      context "when dotenv_filepath is not specified" do
        let(:default_fallback_dotenv_filepath) { ".env" }

        context "when a file exists at the default fallback dotenv filepath" do
          it "has dotenv_filepath equal to the default fallback dotenv filepath" do
            expect(File).to receive(:exist?).with(default_fallback_dotenv_filepath).twice.and_return(true)
            expect(UI).not_to receive(:warn)
            expect(subject.dotenv_filepath).to eq default_fallback_dotenv_filepath
          end
        end

        context "when a file doesn't exist at the default fallback dotenv filepath" do
          it "has dotenv_filepath be nil" do
            expect(File).to receive(:exist?).with(default_fallback_dotenv_filepath).and_return(false)
            expect(UI).not_to receive(:warn)
            expect(subject.dotenv_filepath).to be_nil
          end
        end
      end
    end

    describe "#include_environments" do
      describe "when include_environments is specified" do
        let(:include_environments) { %w[debug debugPlusMore] }

        before { ARGV << "--include-environments" << include_environments.join(",") }

        it "includes the environments specified, case insensitive" do
          expect(subject.environments.map(&:downcase)).to match_array(include_environments.map(&:downcase))
        end
      end

      describe "when include_environments is not specified" do
        it "includes all environments" do
          all_environments = %w[debug release debugPlusMore ReleasePlusMore]
          expect(subject.environments.map(&:downcase)).to match_array(all_environments.map(&:downcase))
        end
      end
    end
  end
end
