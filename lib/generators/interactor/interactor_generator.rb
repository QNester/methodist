require_relative '../methodist_generator'

class InteractorGenerator < MethodistGenerator
  desc 'Create interactor'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'interactors'.freeze
  TEMPLATE_FILE      = 'interactor.erb'.freeze
  TEMPLATE_SPEC_FILE = 'interactor_spec.erb'.freeze

  class_option 'skip-validations', type: :boolean, desc: "Skip validations parts in files source", default: false
  class_option 'path',  type: :string,  desc: "Parent module for new interactor", default: PATTERN_FOLDER

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path}.rb"
    )
  end

  def generate_spec
    template(
      TEMPLATE_SPEC_FILE,
      "#{filename_with_path(prefix: 'spec')}_spec.rb"
    )
  end
end

