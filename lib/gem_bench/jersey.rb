# Std Libs Dependencies
require "tempfile"

# Re-write a gem to a temp directory, re-namespace the primary namespace of that gem module, and load it.
# If the original gem defines multiple top-level namespaces, they can all be renamed by providing more key value pairs.
# If the original gem monkey patches other libraries, that behavior can't be isolated, so YMMV.
#
# NOTE: Non-top-level namespaces do not need to be renamed, as they are isolated within their parent namespace.
#
# Usage
#
#   jersey = GemBench::Jersey.new(
#     gem_name: "alt_memery"
#     trades: {
#       "Memery" => "AltMemery"
#     },
#     metadata: {
#       something: "a value here",
#       something_else: :obviously,
#     },
#   )
#   jersey.doff_and_don
#   # The re-namespaced constant is now available!
#   AltMemery # => AltMemery
#
module GemBench
  class Jersey
    attr_reader :gem_name
    attr_reader :gem_path
    attr_reader :trades
    attr_reader :metadata
    attr_reader :files

    def initialize(gem_name:, trades:, metadata: {})
      @gem_name = gem_name
      @gem_path = Gem.loaded_specs[gem_name]&.full_gem_path
      @trades = trades
      @metadata = metadata
    end

    def required?
      gem_path && trades.values.all? { |new_namespace| Object.const_defined?(new_namespace) }
    end

    # Generates tempfiles and requires them, resulting
    #   in a loaded gem that will not have namespace
    #   collisions when alongside the original-namespaced gem.
    # If a block is provided the contents of each file will be yielded to the block,
    #   after all namespace substitutions are complete, but before the contents
    #   are written to the re-namespaced gem. The return value of the block will be
    #   written to the file in this scenario.
    #
    # @return void
    def doff_and_don(&block)
      return unless gem_path

      Dir.mktmpdir do |directory|
        Dir["#{gem_path}/lib/**/*.rb"].map do |file|
          Tempfile.open([File.basename(file)[0..-4], ".rb"], directory) do |tempfile|
            new_jersey(file, tempfile, &block)
          end
        end
      end

      nil
    end

    def primary_namespace
      trades.values.first
    end

    # Will raise NameError if called before #doff_and_don
    def as_klass
      Object.const_get(primary_namespace) if gem_path
    end

    private

    def new_jersey(file, tempfile)
      nj = File.read(file)
      trades.each do |old_namespace, new_namespace|
        nj.gsub!(old_namespace, new_namespace)
      end
      nj = yield nj if block_given?
      tempfile.write(nj)
      tempfile.rewind
      require tempfile.path
    end
  end
end
