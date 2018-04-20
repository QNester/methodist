require 'test_helper'
require 'generators/command/command_generator'

class CommandGeneratorTest < Rails::Generators::TestCase
  tests CommandGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
