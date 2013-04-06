# GemBench

Gem: "Put me in coach!"
You: ❨╯°□°❩╯︵┻━┻

`gem_bench` is the super easy way to trim down app load times by keeping your worst players on the bench.

It is a fact of RubyGems that many of them do not need to be loaded by your app at boot time.
It is a fact of Bundler that you don't know which ones need to be 'required' while staring at the Gemfile.
It is a fact of Heroku that you only have 60 precious seconds to get your app loaded before ❨╯°□°❩╯︵┻━┻

This gem helps by telling you which gems are being loaded during app boot that don't need to be.

## Installation

You **DO NOT** need to add this gem to your project.

### Option 1

Just install it, and require it in your`irb`/`console` session when you want to use it.  However, if you load your console with `bundle exec` then you only have access to gems in the gemfile, so either load without `bundle exec` or add it to the gemfile.

    $ gem install gem_bench


### Option 2

If you decide to include it in your project: add this line to your Gemfile in the development group:

    gem 'gem_bench', :require => false, :group => :development

And then execute:

    $ bundle


## Usage

Fire up an `irb` session or a `rails console` and then:

    >> require 'gem_bench'
    => true
    >> team = GemBench.check(true) # true => print output, false => just returns a GemBench::Team object you can inspect.

Here is an example `irb` session where I have installed only `gem_bench`, `rails`, and `bundler`.  For the first run I don't require any gems besides `gem_bench`.

    ∴ irb
    >> require 'gem_bench'
    => true
    >> team = GemBench.check(true) # true => print output, false => just returns a GemBench::Team object you can inspect.
    [GemBench] will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems"]
    [GemBench] detected 0 loaded gems (2 will be skipped by GemBench)
    [GemBench] Found no gems to load at boot.
    [GemBench] 0 gems to skip require in Gemfile (require => false):
    => #<GemBench::Team:0x007fd4451207c0 @paths=["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems"], @excluded=[["bundler", "1.2.3"], ["gem_bench", "0.0.1"]], @all=[], @starters=[], @benchers=[], @verbose=true>

For the second run I require rails, and now I can see which rails dependencies are not required at boot time:

    >> require 'rails'
    => true
    >> team = GemBench.check(true)
    [GemBench] will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/bundler/gems"]
    [GemBench] detected 14 loaded gems (2 will be skipped by GemBench)
    You might want to verify that activesupport v3.2.13 really has a Railtie (or Rails::Engine).  Check here:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/activesupport-3.2.11/lib/active_support/i18n_railtie.rb", 146]
    You might want to verify that actionpack v3.2.13 really has a Railtie (or Rails::Engine).  Check here:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/actionpack-3.2.11/lib/action_controller/railtie.rb", 248]
    You might want to verify that railties v3.2.13 really has a Railtie (or Rails::Engine).  Check here:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems/railties-3.2.11/lib/rails/application/configuration.rb", 245]
    [GemBench] 3 gems to load at boot:
    [GemBench] If you want to check for false positives, the files to check for Railties and Engines are listed above:
      gem 'activesupport', '~> 3.2.13'
      gem 'actionpack', '~> 3.2.13'
      gem 'railties', '~> 3.2.13'
    [GemBench] 11 gems to skip require in Gemfile (require => false):
      gem 'i18n', :require => false, '~> 0.6.1'
      gem 'builder', :require => false, '~> 3.0.4'
      gem 'activemodel', :require => false, '~> 3.2.13'
      gem 'rack-cache', :require => false, '~> 1.2'
      gem 'rack', :require => false, '~> 1.4.5'
      gem 'rack-test', :require => false, '~> 0.6.2'
      gem 'journey', :require => false, '~> 1.0.4'
      gem 'hike', :require => false, '~> 1.2.1'
      gem 'tilt', :require => false, '~> 1.3.3'
      gem 'sprockets', :require => false, '~> 2.2.2'
      gem 'erubis', :require => false, '~> 2.7.0'

See that?  Lots of those gems that rails brings don't need to be required when your app boots!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

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

    spec.add_dependency 'gem_bench', '~> 0.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Legal

* MIT License
* Copyright (c) 2013 [Peter H. Boling](http://www.railsbling.com), and Acquaintable [http://acquaintable.com/]
