require_relative '../methodist_generator'

class ObserverGenerator < MethodistGenerator
  desc 'Create an observer'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER = 'observers'.freeze
  TEMPLATE_FILE = 'observer.erb'.freeze
  TEMPLATE_SPEC_FILE = 'observer_spec.erb'.freeze
  DEFAULT_PREFIX = 'config/initializers'.freeze
  PARENT_CLASS   = 'Methodist::Observer'.freeze

  class_option 'skip-validations', type: :boolean, desc: "Skip validations in generated files", default: false
  class_option 'path',  type: :string,  desc: "Parent module for new a interactor", default: PATTERN_FOLDER
  class_option 'parent', type: :string, desc: "Parent class of generated class", default: PARENT_CLASS

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path(prefix: DEFAULT_PREFIX)}_observer.rb"
    )
  end
end

