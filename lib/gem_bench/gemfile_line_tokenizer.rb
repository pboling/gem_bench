module GemBench
  class GemfileLineTokenizer
    GEM_REGEX = /\A\s*gem\s+([^#]*).*\Z/.freeze # run against gem lines like: "gem 'aftership', # Ruby SDK of AfterShip API."
    GEM_NAME_REGEX = /\A\s*gem\s+['"]{1}(?<name>[^'"]*)['"].*\Z/.freeze # run against gem lines like: "gem 'aftership', # Ruby SDK of AfterShip API."
    VERSION_CONSTRAINT = /['"]{1}([^'"]*)['"]/.freeze
    GEMFILE_HASH_CONFIG_KEY_REGEX_PROC = ->(key) { /\A\s*[^#]*(?<key1>#{key}: *)['"]{1}(?<value1>[^'"]*)['"]|(?<key2>['"]#{key}['"] *=> *)['"]{1}(?<value2>[^'"]*)['"]|(?<key3>:#{key} *=> *)['"]{1}(?<value3>[^'"]*)['"]/ }
    VERSION_PATH = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call('path').freeze
    VERSION_GIT = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call('git').freeze
    VERSION_GIT_REF = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call('ref').freeze
    VERSION_GIT_TAG = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call('tag').freeze
    VERSION_GIT_BRANCH = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call('branch').freeze
    VALID_VERSION_TYPES = %i(
      constraint
      git_ref
      git_tag
    )
    # branch is only valid if the branch is not master
    attr_reader :line
    attr_reader :is_gem
    attr_reader :all_lines
    attr_reader :index
    attr_reader :tokens
    # version will be a string if it is a normal constraint like '~> 1.2.3'
    # version will be a hash if it is an alternative constraint like:
    # git: "blah/blah", ref: "shasha"
    attr_reader :version
    attr_reader :version_type
    attr_reader :name
    attr_reader :parse_success
    attr_reader :valid
    def initialize(all_lines, line, index)
      @line = line
      @is_gem = self.line.match(GEM_REGEX)
      if self.is_gem
        @all_lines = all_lines
        @index = index
        @tokens = self.line.split(',')
        determine_name
        if self.name
          determine_version
          @parse_success = true
          @valid = VALID_VERSION_TYPES.include?(self.version_type)
        else
          noop
        end
      else
        noop
      end
    end

    def lines
      [line, *following_non_gem_lines].compact
    end

    private

    # not a gem line.  noop.
    def noop
      @parse_success = false
      @valid = false
    end

    def determine_name
      # uses @tokens[0] because the gem name must be before the first comma
      match_data = @tokens[0].match(GEM_NAME_REGEX)
      @name = match_data[:name]
    end

    def determine_version
      check_for_version_of_type_constraint ||
        version_path ||
        (
          version_git && (
            check_for_version_of_type_git_ref ||
            check_for_version_of_type_git_tag ||
            check_for_version_of_type_git_branch
        )
      )
    end

    def check_for_version_of_type_constraint
      # index 1 of the comma-split tokens will usually be the version constraint, if there is one
      possible_constraint = @tokens[1]
      return false unless possible_constraint
      match_data = possible_constraint.strip.match(VERSION_CONSTRAINT)
      # the version constraint is in a regex capture group
      if match_data && (@version = match_data[1].strip)
        @version_type = :constraint
        true
      else
        false
      end
    end

    def version_path
      @version = {}
      line = following_non_gem_lines.detect { |next_line| (next_line.match(VERSION_PATH)) }
      return false unless line
      enhance_version(
          line.match(VERSION_PATH),
          :path,
          :path
      )
    end

    def version_git
      @version = {}
      line = following_non_gem_lines.detect { |next_line| (next_line.match(VERSION_GIT_REF)) }
      return false unless line
      enhance_version(
          line.match(VERSION_GIT_REF),
          :git,
          :git
      )
    end

    def check_for_version_of_type_git_ref
      line = following_non_gem_lines.detect { |next_line| (next_line.match(VERSION_GIT_REF)) }
      return false unless line
      enhance_version(
          line.match(VERSION_GIT_REF),
          :ref,
          :git_ref
      )
    end

    def check_for_version_of_type_git_tag
      line = following_non_gem_lines.detect { |next_line| (next_line.match(VERSION_GIT_TAG)) }
      return false unless line
      enhance_version(
          line.match(VERSION_GIT_TAG),
          :tag,
          :git_tag
      )
    end

    def check_for_version_of_type_git_branch
      line = following_non_gem_lines.detect { |next_line| (next_line.match(VERSION_GIT_BRANCH)) }
      return false unless line
      enhance_version(
          line.match(VERSION_GIT_BRANCH),
          :branch,
          :git_branch
      )
    end

    # returns an array with each line following the current line, which is not a gem line
    def following_non_gem_lines
      @following_non_gem_lines ||= all_lines[(index+1)..(-1)].inject([]) do |following_lines, next_line|
        break following_lines if next_line.match(GEM_REGEX) || next_line.match(GemBench::TRASH_REGEX)
        following_lines << next_line
      end
    end

    # returns a hash like:
    #   {"key" => ":git => ", "value" => "https://github.com/cte/aftership-sdk-ruby.git"}
    def normalize_match_data_captures(match_data)
      match_data.names.inject({}){|mem, capture| mem[capture.gsub(/\d/,'')] = match_data[capture]; mem}
    end

    def enhance_version(match_data, version_key, type)
      return false unless match_data
      normalized_capture = normalize_match_data_captures(match_data) if match_data
      return false unless normalized_capture
      @version.merge!({version_key => normalized_capture["value"]})
      @version_type = type
      true
    end
  end
end
