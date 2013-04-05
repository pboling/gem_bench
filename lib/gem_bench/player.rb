module GemBench
  class Player

    DO_NOT_SCAN = []

    attr_accessor :name, :version, :state, :stats

    def initialize(options = {})
      @name = options[:name]
      @version = options[:version]
      @state = nil
      @stats = []
    end

    def path_glob
      "#{self.name}*/lib/**/*.rb"
    end

    def set_starter(file_path)
      scan = begin
        if DO_NOT_SCAN.include? self.name
          false
        else
          File.read(file_path) =~ /Rails::Engine|Rails::Railtie/
        end
      end
      self.stats << [file_path,scan] if scan
      self.state = !!scan ?
        'starter' :
        'bench'
    end

    def starter?
      self.state == 'starter'
    end

    def to_s
      "#{self.name} v#{self.version}"
    end

    def how
      case state
        when 'starter' then "gem '#{self.name}', '~> #{self.version}'"
        when 'bench' then   "gem '#{self.name}', :require => false, '~> #{self.version}'"
        else "I'm not sure where I am."
      end
    end
  end
end
