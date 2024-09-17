RSpec.describe GemBench::Scout do
  let(:instance) { described_class.new }

  describe "initialize" do
    it "does not raise error" do
      expect { instance }.not_to raise_error
    end

    context "check_gemfile" do
      context "is true" do
        let(:instance) { described_class.new(check_gemfile: true) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "is false" do
        let(:instance) { described_class.new(check_gemfile: false) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "is nil" do
        let(:instance) { described_class.new(check_gemfile: nil) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "is default" do
        let(:instance) { described_class.new }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end
    end

    context "early bundler error" do
      subject(:instance) { described_class.new }

      before do
        allow(Bundler).to receive(:rubygems).and_raise(Bundler::GemfileNotFound)
      end

      it "does not raise error" do
        expect { instance }.not_to raise_error
      end

      it "sets check_gemfile to false" do
        expect(instance.check_gemfile?).to be(false)
        expect(Bundler).to have_received(:rubygems)
      end

      it "sets gem_paths to empty" do
        expect(instance.gem_paths).to be_empty
        expect(Bundler).to have_received(:rubygems)
      end
    end

    context "late bundler error" do
      subject(:instance) { described_class.new }

      before do
        allow(Bundler).to receive(:bundle_path).and_raise(Bundler::GemfileNotFound)
      end

      it "does not raise error" do
        expect { instance }.not_to raise_error
      end

      it "sets check_gemfile to false" do
        expect(instance.check_gemfile?).to be(false)
        expect(Bundler).to have_received(:bundle_path)
      end

      it "sets gem_paths to soemthing" do
        expect(instance.gem_paths).to include(match(/\/gems/))
        expect(Bundler).to have_received(:bundle_path)
      end
    end
  end

  describe "#gem_paths" do
    it("is an array") do
      expect(instance.gem_paths).to be_an(Array)
    end

    it("is not empty") do
      expect(instance.gem_paths).not_to be_empty
    end

    it("of paths with gems") do
      expect(instance.gem_paths.count { |x| x =~ /gems/ }).to eq(instance.gem_paths.length)
    end
  end

  describe "#gemfile_path" do
    it("is an string") do
      expect(instance.gemfile_path).to be_a(String)
    end

    it("is not empty") do
      expect(instance.gemfile_path).not_to be_empty
    end

    it("points to a Gemfile") do
      expect(instance.gemfile_path).to match("Gemfile")
    end
  end

  describe "#gemfile_trash" do
    subject(:gemfile_trash) { instance.gemfile_trash }

    context "check_gemfile: true" do
      let(:instance) { described_class.new(check_gemfile: true) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do
        expect(instance.gemfile_trash).not_to be_empty
        expect(instance.gemfile_trash).to eq(["# Specify your gem's dependencies in gem_bench.gemspec\n"])
      end
    end

    context "check_gemfile: false" do
      let(:instance) { described_class.new(check_gemfile: false) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is empty" do
        expect(instance.gemfile_trash).to be_empty
      end
    end

    context "check_gemfile: nil" do
      let(:instance) { described_class.new(check_gemfile: nil) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do
        expect(instance.gemfile_trash).not_to be_empty
        expect(instance.gemfile_trash).to eq(["# Specify your gem's dependencies in gem_bench.gemspec\n"])
      end
    end

    context "check_gemfile: default" do
      let(:instance) { described_class.new }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do
        expect(instance.gemfile_trash).not_to be_empty
        expect(instance.gemfile_trash).to eq(["# Specify your gem's dependencies in gem_bench.gemspec\n"])
      end
    end
  end

  describe "#gemfile_lines" do
    subject(:gemfile_lines) { instance.gemfile_lines }

    context "check_gemfile: true" do
      let(:instance) { described_class.new(check_gemfile: true) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
        expect(gemfile_lines).not_to be_empty
        expect(gemfile_lines[0..1]).to eq([
          "source \"https://rubygems.org\"\n",
          "gem \"bundler\" # For specs!\n",
        ])
      end
    end

    context "check_gemfile: false" do
      let(:instance) { described_class.new(check_gemfile: false) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is empty" do
        expect(gemfile_lines).to be_empty
      end
    end

    context "check_gemfile: nil" do
      let(:instance) { described_class.new(check_gemfile: nil) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
        expect(gemfile_lines).not_to be_empty
        expect(gemfile_lines[0..1]).to eq([
          "source \"https://rubygems.org\"\n",
          "gem \"bundler\" # For specs!\n",
        ])
      end
    end

    context "check_gemfile: default" do
      let(:instance) { described_class.new }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
        expect(gemfile_lines).not_to be_empty
        expect(gemfile_lines[0..1]).to eq([
          "source \"https://rubygems.org\"\n",
          "gem \"bundler\" # For specs!\n",
        ])
      end
    end
  end

  describe "#loaded_gems" do
    subject(:loaded_gems) { instance.loaded_gems }

    let(:instance) { described_class.new }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    it "sets gemfile_lines" do
      expect(loaded_gems).to be_an(Array)
    end

    it "is not empty" do
      expect(loaded_gems).not_to be_empty
    end

    it "includes dependencies" do
      names = loaded_gems.map { |tuple| tuple[0] }
      expect(names).to include("rspec")
      expect(names).to include("rake")
      expect(names).to include("bundler")
    end
  end
end
