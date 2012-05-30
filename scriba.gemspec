$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scriba/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scriba"
  s.version     = Scriba::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Scriba."
  s.description = "TODO: Description of Scriba."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "mongoid", "~> 2.4.10"
  s.add_dependency "haml"
  s.add_dependency "will_paginate"
  s.add_dependency "will_paginate_mongoid"

  # s.add_dependency "jquery-rails"
end
