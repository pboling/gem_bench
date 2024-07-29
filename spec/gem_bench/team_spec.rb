RSpec.describe GemBench::Team do
  let(:instance) { described_class.new }

  describe "initialize" do
    it "does not raise error" do
      expect { instance }.not_to raise_error
    end
  end
end
