module GemBench
  class Team

    EXCLUDE = ['bundler','gem_bench']
    # A comment preceding the require: false anywhere on the line should not be considered an active require: false


    attr_accessor :paths, :all, :excluded, :starters, :benchers, :verbose, :gemfile_path, :gemfile_lines, :trash_lines, :check_gemfile, :suggestions

    def initialize(options = {})
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
      exclusions = " (excluding the #{self.excluded.length} GemBench is configured to skip)" if @excluded.length > 0
      puts "[GemBench] detected #{self.all.length} loaded gems#{exclusions}"
      @starters = []
      @benchers = []
      @suggestions = []
      @gemfile_path = options[:gemfile_path] || "#{Dir.pwd}/Gemfile"
      @verbose = options[:verbose]
      self.check_all
      @check_gemfile = can_check_gemfile?
      self.compare_gemfile if self.check_gemfile
      self.print if self.verbose
    end

    def print
      string = ''
      if self.starters.empty?
        string << "[GemBench] Found no gems to load at boot.\n"
      else
        if self.starters.length > 0
          self.starters.each do |starter|
            string << "You might want to verify that #{starter} really has a Rails::Railtie or Rails::Engine.  Check these files:\n"
            starter.stats.each do |stat|
              string << "\t#{stat}\n"
            end
          end
          string << "[GemBench] #{self.starters.length} gems need to be loaded at boot time:\n"
          string << "[GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above:\n"
          self.starters.each do |starter|
            string << "\t#{starter.how}\n"
          end
        else
          string << "[GemBench] Congrats! No gems to load at boot.\n"
        end
      end
      if self.suggestions.length > 0
        string << "[GemBench] Evaluated #{self.all.length} gems and Gemfile at #{self.gemfile_path}.\n[GemBench] Here are #{self.suggestions.length} suggestions for improvement:\n"
        self.suggestions.each_with_index do |suggestion, index|
          string << "#{index + 1}) #{suggestion}\n"
        end
      else
        if self.benchers.length > 0
          string << "[GemBench] Evaluated #{self.all.length} gems and found #{self.benchers.length} gems to skip require in Gemfile (require: false):\n"
          self.benchers.each do |starter|
            string << "\t#{starter.how}\n"
          end
        else
          if self.all.length > 0
            string << "[GemBench] Evaluated #{self.all.length} gems but found none that can skip require in Gemfile (require: false).\n"
          else
            string << "[GemBench] No gems were evaluated by GemBench.\n[GemBench] Usage: Require a gem in this session to evaluate it.\n\tExample:\n\t\trequire 'rails'\n\t\tGemBench.check({verbose: true})"
          end
        end
      end
      puts string
    end

    def can_check_gemfile?
      File.file?(self.gemfile_path)
    end

    def compare_gemfile
      f = File.open(self.gemfile_path)
      # Get all lines as an array
      all_lines = f.readlines
      # Remove all the commented || blank lines
      self.trash_lines, self.gemfile_lines = all_lines.partition {|x| x =~ GemBench::TRASH_REGEX}
      self.benchers.each do |player|
        self.gemfile_lines.each do |line|
          found = (line =~ player.gemfile_regex)
          if found
            # remove the found line from the array, because no sane person has more than one gem dependency per line... right?
            line = self.gemfile_lines.delete_at(self.gemfile_lines.index(line))
            # does the line already have require: false?
            self.suggestions << player.suggest unless line =~ GemBench::REQUIRE_FALSE_REGEX
            break # outside of the inner loop
          end
        end
      end
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
