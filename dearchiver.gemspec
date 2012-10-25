# -*- encoding: utf-8 -*-
require File.expand_path('../lib/dearchiver/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["eljuanchosf"]
  gem.email         = ["juanpgenovese@gmail.com"]
  gem.description   = %q{A simple Ruby Gem to decompress and check the CRC of compressed files.}
  gem.summary       = %q{A simple Ruby Gem to decompress and check the CRC of compressed files.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dearchiver"
  gem.require_paths = ["lib"]
  gem.version       = Dearchiver::VERSION
end
