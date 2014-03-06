# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/automatic/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-automatic"
  spec.version       = Omniauth::Automatic::VERSION
  spec.authors       = ["Nate Klaiber"]
  spec.email         = ["nate@theklaibers.com"]
  spec.summary       = %q{ Strategy for Omniauth rubygem. }
  spec.description   = %q{ OAuth2 Strategy for Omniauth and Automatic }
  spec.homepage      = "https://github.com/nateklaiber/omniauth-automatic"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
