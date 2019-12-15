require_relative '../methodist_generator'

class InteractorGenerator < MethodistGenerator
  desc 'Create an interactor'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'interactors'.freeze
  TEMPLATE_FILE      = 'interactor.erb'.freeze
  TEMPLATE_SPEC_FILE = 'interactor_spec.erb'.freeze
  PARENT_CLASS       = 'Methodist::Interactor'.freeze

  class_option 'skip-validations', type: :boolean, desc: "Skip validations in generated files", default: false
  class_option 'path',  type: :string,  desc: "Parent module for a new interactor", default: PATTERN_FOLDER
  class_option 'parent', type: :string, desc: "Parent class of generated class", default: PARENT_CLASS

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path}.rb"
    )
  end

  def generate_spec
    return unless rspec_used?
    template(
      TEMPLATE_SPEC_FILE,
      "#{filename_with_path(prefix: 'spec')}_spec.rb"
    )
  end
end

