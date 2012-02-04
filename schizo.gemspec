# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "schizo/version"

Gem::Specification.new do |s|
  s.name        = "schizo"
  s.version     = Schizo::VERSION
  s.authors     = ["Christopher J. Bottaro"]
  s.email       = ["cjbottaro@alumni.cs.utexas.edu"]
  s.homepage    = ""
  s.summary     = %q{DCI (data, context and interaction) for Ruby/Rails/ActiveRecord}
  s.description = %q{Tries to alleviate some of the issues of using DCI with Ruby, Rails and/or ActiveRecord}

  s.rubyforge_project = "schizo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
  # s.add_runtime_dependency "rest-client"
end
