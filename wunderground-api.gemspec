# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wunderground-api/version'
#require 'wunderground-api/m'

Gem::Specification.new do |gem|
  gem.name          = "wunderground-api"
  gem.version       = Wunderground::Api::VERSION
  gem.authors       = ["Arnkorty Fu"]
  gem.email         = ["arnkory.fu@gmail.com"]
  gem.description   = %q{wunderground api}
  gem.summary       = %q{wunderground api}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
