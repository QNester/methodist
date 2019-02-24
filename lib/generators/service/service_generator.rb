require_relative '../methodist_generator'

class ClientGenerator < MethodistGenerator
  desc 'Create service'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'services'.freeze
  TEMPLATE_FILE      = 'service.erb'.freeze
  TEMPLATE_SPEC_FILE = 'service_spec.erb'.freeze

  class_option 'path',  type: :string,  desc: "Parent module for a new service", default: PATTERN_FOLDER

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path}_service.rb"
    )
  end

  def generate_spec
    return unless rspec_used?
    template(
      TEMPLATE_SPEC_FILE,
      "#{filename_with_path(prefix: 'spec')}_service_spec.rb"
    )
  end
end

