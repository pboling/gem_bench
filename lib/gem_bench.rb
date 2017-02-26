require "gem_bench/version"
require "bundler" # This gem utilizes bundler as a tool.
require "gem_bench/scout"
require "gem_bench/player"
require "gem_bench/team"

module GemBench
  USAGE = "[GemBench] Usage: Require another gem in this session to evaluate it.\n\tExample:\n\t\trequire 'rails'\n\t\tGemBench.check({verbose: true})\n"
  RAILTIE_REGEX = /Rails::Engine|Rails::Railtie/
  TRASH_REGEX = /^(\s*)([#]+.*)?$/
  REQUIRE_FALSE_REGEX = /^[^#]+require(([:]\s*)|(\s*=>\s*))false.*/
  DEPENDENCY_REGEX_PROC = ->(name) { /^\s*[^#]*\s*gem\s+['"]{1}#{name}['"]{1}/ }
  PATH_GLOB = ->(name) { "#{name}*/lib/**/*.rb" }
  EXCLUDE_FILE_PATTERN_REGEX_PROC = ->(name) { /#{name}\/test|features|spec/ }
  DO_NOT_SCAN = []
  PLAYER_STATES = {
    starter:  :starter,
    bench:    :bench
  }

  class << self
    attr_accessor :roster
    def check(verbose: false)
      @roster = GemBench::Team.new({verbose: verbose})
    end

    def find(look_for_regex: GemBench::RAILTIE_REGEX, exclude_file_pattern_regex_proc: GemBench::EXCLUDE_FILE_PATTERN_REGEX_PROC, verbose: false)
      @roster = GemBench::Team.new({look_for_regex: look_for_regex, exclude_file_pattern_regex_proc: exclude_file_pattern_regex_proc, verbose: verbose})
    end
  end
end
