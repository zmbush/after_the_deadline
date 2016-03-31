# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'after_the_deadline/version'

Gem::Specification.new do |spec|
  spec.name          = 'after_the_deadline'
  spec.version       = AfterTheDeadline::VERSION.dup
  spec.authors       = ['Michael J. Sepcot']
  spec.email         = ['developer@sepcot.com']
  spec.description   = %q{A ruby library for working with the After The Deadline service.}
  spec.summary       = %q{A ruby library for working with the After The Deadline service.}
  spec.homepage      = 'https://github.com/msepcot/after_the_deadline'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.required_ruby_version = '>= 2.0'
  spec.add_dependency 'crack'
end
