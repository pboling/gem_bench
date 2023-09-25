# Get the GEMFILE_VERSION without *require* "my_gem/version", for code coverage accuracy
# See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-825171399
load "lib/gem_bench/version.rb"
gem_version = GemBench::Version::VERSION
GemBench::Version.send(:remove_const, :VERSION)

Gem::Specification.new do |spec|
  spec.name = "gem_bench"
  spec.version = gem_version
  spec.authors = ["Peter Boling"]
  spec.email = ["peter.boling@gmail.com"]

  # See CONTRIBUTING.md
  spec.cert_chain = ["certs/pboling.pem"]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.summary = "Static Gemfile and installed gem library source code analysis"
  spec.description = "Enforce Gemfile version constraints
Regex search across all installed gem's source code to find issues quickly
Trim down app load times by keeping your worst players on the bench (useful for beating Heroku slug load time cutoff)"
  spec.homepage = "http://github.com/acquaintable/gem_bench"

  spec.licenses = ["MIT"]
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.3"

  spec.metadata["homepage_uri"] = "https://rubocop-lts.gitlab.io/"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/-/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/-/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/-/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["wiki_uri"] = "#{spec.homepage}/-/wikis/home"
  spec.metadata["funding_uri"] = "https://liberapay.com/pboling"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    # Splats (alphabetical)
    "lib/**/*.rb",
    # Files (alphabetical)
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md"
  ]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Yes, it *is* actually a run-time dependency. This gem is sort of a bundler add-on.
  spec.add_runtime_dependency("bundler", ">= 1.14")
  spec.add_runtime_dependency("version_gem", "~> 1.1", ">= 1.1.3")

  # Documentation
  spec.add_development_dependency("redcarpet")
  spec.add_development_dependency("yard")
  spec.add_development_dependency("yard-junk")

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
end
