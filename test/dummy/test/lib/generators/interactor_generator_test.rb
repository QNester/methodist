require 'test_helper'
require 'generators/interactor/interactor_generator'

class InteractorGeneratorTest < Rails::Generators::TestCase
  tests InteractorGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
