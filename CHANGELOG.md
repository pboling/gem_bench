Version 1.0.7 - SEP.23.2023
* Compatible with Bundler 2+

Version 1.0.6 - SEP.09.2018
* Documentation improvements
* Add Ruby 2.5 to build matrix

Version 1.0.5 - JUN.05.2017
* Allow github macro as an alternative to git within Gemfile for strict version constraint analysis

Version 1.0.3 - JUN.02.2017
* fixed accidental removal of loaded_gems in 1.0.2
* better documentation

Version 1.0.2 - JUN.02.2017
* version constraint checking, useful to add a spec enforcing Gemfile version constraints, by Peter Boling
  - Console use:
    - GemBench::StrictVersionRequirement.new({verbose: true})
  - Spec use:
```ruby
Rspec.describe "Gemfile" do
  it("has version constraint on every gem") do
    requirements = GemBench::StrictVersionRequirement.new({verbose: true})
    expect(requirements.list_missing_version_constraints).to eq([])
  end
end
```

Version 1.0.1 - MAR.25.2017
* fixed a typo that prevented Gemfile comparison by mobilutz

Version 1.0.0 - FEB.26.2017
* New feature: scan all code (except for test/spec/feature code) in all loaded gems for a given regex:
  - puts GemBench.find(look_for_regex: /HERE BE DRAGONS/).starters.map {|gem| "#{gem.name} has DRAGONS at #{gem.stats}" }.join("\n")
* Added basic specs
* More Documentation
* added back git dependency to gemspec (pulled in latest Gem scaffolding from Bundler :/)

Version 0.0.8 - JAN.16.2014
* Corrected issues with 0.0.7 release.
* More Documentation
* removed git dependency from gemspec

Version 0.0.7 - DEC.23.2013 (Yanked immediately)
* Attempt to fix failure on encoding problem, with a rescue fallback (Issue #1) by Peter Boling
* Readme / Documentation improvements by John Bachir
* Runtime output improvements by John Bachir

Version 0.0.6 - AUG.29.2013
* Added license to gemspec by Peter Boling
* No longer altering Ruby load path - Let the gem manager do that by Peter Boling

Version 0.0.5 - AUG.28.2013
* Encode as UTF-8 prior to comparison by Peter Boling

Version 0.0.4 - APR.06.2013
* Expanded exclusion list by Peter Boling

Version 0.0.3 - APR.06.2013
* Late night coding needs more coffee by Peter Boling

Version 0.0.2 - APR.06.2013
* Works against 265 dependency Gemfile by Peter Boling
* Added ability to evaluate a Gemfile by Peter Boling

Version 0.0.1 - APR.05.2013
* Initial release by Peter Boling
