require_relative '../methodist_generator'

class BuilderGenerator < MethodistGenerator
  desc 'Create a builder'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'builders'.freeze
  TEMPLATE_FILE      = 'builder.erb'.freeze
  TEMPLATE_SPEC_FILE = 'builder_spec.erb'.freeze
  PARENT_CLASS       = 'Methodist::Builder'.freeze

  class_option 'path',  type: :string,  desc: "Parent module for a new builder", default: PATTERN_FOLDER
  class_option 'parent', type: :string, desc: "Parent class of generated class", default: PARENT_CLASS

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

