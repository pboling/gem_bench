source "https://rubygems.org"

gem "bundler" # For specs!
gem "byebug", # for debugging
  ">= 2.0.3"

# For complexity!
# (this syntax is not supported by gem_bench, but also shouldn't make it blow up)
gem <<~GEM_NAME.chomp
  pry-byebug
GEM_NAME

# Need this to be loaded by bundler, to exercise the "excluded" logic, since faker is excluded.
gem "faker"

# Specify your gem's dependencies in gem_bench.gemspec
gemspec
