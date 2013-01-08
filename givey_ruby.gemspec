# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "givey_ruby/version"

Gem::Specification.new do |s|
  s.name        = "givey_ruby"
  s.version     = GiveyRuby::VERSION
  s.authors     = ["nickflux"]
  s.email       = ["nick@givey.com"]
  s.homepage    = "http://github.com/giveydev/givey_ruby"
  s.summary     = %q{Ruby API for accessing Givey API}
  s.description = %q{General, controller and model methods for accessing Givey API from Ruby}

  s.rubyforge_project = "givey_ruby"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "log_buddy"
  s.add_development_dependency "actionpack"

  s.add_dependency 'httparty'
  s.add_dependency 'oauth2'

end
