RSpec.describe GemBench::Scout do
  let(:instance) { described_class.new }

  describe "initialize" do
    it "does not raise error" do
      expect { instance }.not_to raise_error
    end

    context "when check_gemfile" do
      context "when true" do
        let(:instance) { described_class.new(check_gemfile: true) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "when false" do
        let(:instance) { described_class.new(check_gemfile: false) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "when nil" do
        let(:instance) { described_class.new(check_gemfile: nil) }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end

      context "when default" do
        let(:instance) { described_class.new }

        it "does not raise error" do
          expect { instance }.not_to raise_error
        end
      end
    end

    context "when early bundler error" do
      subject(:instance) { described_class.new }

      before do
        allow(Bundler).to receive(:rubygems).and_raise(Bundler::GemfileNotFound)
      end

      it "does not raise error" do
        expect { instance }.not_to raise_error
      end

      context "when #check_gemfile?" do
        subject(:check_gemfile) { instance.check_gemfile? }

        it "sets check_gemfile to false" do
          expect(check_gemfile).to be(false)
        end

        it "uses Bundler's bundle_path" do
          check_gemfile
          expect(Bundler).to have_received(:rubygems)
        end
      end

      context "when #gem_paths" do
        subject(:gem_paths) { instance.gem_paths }

        it "sets gem_paths to empty" do
          expect(gem_paths).to be_empty
        end

        it "uses Bundler's bundle_path" do
          gem_paths
          expect(Bundler).to have_received(:rubygems)
        end
      end
    end

    context "when late bundler error" do
      subject(:instance) { described_class.new }

      before do
        allow(Bundler).to receive(:bundle_path).and_raise(Bundler::GemfileNotFound)
      end

      it "does not raise error" do
        expect { instance }.not_to raise_error
      end

      context "when #check_gemfile?" do
        subject(:check_gemfile) { instance.check_gemfile? }

        it "sets gem_paths to something" do
          expect(check_gemfile).to be(false)
        end

        it "uses Bundler's bundle_path" do
          check_gemfile
          expect(Bundler).to have_received(:bundle_path)
        end
      end

      context "when #gem_paths" do
        subject(:gem_paths) { instance.gem_paths }

        it "sets gem_paths to something" do
          expect(gem_paths).to include(match(/\/gems/))
        end

        it "uses Bundler's bundle_path" do
          gem_paths
          expect(Bundler).to have_received(:bundle_path)
        end
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

    context "when check_gemfile: true" do
      let(:instance) { described_class.new(check_gemfile: true) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do # rubocop:disable RSpec/ExampleLength
        expect(instance.gemfile_trash)
          .to eq(
            [
              "# For complexity!\n",
              "# (this syntax is not supported by gem_bench, but also shouldn't make it blow up)\n",
              "# Need test-unit be loaded by bundler for evaluation in specs\n",
              "# Specify your gem's dependencies in gem_bench.gemspec\n",
            ],
          )
      end
    end

    context "when check_gemfile: false" do
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

    context "when check_gemfile: nil" do
      let(:instance) { described_class.new(check_gemfile: nil) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do # rubocop:disable RSpec/ExampleLength
        expect(instance.gemfile_trash)
          .to eq(
            [
              "# For complexity!\n",
              "# (this syntax is not supported by gem_bench, but also shouldn't make it blow up)\n",
              "# Need test-unit be loaded by bundler for evaluation in specs\n",
              "# Specify your gem's dependencies in gem_bench.gemspec\n",
            ],
          )
      end
    end

    context "when check_gemfile: default" do
      let(:instance) { described_class.new }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_trash" do
        expect(instance.gemfile_trash).to be_an(Array)
      end

      it "gemfile_trash is not empty" do # rubocop:disable RSpec/ExampleLength
        expect(instance.gemfile_trash).to eq(
          [
            "# For complexity!\n",
            "# (this syntax is not supported by gem_bench, but also shouldn't make it blow up)\n",
            "# Need test-unit be loaded by bundler for evaluation in specs\n",
            "# Specify your gem's dependencies in gem_bench.gemspec\n",
          ],
        )
      end
    end
  end

  describe "#gemfile_lines" do
    subject(:gemfile_lines) { instance.gemfile_lines }

    context "when check_gemfile: true" do
      let(:instance) { described_class.new(check_gemfile: true) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
        expect(gemfile_lines[0..1]).to eq([
          "source \"https://rubygems.org\"\n",
          "gem \"bundler\" # For specs!\n",
        ])
      end
    end

    context "when check_gemfile: false" do
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

    context "when check_gemfile: nil" do
      let(:instance) { described_class.new(check_gemfile: nil) }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
        expect(gemfile_lines[0..1]).to eq([
          "source \"https://rubygems.org\"\n",
          "gem \"bundler\" # For specs!\n",
        ])
      end
    end

    context "when check_gemfile: default" do
      let(:instance) { described_class.new }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "sets gemfile_lines" do
        expect(gemfile_lines).to be_an(Array)
      end

      it "gemfile_lines is not empty" do
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
      expect(names).to include("rspec", "rake", "bundler")
    end
  end
end
