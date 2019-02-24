require "dry/transaction"
require "dry/validation"

##
# == Methodist::Interactor
# Base class for a Methodist interactor.
#
# Methodist::Interactor dependency from dry-rb transactions and dry-rb validations
#
#
class Methodist::Interactor < Methodist::Pattern
  include Dry::Transaction

  attr_accessor :validation_result

  class << self
    attr_reader :input_schema
    ##
    # Method set Dry::Validation schema for an interactor.
    #
    # Receive block for generating Dry::Validation schema
    # result.
    #
    #   class InteractorClass < Methodist::Interactor
    #     schema do
    #       required(:name).value(:str?)
    #     end
    #
    #     step :validate
    #   end
    #
    #   InteractorClass.new.call(name: nil) #=> Failure(ValidationError)
    #
    #
    # ==== See
    # http://dry-rb.org/gems/dry-validation/
    #
    # https://github.com/dry-rb/dry-transaction
    ##
    def schema(&block)
      if block_given?
        @input_schema = Dry::Validation.Schema(&block)
      else
        raise SchemaDefinitionError, 'You must pass block to `schema`'
      end
    end
  end

  ##
  # Method for validation input of interactor parameters.
  #
  # ==== Parameters
  # * +input+ [Hash] - parameters for interactor
  #
  # ==== Example
  #
  #   # app/interactors/interactor_class.rb
  #   class InteractorClass < Methodist::Interactor
  #     schema do
  #       required(:name).value(:str?)
  #     end
  #
  #     step :validate
  #   end
  #
  #   # your controller action
  #   def create
  #     result = InteractorClass.new.call(name: nil) #=> Failure(ValidationError)
  #     raise InteractorError, result.value if result.failure?
  #   end
  #
  # ==== Return
  # * +Dry::Monads::Result::Success+ - success result of interactor step
  # * +Dry::Monads::Result::Failure+  - failure result of interactor step
  #
  # ==== Raise
  # * +SchemaDefinitionError+  - raise if method was called without a schema definition
  #
  #
  # ==== Attention
  # You can redefine failure_validation_value for a custom
  # value returning in case of validation Failure
  ##
  def validate(input)
    input = {} unless input
    raise InputClassError, 'If you want to use custom #validate, you have to pass a hash to an interactor' unless input.is_a?(Hash)
    raise SchemaDefinitionError, 'You have to define a schema with #schema method' unless input_schema
    @validation_result = input_schema.call(input)
    return Success(validation_result.to_h) if validation_result.success?
    Failure(failure_validation_value)
  end

  private

  def input_schema
    @input_schema ||= self.class.input_schema rescue nil
  end

  ##
  # Method for validation input of interactor parameters.
  ##
  def failure_validation_value
    field = validation_result.errors.keys.first
    {
      error: 'ValidationError',
      field: field,
      reason: "#{field}: #{validation_result.errors[field].first}"
    }
  end


  class SchemaDefinitionError < StandardError; end
  class InputClassError < StandardError; end
end
