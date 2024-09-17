# frozen_string_literal: true

require "rspec"

RSpec.describe GemBench::GemfileLineTokenizer do
  subject(:instance) { described_class.new(*args) }

  let(:args) {
    [
      all_lines,
      line,
      index,
    ]
  }
  let(:all_lines) { %w(hello darkness) }
  let(:line) { "hello" }
  let(:index) { 0 }

  describe "::new" do
    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end
end
