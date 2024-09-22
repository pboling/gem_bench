source "https://rubygems.org"

gem "bundler" # For specs!
gem "byebug", # for debugging
  ">= 2.0.3"

# For complexity!
# (this syntax is not supported by gem_bench, but also shouldn't make it blow up)
gem <<~GEM_NAME.chomp
  pry-byebug
GEM_NAME

# Need test-unit be loaded by bundler for evaluation in specs
gem "test-unit", "~> 3.6"

# Specify your gem's dependencies in gem_bench.gemspec
gemspec
