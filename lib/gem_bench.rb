require 'bundler' # This gem utilizes bundler as a tool.
require 'gem_bench/version'
require 'gem_bench/team'
require 'gem_bench/player'

module GemBench

  class << self
    attr_accessor :roster
    def check(verbose = false)
      @roster = GemBench::Team.new(verbose)
    end
  end

end
