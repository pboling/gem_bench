RSpec.describe GemBench do
  describe "::check" do
    subject(:check) { described_class.check(**opts) }

    let(:opts) { {} }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "::versions_present?" do
    subject(:versions_present) { described_class.versions_present?(**opts) }

    let(:opts) { {} }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "::list_missing_version_constraints" do
    subject(:list_missing_version_constraints) { described_class.list_missing_version_constraints(**opts) }

    let(:opts) { {} }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "::find" do
    subject(:find) { described_class.find(**opts) }

    let(:opts) { {} }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end
end
