# frozen_string_literal: true

require "rspec"

RSpec.describe GemBench::StrictVersionRequirement do
  subject(:instance) { described_class.new(options) }

  let(:options) { {} }

  describe "::new" do
    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "#versions_present?" do
    subject(:versions_present) { instance.versions_present? }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "#list_missing_version_constraints" do
    subject(:list_missing_version_constraints) { instance.list_missing_version_constraints }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end
  end

  describe "#find" do
    subject(:find) { instance.find(name) }

    let(:name) { "hello" }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end

    context "when not found" do
      it "returns nil" do
        expect(find).to be_nil
      end
    end
  end

  describe "#gem_at" do
    subject(:gem_at) { instance.gem_at(index) }

    let(:index) { 1 }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end

    context "when not found" do
      it "returns nil" do
        expect(gem_at).to be_nil
      end
    end
  end

  describe "#print" do
    subject(:print) { instance.print }

    it "succeeds" do
      block_is_expected.to not_raise_error
    end

    it "has output" do
      expect { print }.to output(/The gems that need to be improved are:/).to_stdout
    end
  end
end
