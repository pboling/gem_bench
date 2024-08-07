# External Gems
require "byebug" if ENV.fetch("DEBUG", "false").casecmp?("true")
require "rspec/block_is_expected" # For RSpec Macros
require "version_gem/rspec" # For RSpec Matchers

# This gem's helpers
require_relative "support/constants"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require "simplecov"
SimpleCov.start

require "gem_bench"
