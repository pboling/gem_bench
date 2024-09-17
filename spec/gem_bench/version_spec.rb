RSpec.describe GemBench::Version do
  it_behaves_like "a Version module", described_class

  it "is greater than 1.0.0" do
    expect(Gem::Version.new(described_class) >= Gem::Version.new("1.0.0")).to be(true)
  end
end
