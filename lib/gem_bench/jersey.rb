# Std Libs Dependencies
require "tmpdir"

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
    attr_reader :verbose

    def initialize(gem_name:, trades:, metadata: {}, verbose: false)
      @gem_name = gem_name
      @gem_path = Gem.loaded_specs[gem_name]&.full_gem_path
      @gem_lib_dir = Gem
      @trades = trades
      @metadata = metadata
      @verbose = verbose
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
      return puts "Skipping #{gem_name} (not loaded on #{RUBY_VERSION})" unless gem_path

      puts "Doffing #{gem_path}" if verbose
      Dir.mktmpdir do |directory|
        Dir[File.join(gem_path, "lib", "**", "*.rb")].map do |file|
          if verbose
            puts file
            puts File.basename(file)
            puts "--------------------------------"
          end
          dirname = File.dirname(file)
          puts "dirname: #{dirname}" if verbose
          is_at_gem_root = dirname[(-4)..(-1)] == "/lib"
          puts "is_at_gem_root: #{is_at_gem_root}" if verbose
          lib_split = dirname.split("/lib/")[-1]
          puts "lib_split: #{lib_split}" if verbose
          # lib_split could be like:
          #   - "ruby/gems/3.2.0/gems/method_source-1.1.0/lib"
          #   - "method_source"
          # Se we check to make sure it is actually a subdir of the gem's lib directory
          full_path = File.join(gem_path, "lib", lib_split)
          relative_path = !is_at_gem_root && Dir.exist?(full_path) && lib_split
          puts "relative_path: #{relative_path}" if verbose
          filename = File.basename(file)[0..-4]
          puts "filename: #{filename}" if verbose

          if relative_path
            dir_path = File.join(directory, relative_path)
            Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
            puts "creating #{filename} in #{dir_path}" if verbose
            create_tempfile_copy(file, filename, dir_path, :dd1, &block)
          else
            puts "directory not relative (#{directory}) for file #{filename}" if verbose
            create_tempfile_copy(file, filename, directory, :dd2, &block)
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

    def create_tempfile_copy(file, filename, directory, from, &block)
      File.open(File.join(directory, "#{filename}.rb"), "w") do |tempfile|
        new_jersey(file, tempfile, from, &block)
      end
    end

    def new_jersey(file, tempfile, from)
      nj = File.read(file)
      trades.each do |old_namespace, new_namespace|
        nj.gsub!(old_namespace, new_namespace)
      end
      if verbose
        puts "new_jersey has from: #{from}"
        puts "new_jersey has file: #{file}"
        puts "new_jersey path: #{tempfile.path}"
      end
      nj = yield nj if block_given?
      tempfile.write(nj)
      tempfile.rewind
      # begin
      require tempfile.path
      # rescue LoadError => e
      #   puts file.to_s
      #   puts tempfile.path
      #   puts e.class
      #   puts e.message
      # end
    end
  end
end
