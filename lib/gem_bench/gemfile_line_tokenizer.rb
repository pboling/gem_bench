module GemBench
  # Line by line parser of a Gemfile
  # Uses regular expressions, which, I know, GROSS, but also meh
  # You aren't using this as a runtime gem in your app are you?
  # Let me know how you use it!
  class GemfileLineTokenizer
    GEM_REGEX = /\A\s*gem\s+([^#]*).*\Z/.freeze # run against gem lines like: "gem 'aftership', # Ruby SDK of AfterShip API."
    # HEREDOC support? (?<op_heredoc><<[~-]?[A-Z0-9_]+\.?[a-z0-9_]+)
    OP_QUO_REG_PROC = lambda { |idx = nil| /((?<op_quo#{idx}>['"]{1})|(?<op_pct_q#{idx}>%[Qq]?[\(\[\{]{1})|(?<op_heredoc><<[~-]?[A-Z0-9_]+\.?[a-z0-9_]+))/x }
    # No close for the heredoc, as it will be on a different line...
    CL_QUO_REG_PROC = lambda { |idx = nil| /((?<cl_quo#{idx}>['"])|(?<cl_pct_q#{idx}>[\)\]\}]{1}))/x }
    GEM_NAME_REGEX = /\A\s*gem\s+#{OP_QUO_REG_PROC.call.source}(?<name>[^'")]*)#{CL_QUO_REG_PROC.call.source}?.*\Z/.freeze # run against gem lines like: "gem 'aftership', # Ruby SDK of AfterShip API."
    VERSION_CONSTRAINT = /#{OP_QUO_REG_PROC.call.source}(?<version>[^'")]*)#{CL_QUO_REG_PROC.call.source}/.freeze
    GEMFILE_HASH_CONFIG_KEY_REGEX_PROC = lambda { |key|
      /
        \A\s*[^#]*
        (
          # when key is "branch" will find: `branch: "main"`
          (?<key1>#{key}:\s*)
          #{OP_QUO_REG_PROC.call("k1").source}(?<value1>[^'")]*)?#{CL_QUO_REG_PROC.call("k1").source}
        )
        |
        (
          # when key is "branch" will find: `"branch" => "main"`
          (?<key2>#{OP_QUO_REG_PROC.call("k2a").source}#{key}#{CL_QUO_REG_PROC.call("k2a").source}\s*=>\s*)
          #{OP_QUO_REG_PROC.call("k2b").source}(?<value2>[^'")]*)?#{CL_QUO_REG_PROC.call("k2b").source}
        )
        |
        (
          # when key is "branch" will find: `:branch => "main"`
          (?<key3>:#{key}\s*=>\s*)
          #{OP_QUO_REG_PROC.call("k3").source}(?<value3>[^'")]*)?#{CL_QUO_REG_PROC.call("k3").source}
        )
        |
        (
          # when key is "branch" will find: `"branch": "main"`
          (?<key4>#{OP_QUO_REG_PROC.call("k4a").source}#{key}#{CL_QUO_REG_PROC.call("k4a").source}:\s*)
          #{OP_QUO_REG_PROC.call("k4b").source}(?<value4>[^'")]*)?#{CL_QUO_REG_PROC.call("k4b").source}
        )
      /x
    }
    VERSION_PATH = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("path").freeze
    VERSION_GIT = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("git").freeze
    VERSION_GITHUB = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("github").freeze
    VERSION_GITLAB = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("gitlab").freeze
    VERSION_BITBUCKET = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("bitbucket").freeze
    VERSION_CODEBERG = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("codeberg").freeze
    VERSION_SRCHUT = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("srchut").freeze
    VERSION_GIT_REF = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("ref").freeze
    VERSION_GIT_TAG = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("tag").freeze
    VERSION_GIT_BRANCH = GEMFILE_HASH_CONFIG_KEY_REGEX_PROC.call("branch").freeze
    VALID_VERSION_TYPES = %i[
      constraint
      git_ref
      git_tag
    ]
    STR_SYNTAX_TYPES = {
      quoted: true,
      pct_q: true,
      # We could try to support HEREDOC via parsing the lines following in all_lines, but... ugh.
      heredoc: false,
      unknown: false,
    }.freeze
    attr_reader :line
    attr_reader :relevant_lines, :is_gem, :all_lines, :index, :tokens, :version_type, :name, :parse_success, :valid
    # version will be a string if it is a normal constraint like '~> 1.2.3'
    # version will be a hash if it is an alternative constraint like:
    # git: "blah/blah", ref: "shasha"
    attr_reader :version, :str_syntax_type

    def initialize(all_lines, line, index)
      @line = line.strip
      @is_gem = self.line.match(GEM_REGEX)
      if is_gem
        @all_lines = all_lines
        @index = index
        @tokens = self.line.split(",").map(&:strip)
        determine_name
        if name && STR_SYNTAX_TYPES[str_syntax_type]
          determine_relevant_lines
          determine_version
          @parse_success = true
          @valid = VALID_VERSION_TYPES.include?(version_type)
        else
          noop
        end
      else
        noop
      end
    end

    private

    # not a gem line.  noop.
    #
    # @return void
    def noop
      @parse_success = false
      @valid = false

      nil
    end

    # @return void
    def determine_name
      # uses @tokens[0] because the gem name must be before the first comma
      match_data = @tokens[0].match(GEM_NAME_REGEX)
      @str_syntax_type =
        if match_data[:op_quo] && match_data[:cl_quo]
          :quoted
        elsif match_data[:op_pct_q] && match_data[:cl_pct_q]
          :pct_q
        # Not handling heredoc, aside from not exploding, as it isn't a reasonable use case.
        # elsif match_data[:op_heredoc]
        #   :heredoc
        else
          :unknown
        end
      @name = match_data[:name]

      nil
    end

    # @return void
    def determine_relevant_lines
      @relevant_lines = [line, *following_non_gem_lines].compact

      nil
    end

    # @return void
    def determine_version
      @version = {}
      return if version_path

      (
        (version_git || version_provider) && (
          check_for_version_of_type_git_tag ||
          check_for_version_of_type_git_branch
        )
      ) ||
        # Needs to be the last check because it can only check for a quoted string,
        #   and quoted strings are part of the other types, so they have to be checked first with higher specificity
        check_for_version_of_type_constraint

      nil
    end

    # @return [true, false]
    def check_for_version_of_type_constraint
      # index 1 of the comma-split tokens will usually be the version constraint, if there is one
      possible_constraint = @tokens[1]
      return false unless possible_constraint

      match_data = possible_constraint.strip.match(VERSION_CONSTRAINT)
      # the version constraint is in a regex capture group
      if match_data && (@version = match_data[:version].strip)
        @version_type = :constraint
        true
      else
        false
      end
    end

    # @return [true, false]
    def version_path
      line = relevant_lines.detect { |next_line| next_line.match(VERSION_PATH) }
      return false unless line

      enhance_version(
        line.match(VERSION_PATH),
        :path,
        :path,
      )
    end

    # @return [true, false]
    def version_git
      line = relevant_lines.detect { |next_line| next_line.match(VERSION_GIT) }
      return false unless line

      enhance_version(
        line.match(VERSION_GIT),
        :git,
        :git,
      )
    end

    # @return [true, false]
    def version_provider
      matcher = nil
      line = relevant_lines.detect do |next_line|
        matcher =
          case next_line
          when VERSION_GITHUB
            VERSION_GITHUB
          when VERSION_GITLAB
            VERSION_GITLAB
          when VERSION_BITBUCKET
            VERSION_BITBUCKET
          when VERSION_CODEBERG
            VERSION_CODEBERG
          when VERSION_SRCHUT
            VERSION_SRCHUT
          end
      end
      return false unless line && matcher

      enhance_version(
        line.match(matcher),
        :github,
        :github,
      )
    end

    # @return [true, false]
    def check_for_version_of_type_git_branch
      return false unless _check_for_version_of_type_git_branch

      line = relevant_lines.detect { |next_line| next_line.match(VERSION_GIT_REF) }
      # At this point we at least have a branch, though perhaps not a ref.
      return true unless line

      enhance_version(
        line.match(VERSION_GIT_REF),
        :ref,
        :git_ref,
      )
    end

    # @return [true, false]
    def check_for_version_of_type_git_tag
      line = relevant_lines.detect { |next_line| next_line.match(VERSION_GIT_TAG) }
      return false unless line

      enhance_version(
        line.match(VERSION_GIT_TAG),
        :tag,
        :git_tag,
      )
    end

    # @return [true, false]
    def _check_for_version_of_type_git_branch
      line = relevant_lines.detect { |next_line| next_line.match(VERSION_GIT_BRANCH) }
      return false unless line

      enhance_version(
        line.match(VERSION_GIT_BRANCH),
        :branch,
        :git_branch,
      )
    end

    # @returns [Array[String]] - each line following the current line, which is not a gem line
    def following_non_gem_lines
      all_lines[(index + 1)..-1]
        .reject { |x| x.strip.empty? || x.match(GemBench::TRASH_REGEX) }
        .map(&:strip)
        .inject([]) do |following_lines, next_line|
        break following_lines if next_line.match(GEM_REGEX)

        following_lines << next_line
      end
    end

    # @return [String] the name of the named capture which has a value (one of: value1, value2, value3, etc.)
    def determine_named_capture(match_data)
      match_data.names
        .select { |name| name.start_with?("value") }
        .detect { |capture| !match_data[capture]&.empty? }
    end

    # @return [true]
    def enhance_version(match_data, version_key, type)
      named_capture = determine_named_capture(match_data)
      value = match_data[named_capture]
      if value
        @version[version_key] = value
        @version_type = type
      else
        @version[version_key] = ""
        @version_type = :invalid
      end

      true
    end
  end
end
