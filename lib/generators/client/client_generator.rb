require_relative '../methodist_generator'

class ClientGenerator < MethodistGenerator
  desc 'Create client'
  source_root File.expand_path('templates', __dir__)

  PATTERN_FOLDER     = 'clients'.freeze
  TEMPLATE_FILE      = 'client.erb'.freeze
  TEMPLATE_SPEC_FILE = 'client_spec.erb'.freeze
  PARENT_CLASS       = 'Methodist::Client'.freeze

  class_option 'path',  type: :string,  desc: "Parent module for a new client", default: PATTERN_FOLDER
  class_option 'parent', type: :string, desc: "Parent class of generated class", default: PARENT_CLASS

  def generate
    template(
      TEMPLATE_FILE,
      "#{filename_with_path}_client.rb"
    )
  end

  def generate_spec
    return unless rspec_used?
    template(
      TEMPLATE_SPEC_FILE,
      "#{filename_with_path(prefix: 'spec')}_client_spec.rb"
    )
  end
end

