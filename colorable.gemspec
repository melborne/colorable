# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'colorable/version'

Gem::Specification.new do |gem|
  gem.name          = "colorable"
  gem.version       = Colorable::VERSION
  gem.authors       = ["kyoendo"]
  gem.email         = ["postagie@gmail.com"]
  gem.description   = %q{A simple color handler which provide a conversion between colorname, RGB, HSB and HEX}
  gem.summary       = %q{A simple color handler which provide a conversion between colorname, RGB, HSB and HEX}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
