# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gem_bench/version'

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

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency(%q<bundler>, ["> 1.2"])
  gem.add_development_dependency( 'gem-release' )

end
