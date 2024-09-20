source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

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

# Git constraint, empty branch (invalid)
gem "standard-rubocop-lts", gitlab: %Q(rubocop-lts/standard-rubocop-lts), branch: ""

# Git constraint, bitbucket
gem "nerds", bitbucket: %Q(atlassian/nerds), branch: "main"

# Git constraint, codeberg
gem "icypop", codeberg: %Q(lick/icypop), branch: "main", ref: "toodles"

# Git constraint, srchut
gem "laguna", srchut: %Q(beryl/laguna), branch: "main", tag: "v1.0.0"

# Git constraint, ridiculous
gem "peach", git: %Q(https://example.com/banana.git), fork: "chair", barn: "door"

# Local path
gem "gem_bench", path: "../../"

# Fancy quotes
gem %Q(rspec-stubbed_env)

# Commented out gem
# gem "flag_shih_tzu"

# Unsupported (by gem_bench) string syntax for name
gem <<~GEM_NAME.chomp
csv_pirate
GEM_NAME
