# frozen_string_literal: true

RSpec.describe GemBench::StrictVersionGem do
  subject(:instance) { described_class.new(*args) }

  let(:args) {
    [
      name,
      version,
      version_type,
      valid,
      relevant_lines,
      index,
      tokenized_line,
    ]
  }
  let(:name) { "oh_hi" }
  let(:version) { "5.7.4" }
  let(:version_type) { :constraint }
  let(:valid) { true }
  let(:relevant_lines) { %w(hello darkness) }
  let(:index) { 1 }
  let(:tokenized_line) { "oh_hi" }

  describe "::new" do
    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end
end
