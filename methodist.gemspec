$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "methodist/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "methodist"
  s.version     = Methodist::VERSION
  s.authors     = ["Sergey Nesterov"]
  s.email       = ["qnesterr@gmail.com"]
  s.homepage    = "https://github.com/QNester/methodist"
  s.summary     = "Methodist summary"
  s.description = "Description of Methodist."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency 'dry-validation', '~> 0.11.1'
  s.add_dependency 'dry-transaction', '~> 0.11.1'

  s.add_development_dependency "sqlite3", '~> 1.3.13'

end
