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
  NEW_DRY_VALIDATION_V = '1.0.0'.freeze

  attr_accessor :validation_result

  class << self
    attr_reader :input_schema, :contract_class
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
        @input_schema = dry_schema(&block)
      else
        raise SchemaDefinitionError, 'You must pass block to `schema`'
      end
    end

    ##
    # ATTENTION: require dry-validation >= 1.0.0
    # Method set Dry::Validation::Contract contract for an interactor.
    #
    # Receive block for generating Dry::Validation:Contract
    # result.
    #
    #   class InteractorClass < Methodist::Interactor
    #     contract do
    #       params do
    #         required(:name).value(:str?)
    #       end
    #
    #       rule(:name) do
    #          ...
    #       end
    #     end
    #
    #     step :validate
    #   end
    #
    #   InteractorClass.new.call(name: nil) #=> Failure(ValidationError)
    #
    # Or you can pass contract class:
    #   class InteractorClass < Methodist::Interactor
    #     contract contract_class: MyContract
    #
    #     step :validate
    #   end
    #
    # ==== See
    # http://dry-rb.org/gems/dry-validation/
    #
    # https://github.com/dry-rb/dry-transaction
    ##
    def contract(contract_class: nil, &block)
      unless new_dry_validation?
        raise DryValidationVersionError,
          "Your depended dry-validation gem version must be gteq #{NEW_DRY_VALIDATION_V}"
      end

      unless block_given? || contract_class
        raise ContractDefinitionError, 'You must pass block or contract_class to `contract`'
      end

      @contract_class = contract_class
      @contract_class ||= Class.new(Dry::Validation::Contract, &block)
    end

    private

    def dry_schema(&block)
      return Dry::Schema.Params(&block) if new_dry_validation?
      Dry::Validation.Schema(&block)
    end

    def new_dry_validation?
      Gem.loaded_specs['dry-validation'].version.to_s >= NEW_DRY_VALIDATION_V
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

    validator = contract_class ? contract_class : input_schema
    raise ValidatorDefinitionError, 'you must define schema via #schema OR define contract via #contract' unless validator

    @validation_result = validator.call(input)
    return Success(validation_result.to_h) if validation_result.success?
    Failure(failure_validation_value)
  end

  private

  def input_schema
    @input_schema ||= self.class.input_schema rescue nil
  end

  def contract_class
    @contract_class ||= self.class.contract_class.new rescue nil
  end

  ##
  # Method for validation input of interactor parameters.
  ##
  def failure_validation_value
    field = validation_result.errors.to_hash.keys.first
    {
      error: 'ValidationError',
      field: field,
      reason: "#{field}: #{validation_result.errors[field].first}"
    }
  end

  class ValidatorDefinitionError < StandardError; end
  class InputClassError < StandardError; end
  class DryValidationVersionError < StandardError; end
  class ContractDefinitionError < StandardError; end
  class SchemaDefinitionError < StandardError; end
end
