$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "airdata/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "airdata"
  s.version     = Airdata::VERSION
  s.authors     = ["Svilen Vassilev"]
  s.email       = ["svilen@rubystudio.net"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Airdata."
  s.description = "TODO: Description of Airdata."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.7"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
