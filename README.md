# GemBench

`gem_bench` is for static Gemfile and installed gem library source code analysis.

`gem_bench` can also be used to trim down app load times by keeping your worst players on the bench.

Gem: "Put me in coach!"
You: ❨╯°□°❩╯︵┻━┻

| Project                | GemBench                                                                                                                                                                                             |
|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| gem name               | [gem_bench](https://rubygems.org/gems/gem_bench)                                                                                                                                                     |
| license                | [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)                                                                                           |
| download rank          | [![Downloads Today](https://img.shields.io/gem/rd/gem_bench.svg)](https://github.com/pboling/gem_bench)                                                                                              |
| version                | [![Version](https://img.shields.io/gem/v/gem_bench.svg)](https://rubygems.org/gems/gem_bench)                                                                                                        |
| dependencies           | [![Depfu](https://badges.depfu.com/badges/865e7bb1d0d3eb3ba807fca7344e22d1/overview.svg)](https://depfu.com/github/pboling/gem_bench?project_id=5613)                                                |
| continuous integration | [![Current][🚎cwfi]][🚎cwf] [![Heads][🖐hwfi]][🖐hwf] [![Style][🧮swfi]][🧮swf] [![Coverage][📗cov-wfi]][📗cov-wf]                                                                                   |
| test coverage          | [![Test Coverage](https://api.codeclimate.com/v1/badges/80787f126e7a486b19af/test_coverage)](https://codeclimate.com/github/pboling/gem_bench/test_coverage)                                         |
| maintainability        | [![Maintainability](https://api.codeclimate.com/v1/badges/80787f126e7a486b19af/maintainability)](https://codeclimate.com/github/pboling/gem_bench/maintainability)                                   |
| code triage            | [![Open Source Helpers](https://www.codetriage.com/pboling/gem_bench/badges/users.svg)](https://www.codetriage.com/pboling/gem_bench)                                                                |
| homepage               | [on Github.com][homepage]                                                                                                                                                                            |
| documentation          | [on Rdoc.info][documentation]                                                                                                                                                                        |
| live chat              | [![Join the chat][🏘chati]][🏘chat]                                                                                                                                                                         |
| expert support         | [![Get help on Codementor](https://cdn.codementor.io/badges/get_help_github.svg)](https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github) |
| Spread ~♡ⓛⓞⓥⓔ♡~        | [🌏](https://about.me/peter.boling), [👼](https://angel.co/peter-boling), [![Tweet Peter](https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow)](http://twitter.com/galtzo)    |

[🚎cwf]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/current.yml
[🚎cwfi]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/current.yml/badge.svg
[🖐hwf]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/heads.yml
[🖐hwfi]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/heads.yml/badge.svg
[🧮swf]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/style.yml
[🧮swfi]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/style.yml/badge.svg
[📗cov-wf]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/coverage.yml
[📗cov-wfi]: https://github.com/rubocop-lts/rubocop-lts/actions/workflows/coverage.yml/badge.svg
[🏘chat]: https://matrix.to/#/%23pboling_gem_bench:gitter.im
[🏘chati]: https://badges.gitter.im/Join%20Chat.svg

### New for 2.0.0 - Dropped Support for Ruby 2.0, 2.1, 2.2

-- Required Ruby is now 2.3+
- `VERSION` is now namespaced at `GemBench::Version::VERSION` and is enhanced by `version_gem`.

### New for 1.0.2 - Gemfile specs

Version constraints are important.  Give the Gemfile some love in your CI build

Create a `spec/gemfile_spec.rb` like:
```ruby
Rspec.describe("Gemfile") do
  it("has version constraint on every gem") do
    requirements = GemBench::StrictVersionRequirement.new({verbose: false})
    expect(requirements.list_missing_version_constraints).to(eq([]))
  end
end
```

Then your build will fail as soon as a gem is added without a proper constraint:

```
Failures:

1) Gemfile has version constraint on every gem
Failure/Error: expect(requirements.list_missing_version_constraints).to eq([])

  expected: []
       got: ["puma"]

  (compared using ==)
# ./spec/gemfile_spec.rb:7:in `block (2 levels) in <top (required)>'
```

For `:git`/`:github` sources, `:ref` and `:tag` are considered as "constraints", while `:branch` is not, because branches may be a moving target, and this gem aims to make Gemfiles production-ready.
For string version constraints anything is allowed (e.g. `'~> 1.0'`), as it assumes the constraint placed is well considered.

### New for 1.0.0 - Find WAT Dragons in 3rd party source code

Search the Ruby source code of all the gems loaded by your Gemfile for a specified regex, to find out which gems have wat DRAGONS.

Gem: "I have no wat DRAGONS!"
You: ❨╯°□°❩╯︵┻━┻

```
>> puts GemBench.find(look_for_regex: /wat/).starters.map {|gem| "#{gem.name} has wat DRAGONS at #{gem.stats}" }.join("\n")
[GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@global/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@foss/bundler/gems"]
[GemBench] Detected 11 loaded gems + 2 loaded gems which GemBench is configured to ignore.
byebug has wat DRAGONS at [["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems/byebug-9.0.6/lib/byebug/commands/frame.rb", 954]]
=> nil
```

NOTE: The number (954, above) is not a line number. The file which contains the text `wat` was the 954th file evaluated, i.e. the number doesn't matter.
NOTE: This is a contrived example.  The occurrence of `wat` in byebug is meaningless: `byebug/commands/frame.rb:34` has `        if there is a front end also watching over things.`.  This is just an example!  You can find anything you want, perhaps even something important!

It is a fact of RubyGems that many of them do not need to be loaded by your app at boot time.
It is a fact of Bundler that you don't know which ones need to be 'required' while staring at the Gemfile.
It is a fact of Heroku that you only have 60, 75, or 120 ([by special request](https://devcenter.heroku.com/articles/error-codes#h20-app-boot-timeout)) precious seconds to get your app loaded before ❨╯°□°❩╯︵┻━┻

This gem helps by telling you which gems don't need to be loaded during boot time.

You can even use it to evaluate your project's actual Gemfile for easy peasy boot time savings. (see Advanced Usage)

## Installation

You *may not* need to add this gem to your project.  You have three options, 1, 2 or BEST:

### Option 1

Just install it, and require it in your`irb`/`console` session when you want to use it.  However, if you load your console with `bundle exec` then you only have access to gems in the gemfile, so either load without `bundle exec` or add it to the `Gemfile`.

    $ gem install gem_bench

### Option 2

If you decide to include it in your project: add this line to your `Gemfile` in the `:development` group.

    gem 'gem_bench', :require => false, :group => :development

### Option BEST 1

Or better yet [follow the bundle group pattern in your Gemfile][bundle-group-pattern] and setup a console group so it will only load in the console, and not the web app.  With it loading only in the console session the `require: false` is completely optional. The gem is tiny, so won't impact console load time much. Requiring it will allow checking your `Gemfile` without needing to first `require 'gem_bench'`.

    gem 'gem_bench', :group => :console

And then execute:

    $ bundle

### Option BEST 2

If you are going to use the gem in your specs, you will need to add it to the test group.

    gem 'gem_bench', :group => :test

## Usage

Works with Ruby >= 2.3.

### Example!

Getting tired of seeing this `irb` warning, perhaps?

```
$ bundle exec rails console
Loading staging environment (Rails M.m.p)
irb: warn: can't alias context from irb_context.
```

Find out what gems may be causing it by defining `context`!
```
>> require 'gem_bench'
=> true
>> bad_context_maybes = GemBench.find(look_for_regex: /def context/).starters
[GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@global/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@foss/bundler/gems"]
[GemBench] Detected 11 loaded gems + 2 loaded gems which GemBench is configured to ignore.
=> [byebug, diff-lcs]
```
Then find the file with the first occurrence of the regex in each:
```
>> bad_context_maybes.map { |bcm| bcm.stats.map(&:first) }
=> [["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems/byebug-9.0.6/lib/byebug/command.rb"], ["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems/diff-lcs-1.3/lib/diff/lcs/hunk.rb"]]
```

### More Different Example!

Fire up an `irb` session or a `rails console` and then:

    >> require 'gem_bench'
    => true
    >> team = GemBench.check({verbose: true}) # verbose: true => print output, verbose: false => just returns a GemBench::Team object you can inspect.

Here is an example `irb` session where I have installed only `gem_bench`, `rails`, and `bundler`.  For the first run I don't require any gems besides `gem_bench`.

    ∴ irb
    >> require 'gem_bench'
    => true
    >> team = GemBench.check({verbose: true})
    [GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems"]
    [GemBench] Will check Gemfile at /Users/pboling/Documents/src/my/gem_bench/Gemfile.
    [GemBench] Detected 0 loaded gems
      (excluding the 2 loaded gems which GemBench is configured to ignore)
    [GemBench] No gems were evaluated by GemBench.
    [GemBench] Usage: Require another gem in this session to evaluate it.
      Example:
        require 'rails'
        GemBench.check({verbose: true})
    [GemBench] Evaluated 0 gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).

For the second run I `require 'rails'` as well, and now I can see which rails dependencies are required at boot time.  I am in a project with a Gemfile, (gem_bench) but it doesn't depend on rails.

    ∴ irb
    >> require 'gem_bench'
    => true
    >> require 'rails'
    => true
    >> team = GemBench.check({verbose: true})
    [GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems"]
    [GemBench] Will check Gemfile at /Users/pboling/Documents/src/my/gem_bench/Gemfile.
    [GemBench] Detected 14 loaded gems
      (excluding the 2 loaded gems which GemBench is configured to ignore)
    [GemBench] You might want to verify that activesupport v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/activesupport-3.2.11/lib/active_support/i18n_railtie.rb", 146]
    [GemBench] You might want to verify that actionpack v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/actionpack-3.2.11/lib/action_controller/railtie.rb", 248]
    [GemBench] You might want to verify that railties v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/railties-3.2.11/lib/rails/application/configuration.rb", 245]
    [GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above.
    [GemBench] 3 out of 14 evaluated gems actually need to be loaded at boot time. They are:
      [SUGGESTION] 1) gem 'activesupport', '~> 3.2.13'
      [SUGGESTION] 2) gem 'actionpack', '~> 3.2.13'
      [SUGGESTION] 3) gem 'railties', '~> 3.2.13'
    [GemBench] Evaluated 14 gems against your Gemfile but found no primary dependencies which can safely skip require on boot (require: false).

See that?  Only 3 of the 14 gems rails loads need to be required when your app boots, technically!
However, in order to prevent loading them we would have to make them primary dependencies, listed in the Gemfile, which isn't really the best idea.  Moving on...
If you run the check against a real app's Gemfile it will find numerous primary dependencies that don't need to be required at app boot. See Advanced Usage :)

In a random directory, in an irb session, where there is no Gemfile in sight it will give a lot more information.

### Advanced Usage

In order to *also* see list gems may *not* be required at boot time you need to:

1. Make sure you are in the root of a project with a Gemfile
2. Make sure the gem is actually a dependency in the Gemfile

So here's a [*fat* Gemfile][bundle-group-pattern] weighing in at 265 gem dependencies.  We'll use it for this example:

    ∴ bundle exec rails console
    Welcome to RAILS. You are using ruby 1.9.3p392 (2013-02-22 revision 39386) [x86_64-darwin12.2.1]. Have fun ;)
    Loading development environment (Rails 3.2.13)
    [1] pry(main)> a = GemBench.check({verbose: true})
    ... # snip # ...
    [GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above.
    [GemBench] 74 out of 265 evaluated gems actually need to be loaded at boot time. They are:
      [SUGGESTION] 1) gem 'activesupport', '~> 3.2.13', require: false
      [SUGGESTION] 2) gem 'sprockets', '~> 2.2.2', require: false
      [SUGGESTION] 3) gem 'actionpack', '~> 3.2.13', require: false
      [SUGGESTION] 4) gem 'actionmailer', '~> 3.2.13', require: false
      [SUGGESTION] 5) gem 'activerecord', '~> 3.2.13', require: false
      [SUGGESTION] 6) gem 'activerecord-postgres-array', '~> 0.0.9', require: false
      [SUGGESTION] 7) gem 'activerecord-postgres-hstore', '~> 0.7.6', require: false
      [SUGGESTION] 8) gem 'activeresource', '~> 3.2.13', require: false
      [SUGGESTION] 9) gem 'railties', '~> 3.2.13', require: false
      [SUGGESTION] 10) gem 'acts-as-messageable', '~> 0.4.8', require: false
      [SUGGESTION] 11) gem 'airbrake', '~> 3.1.10', require: false
      [SUGGESTION] 12) gem 'asset_sync', '~> 0.5.4', require: false
      [SUGGESTION] 13) gem 'slim', '~> 1.3.6', require: false
      [SUGGESTION] 14) gem 'sidekiq', '~> 2.10.0', require: false
      [SUGGESTION] 15) gem 'aws-sdk', '~> 1.8.5', require: false
      [SUGGESTION] 16) gem 'better_errors', '~> 0.8.0', require: false
      [SUGGESTION] 17) gem 'sass', '~> 3.2.7', require: false
      [SUGGESTION] 18) gem 'bootstrap-sass', '~> 2.3.1.0', require: false
      [SUGGESTION] 19) gem 'haml', '~> 4.0.1', require: false
      [SUGGESTION] 20) gem 'bullet', '~> 4.5.0', require: false
      [SUGGESTION] 21) gem 'parallel', '~> 0.6.4', require: false
      [SUGGESTION] 22) gem 'cells', '~> 3.8.8', require: false
      [SUGGESTION] 23) gem 'coffee-rails', '~> 3.2.2', require: false
      [SUGGESTION] 24) gem 'compass', '~> 0.12.2', require: false
      [SUGGESTION] 25) gem 'compass-rails', '~> 1.0.3', require: false
      [SUGGESTION] 26) gem 'csv_pirate', '~> 5.0.7', require: false
      [SUGGESTION] 27) gem 'devise', '~> 2.2.3', require: false
      [SUGGESTION] 28) gem 'devise_invitable', '~> 1.1.3', require: false
      [SUGGESTION] 29) gem 'rails', '~> 3.2.13', require: false
      [SUGGESTION] 30) gem 'dismissible_helpers', '~> 0.1.5', require: false
      [SUGGESTION] 31) gem 'dotenv', '~> 0.6.0', require: false
      [SUGGESTION] 32) gem 'dry_views', '~> 0.0.2', require: false
      [SUGGESTION] 33) gem 'sass-rails', '~> 3.2.6', require: false
      [SUGGESTION] 34) gem 'font-awesome-sass-rails', '~> 3.0.2.2', require: false
      [SUGGESTION] 35) gem 'foundation-icons-sass-rails', '~> 2.0.0', require: false
      [SUGGESTION] 36) gem 'g', '~> 1.7.2', require: false
      [SUGGESTION] 37) gem 'geocoder', '~> 1.1.6', require: false
      [SUGGESTION] 38) gem 'geokit', '~> 1.6.5', require: false
      [SUGGESTION] 39) gem 'geokit-rails3', '~> 0.1.5', require: false
      [SUGGESTION] 40) gem 'pry', '~> 0.9.12', require: false
      [SUGGESTION] 41) gem 'rspec', '~> 2.13.0', require: false
      [SUGGESTION] 42) gem 'spork', '~> 1.0.0rc3', require: false
      [SUGGESTION] 43) gem 'haml-rails', '~> 0.4', require: false
      [SUGGESTION] 44) gem 'handlebars_assets', '~> 0.12.0', require: false
      [SUGGESTION] 45) gem 'hirefire-resource', '~> 0.0.2', require: false
      [SUGGESTION] 46) gem 'jquery-rails', '~> 2.2.1', require: false
      [SUGGESTION] 47) gem 'html5-rails', '~> 0.0.7', require: false
      [SUGGESTION] 48) gem 'jquery-ui-rails', '~> 3.0.1', require: false
      [SUGGESTION] 49) gem 'kaminari', '~> 0.14.1', require: false
      [SUGGESTION] 50) gem 'neography', '~> 1.0.9', require: false
      [SUGGESTION] 51) gem 'neoid', '~> 0.1.2', require: false
      [SUGGESTION] 52) gem 'nested_form', '~> 0.3.2', require: false
      [SUGGESTION] 53) gem 'newrelic_rpm', '~> 3.6.0.78', require: false
      [SUGGESTION] 54) gem 'parallel_tests', '~> 0.10.4', require: false
      [SUGGESTION] 55) gem 'pg', '~> 0.15.0', require: false
      [SUGGESTION] 56) gem 'rspec-rails', '~> 2.13.0', require: false
      [SUGGESTION] 57) gem 'pg_power', '~> 1.3.1', require: false
      [SUGGESTION] 58) gem 'pry-rails', '~> 0.2.2', require: false
      [SUGGESTION] 59) gem 'quiet_assets', '~> 1.0.2', require: false
      [SUGGESTION] 60) gem 'remotipart', '~> 1.0.5', require: false
      [SUGGESTION] 61) gem 'rails_admin', '~> 0.4.6', require: false
      [SUGGESTION] 62) gem 'requirejs-rails', '~> 0.9.1.1', require: false
      [SUGGESTION] 63) gem 'rolify', '~> 3.2.0', require: false
      [SUGGESTION] 64) gem 'rspec-cells', '~> 0.1.6', require: false
      [SUGGESTION] 65) gem 'sanitize_email', '~> 1.0.6', require: false
      [SUGGESTION] 66) gem 'simplecov', '~> 0.7.1', require: false
      [SUGGESTION] 67) gem 'spork-rails', '~> 3.2.1', require: false
      [SUGGESTION] 68) gem 'sprockets-rails', '~> 0.0.1', require: false
      [SUGGESTION] 69) gem 'stackable_flash', '~> 0.0.7', require: false
      [SUGGESTION] 70) gem 'state_machine', '~> 1.2.0', require: false
      [SUGGESTION] 71) gem 'teabag', '~> 0.4.6', require: false
      [SUGGESTION] 72) gem 'turbo-sprockets-rails3', '~> 0.3.6', require: false
      [SUGGESTION] 73) gem 'turbolinks', '~> 1.1.1', require: false
      [SUGGESTION] 74) gem 'zurb-foundation', '~> 4.1.1', require: false
    [GemBench] Evaluated 265 gems and Gemfile at /Users/pboling/Documents/RubyMineProjects/simple/Gemfile.
    [GemBench] Here are 45 suggestions for improvement:
      [SUGGESTION] 1) gem 'tilt', '~> 1.3.6'
      [SUGGESTION] 2) gem 'json', '~> 1.7.7'
      [SUGGESTION] 3) gem 'annotate', '~> 2.5.0'
      [SUGGESTION] 4) gem 'nokogiri', '~> 1.5.9'
      [SUGGESTION] 5) gem 'redis', '~> 3.0.3'
      [SUGGESTION] 6) gem 'sinatra', '~> 1.3.6'
      [SUGGESTION] 7) gem 'autoscaler', '~> 0.2.1'
      [SUGGESTION] 8) gem 'binding_of_caller', '~> 0.7.1'
      [SUGGESTION] 9) gem 'bourne', '~> 1.4.0'
      [SUGGESTION] 10) gem 'brakeman', '~> 1.9.5'
      [SUGGESTION] 11) gem 'cancan', '~> 1.6.9'
      [SUGGESTION] 12) gem 'capybara', '~> 2.0.3'
      [SUGGESTION] 13) gem 'chronic', '~> 0.9.1'
      [SUGGESTION] 14) gem 'compass-h5bp', '~> 0.1.1'
      [SUGGESTION] 15) gem 'database_cleaner', '~> 0.9.1'
      [SUGGESTION] 16) gem 'debugger', '~> 1.5.0'
      [SUGGESTION] 17) gem 'devise-async', '~> 0.7.0'
      [SUGGESTION] 18) gem 'dotenv-rails', '~> 0.6.0'
      [SUGGESTION] 19) gem 'email_spec', '~> 1.4.0'
      [SUGGESTION] 20) gem 'fabrication', '~> 2.6.4'
      [SUGGESTION] 21) gem 'fakeweb', '~> 1.3.0'
      [SUGGESTION] 22) gem 'flag_shih_tzu', '~> 0.3.2'
      [SUGGESTION] 23) gem 'friendly_id', '~> 4.0.9'
      [SUGGESTION] 24) gem 'guard', '~> 1.7.0'
      [SUGGESTION] 25) gem 'guard-rspec', '~> 2.5.2'
      [SUGGESTION] 26) gem 'i18n-airbrake', '~> 0.0.2'
      [SUGGESTION] 27) gem 'km', '~> 1.1.3'
      [SUGGESTION] 28) gem 'localtunnel', '~> 0.3'
      [SUGGESTION] 29) gem 'mailcatcher', '~> 0.5.10'
      [SUGGESTION] 30) gem 'numbers_and_words', '~> 0.6.0'
      [SUGGESTION] 31) gem 'oj', '~> 2.0.10'
      [SUGGESTION] 32) gem 'omniauth-facebook', '~> 1.4.1'
      [SUGGESTION] 33) gem 'poltergeist', '~> 1.0.2'
      [SUGGESTION] 34) gem 'pry-doc', '~> 0.4.5'
      [SUGGESTION] 35) gem 'puma', '~> 2.0.0.b7'
      [SUGGESTION] 36) gem 'queryable_array', '~> 0.0.1'
      [SUGGESTION] 37) gem 'rails_best_practices', '~> 1.13.4'
      [SUGGESTION] 38) gem 'redcarpet', '~> 2.2.2'
      [SUGGESTION] 39) gem 'redis-rails', '~> 3.2.3'
      [SUGGESTION] 40) gem 'shoulda-matchers', '~> 1.4.2'
      [SUGGESTION] 41) gem 'sidekiq-status', '~> 0.3.0'
      [SUGGESTION] 42) gem 'terminal-notifier', '~> 1.4.2'
      [SUGGESTION] 43) gem 'test-unit', '~> 2.5.4'
      [SUGGESTION] 44) gem 'uglifier', '~> 1.3.0'
      [SUGGESTION] 45) gem 'vestal_versions', '~> 1.2.3'

`gem_bench` found 45 gems which are listed as primary dependencies in my `Gemfile` which I can add `require: false` to.
After adding `require: false`, try all these locally:

1. running your tests
2. starting the console
3. starting the server and using your app
4. running rake tasks if you have any special ones

When doing these, you will probably encounter errors saying that a library is not available. You should then
add `require "foo"` where the error happens. Keep in mind that if this is in an initializer or environment file,
you aren't saving any time when the rails server is booting. However,
it does save time when running a rake task that does not invoke the environment (some do, some don't). So, if
you don't think saving this time is worth the minor additional code complexity, you can exclude the `require: false`s
in these cases.

After adding your `require: false`s, run gem_bench again. The gem's logic isn't perfect so it sometimes
will find new suggested exclusions.

How much faster will my app boot loading 45 fewer gems?  A bit.

**Note:** Some of the gems in the list above should have been excluded.  They are now excluded as of `gem_bench` version 0.0.4.

## Future

This gem determines which gems need to be loaded at Rails' boot time by looking for Railties and Engines.
A future version will also look for initializers, because gems which have code that runs (e.g. configuration) in an initializer also need to be loaded at boot time.

## Contributors

[![Contributors](https://contrib.rocks/image?repo=pboling/gitmoji-regex)][🖐contributors]

Made with [contributors-img][contrib-rocks].

[🖐contributors]: https://github.com/pboling/gem_bench/graphs/contributors
[contrib-rocks]: https://contrib.rocks

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically,
if a minor or patch version is released that breaks backward
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

    spec.add_dependency 'gem_bench', '~> 2.0'

See [CHANGELOG.md](CHANGELOG.md) for list of releases.

## Legal

* [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
* Copyright (c) 2013 - 2014, 2016 - 2020, 2023 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[bundle-group-pattern]: https://gist.github.com/pboling/4564780
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[coderwall]: http://coderwall.com/pboling
[documentation]: http://rdoc.info/github/pboling/gem_bench/frames
[homepage]: https://github.com/pboling/gem_bench
