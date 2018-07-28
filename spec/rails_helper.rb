require 'spec_helper'
require 'rspec/rails'
require 'generator_spec'
require 'fileutils'

ENV['RAILS_ENV'] ||= 'test'
abort("The Rails environment is running in production mode!") if Rails.env.production?
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('../../lib/generators/**/*.rb')].each { |f| require f }

TMP_PATH = "#{Rails.root}/spec/tmp".freeze
MODULE_NAME = %w[anything modulname in my life i dont wanna die and doesnt help me nothing].sample
KLASS_NAME = %w[jhonny field summa kiddo verify kilo pender finder guava verslio create delete].sample

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end