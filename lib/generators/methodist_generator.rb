class MethodistGenerator < Rails::Generators::NamedBase
  DEFAULT_PREFIX = 'app'.freeze

  class_option 'clean',  type: :boolean, desc: "Skip comments and annotations in files source", default: false
  class_option 'in-lib', type: :boolean, desc: "Create file in lib path, not in app", default: false

  private

  def filename_with_path(prefix: DEFAULT_PREFIX)
    prefix = 'lib' if options['in-lib'] && prefix != 'spec'
    prefix = 'spec/lib' if options['in-lib'] && prefix == 'spec'

    name_as_arr = name.split('/')
    path = name_as_arr.first(name_as_arr.size - 1).join('/')
    name = name_as_arr.last
    "#{prefix}/#{options['path']}/#{path}/#{name}"
  end
end