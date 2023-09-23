require "spec_helper"

RSpec.describe GemBench::Team do
  let(:instance) { GemBench::Team.new }

  describe "initialize" do
    it "does not raise error" do
      expect { instance }.not_to raise_error
    end
  end
end
