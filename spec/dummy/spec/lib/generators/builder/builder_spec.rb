require 'rails_helper'

RSpec.describe BuilderGenerator, type: :generator do
  include_examples :create_files,   'builder'
end