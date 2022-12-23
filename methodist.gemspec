$:.push File.expand_path('lib', __dir__)

require 'methodist/version'

Gem::Specification.new do |s|
  s.name        = 'methodist'
  s.version     = Methodist::VERSION
  s.authors     = ['Sergey Nesterov']
  s.email       = ['qnesterr@gmail.com']
  s.homepage    = 'https://github.com/QNester/methodist'
  s.summary     = 'Gem for Ruby on Rails created to stop chaos in your buisness logic.'
  s.description = 'Methodist - a gem for Ruby on Rails created to stop chaos in your business logic. ' +
    'This gem adds generators to your rails application using some patterns: interactor, ' +
      "builder, observer and client. Just use `rails g <pattern> <new_class_name>`. \n" +
    'Docs: https://github.com/QNester/methodist/wiki'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.2'
  s.add_dependency 'dry-validation', '>= 0.13'
  s.add_dependency 'dry-transaction', '~> 0.13'
  s.add_dependency 'rbs', '~> 2.8.2'

  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'rspec-rails', '~> 3.7'
  s.add_development_dependency 'generator_spec', '~> 0.9'
  s.add_development_dependency 'ffaker', '~> 2.9'
end
