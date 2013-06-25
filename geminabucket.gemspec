# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geminabucket/version'

Gem::Specification.new do |spec|
  spec.name          = "geminabucket"
  spec.version       = Geminabucket::VERSION
  spec.authors       = ["Alexis Midon"]
  spec.email         = ["alexismidon@gmail.com"]
  spec.summary       = %q{A Rubygems plugin to access gems stored in S3 buckets}
  spec.description   = <<-TEXT
Why run a gem server to host your gems when you have Amazon S3?
Geminbucket is Rubygem plugin that lets your use S3 buckets as sources.
S3 buckets are accessed with the official aws-sdk gem.
  TEXT
  spec.homepage      = ""
  spec.license       = "Apache 2.0"
  spec.post_install_message = <<-TEXT
********************************************************************************

           Thanks for installing Geminabucket! You can now run:

  gem sources --add s3://my_gem_bucket/

********************************************************************************
  TEXT

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extra_rdoc_files = ['README.md', 'Changelog.md']

  spec.add_dependency "aws-sdk", ["~> 1.8.3"]
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
