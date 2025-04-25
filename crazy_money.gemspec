# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "crazy_money"
  spec.version       = "1.4.2"
  spec.authors       = ["Cédric Félizard", "Craig Watson"]
  spec.email         = ["cedric@felizard.fr", "craig@cwatson.org"]
  spec.description   = 'Simple money wrapper'
  spec.summary       = 'Crazy Money'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "i18n", ">= 0.7"
  spec.add_runtime_dependency "currency_data", ">= 1.1.0"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
end
