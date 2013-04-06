module GemBench

  RAILTIE_REGEX = /Rails::Engine|Rails::Railtie/
  TRASH_REGEX = /^(\s*)([#]+.*)?$/
  REQUIRE_FALSE_REGEX = /^[^#]+require(([:]\s*)|(\s*=>\s*))false.*/
  DEPENDENCY_REGEX = ->(name) { /^\s*[^#]*\s*gem\s+['"]{1}#{name}['"]{1}/ }
  PATH_GLOB = ->(name) { "#{name}*/lib/**/*.rb" }
  DO_NOT_SCAN = []
  PLAYER_STATES = {
    starter:  :starter,
    bench:    :bench
  }

  require 'bundler' # This gem utilizes bundler as a tool.
  require 'gem_bench/version'
  require 'gem_bench/team'
  require 'gem_bench/player'

  class << self
    attr_accessor :roster
    def check(verbose = false)
      @roster = GemBench::Team.new(verbose)
    end
  end

end
