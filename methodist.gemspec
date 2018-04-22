$:.push File.expand_path('lib', __dir__)

require 'methodist/version'

Gem::Specification.new do |s|
  s.name        = 'methodist'
  s.version     = Methodist::VERSION
  s.authors     = ['Sergey Nesterov']
  s.email       = ['qnesterr@gmail.com']
  s.homepage    = 'https://github.com/QNester/methodist'
  s.summary     = 'Summary of Methodist.'
  s.description = 'Description of Methodist.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.2.0'
  s.add_dependency 'dry-validation', '~> 0.11.1'
  s.add_dependency 'dry-transaction', '~> 0.11.1'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'pry-rails'
end
