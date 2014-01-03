require "bundler/gem_tasks"

require 'active_record'
require 'yaml'
require 'logger'
require 'rspec/core/rake_task'

ENV["RAILS_ENV"] ||= "test"

task :default => :spec

desc "Run specs (default)"
RSpec::Core::RakeTask.new(:spec => :migrate) do |t|
  t.rspec_opts = "--color -f d"
end

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  FileUtils.mkdir_p("tmp")
  ActiveRecord::Base.establish_connection(YAML::load(File.open('db/database.yml')))
  ActiveRecord::Base.logger = Logger.new(File.open('tmp/database.log', 'a'))
end

