source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
git_source(:gitlab) { |repo_name| "https://gitlab.com/#{repo_name}" }

group :development do
  # No constraint
  gem "anonymous_active_record"

  # SemVer constraint
  gem "require_bench", "~> 1.0"

  # Locked constraint
  gem "debug_logging", "4.0.2"

  # Git constraint, tag
  gem "dynamoid", github: "Dynamoid/dynamoid", tag: "v3.10.0"

  # Git constraint, branch
  gem "rubocop-lts", gitlab: "rubocop-lts/rubocop-lts", branch: "3_2-even-v24"

  # Git constraint, no ref
  gem "rots", github: "oauth-xx/rots"

  # Git constraint, with ref
  gem "sanitize_email", github: "pboling/sanitize_email", ref: "c1886ee4864dbcca6852c650d6e6d65c471a8178"

  # Local path
  gem "gem_bench", path: "../../"

  # Fancy quotes
  gem %Q(rspec-stubbed_env)

  # Commented out gem
  # gem "flag_shih_tzu"

  # Excluded gem
  gem "friendly_id"

  # Unsupported (by gem_bench) string syntax for name
  gem <<~GEM_NAME.chomp
csv_pirate
GEM_NAME
end
