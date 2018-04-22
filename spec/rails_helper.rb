require 'spec_helper'
require 'rspec/rails'
require 'generator_spec'
require 'fileutils'

ENV['RAILS_ENV'] ||= 'test'
abort("The Rails environment is running in production mode!") if Rails.env.production?
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('../../lib/generators/**/*.rb')].each { |f| require f }

TMP_PATH = "#{Rails.root}/spec/tmp".freeze

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end