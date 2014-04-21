# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rate_limiter/version'

Gem::Specification.new do |spec|
  spec.name          = "rate_limiter"
  spec.version       = RateLimiter::VERSION
  spec.authors       = ["Ahmed Al Hafoudh"]
  spec.email         = ["alhafoudh@freevision.sk"]
  spec.summary       = %q{This library allows you to rate-limit resource access.}
  spec.description   = %q{This library allows you to rate-limit resource access using counters implemented in Redis.}
  spec.homepage      = "https://github.com/alhafoudh/rate_limiter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", ">= 2.2.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
