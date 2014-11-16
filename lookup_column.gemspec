# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lookup_column/version'

Gem::Specification.new do |gem|
  gem.name          = "lookup_column"
  gem.version       = LookupColumn::VERSION
  gem.authors       = ["Mike Skeen"]
  gem.email         = ["skeen.mike@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "activesupport"
  gem.add_development_dependency "rspec", "~> 3.1"
  gem.add_development_dependency "rspec-nc"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-remote"
  gem.add_development_dependency "pry-nav"
end
