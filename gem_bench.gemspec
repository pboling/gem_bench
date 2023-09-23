lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gem_bench/version"

Gem::Specification.new do |spec|
  spec.name = "gem_bench"
  spec.version = GemBench::VERSION
  spec.authors = ["Peter Boling"]
  spec.email = ["peter.boling@gmail.com"]

  spec.summary = "Static Gemfile and installed gem library source code analysis"
  spec.description = "Enforce Gemfile version constraints
Regex search across all installed gem's source code to find issues quickly
Trim down app load times by keeping your worst players on the bench (useful for beating Heroku slug load time cutoff)"
  spec.homepage = "http://github.com/acquaintable/gem_bench"

  spec.licenses = ["MIT"]
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.0.0" # for named parameters with default values

  spec.files = %x(git ls-files -z).split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Yes, it *is* actually a run-time dependency. This gem is sort of a bundler add-on.
  spec.add_runtime_dependency("bundler", ">= 1.14")

  # Documentation
  spec.add_development_dependency("redcarpet")
  spec.add_development_dependency("yard")
  spec.add_development_dependency("yard-junk")

  spec.add_development_dependency("appraisal")
  spec.add_development_dependency("awesome_print")
  spec.add_development_dependency("byebug")
  spec.add_development_dependency("gem-release", "~> 2.0")
  spec.add_development_dependency("pry-byebug")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec")
  spec.add_development_dependency("rspec-block_is_expected")
  spec.add_development_dependency("rubocop-lts", "~> 4.1") # Lint & Style Support for Ruby 2.0.0
  spec.add_development_dependency("rubocop-packaging", "~> 0.5", ">=0.5.2")
  spec.add_development_dependency("rubocop-rspec")
  spec.add_development_dependency("simplecov")
  spec.add_development_dependency("wwtd")
end
