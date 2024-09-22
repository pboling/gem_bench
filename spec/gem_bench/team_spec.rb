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

    context "when excluded" do
      it "excludes the excluded gems" do
        expect(instance.excluded.map(&:first).sort).to eq(%w(bundler gem_bench))
      end
    end

    context "when not excluded" do
      it "excludes nothing" do
        allow(GemBench::Scout).to receive(:new).and_return(
          instance_double(
            GemBench::Scout,
            "instance.scout",
            loaded_gems: [["rspec", "4.0.0"]],
            gem_paths: [],
            gemfile_path: "",
            "check_gemfile?": false,
          ),
        )
        expect(instance.excluded.map(&:first).sort).to be_empty
        expect(GemBench::Scout).to have_received(:new)
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

    context "with no starters" do
      let(:scout) { GemBench::Scout.new(check_gemfile: check_gemfile, **scout_options) }
      let(:scout_options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "no_starters_benchable.gemfile")} }
      let(:check_gemfile) { nil } # when nil it can default to true

      context "when :all empty" do
        it "evaluates nothing" do
          allow(scout).to receive(:loaded_gems).and_return([])
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] No gems were evaluated by GemBench.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
        end
      end

      context "when :starters empty" do
        it "finds no gems to load at boot time" do
          allow(scout).to receive(:loaded_gems).and_return([["test-unit", "3.6.2"]])
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] Found no gems that need to load at boot time.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
        end

        context "when bad ideas" do
          let(:options) { {bad_ideas: true} }
          let(:check_gemfile) { false }

          it "shows bad ideas" do
            allow(scout).to receive(:loaded_gems).and_return([["test-unit", "3.6.2"]])
            allow(GemBench::Scout).to receive(:new).and_return(scout)
            block_is_expected.to not_raise_error.and output(
              include(
                <<~OUT.chomp,
                  [GemBench] Evaluated 1 loaded gems and found 1 which may be able to skip boot loading (require: false).
                  *** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.
                  To safely evaluate a Gemfile:
                  \t1. Make sure you are in the root of a project with a Gemfile
                  \t2. Make sure the gem is actually a dependency in the Gemfile
                  \t[BE CAREFUL] 1) gem 'test-unit', '~> 3.6', require: false
                OUT
              ),
            ).to_stdout
            expect(GemBench::Scout).to have_received(:new)
          end

          context "already benched" do
            let(:scout_options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "no_starters_benched.gemfile")} }
            let(:options) { {bad_ideas: true} }
            let(:check_gemfile) { false }

            it "shows bad ideas" do
              allow(scout).to receive(:loaded_gems).and_return([["test-unit", "3.6.2"]])
              allow(GemBench::Scout).to receive(:new).and_return(scout)
              block_is_expected.to not_raise_error.and output(
                include(
                  <<~OUT.chomp,
                    [GemBench] Evaluated 1 loaded gems and found 1 which may be able to skip boot loading (require: false).
                    *** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.
                    To safely evaluate a Gemfile:
                    \t1. Make sure you are in the root of a project with a Gemfile
                    \t2. Make sure the gem is actually a dependency in the Gemfile
                    \t[BE CAREFUL] 1) gem 'test-unit', '~> 3.6', require: false
                  OUT
                ),
              ).to_stdout
              expect(GemBench::Scout).to have_received(:new)
            end

            context "when check gemfile" do
              let(:check_gemfile) { true }

              it "shows bad ideas" do
                allow(scout).to receive(:loaded_gems).and_return([["test-unit", "3.6.2"]])
                allow(GemBench::Scout).to receive(:new).and_return(scout)
                block_is_expected.to not_raise_error.and output(
                  include(
                    <<~OUT.chomp,
                      [GemBench] Will show bad ideas.  Be Careful.
                      [GemBench] Detected 1 loaded gems
                      [GemBench] Found no gems that need to load at boot time.
                      [GemBench] Evaluated 1 gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).
                      [GemBench] Evaluated 1 loaded gems and found 1 which may be able to skip boot loading (require: false).
                      *** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.
                      \t[BE CAREFUL] 1) gem 'test-unit', '~> 3.6', require: false
                    OUT
                  ),
                ).to_stdout
                expect(GemBench::Scout).to have_received(:new)
              end
            end
          end
        end
      end

      context "when :look_for_regex" do
        let(:options) { {look_for_regex: /luke-i-am-your-mother/} }

        it "tries to find" do
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] Found no gems containing (?-mix:luke-i-am-your-mother) in Ruby code.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
        end
      end
    end

    context "with no benchers" do
      let(:scout) { GemBench::Scout.new(check_gemfile: check_gemfile, **scout_options) }
      let(:scout_options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "no_benchers.gemfile")} }
      let(:check_gemfile) { nil } # when nil it can default to true

      context "when :all empty" do
        it "evaluates nothing" do
          allow(scout).to receive(:loaded_gems).and_return([])
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] No gems were evaluated by GemBench.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
        end
      end

      context "when :starters empty" do
        it "finds no gems to load at boot time" do
          allow(scout).to receive(:loaded_gems).and_return([["rspec", "3.13.0"]])
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] Found no gems that need to load at boot time.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
        end

        context "when bad ideas" do
          let(:options) { {bad_ideas: true} }
          let(:check_gemfile) { false }

          it "shows bad ideas" do
            allow(scout).to receive(:loaded_gems).and_return([["rspec", "3.13.0"]])
            allow(GemBench::Scout).to receive(:new).and_return(scout)
            block_is_expected.to not_raise_error.and output(
              include(
                <<~OUT.chomp,
                  [GemBench] Evaluated 1 loaded gems and found 1 which may be able to skip boot loading (require: false).
                  *** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.
                  To safely evaluate a Gemfile:
                  \t1. Make sure you are in the root of a project with a Gemfile
                  \t2. Make sure the gem is actually a dependency in the Gemfile
                  \t[BE CAREFUL] 1) rspec had no files to evaluate.
                OUT
              ),
            ).to_stdout
            expect(GemBench::Scout).to have_received(:new)
          end

          context "when check gemfile" do
            let(:check_gemfile) { true }

            it "shows bad ideas" do
              allow(scout).to receive(:loaded_gems).and_return([["rspec", "3.13.0"]])
              allow(GemBench::Scout).to receive(:new).and_return(scout)
              out1 = <<~OUT1.chomp
                [GemBench] Will show bad ideas.  Be Careful.
                [GemBench] Detected 1 loaded gems
                [GemBench] Found no gems that need to load at boot time.
              OUT1
              out2 = <<~OUT2.chomp
                [GemBench] Here are 1 suggestions for improvement:
                \t[SUGGESTION] 1) rspec had no files to evaluate.
                [GemBench] Evaluated 1 gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).
              OUT2
              block_is_expected.to not_raise_error.and output(include(out1, out2)).to_stdout
              expect(GemBench::Scout).to have_received(:new)
            end
          end
        end
      end

      context "when :look_for_regex" do
        let(:options) { {look_for_regex: /luke-i-am-your-mother/} }

        it "tries to find" do
          allow(GemBench::Scout).to receive(:new).and_return(scout)
          block_is_expected.to not_raise_error.and output(include("[GemBench] Found no gems containing (?-mix:luke-i-am-your-mother) in Ruby code.\n")).to_stdout
          expect(GemBench::Scout).to have_received(:new)
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
