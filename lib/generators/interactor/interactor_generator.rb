class InteractorGenerator < Rails::Generators::NamedBase
  desc 'Create interactor'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER = 'interactors'.freeze
  TEMPLATE_FILE = 'interactor.erb'.freeze
  TEMPLATE_SPEC_FILE = 'interactor_spec.erb'.freeze

  class_option 'skip-main-dir',    type: :boolean, desc: "Skip `#{PATTERN_FOLDER}` folder for created files", default: false
  class_option 'skip-validations', type: :boolean, desc: "Skip validations parts in files source",            default: false
  class_option 'clean',            type: :boolean, desc: "Skip comments and annotations in files source",     default: false

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

  private

  def filename_with_path(prefix: 'app')
    name_as_arr = name.split('/')
    path = name_as_arr.first(name_as_arr.size - 1).join('/')
    name = name_as_arr.last
    return "#{prefix}/#{PATTERN_FOLDER}/#{path}/#{name}" unless options['skip-main-dir']
    "#{prefix}/#{path}/#{name}"
  end
end

