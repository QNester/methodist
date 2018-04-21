class MethodistGenerator < Rails::Generators::NamedBase
  DEFAULT_PREFIX = 'app'.freeze

  class_option 'clean', type: :boolean, desc: "Skip comments and annotations in files source", default: false

  private

  def filename_with_path(prefix: DEFAULT_PREFIX)
    name_as_arr = name.split('/')
    path = name_as_arr.first(name_as_arr.size - 1).join('/')
    name = name_as_arr.last
    "#{prefix}/#{options['path']}/#{path}/#{name}"
  end
end