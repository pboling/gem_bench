# Std Libs Dependencies
require "tmpdir"

module GemBench
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
  # Benchmarking Example
  #
  #   See: https://github.com/panorama-ed/memo_wise/blob/main/benchmarks/benchmarks.rb
  class Jersey
    attr_reader :gem_name
    attr_reader :gem_path
    attr_reader :trades
    attr_reader :metadata
    attr_reader :files
    attr_reader :verbose

    def initialize(gem_name:, trades:, metadata: {}, verbose: false)
      @gem_name = gem_name
      @gem_path = Gem.loaded_specs[gem_name]&.full_gem_path
      @gem_lib_dir = Gem
      @trades = trades
      @metadata = metadata
      @verbose = verbose
    end

    # return [true, false] proxy for whether the copied, re-namespaced gem has been successfully loaded
    def required?
      gem_path && trades.values.all? { |new_namespace| Object.const_defined?(new_namespace) }
    end

    # Generates a temp directory, and creates a copy of a gem within it.
    # Re-namespaces the copy according to the `trades` configuration.
    # Then requires each file of the "copied gem", resulting
    #   in a loaded gem that will not have namespace
    #   collisions when loaded alongside the original-namespaced gem.
    # Note that "copied gem" in the previous sentence is ambiguous without the supporting context.
    # The "copied gem" can mean either the original, or the "copy", which is why this gem refers to
    #   a "doffed gem" (the original) and a "donned gem" (the copy).
    # If a block is provided the contents of each file will be yielded to the block,
    #   after all namespace substitutions from `trades` are complete, but before the contents
    #   are written to the re-namespaced gem. The return value of the block will be
    #   written to the file in this scenario.
    #
    # @return void
    def doff_and_don(&block)
      return puts "[#{gem_name}] Skipped (not loaded on #{RUBY_VERSION})" unless gem_path

      puts "[#{gem_name}] Doffing #{gem_path}" if verbose
      Dir.mktmpdir do |tmp_dir|
        files = []
        Dir[File.join(gem_path, "lib", "**", "*.rb")].map do |file|
          if verbose
            puts "[#{gem_name}] --------------------------------"
            puts "[#{gem_name}] Doffing file #{file}"
            puts "[#{gem_name}] --------------------------------"
          end
          basename = File.basename(file)
          dirname = File.dirname(file)
          puts "[#{gem_name}][#{basename}] dirname: #{dirname}" if verbose
          is_at_gem_root = dirname[(-4)..(-1)] == "/lib"
          puts "[#{gem_name}][#{basename}] is_at_gem_root: #{is_at_gem_root}" if verbose
          lib_split = dirname.split("/lib/")[-1]
          puts "[#{gem_name}][#{basename}] lib_split: #{lib_split}" if verbose
          # lib_split could be like:
          #   - "ruby/gems/3.2.0/gems/method_source-1.1.0/lib"
          #   - "method_source"
          # Se we check to make sure it is actually a subdir of the gem's lib directory
          full_path = File.join(gem_path, "lib", lib_split)
          relative_path = !is_at_gem_root && Dir.exist?(full_path) && lib_split
          puts "[#{gem_name}][#{basename}] relative_path: #{relative_path}" if verbose

          if relative_path
            dir_path = File.join(tmp_dir, relative_path)
            Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
            puts "[#{gem_name}][#{basename}] copying file to #{dir_path}" if verbose
            files << create_tempfile_copy(file, dir_path, basename, :dd1, &block)
          else
            puts "[#{gem_name}][#{basename}] directory not relative (#{tmp_dir})" if verbose
            files << create_tempfile_copy(file, tmp_dir, basename, :dd2, &block)
          end
        end
        load_gem_copy(tmp_dir, files)
      end

      nil
    end

    # @return [String] Namespace of the doffed (original) gem
    def doffed_primary_namespace
      trades.keys.first
    end

    # @return [String] Namespace of the donned gem
    def donned_primary_namespace
      trades.values.first
    end

    # Will raise NameError if called before #doff_and_don
    # @return [Class, nil]
    def as_klass
      Object.const_get(donned_primary_namespace) if gem_path
    end

    private

    # @param tmp_dir [String] absolute file path of the tmp directory
    # @param files [Array[String]] absolute file path of each file in the donned gem
    # @return void
    def load_gem_copy(tmp_dir, files)
      if verbose
        puts "[#{gem_name}] Doffed gem located at #{gem_path}"
        puts "[#{gem_name}] Donned gem located at #{tmp_dir}"
        puts "[#{gem_name}] Primary namespace updated: #{doffed_primary_namespace} => #{donned_primary_namespace}"
        puts "[#{gem_name}] Donned files:\n\t#{files.join("\n\t")}"
      end
      files.each do |filepath|
        # But files required here may not load their own internal files properly if they are still using `require`.
        # Since Ruby 1.9.2, best practice for ruby libraries is to use require_relative for internal files,
        #   and require for external files and dependencies, generally, and oversimplified.
        # Ref: https://github.com/rubocop/rubocop/issues/8748#issuecomment-2363327346
        # However, We *can* use `require` *here*, because filepath here is an absolute paths
        require filepath
      end

      nil
    end

    # @param orig_file_path [String] absolute file path of the original file
    # @param tmp_dir [String] absolute file path of the tmp directory
    # @param basename [String] the basename of the file being copied
    # @param debug_info [Symbol] for debugging purposes
    # @return [String] the file path of the new copy of the original file
    def create_tempfile_copy(orig_file_path, tmp_dir, basename, debug_info, &block)
      File.open(File.join(tmp_dir, basename), "w") do |donned_file|
        # Value of block is returned from File.open, and thus from this method
        new_jersey(orig_file_path, donned_file, basename, debug_info, &block)
      end
    end

    # New Jersey is not Ohio. Writes donned files to disk.
    #
    # @param doffed_file_path [String] absolute file path of the original file
    # @param donned_file [File] the file which needs to be written to disk
    # @param basename [String] the basename of the file for verbose logging
    # @param debug_info [Symbol] for debugging purposes
    # @return [String] the file path of the donned file
    def new_jersey(doffed_file_path, donned_file, basename, debug_info = nil)
      nj = File.read(doffed_file_path)
      trades.each do |old_namespace, new_namespace|
        nj.gsub!(old_namespace, new_namespace)
      end
      if verbose
        puts "[#{gem_name}][#{basename}] new_jersey doffed_file_path: #{doffed_file_path}"
        puts "[#{gem_name}][#{basename}] new_jersey donned_file path: #{donned_file.path}"
        puts "[#{gem_name}][#{basename}] new_jersey debug_info: #{debug_info}"
      end
      nj = yield nj if block_given?
      donned_file.write(nj)
      donned_file.close
      donned_file.path
    end
  end
end
