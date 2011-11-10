# -*- encoding: utf-8 -*-
require File.expand_path('../lib/daneel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andre Arko"]
  gem.email         = ["andre@arko.net"]
  gem.description   = %q{A 19,230-year-old Campfire bot}
  gem.summary       = %q{A library and rack app to bot up your Campfire rooms}
  gem.homepage      = "http://github.com/indirect/daneel"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "daneel"
  gem.require_paths = ["lib"]
  gem.version       = Daneel::VERSION

  gem.add_dependency "firering", "~> 1.2.0"
  gem.add_dependency "activerecord", "~> 3.1.0"
end
