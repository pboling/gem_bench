module GemBench
  class Player

    attr_accessor :name, :version, :state, :stats

    def initialize(options = {})
      @name = options[:name]
      @version = options[:version]
      @state = nil
      @stats = []
    end

    def path_glob
      GemBench::PATH_GLOB.call(self.name)
    end

    def set_starter(file_path)
      scan = begin
        if GemBench::DO_NOT_SCAN.include? self.name
          false
        else
          File.read(file_path).encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_') =~ GemBench::RAILTIE_REGEX
        end
      end
      self.stats << [file_path,scan] if scan
      self.state = !!scan ?
        GemBench::PLAYER_STATES[:starter] :
        GemBench::PLAYER_STATES[:bench]
    end

    def starter?
      self.state == GemBench::PLAYER_STATES[:starter]
    end

    # Used to find the line of the Gemfile which creates the primary dependency on this gem
    def gemfile_regex
      GemBench::DEPENDENCY_REGEX.call(self.name)
    end

    def to_s
      "#{self.name} v#{self.version}"
    end

    def how
      case self.state
        when GemBench::PLAYER_STATES[:starter] then "gem '#{self.name}', '~> #{self.version}'"
        when GemBench::PLAYER_STATES[:bench] then   "gem '#{self.name}', '~> #{self.version}', require: false"
        else "#{self} is feeling very lost right now."
      end
    end

    def suggest(num)
      "\t[SUGGESTION] #{num}) #{self.how}"
    end

    def info(num)
      "\t[INFO] #{num}) #{self.how}"
    end

    def careful(num)
      "\t[BE CAREFUL] #{num}) #{self.how}"
    end

  end
end
