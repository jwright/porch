# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "porch/version"

Gem::Specification.new do |spec|
  spec.name          = "porch"
  spec.version       = Porch::VERSION
  spec.authors       = ["Jamie Wright"]
  spec.email         = ["jamie@brilliantfantastic.com"]

  spec.summary       = "A simple service layer pattern for plain old Ruby objects."
  spec.description   = %q{Porch allows you to move the code into a series of steps that execute simple methods on itself or within simple PORO objects.}
  spec.homepage      = "https://github.com/jwright/porch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-validation", "~> 0.10.4"

  spec.add_development_dependency "bundler", "~> 1.12.0"
  spec.add_development_dependency "rake", "~> 10.0.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
end
