# Scout's job is to figure out where gems are hiding
#
module GemBench
  class Scout
    attr_reader :gem_paths, :gemfile_path, :gemfile_lines, :gemfile_trash, :loaded_gems

    def initialize(check_gemfile: nil)
      @check_gemfile = check_gemfile.nil? ? true : check_gemfile
      @gemfile_path = "#{Dir.pwd}/Gemfile"
      gem_lookup_paths_from_bundler
      gem_lines_from_gemfile
      # Gem.loaded_specs are the gems that have been loaded / required.
      @loaded_gems = Gem.loaded_specs.values.map { |x| [x.name, x.version.to_s] }
    end

    def check_gemfile?
      @check_gemfile
    end

    private

    def gem_lookup_paths_from_bundler
      @gem_paths = [Bundler.rubygems.gem_dir, Bundler.rubygems.gem_path]
        .flatten
        .compact
        .uniq
        .map { |x| x.to_s }
        .reject { |p| p.empty? }
        .map { |x| "#{x}/gems" }
      @gem_paths << "#{Bundler.install_path}"
      @gem_paths << "#{Bundler.bundle_path}/gems"
      @gem_paths.uniq!
    rescue Bundler::GemfileNotFound => e
      # Don't fail here, but also don't check the Gemfile.
      @check_gemfile = false
    ensure
      @gem_paths = [] unless @gem_paths.is_a?(Array)
    end

    def gem_lines_from_gemfile
      if check_gemfile?
        file = File.open(gemfile_path)
        # Get all lines as an array
        all_lines = file.readlines
        # Remove all the commented || blank lines
        @gemfile_trash, @gemfile_lines = all_lines.partition { |x| x =~ GemBench::TRASH_REGEX }
        @gemfile_trash.reject! { |x| x == "\n" } # remove blank lines
      else
        @gemfile_trash = []
        @gemfile_lines = []
      end
    end
  end
end
