# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_bench/version'

Gem::Specification.new do |spec|
  spec.name          = "gem_bench"
  spec.version       = GemBench::VERSION
  spec.authors       = ["Peter Boling"]
  spec.email         = ["peter.boling@gmail.com"]

  spec.summary       = %q{Gem: "Put me in coach"
You: ❨╯°□°❩╯︵┻━┻}
  spec.description   = %q{trim down app load times by keeping your worst players on the bench}
  spec.homepage      = "http://github.com/acquaintable/gem_bench"

  spec.licenses      = ['MIT']
  spec.platform      = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.0.0" # because has named parameters with default values

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files    = Dir.glob("{test|spec|features}/**/*")

  # Yes, it *is* actually a run-time dependency. This gem is sort of a bundler add-on.
  spec.add_runtime_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency "byebug", "~> 9.0"
  spec.add_development_dependency "gem-release", "~> 0.5"
  spec.add_development_dependency "awesome_print"
end
