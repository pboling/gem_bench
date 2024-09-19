require "gem_bench/jersey"

require "method_source"

RSpec.describe GemBench::Jersey do
  let(:args) do
    {
      gem_name: gem_name,
      trades: trades,
      metadata: metadata,
      verbose: verbose,
    }
  end
  let(:gem_name) { "method_source" }
  let(:old_namespace) { "MethodSource" }
  let!(:alphabet) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
  let(:donned_namespace) { "#{alphabet[rand(26)]}#{alphabet[rand(26)].downcase}#{alphabet[rand(26)].downcase}#{alphabet[rand(26)]}#{alphabet[rand(26)].downcase}#{alphabet[rand(26)].downcase}#{alphabet[rand(26)]}#{alphabet[rand(26)].downcase}#{alphabet[rand(26)].downcase}" }
  let(:trades) { {old_namespace => donned_namespace} }
  let(:metadata) { {} }
  let(:verbose) { false }
  let(:instance) { described_class.new(**args) }

  describe "#initialize" do
    subject(:init) { instance }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end
  end

  describe "#required?" do
    subject(:required) { instance.required? }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    it "returns false" do
      expect(required).to be(false)
    end

    context "when doff and donned" do
      before { instance.doff_and_don }

      it "returns true" do
        expect(required).to be(true)
      end
    end
  end

  describe "#doff_and_don" do
    subject(:doff_and_don) { instance.doff_and_don }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    it "returns nil" do
      expect(doff_and_don).to be_nil
    end

    context "when verbose" do
      let(:verbose) { true }

      it "returns nil" do
        expect(doff_and_don).to be_nil
      end
    end
  end

  describe "#doffed_primary_namespace" do
    subject(:doffed_primary_namespace) { instance.doffed_primary_namespace }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    it "returns first original namespace" do
      expect(doffed_primary_namespace).to eq(old_namespace)
    end

    context "when multiple namespaces" do
      let(:trades) do
        {
          "Blue" => "Green",
          old_namespace => donned_namespace,
        }
      end

      it "returns first original namespace" do
        expect(doffed_primary_namespace).to eq("Blue")
      end
    end
  end

  describe "#donned_primary_namespace" do
    subject(:donned_primary_namespace) { instance.donned_primary_namespace }

    it "does not raise error" do
      block_is_expected.not_to raise_error
    end

    it "returns first new namespace" do
      expect(donned_primary_namespace).to eq(donned_namespace)
    end

    context "when multiple namespaces" do
      let(:trades) do
        {
          "Blue" => "Green",
          old_namespace => donned_namespace,
        }
      end

      it "returns first new namespace" do
        expect(donned_primary_namespace).to eq("Green")
      end
    end
  end

  describe "#gem_path" do
    it "includes the gem's name" do
      expect(instance.gem_path).to include(gem_name)
    end
  end

  describe "#as_klass" do
    subject(:as_klass) { instance.as_klass }

    context "when not doffed and donned" do
      it "raises error" do
        block_is_expected.to raise_error(NameError, "uninitialized constant #{donned_namespace}")
      end
    end

    context "when doff and donned" do
      before { instance.doff_and_don }

      it "does not raise error" do
        block_is_expected.not_to raise_error
      end

      it "returns a module/class with name of new namespace" do
        expect(as_klass.name).to eq(donned_namespace)
      end
    end
  end
end
