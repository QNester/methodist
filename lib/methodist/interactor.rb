require "dry/transaction"
require "dry/validation"

##
# == Methodist::Interactor
# Base class for methodist interactor.
#
# Methodist::Interactor dependency from dry-rb transactions and dry-rb validations
#
#
class Methodist::Interactor < Methodist::Pattern
  include Dry::Transaction

  attr_accessor :validation_result

  SCHEMA_CONST = 'SCHEMA'

  class << self
    ##
    # Method set Dry::Validation schema for interactor.
    #
    # Receive block for generate Dry::Validation schema
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
        const_set SCHEMA_CONST, Dry::Validation.Schema(&block)
      else
        raise SchemaDefinitionError, 'You must pass block to `schema`'
      end
    end
  end

  ##
  # Method for validate input to interactor parameters.
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
  # * +SchemaDefinitionError+  - raise if method was calling without schema definition
  #
  #
  # ==== Attention
  # You can redefine left_validation_value for custom
  # validation value returning in Failure
  ##
  def validate(input)
    schema = self.class.const_get SCHEMA_CONST rescue nil
    raise SchemaDefinitionError, 'You must define schema with #schema method' unless schema
    @validation_result = schema.call(input)
    return Success(validation_result.to_h) if validation_result.success?
    Failure(left_validation_value)
  end

  private

  ##
  # Method for validate input to interactor parameters.
  ##
  def left_validation_value
    field = validation_result.errors.keys.first
    {
      error: 'ValidationError',
      field: field,
      reason: "#{field}: #{validation_result.errors[field].first}"
    }
  end


  class SchemaDefinitionError < StandardError; end
end