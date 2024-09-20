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
  spec.cert_chain = [ENV.fetch("GEM_CERT_PATH", "certs/#{ENV.fetch("GEM_CERT_USER", ENV["USER"])}.pem")]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.summary = "Benchmark different versions of same or similar gems & Static Gemfile and installed gem library source code analysis"
  spec.description = "* Benchmark different versions of same or similar gems
* Copy & Re-namespace any gem to benchmark side-by-side with `benchmarks-ips`
* Enforce Gemfile version constraints
* Regex search across all installed gem's source code to find issues quickly
* Trim down app load times by keeping your worst players on the bench (useful for beating Heroku slug load time cutoff)"
  spec.homepage = "http://github.com/pboling/#{spec.name}"

  spec.licenses = ["MIT"]
  spec.required_ruby_version = ">= 2.3"

  spec.metadata["homepage_uri"] = "https://railsbling.com/tags/gem_bench/"
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["wiki_uri"] = "#{spec.homepage}/wiki"
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
  spec.add_dependency("bundler", ">= 1.14")
  spec.add_dependency("version_gem", "~> 1.1", ">= 1.1.4")

  # Documentation
  spec.add_development_dependency("yard", "~> 0.9", ">= 0.9.34")
  spec.add_development_dependency("yard-junk", "~> 0.0.10")

  # Coverage
  spec.add_development_dependency("kettle-soup-cover", "~> 1.0", ">= 1.0.2")

  # Unit tests
  spec.add_development_dependency("awesome_print", "~> 1.9")
  spec.add_development_dependency("method_source", ">= 1.1.0")
  spec.add_development_dependency("rake", ">= 10")
  spec.add_development_dependency("rspec", "~> 3.13")
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0", ">= 1.0.6")

  # Linting
  spec.add_development_dependency("rubocop-lts", "~> 10.1") # Lint & Style Support for Ruby 2.3+
  spec.add_development_dependency("rubocop-packaging", "~> 0.5", ">= 0.5.2")
  spec.add_development_dependency("rubocop-rspec", "~> 3.0")
  spec.add_development_dependency("standard", "~> 1.40")
end
