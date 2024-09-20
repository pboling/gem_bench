# frozen_string_literal: true

require "rspec"

RSpec.describe GemBench::StrictVersionRequirement do
  subject(:instance) { described_class.new(options) }

  let(:options) { {} }

  describe "::new" do
    it "succeeds" do
      block_is_expected.to not_raise_error
    end

    context "when verbose" do
      let(:options) { {verbose: true} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
    end

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
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

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      let(:name) { "sanitize_email" }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      it "returns a StrictVersionGem" do
        expect(find).to be_a(GemBench::StrictVersionGem)
      end

      it "the right one" do
        expect(find.name).to eq(name)
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

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      let(:index) { 5 }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end

      it "returns gem at line number" do
        expect(gem_at.name).to eq("anonymous_active_record")
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

    context "when gemfile_path" do
      let(:options) { {gemfile_path: File.join(File.dirname(__FILE__), "..", "support", "gemfile.rb")} }

      it "succeeds" do
        block_is_expected.to not_raise_error
      end
    end
  end
end
