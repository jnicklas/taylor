# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taylor/version'

Gem::Specification.new do |gem|
  gem.name          = "taylor"
  gem.version       = Taylor::VERSION
  gem.authors       = ["Jonas Nicklas"]
  gem.email         = ["jonas.nicklas@gmail.com"]
  gem.description   = %q{Generate valid models without any additional setup}
  gem.summary       = %q{Yet another factory replacement gem}
  gem.homepage      = "http://github.com/jnicklas/taylor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "activerecord", "~> 3.0"
  gem.add_development_dependency "rspec", "~> 2.0"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "pry"
end
