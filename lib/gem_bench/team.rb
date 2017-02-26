require "forwardable"

module GemBench
  class Team
    EXCLUDE = [ 'bundler','gem_bench','i18n-airbrake','devise-async','km','vestal_versions','omniauth-facebook',
                'flag_shih_tzu','pry-remote','koala','simple_form','thumbs_up','memoist','cancan','friendly_id',
                'faker']
    # A comment preceding the require: false anywhere on the line should not be considered an active require: false
    extend Forwardable
    def_delegators :@scout, :gem_paths, :gemfile_path, :check_gemfile?, :loaded_gems
    attr_reader :scout, :look_for_regex
    attr_accessor :all, :excluded, :starters, :benchers, :verbose, :gemfile_lines, :trash_lines, :current_gemfile_suggestions, :bad_ideas

    def initialize(options = {})
      @look_for_regex = options[:look_for_regex]
      # find: Find gems containing specific strings in code
      # bench: Find gems that can probably be benched (require: false) in the Gemfile
      @check_type = @look_for_regex ? :find : :bench
      @benching = @check_type == :bench
      @scout = GemBench::Scout.new(check_gemfile: options[:check_gemfile] || benching?)
      @exclude_file_pattern_regex_proc = options[:exclude_file_pattern_regex_proc].respond_to?(:call) ? options[:exclude_file_pattern_regex_proc] : GemBench::EXCLUDE_FILE_PATTERN_REGEX_PROC
      # Among the loaded gems there may be some that did not need to be.
      @excluded, @all = @scout.loaded_gems.partition {|x| EXCLUDE.include?(x[0]) }
      exclusions = " + #{self.excluded.length} loaded gems which GemBench is configured to ignore.\n" if @excluded.length > 0
      @starters = []
      @benchers = []
      @current_gemfile_suggestions = []
      @verbose = options[:verbose]
      self.check_all
      @bad_ideas = if benching?
                     options[:bad_ideas] ? true : check_gemfile? ? false : options[:bad_ideas] == false ? false : true
                   else
                     false
                   end
      puts "[GemBench] Will search for gems in #{gem_paths.inspect}\n#{benching? ? @scout.check_gemfile? ? "[GemBench] Will check Gemfile at #{gemfile_path}.\n" : "[GemBench] No Gemfile found.\n" : ""}#{self.bad_ideas ? "[GemBench] Will show bad ideas.  Be Careful.\n" : ''}[GemBench] Detected #{self.all.length} loaded gems#{exclusions}"
      self.compare_gemfile if benching? && @scout.check_gemfile?
      self.print if self.verbose
    end

    def list_starters(format: :name)
      starters.map {|starter| starter.to_s(format)}
    end

    def print
      string = ''
      if self.all.empty?
        string << nothing
      elsif self.starters.empty?
        string << if benching?
                    "[GemBench] Found no gems that need to load at boot time.\n"
                  else
                    "[GemBench] Found no gems containing #{look_for_regex} in Ruby code.\n"
                  end
      else
        if self.starters.length > 0
          string << "\n#{GemBench::USAGE}" unless check_gemfile?
          string << if benching?
                      "[GemBench] We found a Rails::Railtie or Rails::Engine in the following files. However, it is possible that there are false positives, so you may want to verify that this is the case.\n\n"
                    else
                      "[GemBench] We found #{look_for_regex} in the following files.\n\n"
                    end
          self.starters.each do |starter|
            string << "\t#{starter}:\n"
            starter.stats.each do |stat|
              string << "\t\t#{stat[0]}:#{stat[1]}\n"
            end
          end
          string << "[GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above.\n" if benching?
          string << if benching?
                      "[GemBench] #{self.starters.length} out of #{self.all.length} evaluated gems actually need to be loaded at boot time. They are:\n"
                    else
                      "[GemBench] #{self.starters.length} out of #{self.all.length} evaluated gems contain #{look_for_regex}. They are:\n"
                    end
          self.starters.each_with_index do |starter, index|
            string << "#{starter.info(index + 1)}\n"
          end
          if extra_verbose? && !benching? && self.benchers.length > 0
            string << "[GemBench] #{self.benchers.length} out of #{self.all.length} evaluated gems did not contain #{look_for_regex}. They are:\n"
            self.benchers.each_with_index do |bencher, index|
              string << "#{bencher.info(index + 1)}\n"
            end
          end
        else
          string << "[GemBench] Congrats! All gems appear clean.\n"
          string << "\n#{GemBench::USAGE}" unless check_gemfile?
        end
      end
      if check_gemfile? && benching?
        if self.current_gemfile_suggestions.length > 0
          string << "[GemBench] Evaluated #{self.all.length} gems and Gemfile at #{gemfile_path}.\n[GemBench] Here are #{self.current_gemfile_suggestions.length} suggestions for improvement:\n"
          self.current_gemfile_suggestions.each_with_index do |player, index|
            string << "#{player.suggest(index + 1)}\n"
          end
        else
          string << self.strike_out
        end
      end

      if benching? && self.bad_ideas
        # Only bad ideas if you are evaluating an actual Gemfile. If just evaluating loaded gems, then info is fine.
        string << self.prepare_bad_ideas
      end

      puts string
    end

    def strike_out
      check_gemfile? ?
        "[GemBench] Evaluated #{self.all.length} gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).\n" :
        "[GemBench] Evaluated #{self.all.length} gems but found none which can safely skip require on boot (require: false).\n"
    end

    def nothing
      "[GemBench] No gems were evaluated by GemBench.\n#{GemBench::USAGE}"
    end

    def prepare_bad_ideas
      string = ''
      if self.benchers.length > 0
        gemfile_instruction = check_gemfile? ? '' : "To safely evaluate a Gemfile:\n\t1. Make sure you are in the root of a project with a Gemfile\n\t2. Make sure the gem is actually a dependency in the Gemfile\n"
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
      self.benchers.each do |player|
        scout.gemfile_lines.each do |line|
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
        exclude_file_pattern = @exclude_file_pattern_regex_proc.call(player_data[0])
        player = GemBench::Player.new({name: player_data[0], version: player_data[1], exclude_file_pattern: exclude_file_pattern})
        self.check(player)
        self.add_to_roster(player)
      end
    end

    def check(player)
      gem_paths.each do |path|
        glob_path = "#{path}/#{player.file_path_glob}"
        file_paths = Dir.glob("#{glob_path}")
        puts "[GemBench] checking #{player} at #{glob_path} (#{file_paths.length} files)" if extra_verbose?
        file_paths.each do |file_path|
          player.set_starter(file_path, line_match: look_for_regex)
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

    private

    def extra_verbose?
      self.verbose == "extra"
    end

    def benching?
      @benching
    end
  end
end
