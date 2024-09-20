# external gems
require "version_gem"
require "bundler" # This gem utilizes bundler as a tool.

# this library
require_relative "gem_bench/version"
require_relative "gem_bench/scout"
require_relative "gem_bench/player"
require_relative "gem_bench/team"
require_relative "gem_bench/gemfile_line_tokenizer"
require_relative "gem_bench/strict_version_gem"
require_relative "gem_bench/strict_version_requirement"

module GemBench
  USAGE = "[GemBench] Usage: Require another gem in this session to evaluate it.\n\tExample:\n\t\trequire 'rails'\n\t\tGemBench.check({verbose: true})\n"
  RAILTIE_REGEX = /Rails::Engine|Rails::Railtie/
  TRASH_REGEX = /^(\s*)(\#+.*)?$/
  REQUIRE_FALSE_REGEX = /^[^#]+require((:\s*)|(\s*=>\s*))false.*/
  DEPENDENCY_REGEX_PROC = ->(name) { /^\s*[^#]*\s*gem\s+['"]{1}#{name}['"]{1}/ }
  PATH_GLOB = ->(name) { "#{name}*/lib/**/*.rb" }
  EXCLUDE_FILE_PATTERN_REGEX_PROC = ->(name) { %r{#{name}/test|features|spec|bin|exe} }
  DO_NOT_SCAN = []
  PLAYER_STATES = {
    starter: :starter,
    bench: :bench,
  }

  class << self
    def check(verbose: false, gemfile_path: nil)
      options = {
        verbose: verbose,
      }
      options[:gemfile_path] = gemfile_path if gemfile_path
      GemBench::Team.new(**options)
    end

    def versions_present?(verbose: false, gemfile_path: nil)
      options = {
        verbose: verbose,
      }
      options[:gemfile_path] = gemfile_path if gemfile_path
      GemBench::StrictVersionRequirement.new(**options).versions_present?
    end

    def list_missing_version_constraints(verbose: false, gemfile_path: nil)
      options = {
        verbose: verbose,
      }
      options[:gemfile_path] = gemfile_path if gemfile_path
      GemBench::StrictVersionRequirement.new(**options).list_missing_version_constraints
    end

    def find(look_for_regex: GemBench::RAILTIE_REGEX,
      exclude_file_pattern_regex_proc: GemBench::EXCLUDE_FILE_PATTERN_REGEX_PROC,
      verbose: false,
      gemfile_path: nil)
      options = {
        verbose: verbose,
        look_for_regex: look_for_regex,
        exclude_file_pattern_regex_proc: exclude_file_pattern_regex_proc,
      }
      options[:gemfile_path] = gemfile_path if gemfile_path
      GemBench::Team.new(**options)
    end
  end
end

GemBench::Version.class_eval do
  extend VersionGem::Basic
end
