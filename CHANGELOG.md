# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog v1](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning v2](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
### Fixed
### Removed

## [2.0.5] SEP.21.2024
- COVERAGE:  99.80% -- 495/496 lines in 9 files
- BRANCH COVERAGE:  94.35% -- 167/177 branches in 9 files
- 58.87% documented
### Added
- More specs
- More documentation
- 0.2% remaining to 100% test coverage (line)
### Fixed
- Documentation errors
- Minor improvements to logic and performance (a bit more idiomatic Ruby)

## [2.0.4] SEP.20.2024
- COVERAGE:  98.19% -- 488/497 lines in 9 files
- BRANCH COVERAGE:  88.95% -- 161/181 branches in 9 files
- 58.06% documented
### Added
- More documentation
- 1.81% remaining to 100% test coverage (line)
- Thread safety (removed `GemBench.roster`, which was effectively never used internally)
- Performance improvements
- Support for specifying arbitrary `:gemfile_path` in most class initializers
### Fixed
- Can now handle more variations of Ruby syntax in the Gemfile analyzer
- `require_relative` > `require` for internal files (except for `spec` => `lib`)
- Updated logic for version specified via git with branch, tag, ref (to match fixes to Bundler's behavior)
- Ambiguous naming of `GemBench::Jersey#primary_namespace` is split to:
  - `#doffed_primary_namespace`
  - `#donned_primary_namespace`

## [2.0.3] SEP.18.2024
### Added
- More documentation
### Fixed
- Typos in documentation
- Copyright years

## [2.0.2] SEP.17.2024
- COVERAGE:  82.15% -- 382/465 lines in 9 files
- BRANCH COVERAGE:  58.79% -- 97/165 branches in 9 files
- 51.72% documented
### Added
- CI for Ancient Rubies
  - Ruby 2.3
  - Ruby 2.4
  - Ruby 2.5
  - Ruby 2.6
- More & improved documentation
### Fixed
- Typo in URL in documentation
- Gemspec description & Summary

## [2.0.1] SEP.17.2024
- COVERAGE:  82.15% -- 382/465 lines in 9 files
- BRANCH COVERAGE:  58.08% -- 97/167 branches in 9 files
- 51.72% documented
### Added
- Ability to re-namespace and load copy of a gem alongside vanilla version for benchmarking via `GemBench::Jersey`
  - See: https://github.com/panorama-ed/memo_wise/pull/339
- Many more tests
- `kettle-soup-cover` for test coverage enforcement
- Better documentation
- Improved instructions for contributing
### Changed
- Improved `bin/checksums`
### Fixed
- Stopped swallowing `ArgumentError` in certain exceptional cases

## [2.0.0] SEP.25.2023
### Added
- Compatible with Bundler 2+
- Checksums for release
  - SHA-256
  - SHA-512
- Signed releases
- Add CODE_OF_CONDUCT.md
- Add SECURITY.md (Security policy)
- Github Actions
### Changed
- Dropped support for Ruby 2.0, 2.1, and 2.2
- `VERSION` constant now lives at `GemBench::Version::VERSION`, enhanced by `version_gem`
- Changelog updated to Keep-a-changelog format (going forward)
### Removed
- Removed Appraisals
- Removed Travis-CI

## [1.0.6] SEP.09.2018
- Documentation improvements
- Add Ruby 2.5 to build matrix

## [1.0.5] JUN.05.2017
- Allow github macro as an alternative to git within Gemfile for strict version constraint analysis

## [1.0.3] JUN.02.2017
- fixed accidental removal of loaded_gems in 1.0.2
- better documentation

## [1.0.2] JUN.02.2017
- version constraint checking, useful to add a spec enforcing Gemfile version constraints, by Peter Boling
  - Console use:
    - GemBench::StrictVersionRequirement.new({verbose: true})
  - Spec use:
```ruby
Rspec.describe("Gemfile") do
  it("has version constraint on every gem") do
    requirements = GemBench::StrictVersionRequirement.new({verbose: true})
    expect(requirements.list_missing_version_constraints).to(eq([]))
  end
end
```

## [1.0.1] MAR.25.2017
- fixed a typo that prevented Gemfile comparison by mobilutz

## [1.0.0] FEB.26.2017
- New feature: scan all code (except for test/spec/feature code) in all loaded gems for a given regex:
  - puts GemBench.find(look_for_regex: /HERE BE DRAGONS/).starters.map {|gem| "#{gem.name} has DRAGONS at #{gem.stats}" }.join("\n")
- Added basic specs
- More Documentation
- added back git dependency to gemspec (pulled in latest Gem scaffolding from Bundler :/)

## [0.0.8] JAN.16.2014
- Corrected issues with 0.0.7 release.
- More Documentation
- removed git dependency from gemspec

## [0.0.7] DEC.23.2013 (Yanked immediately)
- Attempt to fix failure on encoding problem, with a rescue fallback (Issue #1) by Peter Boling
- Readme / Documentation improvements by John Bachir
- Runtime output improvements by John Bachir

## [0.0.6] AUG.29.2013
- Added license to gemspec by Peter Boling
- No longer altering Ruby load path - Let the gem manager do that by Peter Boling

## [0.0.5] AUG.28.2013
- Encode as UTF-8 prior to comparison by Peter Boling

## [0.0.4] APR.06.2013
- Expanded exclusion list by Peter Boling

## [0.0.3] APR.06.2013
- Late night coding needs more coffee by Peter Boling

## [0.0.2] APR.06.2013
- Works against 265 dependency Gemfile by Peter Boling
- Added ability to evaluate a Gemfile by Peter Boling

## [0.0.1] APR.05.2013
- Initial release by Peter Boling
