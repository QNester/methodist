require 'rails_helper'

RSpec.describe ClientGenerator, type: :generator do
  include_examples :create_files,   'client'
end