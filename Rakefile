require "bundler/gem_tasks"

require 'active_record'
require 'yaml'
require 'logger'
require 'rspec/core/rake_task'

ENV["RAILS_ENV"] ||= "test"

task :default => :spec

desc "Run specs (default)"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = "--color"
end
