require "dry/transaction"
require "dry/validation"

class Methodist::Interactor < Methodist::Pattern
  include Dry::Transaction

  attr_accessor :validation_result

  SCHEMA_CONST = 'SCHEMA'

  class << self
    def set_schema(&block)
      if block_given?
        const_set SCHEMA_CONST, Dry::Validation.Schema(&block)
      else
        raise SchemaDefinitionError, 'You must pass block to set_schema'
      end
    end
  end

  def validate(input)
    schema = self.class.const_get SCHEMA_CONST rescue nil
    raise SchemaDefinitionError, 'You must define schema with #set_schema method' unless schema
    @validation_result = schema.call(input)
    return Right(validation_result.to_h) if validation_result.success?
    Left(left_validation_value)
  end

  private

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