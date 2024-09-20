RSpec.describe GemBench::Team do
  subject(:instance) { described_class.new(**options) }

  let(:options) { {} }

  describe "#initialize" do
    it "succeeds" do
      block_is_expected.not_to raise_error
    end

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
    end

    context "when extra verbose" do
      let(:options) {
        {
          gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
          verbose: "extra",
        }
      }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
    end
  end

  describe "#print" do
    subject(:print) { instance.print }

    it "succeeds" do
      block_is_expected.not_to raise_error
    end

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      context "when extra verbose" do
        let(:options) {
          {
            gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
            verbose: "extra",
          }
        }

        it "succeeds" do
          block_is_expected.to not_raise_error
        end
      end
    end

    context "when empty gemfile" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "empty_gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      context "when extra verbose" do
        let(:options) {
          {
            gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
            verbose: "extra",
          }
        }

        it "succeeds" do
          block_is_expected.to not_raise_error
        end
      end
    end

    context "when dev gemfile" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "dev_gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      context "when look_for_regex" do
        let(:options) {
          {
            gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
            verbose: "extra",
            bad_ideas: false,
            look_for_regex: /DRAGONS/i,
          }
        }

        it "succeeds" do
          block_is_expected.to not_raise_error
        end

        context "when check_gemfile" do
          let(:options) {
            {
              gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
              verbose: "extra",
              bad_ideas: false,
              check_gemfile: true,
              look_for_regex: /DRAGONS/i,
            }
          }

          it "succeeds" do
            block_is_expected.to not_raise_error
          end
        end
      end

      context "when benching" do
        context "when bad_ideas" do
          let(:options) {
            {
              gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
              verbose: "extra",
              bad_ideas: true,
            }
          }

          it "succeeds" do
            block_is_expected.to not_raise_error
          end
        end

        context "when check_gemfile" do
          let(:options) {
            {
              gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
              verbose: "extra",
              check_gemfile: true,
            }
          }

          it "succeeds" do
            block_is_expected.to not_raise_error
          end

          context "when bad_ideas nil" do
            let(:options) {
              {
                gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
                verbose: "extra",
                check_gemfile: true,
                bad_ideas: nil,
              }
            }

            it "succeeds" do
              block_is_expected.to not_raise_error
            end
          end

          context "when bad_ideas false" do
            let(:options) {
              {
                gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
                verbose: "extra",
                check_gemfile: true,
                bad_ideas: nil,
              }
            }

            it "succeeds" do
              block_is_expected.to not_raise_error
            end

            context "when not checking gemfile" do
              let(:options) {
                {
                  gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
                  verbose: "extra",
                  check_gemfile: false,
                  bad_ideas: nil,
                }
              }

              it "succeeds" do
                block_is_expected.to not_raise_error
              end
            end
          end
        end

        context "when extra verbose" do
          let(:options) {
            {
              gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb"),
              verbose: "extra",
            }
          }

          it "succeeds" do
            block_is_expected.to not_raise_error
          end
        end
      end
    end
  end

  describe "#list_starters" do
    subject(:list_starters) { instance.list_starters(format: format) }

    let(:format) { nil }

    context "when unknown format" do
      let(:player) do
        GemBench::Player.new(
          {
            name: "pry",
            version: "0.14.2",
            exclude_file_pattern: GemBench::EXCLUDE_FILE_PATTERN_REGEX_PROC.call("pry"),
          },
        )
      end

      it "raises error" do
        # Stubbing this is the only way to normalize the behavior across different loaded Gemfiles on the various Rubies
        allow(instance).to receive(:starters).and_return([player]) # rubocop:disable RSpec/SubjectStub
        block_is_expected.to raise_error(ArgumentError, /Unknown format for/)
      end
    end

    context "when known format" do
      let(:format) { :name }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
    end
  end
end
