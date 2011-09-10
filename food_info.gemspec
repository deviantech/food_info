# -*- encoding: utf-8 -*-
require File.expand_path('../lib/food_info/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kali Donovan"]
  gem.email         = ["kali@deviantech.com"]
  gem.description   = %q{Ruby interface to FatSecret's REST API.  Only API functions relating to general food research have been implemented.}
  gem.summary       = %q{Look up nutritional information for various foods}
  gem.homepage      = ""

  gem.add_dependency('httparty', '>= 0.7.8')
  gem.add_dependency('hashie', '>= 2.0')

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "food_info"
  gem.require_paths = ["lib"]
  gem.version       = FoodInfo::VERSION
end
