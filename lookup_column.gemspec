# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lookup_column/version'

Gem::Specification.new do |gem|
  gem.name          = "lookup_column"
  gem.version       = LookupColumn::VERSION
  gem.authors       = ["Mike Skeen"]
  gem.email         = ["skeen.mike@gmail.com"]
  gem.description   = %q{Gem to conveniently handle lookup values in a model. Provides field getters/setters and option list for droplists in views.}
  gem.summary       = %q{Gem to conveniently handle lookup values in a model.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "activesupport"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.1"
  gem.add_development_dependency "rspec-nc"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-remote"
  gem.add_development_dependency "pry-nav"
  gem.add_development_dependency "coveralls"
end
