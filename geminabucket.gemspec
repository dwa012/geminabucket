# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geminabucket/version'

Gem::Specification.new do |spec|
  spec.name          = "geminabucket"
  spec.version       = Geminabucket::VERSION
  spec.authors       = ["Alexis Midon"]
  spec.email         = ["alexismidon@gmail.com"]
  spec.summary       = %q{Host your gems in a *private* S3 bucket}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", ["~> 1.8.3"]
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
