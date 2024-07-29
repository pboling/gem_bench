RSpec.describe GemBench::Player do
  let(:instance) { described_class.new({name: "gem_bench", version: "0.1.0"}) }

  describe "initialize" do
    it "does not raise error" do
      block_is_expected.not_to raise_error
    end
  end
end
