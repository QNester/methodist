require 'rails_helper'

RSpec.describe ServiceGenerator, type: :generator do
  include_examples :create_files,   'service'
end