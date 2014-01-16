# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gem_bench/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "gem_bench"
  gem.version       = GemBench::VERSION
  gem.authors       = ["Peter Boling"]
  gem.email         = ["peter.boling@gmail.com"]
  gem.description   = %q{trim down app load times by keeping your worst players on the bench}
  gem.summary       = %q{Gem: "Put me in coach"
You: ❨╯°□°❩╯︵┻━┻}
  gem.homepage      = "http://github.com/acquaintable/gem_bench"

  gem.licenses    = ['MIT']
  gem.platform    = Gem::Platform::RUBY

  gem.files         = Dir.glob("{bin,lib,vendor}/**/*") + %w(LICENSE.txt README.md CHANGELOG Rakefile)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = ["lib"]

  # Yes, it *is* actually a run-time dependency. This gem is sort of a bundler add-on.
  gem.add_runtime_dependency(%q<bundler>, ["> 1.2"])
  gem.add_development_dependency( 'gem-release' )

end
