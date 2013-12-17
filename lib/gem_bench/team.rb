module GemBench
  class Team

    EXCLUDE = [ 'bundler','gem_bench','i18n-airbrake','devise-async','km','vestal_versions','omniauth-facebook',
                'flag_shih_tzu','pry-remote','koala','simple_form','thumbs_up','memoist','cancan','friendly_id',
                'faker']
    # A comment preceding the require: false anywhere on the line should not be considered an active require: false


    attr_accessor :paths, :all, :excluded, :starters, :benchers, :verbose, :gemfile_lines, :trash_lines, :check_gemfile, :current_gemfile_suggestions, :bad_ideas, :gemfile_path

    def initialize(options = {})
      possibles = [Bundler.rubygems.gem_dir, Bundler.rubygems.gem_path]
      @paths = possibles.flatten.compact.uniq.map {|x| x.to_s }.reject { |p| p.empty? }.map {|x| "#{x}/gems" }
      begin
        self.paths << "#{Bundler.install_path}"
        self.paths << "#{Bundler.bundle_path}/gems"
        @check_gemfile = true
        @gemfile_path = "#{Dir.pwd}/Gemfile"
      rescue Bundler::GemfileNotFound => e
        # Don't fail here
      ensure
        @check_gemfile ||= false
        @gemfile_path ||= nil
      end
      self.paths.uniq!
      # Gem.loaded_specs are the gems that have been loaded / required.
      # Among these there may be some that did not need to be.
      totes = Gem.loaded_specs.values.map {|x| [x.name, x.version.to_s] }
      @excluded, @all = totes.partition {|x| EXCLUDE.include?(x[0]) }
      exclusions = "\t(excluding the #{self.excluded.length} loaded gems which GemBench is configured to ignore)\n" if @excluded.length > 0
      @starters = []
      @benchers = []
      @current_gemfile_suggestions = []
      @verbose = options[:verbose]
      self.check_all
      @bad_ideas = options[:bad_ideas] ? true : self.check_gemfile ? false : options[:bad_ideas] == false ? false : true
      puts "[GemBench] Will search for gems in #{self.paths.inspect}\n#{self.check_gemfile ? "[GemBench] Will check Gemfile at #{self.gemfile_path}.\n" : "[GemBench] No Gemfile found.\n"}#{self.bad_ideas ? "[GemBench] Will show bad ideas.  Be Careful.\n" : ''}[GemBench] Detected #{self.all.length} loaded gems\n#{exclusions}"
      self.compare_gemfile if self.check_gemfile
      self.print if self.verbose
    end

    def print
      string = ''
      if self.all.empty?
        string << nothing
      elsif self.starters.empty?
        string << "[GemBench] Found no gems that need to load at boot time.\n"
      else
        if self.starters.length > 0
          string << "\n#{GemBench::USAGE}" unless self.check_gemfile
          string << "[GemBench] We found a Rails::Railtie or Rails::Engine in the following files. However, it is possible that there are false positives, so you may want to verify that this is the case.\n\n"
          self.starters.each do |starter|
            string << "\t#{starter}:\n"
            starter.stats.each do |stat|
              string << "\t\t#{stat[0]}:#{stat[1]}\n"
            end
          end
          string << "[GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above.\n"
          string << "[GemBench] #{self.starters.length} out of #{self.all.length} evaluated gems actually need to be loaded at boot time. They are:\n"
          self.starters.each_with_index do |starter, index|
            string << "#{starter.suggest(index + 1)}\n"
          end
        else
          string << "[GemBench] Congrats! No gems to load at boot.\n"
          string << "\n#{GemBench::USAGE}" unless self.check_gemfile
        end
      end
      if self.check_gemfile
        if self.current_gemfile_suggestions.length > 0
          string << "[GemBench] Evaluated #{self.all.length} gems and Gemfile at #{self.gemfile_path}.\n[GemBench] Here are #{self.current_gemfile_suggestions.length} suggestions for improvement:\n"
          self.current_gemfile_suggestions.each_with_index do |player, index|
            string << "#{player.suggest(index + 1)}\n"
          end
        else
          string << self.strike_out
        end
      end

      if self.bad_ideas
        # Only bad ideas if you are evaluating an actual Gemfile. If just evaluating loaded gems, then info is fine.
        string << self.prepare_bad_ideas
      end

      puts string
    end

    def strike_out
      self.check_gemfile ?
        "[GemBench] Evaluated #{self.all.length} gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).\n" :
        "[GemBench] Evaluated #{self.all.length} gems but found none which can safely skip require on boot (require: false).\n"
    end

    def nothing
      "[GemBench] No gems were evaluated by GemBench.\n#{GemBench::USAGE}"
    end

    def prepare_bad_ideas
      string = ''
      if self.benchers.length > 0
        gemfile_instruction = self.check_gemfile ? '' : "To safely evaluate a Gemfile:\n\t1. Make sure you are in the root of a project with a Gemfile\n\t2. Make sure the gem is actually a dependency in the Gemfile\n"
        string << "[GemBench] Evaluated #{self.all.length} loaded gems and found #{self.benchers.length} which may be able to skip boot loading (require: false).\n*** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.\n#{gemfile_instruction}"
        self.benchers.each_with_index do |player, index|
          string << "#{player.careful(index + 1)}\n"
        end
      else
        string << self.strike_out
      end
      string
    end

    def compare_gemfile
      f = File.open(self.gemfile_path)
      # Get all lines as an array
      all_lines = f.readlines
      # Remove all the commented || blank lines
      self.trash_lines, self.gemfile_lines = all_lines.partition {|x| x =~ GemBench::TRASH_REGEX}
      self.benchers.each_with_index do |player, index|
        self.gemfile_lines.each do |line|
          found = (line =~ player.gemfile_regex)
          if found
            # remove the found line from the array, because no sane person has more than one gem dependency per line... right?
            line = self.gemfile_lines.delete_at(self.gemfile_lines.index(line))
            # does the line already have require: false?
            self.current_gemfile_suggestions << self.benchers.delete_at(self.benchers.index(player)) unless line =~ GemBench::REQUIRE_FALSE_REGEX
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
