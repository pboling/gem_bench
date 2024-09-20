# frozen_string_literal: true

require "rspec"

RSpec.describe GemBench::GemfileLineTokenizer do
  subject(:instance) { described_class.new(*args) }

  let(:args) {
    [
      all_lines,
      line,
      index,
    ]
  }
  let(:all_lines) { %w(hello darkness) }
  let(:line) { "hello" }
  let(:index) { 0 }

  describe "::new" do
    it "succeeds" do
      block_is_expected.to not_raise_error
    end

    context "when is gem" do
      let(:all_lines) {
        [
          %(gem "snaky_hash"),
          line,
        ]
      }
      let(:line) { %(gem "version_gem", "1.0.4") }
      let(:index) { 1 }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      it "has name" do
        expect(instance.name).to eq("version_gem")
      end

      it "has version" do
        expect(instance.version).to eq("1.0.4")
      end

      context "when fancy quotes" do
        let(:line) { "gem %Q(version_gem), %Q(1.0.4)" }

        it "has name" do
          expect(instance.name).to eq("version_gem")
        end

        it "has version" do
          expect(instance.version).to eq("1.0.4")
        end
      end

      context "when branch" do
        let(:line) { "gem %Q(version_gem), gitlab: %Q(oauth-xx/version_gem), branch: 'main'" }

        it "has name" do
          expect(instance.name).to eq("version_gem")
        end

        it "has version" do
          expect(instance.version).to eq({
            github: "oauth-xx/version_gem",
            branch: "main",
          })
        end

        context "when git ref" do
          let(:line) { "gem %Q(version_gem), gitlab: %Q(oauth-xx/version_gem), branch: 'main', ref: %Q(5086ef73754282e1e878539819e76915bce56103)" }

          it "has name" do
            expect(instance.name).to eq("version_gem")
          end

          it "has version" do
            expect(instance.version).to eq({
              github: "oauth-xx/version_gem",
              branch: "main",
              ref: "5086ef73754282e1e878539819e76915bce56103",
            })
          end

          context "when empty" do
            let(:line) { "gem %Q(version_gem), gitlab: %Q(oauth-xx/version_gem), branch: 'main', ref: ''" }

            it "has name" do
              expect(instance.name).to eq("version_gem")
            end

            it "has empty ref" do
              expect(instance.version).to eq({
                github: "oauth-xx/version_gem",
                branch: "main",
                ref: "",
              })
            end
          end
        end
      end
    end
  end
end
