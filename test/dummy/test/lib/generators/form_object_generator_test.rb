require 'test_helper'
require 'generators/form_object/form_object_generator'

class FormObjectGeneratorTest < Rails::Generators::TestCase
  tests FormObjectGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
