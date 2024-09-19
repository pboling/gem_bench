# GemBench

<div id="badges">

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/gem/v/gem_bench.svg)](https://rubygems.org/gems/gem_bench)
[![Downloads Today](https://img.shields.io/gem/rd/gem_bench.svg)](https://github.com/pboling/gem_bench)
[![Depfu](https://badges.depfu.com/badges/865e7bb1d0d3eb3ba807fca7344e22d1/overview.svg)](https://depfu.com/github/pboling/gem_bench?project_id=2688)
[![CodeCov][🖇codecov-img♻️]][🖇codecov]
[![Test Coverage](https://api.codeclimate.com/v1/badges/80787f126e7a486b19af/test_coverage)](https://codeclimate.com/github/pboling/gem_bench/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/80787f126e7a486b19af/maintainability)](https://codeclimate.com/github/pboling/gem_bench/maintainability)
[![CI Supported Build][🚎s-wfi]][🚎s-wf]
[![CI Unsupported Build][🚎us-wfi]][🚎us-wf]
[![CI Style Build][🚎st-wfi]][🚎st-wf]
[![CI Coverage Build][🚎cov-wfi]][🚎cov-wf]
[![CI Heads Build][🚎hd-wfi]][🚎hd-wf]
[![CI Ancient Build][🚎an-wfi]][🚎an-wf]

[🖇codecov-img♻️]: https://codecov.io/gh/pboling/gem_bench/graph/badge.svg?token=selEoMrZzA
[🖇codecov]: https://codecov.io/gh/pboling/gem_bench
[🚎s-wf]: https://github.com/pboling/gem_bench/actions/workflows/supported.yml
[🚎s-wfi]: https://github.com/pboling/gem_bench/actions/workflows/supported.yml/badge.svg
[🚎us-wf]: https://github.com/pboling/gem_bench/actions/workflows/unsupported.yml
[🚎us-wfi]: https://github.com/pboling/gem_bench/actions/workflows/unsupported.yml/badge.svg
[🚎st-wf]: https://github.com/pboling/gem_bench/actions/workflows/style.yml
[🚎st-wfi]: https://github.com/pboling/gem_bench/actions/workflows/style.yml/badge.svg
[🚎cov-wf]: https://github.com/pboling/gem_bench/actions/workflows/coverage.yml
[🚎cov-wfi]: https://github.com/pboling/gem_bench/actions/workflows/coverage.yml/badge.svg
[🚎hd-wf]: https://github.com/pboling/gem_bench/actions/workflows/heads.yml
[🚎hd-wfi]: https://github.com/pboling/gem_bench/actions/workflows/heads.yml/badge.svg
[🚎an-wf]: https://github.com/pboling/gem_bench/actions/workflows/ancient.yml
[🚎an-wfi]: https://github.com/pboling/gem_bench/actions/workflows/ancient.yml/badge.svg

</div>

-----

<div align="center">

[![Liberapay Patrons][⛳liberapay-img]][⛳liberapay]
[![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor]
[![Polar Shield][🖇polar-img]][🖇polar]
[![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi]
[![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/patrons/pboling.svg?logo=liberapay
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://polar.sh/embed/seeks-funding-shield.svg?org=pboling
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/buy%20me%20coffee-donate-yellow.svg
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-yellow.svg
[🖇patreon]: https://patreon.com/galtzo

<span class="badge-buymealatte">
<a href="https://www.buymeacoffee.com/pboling"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff" /></a>
</span>

</div>
</div>

[benchmarking-example]: https://github.com/panorama-ed/memo_wise/pull/339

## What's it do?

🏁 Copy & Re-namespace any gem to benchmark side-by-side with `benchmarks-ips`!

👯 For example, many of the ~dozen Memoization gems use the same namespaces (`Memoist`, `Memery`, etc).
In order to compare them side-by-side one of them must be re-namespaced. ([working example][benchmarking-example])

<details>
  <summary>Scene: Spectator at a game of Ruby Sports Gem Ball</summary>

Gem wearing jersey **#23**:

> "Put me in coach!"

Other Gem, also wearing jersey **#23**:

> "Put me in coach!"

Coach:

> ❨╯°□°❩╯︵┻━┻ fine, but one of you change your jersey first!

</details>

🤩 Benchmark trunk against released version of a library! ([working example][benchmarking-example])

🧐 A `git clone` build can now be run against the latest public release build, side-by-side, by re-namespacing one of them. ([working example][benchmarking-example])

🕵️‍♀️ Static Gemfile and installed gem library source code analysis.
Regex search through all of a project's source code, including installed Bundler dependencies.

🛟 Trim down app load times, such as on Heroku, by finding and keeping your worst players on the bench.

| Project        | GemBench                                                                                                                                                                                                                                                                                                                                                                                                                                              |
|----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| gem name       | [gem_bench](https://rubygems.org/gems/gem_bench)                                                                                                                                                                                                                                                                                                                                                                                                      |
| code triage    | [![Open Source Helpers](https://www.codetriage.com/pboling/gem_bench/badges/users.svg)](https://www.codetriage.com/pboling/gem_bench)                                                                                                                                                                                                                                                                                                                 |
| homepage       | [on Github.com][homepage]                                                                                                                                                                                                                                                                                                                                                                                                                             |
| documentation  | [on Rdoc.info][documentation]                                                                                                                                                                                                                                                                                                                                                                                                                         |
| expert support | [![Get help on Codementor](https://cdn.codementor.io/badges/get_help_github.svg)](https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github)                                                                                                                                                                                                                                                 |
| `...` 💖       | [![Liberapay Patrons][⛳liberapay-img]][⛳liberapay] [![Sponsor Me][🖇sponsor-img]][🖇sponsor] [![Follow Me on LinkedIn][🖇linkedin-img]][🖇linkedin] [![Find Me on WellFound:][✌️wellfound-img]][✌️wellfound] [![Find Me on CrunchBase][💲crunchbase-img]][💲crunchbase] [![My LinkTree][🌳linktree-img]][🌳linktree] [![Follow Me on Ruby.Social][🐘ruby-mast-img]][🐘ruby-mast] [![Tweet @ Peter][🐦tweet-img]][🐦tweet] [💻][coderme] [🌏][aboutme] |

<!-- 7️⃣ spread 💖 -->
[🐦tweet-img]: https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow%20%40galtzo
[🐦tweet]: http://twitter.com/galtzo
[🚎blog]: http://www.railsbling.com/tags/gem_bench/
[🚎blog-img]: https://img.shields.io/badge/blog-railsbling-brightgreen.svg?style=flat
[🖇linkedin]: http://www.linkedin.com/in/peterboling
[🖇linkedin-img]: https://img.shields.io/badge/PeterBoling-blue?style=plastic&logo=linkedin
[✌️wellfound]: https://angel.co/u/peter-boling
[✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=plastic&logo=wellfound
[💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=plastic&logo=crunchbase
[🐘ruby-mast]: https://ruby.social/@galtzo
[🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https%3A%2F%2Fruby.social&style=plastic&logo=mastodon&label=Ruby%20%40galtzo
[🌳linktree]: https://linktr.ee/galtzo
[🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=plastic&logo=linktree

<!-- Maintainer Contact Links -->
[aboutme]: https://about.me/peter.boling
[coderme]: https://coderwall.com/Peter%20Boling

### New for 2.0.1 - `GemBench::Jersey`

Allows you to re-namespace any gem.
You can, for example, benchmark a gem against another version of itself.

The gem `alt_memery` uses a namespace, `Memery`, that does not match the gem name.

```ruby
require "gem_bench/jersey"

jersey = GemBench::Jersey.new(
  gem_name: "alt_memery",
  trades: {"Memery" => "AltMemery"},
  metadata: { # optional, mostly used for benchmarking report output
    something: "a value here",
    something_else: :obviously,
  },
)
jersey.doff_and_don
# The re-namespaced constant is now available!
AltMemery # => AltMemery
jersey.as_klass # => AltMemery

# The original, unmodified, gem is still there!
require "alt_memery"

Memery # => Memery
# So you can use both!
```

NOTE: It is not required by default, so you do need to require the Jersey if you want to use it!

```ruby
require "gem_bench/jersey"
```

#### Usage

If the original gem defines multiple top-level namespaces,
they can all be renamed by providing more key value pairs in `trades`.
If the original gem monkey patches other libraries,
that behavior can't be isolated, so YMMV.

NOTE: Non-top-level namespaces do not need to be renamed,
as they are isolated within their parent namespace.

#### Example

For a real example, see: https://github.com/panorama-ed/memo_wise/pull/339

#### Naming: Why `doff_and_don`?

> Wouldn't "copy_gem" make sense?

Actually copy is an overloaded term, which creates confusion in this use case.
This method Generates a temp directory, and creates a copy of a gem within it.
Re-namespaces the copy according to the `trades` configuration.
Then requires each file of the "copied gem", resulting
in a loaded gem that will not have namespace
collisions when loaded alongside the original-namespaced gem.
Note that "copied gem" in the previous sentence is ambiguous without the supporting context.
The "copied gem" can mean either the original, or the "copy", which is why this gem refers to
a "doffed gem" (the original) and a "donned gem" (the copy).

Also because `Jersey`.  Duh...

#### Advanced Usage

If a block is provided the contents of each file will be yielded to the block,
after all namespace substitutions from `trades` are complete, but before the contents
are written to the donned (re-namespaced) gem. The return value of the block will be
written to the file in this scenario.

### New for 2.0.0 - Dropped Support for Ruby 2.0, 2.1, 2.2

- Required Ruby is now 2.3+
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

<details>
  <summary>Scene: Rubiana Jones is searching for WAT Dragon relics in dusty bins of source code</summary>

Gem:

> "I have no wat DRAGONS!"`

Rubiana Jones:

> ❨╯°□°❩╯︵┻━┻ Yes you do!

```
>> puts GemBench.find(look_for_regex: /wat/).starters.map {|gem| "#{gem.name} has wat DRAGONS at #{gem.stats}" }.join("\n")
[GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@global/gems", "/Users/pboling/.rvm/gems/ruby-2.4.0@foss/bundler/gems"]
[GemBench] Detected 11 loaded gems + 2 loaded gems which GemBench is configured to ignore.
byebug has wat DRAGONS at [["/Users/pboling/.rvm/gems/ruby-2.4.0@foss/gems/byebug-9.0.6/lib/byebug/commands/frame.rb", 954]]
=> nil
```

NOTE: The number (954, above) is not a line number. The file which contains the text `wat` was the 954th file evaluated, i.e. the number doesn't matter.
NOTE: This is a contrived example.  The occurrence of `wat` in byebug is meaningless: `byebug/commands/frame.rb:34` has `        if there is a front end also watching over things.`.  This is just an example!  You can find anything you want, perhaps even something important!

</details>

It is a fact of RubyGems that many of them do not need to be loaded by your app at boot time.
It is a fact of Bundler that you don't know which ones need to be 'required' while staring at the Gemfile.
It is a fact of Heroku that you only have 60, 75, or 120 ([by special request](https://devcenter.heroku.com/articles/error-codes#h20-app-boot-timeout)) precious seconds to get your app loaded before ❨╯°□°❩╯︵┻━┻

This gem helps by telling you which gems don't need to be loaded during boot time.

You can even use it to evaluate your project's actual Gemfile for easy peasy boot time savings. (see Advanced Usage)

## Installation

You *may not* need to add this gem to your project.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add gem_bench

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install gem_bench

<details>
    <summary>Installation Options</summary>

### Option 1

Just install it, and require it in your `irb` or `console` session when you want to use it.  However, if you load your console with `bundle exec` then you only have access to gems in the gemfile, so either load without `bundle exec` or add it to the `Gemfile`.

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

</details>

## Usage

Works with Ruby >= 2.3.

### Examples

<details>
    <summary>Getting tired of seeing this `irb` warning, perhaps?</summary>

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

</details>

<details>
  <summary>Find what gems have `RAILS_ENV` specific code!</summary>

Let's try to find what libraries might be using a conditional guard to alter their behavior in a specific Rails environment.

```
# Not a perfect regex, but pretty good: https://rubular.com/r/b7tdIoYOVQM2RR
# RAILS_ENV == "development"
# Rails.env.development?
# Rails.env == "development"
# ENV["RAILS_ENV"] == "development"
# ENV.fetch("RAILS_ENV") == "development"
>> require "gem_bench"
=> true
>> conditional_rails_behavior_regex = /(ENV(\["|\.fetch\("))?rails(_|\.)env("\]|"\))?( == "|\.)development/i
>> conditional_rails_behavior = GemBench.find(look_for_regex: conditional_rails_behavior_regex).starters
=> [rack, actionpack, actioncable, actionmailer, rubocop, railties, rubocop-ruby2_7, sass, sass-rails]
>> print conditional_rails_behavior.map {|gem| "#{gem.name} has Rails.env condition in #{gem.stats}" }.join("\n")
rack has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/rack-mini-profiler-3.1.0/lib/mini_profiler_rails/railtie.rb", 1154]]
actionpack has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/actionpack-3.2.22.5/lib/action_controller/metal/force_ssl.rb", 1377]]
actioncable has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/actioncable-5.2.8.1/lib/action_cable/engine.rb", 886]]
actionmailer has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/actionmailer-7.0.5/lib/action_mailer/railtie.rb", 807]]
rubocop has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/rubocop-ruby2_2-2.0.5/lib/rubocop/ruby2_2/railtie.rb", 131]]
railties has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/railties-3.2.22.5/lib/rails.rb", 2478]]
rubocop-ruby2_7 has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/rubocop-ruby2_7-2.0.5/lib/rubocop/ruby2_7/railtie.rb", 131]]
sass has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/sass-rails-5.1.0/lib/sass/rails/railtie.rb", 3349]]
sass-rails has Rails.env condition in [["/Users/pboling/.asdf/installs/ruby/2.7.8/lib/ruby/gems/2.7.0/gems/sass-rails-5.1.0/lib/sass/rails/railtie.rb", 3349]]
```

</details>

<details>
  <summary> Basic Gemfile Analysis</summary>

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

</details>

<details>
  <summary>Advanced Gemfile Analysis</summary>

In order to *also* see list gems may *not* be required at boot time you need to:

1. Make sure you are in the root of a project with a Gemfile
2. Make sure the gem is actually a dependency in the Gemfile

So here's a [fat Gemfile][bundle-group-pattern] weighing in at 265 gem dependencies.  We'll use it for this example:

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

</details>

## Future

This gem determines which gems need to be loaded at Rails' boot time by looking for Railties and Engines.
A future version will also look for initializers, because gems which have code that runs (e.g. configuration) in an initializer also need to be loaded at boot time.

## 🤝 Contributing

See [CONTRIBUTING.md][🤝contributing]

[🤝contributing]: CONTRIBUTING.md

### Code Coverage

If you need some ideas of where to help, you could work on adding more code coverage.

[![Coverage Graph][🔑codecov-g]][🖇codecov]

[🔑codecov-g]: https://codecov.io/gh/pboling/gem_bench/graphs/tree.svg?token=selEoMrZzA

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/pboling/gem_bench/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=pboling/gem_bench

## Star History

<a href="https://star-history.com/#pboling/gem_bench&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=pboling/gem_bench&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=pboling/gem_bench&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=pboling/gem_bench&type=Date" />
 </picture>
</a>

## 🪇 Code of Conduct

Everyone interacting in this project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct][🪇conduct].

[🪇conduct]: CODE_OF_CONDUCT.md

## 📌 Versioning

This Library adheres to [Semantic Versioning 2.0.0][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

As a result of this policy, you can (and should) specify a dependency on these libraries using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("gem_bench", "~> 2.0")
```

See [CHANGELOG.md][📌changelog] for list of releases.

[comment]: <> ( 📌 VERSIONING LINKS )

[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: http://semver.org/
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: CHANGELOG.md

## 📄 License

The gem is available as open source under the terms of
the [MIT License][📄license] [![License: MIT][📄license-img]][📄license-ref].
See [LICENSE.txt][📄license] for the official [Copyright Notice][📄copyright-notice-explainer].

[comment]: <> ( 📄 LEGAL LINKS )

[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.txt
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-green.svg

### © Copyright

* Copyright (c) 2013 - 2014, 2016 - 2020, 2023 - 2024 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[bundle-group-pattern]: https://gist.github.com/pboling/4564780
[documentation]: http://rdoc.info/github/pboling/gem_bench/frames
[homepage]: https://github.com/pboling/gem_bench
