require_relative '../methodist_generator'

class ObserverGenerator < MethodistGenerator
  desc 'Create observer'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER = 'observers'.freeze
  TEMPLATE_FILE = 'observer.erb'.freeze
  TEMPLATE_SPEC_FILE = 'observer_spec.erb'.freeze
  DEFAULT_PREFIX = 'config/initializers'.freeze

  class_option 'skip-validations', type: :boolean, desc: "Skip validations parts in files source", default: false
  class_option 'path',  type: :string,  desc: "Parent module for new interactor", default: PATTERN_FOLDER

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path(prefix: DEFAULT_PREFIX)}_observer.rb"
    )
  end
end

