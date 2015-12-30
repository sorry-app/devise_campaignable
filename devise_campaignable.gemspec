# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise_campaignable/version'

Gem::Specification.new do |spec|
  spec.name          = "devise_campaignable"
  spec.version       = DeviseCampaignable::VERSION
  spec.authors       = ["Robert Rawlins"]
  spec.email         = ["robert@weboffins.com"]
  spec.summary       = "A multi-vendor mailing list extension for Devise. Have your users automatically added to a mailing list."
  spec.description   = "Inspired by the now slightly out of date devise_mailchimp this gem works in a similar fashion but with a focus on multi-vendor support, rather than exclusively MailChimp."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "devise", ">= 3.2.0"
  spec.add_runtime_dependency "gibbon", "~> 1.1"
end
