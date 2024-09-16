RSpec.describe GemBench::Player do
  let(:options) {
    {
      name: "gem_bench",
      version: "0.1.0",
    }
  }
  let(:instance) { described_class.new(options) }

  describe "initialize" do
    it "does not raise error" do
      block_is_expected.not_to raise_error
    end
  end

  describe "#set_starter" do
    let(:options) {
      {
        name: "gem_bench",
        version: "0.1.0",
        exclude_file_pattern: /banana/,
      }
    }

    it "returns false if matches exclude pattern" do
      expect(instance.set_starter("hello_banana_peel")).to be(false)
    end

    it "sets state to bench if non scannable gem" do
      stub_const("GemBench::DO_NOT_SCAN", ["gem_bench"])
      expect { instance.set_starter("margarine") }
        .to change(instance, :state)
        .from(nil)
        .to(:bench)
      stub_const("GemBench::DO_NOT_SCAN", [])
    end

    it "sets state to bench when invalid byte sequence" do
      allow(File).to receive(:read).and_raise(ArgumentError, "invalid byte sequence")
      expect { instance.set_starter("margarine") }
        .to change(instance, :state)
        .from(nil)
        .to(:bench)
    end

    it "raises when other error" do
      allow(File).to receive(:read).and_raise(ArgumentError, "pumpkins are orange")
      expect { instance.set_starter("margarine") }
        .to raise_error(ArgumentError, "pumpkins are orange")
    end
  end

  describe "#to_s" do
    it "returns string with name format" do
      expect(instance.to_s(:name)).to eq("gem_bench")
    end

    it "returns string with :v format" do
      expect(instance.to_s(:v)).to eq("gem_bench v0.1.0")
    end

    it "returns string with :semver format" do
      expect(instance.to_s(:semver)).to eq("gem 'gem_bench', '~> 0.1'")
    end

    it "returns string with :locked format" do
      expect(instance.to_s(:locked)).to eq("gem 'gem_bench', '0.1.0'")
    end

    it "returns string with :legacy format" do
      expect(instance.to_s(:legacy)).to eq("gem 'gem_bench', '~> 0.1.0'")
    end

    it "returns string with :upgrade format" do
      expect(instance.to_s(:upgrade)).to eq("gem 'gem_bench', '>= 0.1.0'")
    end

    it "returns string with default format" do
      expect(instance.to_s).to eq("gem_bench")
    end

    context "unknown format" do
      subject(:player_to_string) { instance.to_s(:smartypants) }

      it "raises error with unknown format" do
        block_is_expected.to raise_error(ArgumentError, "Unknown format for GemBench::Player#to_s")
      end
    end
  end

  describe "#inspect" do
    it "returns name" do
      expect(instance.inspect).to eq("gem_bench")
    end
  end

  describe "#how" do
    subject(:how) { instance.how }

    before do
      instance.state = state
    end

    context "when state is starter" do
      let(:state) { :starter }

      it "returns semver format" do
        expect(how).to eq("gem 'gem_bench', '~> 0.1'")
      end
    end

    context "when state is bench" do
      let(:state) { :bench }

      it "returns semver format, require: false" do
        expect(how).to eq("gem 'gem_bench', '~> 0.1', require: false")
      end
    end

    context "when state is nil" do
      let(:state) { nil }

      context "when checked is falsey" do
        it "returns string" do
          expect(instance.checked).to be_falsey
          expect(how).to eq("gem_bench had no files to evaluate.")
        end
      end

      context "when checked is truthy" do
        before do
          # sets checked to true
          instance.set_starter(File.join(File.dirname(__FILE__), "..", "..", "lib", "gem_bench.rb"))
          # set state to unexpected value
          instance.state = nil
        end

        it "is feeling very lost" do
          expect(how).to eq("gem_bench is feeling very lost right now.")
        end
      end
    end
  end

  describe "#suggest" do
    it "returns string" do
      expect(instance.suggest(2)).to eq("\t[SUGGESTION] 2) gem_bench had no files to evaluate.")
    end
  end

  describe "#info" do
    it "returns string" do
      expect(instance.info(2)).to eq("\t[INFO] 2) gem_bench had no files to evaluate.")
    end
  end

  describe "#careful" do
    it "returns string" do
      expect(instance.careful(2)).to eq("\t[BE CAREFUL] 2) gem_bench had no files to evaluate.")
    end
  end
end
