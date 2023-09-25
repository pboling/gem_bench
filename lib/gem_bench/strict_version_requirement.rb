module GemBench
  class StrictVersionRequirement
    attr_reader :gemfile_path, :gems, :starters, :benchers, :verbose

    def initialize(options = {})
      @gemfile_path = "#{Dir.pwd}/Gemfile"
      file = File.open(gemfile_path)
      # Get all lines as an array
      all_lines = file.readlines
      @gems = []
      all_lines.each_with_index do |line, index|
        # will return nil if the line is not a gem line
        gem = StrictVersionGem.from_line(all_lines, line, index)
        @gems << gem if gem
      end

      @starters, @benchers = @gems.partition { |x| x.valid? }
      # Remove all the commented || blank lines
      @verbose = options[:verbose]
      self.print if verbose
    end

    def versions_present?
      gems.detect { |x| !x.valid? }.nil?
    end

    def list_missing_version_constraints
      benchers.map { |x| x.name }
    end

    def find(name)
      gems.detect { |x| x.name == name }
    end

    def gem_at(index)
      gems.detect { |x| x.index == index }
    end

    def print
      using_path = benchers.count { |x| x.is_type?(:path) }
      puts <<~EOS
        #{"      "}
        The gems that need to be improved are:

        #{benchers.map(&:to_s).join("\n")}

        There are #{starters.length} gems that have valid strict version constraints.
        Of those:
          #{starters.count { |x| x.is_type?(:constraint) }} use primary constraints (e.g. '~> 1.2.3').
          #{starters.count { |x| x.is_type?(:git_ref) }} use git ref constraints.
          #{starters.count { |x| x.is_type?(:git_tag) }} use git tag constraints.

        There are #{benchers.length} gems that do not have strict version constraints.
        Of those:
          #{benchers.count { |x| x.is_type?(:git_branch) }} use git branch constraints.
          #{benchers.count { |x| x.is_type?(:git) }} use some other form of git constraint considered not strict enough.
          #{benchers.count { |x| x.is_type?(:unknown) }} gems seem to not have any constraint at all.
          #{using_path} gems are using a local path. #{"WARNING!!!" if using_path > 0}
      EOS
    end
  end
end
