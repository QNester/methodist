require_relative '../methodist_generator'

class BuilderGenerator < MethodistGenerator
  desc 'Create a builder'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'builders'.freeze
  TEMPLATE_FILE      = 'builder.erb'.freeze
  TEMPLATE_SPEC_FILE = 'builder_spec.erb'.freeze

  class_option 'path',  type: :string,  desc: "Parent module for a new builder", default: PATTERN_FOLDER

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path}_builder.rb"
    )
  end

  def generate_spec
    return unless rspec_used?
    template(
      TEMPLATE_SPEC_FILE,
      "#{filename_with_path(prefix: 'spec')}_builder_spec.rb"
    )
  end
end

