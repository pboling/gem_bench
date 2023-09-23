module GemBench
  class Player
    # MAJOR.MINOR split on point length == 2
    # MAJOR.MINOR.PATCH split on point length == 3
    # Semver 2.0 Standard is to accept minor and patch updates
    SEMVER_SPLIT_ON_POINT_LENGTH = 2
    attr_accessor :name, :version, :state, :stats
    attr_reader :file_path_glob, :gemfile_regex, :checked, :exclude_file_pattern

    def initialize(options = {})
      @name = options[:name]
      @version = options[:version]
      @exclude_file_pattern = options[:exclude_file_pattern]
      @state = nil
      @stats = []
      @file_path_glob = GemBench::PATH_GLOB.call(@name)
      # Used to find the line of the Gemfile which creates the primary dependency on this gem
      @gemfile_regex = GemBench::DEPENDENCY_REGEX_PROC.call(@name)
      @checked = false
    end

    def set_starter(file_path, line_match: nil)
      return false if file_path =~ exclude_file_pattern

      # Some gems may have zero files to check, as they may be using gem as a
      #   delivery system for shell scripts!  As such we need to check which
      #   gems got checked, and which had nothing to check
      @checked = true
      line_match ||= GemBench::RAILTIE_REGEX
      scan = if GemBench::DO_NOT_SCAN.include?(name)
        false
      else
        begin
          File.read(file_path).encode(
            "utf-8",
            invalid: :replace,
            undef: :replace,
            replace: "_",
          ) =~ line_match
        rescue ArgumentError => e
          if e.message =~ /invalid byte sequence/
            puts "[GemBench] checking #{file_path} failed due to unparseable file content"
            false # Assume the likelihood of files with encoding issues that also contain railtie to be low, so: false.
          end
        end
      end

      stats << [file_path, scan] if scan
      self.state = if !!scan
        GemBench::PLAYER_STATES[:starter]
      else
        GemBench::PLAYER_STATES[:bench]
      end
    end

    def starter?
      state == GemBench::PLAYER_STATES[:starter]
    end

    def to_s(format = :name)
      case format
      when :name
        name
      when :v
        "#{name} v#{version}"
      when :semver
        "gem '#{name}', '~> #{semver}'"
      when :locked
        "gem '#{name}', '#{version}'"
      when :legacy # when depending on legacy gems, you specifically want to not upgrade, except patches.
        "gem '#{name}', '~> #{version}'"
      when :upgrade # when upgrading, and testing gem compatibility you want to try anything newer
        "gem '#{name}', '>= #{version}'"
      end
    end

    def inspect
      to_s(:name)
    end

    def semver
      ver = version
      ver = ver[0..(ver.rindex(".") - 1)] until ver.split(".").length <= SEMVER_SPLIT_ON_POINT_LENGTH
      ver
    end

    def how
      case state
      when GemBench::PLAYER_STATES[:starter]
        to_s(:semver)
      when GemBench::PLAYER_STATES[:bench]
        "#{to_s(:semver)}, require: false"
      else
        if checked
          "#{self} is feeling very lost right now."
        else
          "#{self} had no files to evaluate."
        end
      end
    end

    def suggest(num)
      "\t[SUGGESTION] #{num}) #{how}"
    end

    def info(num)
      "\t[INFO] #{num}) #{how}"
    end

    def careful(num)
      "\t[BE CAREFUL] #{num}) #{how}"
    end
  end
end
