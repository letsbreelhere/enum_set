# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enum_set/version'

Gem::Specification.new do |spec|
  spec.name          = "enum_set"
  spec.version       = EnumSet::VERSION
  spec.authors       = ["Bree Stanwyck"]
  spec.email         = ["bree@bignerdranch.com"]
  spec.summary       = %q{Allows using a single integer column as a set of booleans, with bitfield-style storage.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
