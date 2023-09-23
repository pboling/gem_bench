require "spec_helper"

RSpec.describe GemBench::Player do
  let(:instance) { GemBench::Player.new({name: "gem_bench", version: "0.1.0"}) }

  describe "initialize" do
    it "does not raise error" do
      expect { instance }.not_to raise_error
    end
  end
end
