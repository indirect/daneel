# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daneel/version'

Gem::Specification.new do |gem|
  gem.name          = "daneel"
  gem.version       = Daneel::VERSION
  gem.summary       = %q{A 19,230-year-old robot}
  gem.description   = %q{Daneel is a chatbot inspired by the late, lamented Wesabot. And also Hubot.}
  gem.authors       = ["André Arko"]
  gem.email         = ["andre@arko.net"]
  gem.homepage      = "http://github.com/indirect/daneel"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sparks", "~> 0.4"
  gem.add_dependency "sinatra", "~> 1.4.0"
  gem.add_dependency "puma", "~> 1.6.3"

  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "bundler", "~> 1.2"
end
