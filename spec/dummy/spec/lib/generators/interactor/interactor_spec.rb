require 'rails_helper'

RSpec.describe InteractorGenerator, type: :generator do
  include_examples :create_files, 'interactor', no_pattern_in_file_name: true
end