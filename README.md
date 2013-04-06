# GemBench

Gem: "Put me in coach!"
You: ❨╯°□°❩╯︵┻━┻

`gem_bench` is the super easy way to trim down app load times by keeping your worst players on the bench.

It is a fact of RubyGems that many of them do not need to be loaded by your app at boot time.
It is a fact of Bundler that you don't know which ones need to be 'required' while staring at the Gemfile.
It is a fact of Heroku that you only have 60 precious seconds to get your app loaded before ❨╯°□°❩╯︵┻━┻

This gem helps by telling you which gems are don't need to be loaded during boot time.

You can even use it to evaluate your project's actual Gemfile for easy peasy boot time savings. (see Advanced Usage)

## Installation

You *may not* need to add this gem to your project.  You have three options, 1, 2 or BEST:

### Option 1

Just install it, and require it in your`irb`/`console` session when you want to use it.  However, if you load your console with `bundle exec` then you only have access to gems in the gemfile, so either load without `bundle exec` or add it to the `Gemfile`.

    $ gem install gem_bench


### Option 2

If you decide to include it in your project: add this line to your `Gemfile` in the `:development` group.

    gem 'gem_bench', :require => false, :group => :development

### Option BEST

Or better yet [follow the bundle group pattern in your Gemfile][bundle-group-pattern] and setup a console group so it will only load in the console, and not the web app.  With it loading only in the console session the `require: false` is completely optional. The gem is tiny, so won't impact console load time much. Requiring it will allow checking your `Gemfile` without needing to first `require 'gem_bench'`.

    gem 'gem_bench', :group => :console

And then execute:

    $ bundle


## Usage

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

In a random directory, in an irb session, where there is no Gemfile in sight it will give a lot more information:

    ∴ irb
    >> require 'gem_bench'
    => true
    >> require 'rails'
    => true
    >> team = GemBench.check({verbose: true})
    [GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-head@foss/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-head@global/gems"]
    [GemBench] No Gemfile found.
    [GemBench] Will show bad ideas.  Be Careful.
    [GemBench] Detected 14 loaded gems
      (excluding the 2 loaded gems which GemBench is configured to ignore)

    [GemBench] Usage: Require another gem in this session to evaluate it.
      Example:
        require 'rails'
        GemBench.check({verbose: true})
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
    [GemBench] Evaluated 14 loaded gems and found 11 which may be able to skip boot loading (require: false).
    *** => WARNING <= ***: Be careful adding non-primary dependencies to your Gemfile as it is generally a bad idea.
    To safely evaluate a Gemfile:
      1. Make sure you are in the root of a project with a Gemfile
      2. Make sure the gem is actually a dependency in the Gemfile
      [BE CAREFUL] 1) gem 'i18n', '~> 0.6.1', require: false
      [BE CAREFUL] 2) gem 'builder', '~> 3.0.4', require: false
      [BE CAREFUL] 3) gem 'activemodel', '~> 3.2.13', require: false
      [BE CAREFUL] 4) gem 'rack-cache', '~> 1.2', require: false
      [BE CAREFUL] 5) gem 'rack', '~> 1.4.5', require: false
      [BE CAREFUL] 6) gem 'rack-test', '~> 0.6.2', require: false
      [BE CAREFUL] 7) gem 'journey', '~> 1.0.4', require: false
      [BE CAREFUL] 8) gem 'hike', '~> 1.2.1', require: false
      [BE CAREFUL] 9) gem 'tilt', '~> 1.3.3', require: false
      [BE CAREFUL] 10) gem 'sprockets', '~> 2.2.2', require: false
      [BE CAREFUL] 11) gem 'erubis', '~> 2.7.0', require: false

## Advanced Usage

In order to *also* see list gems may *not* be required at boot time you need to:

1. Make sure you are in the root of a project with a Gemfile
2. Make sure the gem is actually a dependency in the Gemfile

So here's a [*fat* Gemfile][bundle-group-pattern] weighing in at 265 gem dependencies.  We'll use it for this example:

    ∴ bundle exec rails console
    Welcome to RAILS. You are using ruby 1.9.3p392 (2013-02-22 revision 39386) [x86_64-darwin12.2.1]. Have fun ;)
    Loading development environment (Rails 3.2.13)
    [1] pry(main)> a = GemBench.check({verbose: true})
    [GemBench] Will search for gems in ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-p392@global/gems", "/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems"]
    [GemBench] Will check Gemfile at /Users/pboling/Documents/RubyMineProjects/simple/Gemfile.
    [GemBench] Detected 265 loaded gems
      (excluding the 2 GemBench is configured to skip)
    [GemBench] You might want to verify that activesupport v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/activesupport-3.2.12/lib/active_support/i18n_railtie.rb", 146]
    [GemBench] You might want to verify that sprockets v2.2.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sprockets-rails-1.0.0/lib/sprockets/rails/railtie.rb", 495]
    [GemBench] You might want to verify that actionpack v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/actionpack-3.2.12/lib/action_controller/railtie.rb", 248]
    [GemBench] You might want to verify that actionmailer v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/actionmailer-3.2.12/lib/action_mailer/railtie.rb", 133]
    [GemBench] You might want to verify that activerecord v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/activerecord-3.2.12/lib/active_record/railtie.rb", 409]
    [GemBench] You might want to verify that activerecord-postgres-array v0.0.9 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/activerecord-postgres-array-07c5291804a2/lib/activerecord-postgres-array.rb", 55]
    [GemBench] You might want to verify that activerecord-postgres-hstore v0.7.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/activerecord-postgres-hstore-0.7.5/lib/activerecord-postgres-hstore/railties.rb", 226]
    [GemBench] You might want to verify that activeresource v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/activeresource-3.2.12/lib/active_resource/railtie.rb", 83]
    [GemBench] You might want to verify that railties v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/railties-3.2.12/lib/rails/application/configuration.rb", 245]
    [GemBench] You might want to verify that acts-as-messageable v0.4.8 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/acts-as-messageable-0.4.8/lib/acts-as-messageable/railtie.rb", 110]
    [GemBench] You might want to verify that airbrake v3.1.10 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/airbrake-3.1.10/lib/airbrake/railtie.rb", 109]
    [GemBench] You might want to verify that asset_sync v0.5.4 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/asset_sync-0.5.4/lib/asset_sync/engine.rb", 34]
    [GemBench] You might want to verify that slim v1.3.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/slim-rails-1.1.0/lib/slim-rails.rb", 81]
    [GemBench] You might want to verify that sidekiq v2.10.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sidekiq-2.7.4/lib/sidekiq/rails.rb", 290]
    [GemBench] You might want to verify that aws-sdk v1.8.5 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/aws-sdk-1.8.3.1/lib/aws/rails.rb", 705]
    [GemBench] You might want to verify that better_errors v0.8.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/better_errors-0.6.0/lib/better_errors/rails.rb", 51]
    [GemBench] You might want to verify that sass v3.2.7 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sass-rails-3.2.6/lib/sass/rails/railtie.rb", 68]
    [GemBench] You might want to verify that bootstrap-sass v2.3.1.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/bootstrap-sass-2.3.0.1/lib/bootstrap-sass/engine.rb", 53]
    [GemBench] You might want to verify that haml v4.0.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/haml-4.0.0/lib/haml/railtie.rb", 232]
    [GemBench] You might want to verify that bullet v4.5.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/bullet-4.3.0/lib/bullet.rb", 683]
    [GemBench] You might want to verify that parallel v0.6.4 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/parallel_tests-0.10.0/lib/parallel_tests/railtie.rb", 67]
    [GemBench] You might want to verify that cells v3.8.8 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/cells-3.8.8/lib/cell/rails4_0_strategy.rb", 773]
    [GemBench] You might want to verify that coffee-rails v3.2.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/coffee-rails-3.2.2/lib/coffee/rails/engine.rb", 74]
    [GemBench] You might want to verify that compass v0.12.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/compass-rails-1.0.3/lib/compass-rails/railties/3_0.rb", 49]
    [GemBench] You might want to verify that compass-rails v1.0.3 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/compass-rails-1.0.3/lib/compass-rails/railties/3_0.rb", 49]
    [GemBench] You might want to verify that csv_pirate v5.0.7 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/csv_pirate-5.0.7/lib/csv_pirate/railtie.rb", 35]
    [GemBench] You might want to verify that devise v2.2.3 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/devise-2.2.3/lib/devise/rails.rb", 101]
    [GemBench] You might want to verify that devise_invitable v1.1.3 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/devise_invitable-5af50a925e0a/lib/devise_invitable/rails.rb", 42]
    [GemBench] You might want to verify that rails v3.2.13 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/rails_admin-05a029da6fab/lib/rails_admin/engine.rb", 373]
    [GemBench] You might want to verify that dismissible_helpers v0.1.5 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/dismissible_helpers-0.1.5/lib/dismissible_helpers/engine.rb", 44]
    [GemBench] You might want to verify that dotenv v0.6.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/dotenv-0.5.0/lib/dotenv/railtie.rb", 32]
    [GemBench] You might want to verify that dry_views v0.0.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/dry_views-0.0.2/lib/dry_views/railtie.rb", 138]
    [GemBench] You might want to verify that sass-rails v3.2.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sass-rails-3.2.6/lib/sass/rails/railtie.rb", 68]
    [GemBench] You might want to verify that font-awesome-sass-rails v3.0.2.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/font-awesome-sass-rails-3.0.2.2/lib/font-awesome-sass-rails/engine.rb", 89]
    [GemBench] You might want to verify that foundation-icons-sass-rails v2.0.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/foundation-icons-sass-rails-2.0.0/lib/foundation-icons-sass-rails/engine.rb", 95]
    [GemBench] You might want to verify that g v1.7.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/gem_bench-0.0.2/lib/gem_bench/team.rb", 2462]
    [GemBench] You might want to verify that geocoder v1.1.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/geocoder-1.1.6/lib/geocoder/railtie.rb", 90]
    [GemBench] You might want to verify that geokit v1.6.5 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/geokit-rails3-9988045e1c4b/lib/geokit-rails3/railtie.rb", 76]
    [GemBench] You might want to verify that geokit-rails3 v0.1.5 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/geokit-rails3-9988045e1c4b/lib/geokit-rails3/railtie.rb", 76]
    [GemBench] You might want to verify that pry v0.9.12 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/pry-rails-0.2.2/lib/pry-rails/railtie.rb", 53]
    [GemBench] You might want to verify that rspec v2.13.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/rspec-rails-2.12.2/lib/rspec-rails.rb", 50]
    [GemBench] You might want to verify that spork v1.0.0rc3 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/spork-rails-3.2.1/lib/spork/app_framework/rails.rb", 1267]
    [GemBench] You might want to verify that haml-rails v0.4 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/haml-rails-0.4/lib/haml-rails.rb", 81]
    [GemBench] You might want to verify that handlebars_assets v0.12.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/handlebars_assets-0.12.0/lib/handlebars_assets/engine.rb", 43]
    [GemBench] You might want to verify that hirefire-resource v0.0.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/hirefire-resource-0.0.2/lib/hirefire/railtie.rb", 55]
    [GemBench] You might want to verify that jquery-rails v2.2.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/jquery-rails-2.1.4/lib/jquery/rails/engine.rb", 50]
    [GemBench] You might want to verify that html5-rails v0.0.7 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/html5-rails-0.0.6/lib/html5/rails/engine.rb", 49]
    [GemBench] You might want to verify that jquery-ui-rails v3.0.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/jquery-ui-rails-3.0.1/lib/jquery/ui/rails/engine.rb", 66]
    [GemBench] You might want to verify that kaminari v0.14.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/kaminari-0.14.1/lib/kaminari/engine.rb", 44]
    [GemBench] You might want to verify that neography v1.0.9 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/neography-1.0.6/lib/neography/railtie.rb", 52]
    [GemBench] You might want to verify that neoid v0.1.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/neoid-0.1.2/lib/neoid/railtie.rb", 59]
    [GemBench] You might want to verify that nested_form v0.3.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/nested_form-0.3.1/lib/nested_form/engine.rb", 54]
    [GemBench] You might want to verify that newrelic_rpm v3.6.0.78 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/newrelic_rpm-3.5.5.540.dev/lib/newrelic_rpm.rb", 863]
    [GemBench] You might want to verify that parallel_tests v0.10.4 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/parallel_tests-0.10.0/lib/parallel_tests/railtie.rb", 67]
    [GemBench] You might want to verify that pg v0.15.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/pg_power-1.3.0/lib/pg_power/engine.rb", 43]
    [GemBench] You might want to verify that rspec-rails v2.13.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/rspec-rails-2.12.2/lib/rspec-rails.rb", 50]
    [GemBench] You might want to verify that pg_power v1.3.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/pg_power-1.3.0/lib/pg_power/engine.rb", 43]
    [GemBench] You might want to verify that pry-rails v0.2.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/pry-rails-0.2.2/lib/pry-rails/railtie.rb", 53]
    [GemBench] You might want to verify that quiet_assets v1.0.2 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/quiet_assets-1.0.2/lib/quiet_assets.rb", 38]
    [GemBench] You might want to verify that remotipart v1.0.5 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/remotipart-1.0.5/lib/remotipart/rails/engine.rb", 77]
    [GemBench] You might want to verify that rails_admin v0.4.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/rails_admin-05a029da6fab/lib/rails_admin/engine.rb", 373]
    [GemBench] You might want to verify that requirejs-rails v0.9.1.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/requirejs-rails-0.9.0/lib/requirejs/rails/engine.rb", 107]
    [GemBench] You might want to verify that rolify v3.2.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/rolify-3.2.0/lib/rolify/railtie.rb", 66]
    [GemBench] You might want to verify that rspec-cells v0.1.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/rspec-cells-47232afed355/lib/rspec-cells.rb", 50]
    [GemBench] You might want to verify that sanitize_email v1.0.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sanitize_email-1.0.6/lib/sanitize_email/engine.rb", 144]
    [GemBench] You might want to verify that simplecov v0.7.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/simplecov-0.7.1/lib/simplecov/railtie.rb", 37]
    [GemBench] You might want to verify that spork-rails v3.2.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/spork-rails-3.2.1/lib/spork/app_framework/rails.rb", 1267]
    [GemBench] You might want to verify that sprockets-rails v0.0.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/sprockets-rails-1.0.0/lib/sprockets/rails/railtie.rb", 495]
    [GemBench] You might want to verify that stackable_flash v0.0.7 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/stackable_flash-0.0.7/lib/stackable_flash/railtie.rb", 40]
    [GemBench] You might want to verify that state_machine v1.2.0 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/state_machine-1.1.2/lib/state_machine/initializers/rails.rb", 262]
    [GemBench] You might want to verify that teabag v0.4.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/bundler/gems/teabag-0d3fde2505b9/lib/teabag/engine.rb", 33]
    [GemBench] You might want to verify that turbo-sprockets-rails3 v0.3.6 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/turbo-sprockets-rails3-0.3.6/lib/turbo-sprockets/railtie.rb", 179]
    [GemBench] You might want to verify that turbolinks v1.1.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/turbolinks-0.6.1/lib/turbolinks.rb", 650]
    [GemBench] You might want to verify that zurb-foundation v4.1.1 really has a Rails::Railtie or Rails::Engine.  Check these files:
      ["/Users/pboling/.rvm/gems/ruby-1.9.3-p392@simple/gems/zurb-foundation-3.2.5/lib/foundation/engine.rb", 35]
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

If found 45 gems which are listed as primary dependencies in my `Gemfile` which I can add `require: false` to.

How much faster will my app boot loading 45 fewer gems?  A bit.

**Note:** Some of the gems in the list above should have been excluded.  They are now excluded as of `gem_bench` version 0.0.4.

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

## Legal

* MIT License
* Copyright (c) 2013 [Peter H. Boling](http://www.railsbling.com), and Acquaintable [http://acquaintable.com/]

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[bundle-group-pattern]: https://gist.github.com/pboling/4564780
