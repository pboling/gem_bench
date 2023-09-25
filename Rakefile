require "bundler/gem_tasks"

require "yard-junk/rake"

YardJunk::Rake.define_task

require "yard"

YARD::Rake::YardocTask.new(:yard)

require "rspec/core/rake_task"

require "rubocop/lts"

Rubocop::Lts.install_tasks

RSpec::Core::RakeTask.new(:spec)
desc "alias test task to spec"
task test: :spec

task default: [:yard, :rubocop_gradual, :spec]
