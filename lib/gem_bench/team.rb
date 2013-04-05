module GemBench
  class Team

    EXCLUDE = ['bundler','gem_bench']

    attr_accessor :paths, :all, :excluded, :starters, :benchers, :verbose

    def initialize(verbose = false)
      #>> Bundler.install_path
      #=> #<Pathname:/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems>
      #>> Bundler.bundle_path
      #=> #<Pathname:/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss>
      possibles = [Bundler.rubygems.gem_dir, Bundler.rubygems.gem_path]
      @paths = possibles.flatten.compact.uniq.map {|x| x.to_s }.reject { |p| p.empty? }.map {|x| "#{x}/gems" }
      self.paths << "#{Bundler.install_path}"
      self.paths << "#{Bundler.bundle_path}/gems"
      self.paths.uniq!
      puts "[GemBench] will search for gems in #{self.paths.inspect}"
      # Gem.loaded_specs are the gems that have been loaded / required.
      # Among these there may be some that did not need to be.
      totes = Gem.loaded_specs.values.map {|x| [x.name, x.version.to_s] }
      @excluded, @all = totes.partition {|x| EXCLUDE.include?(x[0]) }
      puts "[GemBench] detected #{self.all.length} loaded gems (#{self.excluded.length} will be skipped by GemBench)"
      @starters = []
      @benchers = []
      @verbose = verbose
      self.check_all
      self.print  if self.verbose
    end

    def print
      string = ''
      if self.starters.empty?
        string << "[GemBench] Found no gems to load at boot.\n"
      else
        self.starters.each do |starter|
          string << "You might want to verify that #{starter} really has a Railtie (or Rails::Engine).  Check here:\n"
          starter.stats.each do |stat|
            string << "\t#{stat}\n"
          end
        end
        string << "[GemBench] #{self.starters.length} gems to load at boot:\n"
        string << "[GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above:\n"
        self.starters.each do |starter|
          string << "\t#{starter.how}\n"
        end
      end
      string << "[GemBench] #{self.benchers.length} gems to skip require in Gemfile (require => false):\n"
      self.benchers.each do |starter|
        string << "\t#{starter.how}\n"
      end
      puts string
    end

    def check_all
      self.all.each do |player_data|
        player = GemBench::Player.new({name: player_data[0], version: player_data[1]})
        self.check(player)
        self.add_to_roster(player)
      end
    end

    def check(player)
      self.paths.each do |path|
        glob_path = "#{path}/#{player.path_glob}"
        file_paths = Dir.glob("#{glob_path}")
        puts "[GemBench] checking #{player} at #{glob_path} (#{file_paths.length} files)" if self.verbose == 'extra'
        file_paths.each do |file_path|
          player.set_starter(file_path)
          return if player.starter?
        end
      end
    end

    def add_to_roster(player)
      if player.starter?
        self.starters << player
      else
        self.benchers << player
      end
    end

  end
end
