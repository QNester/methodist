##
# == Methodist::Observer
# Base class for Methodist observers
#
#
class Methodist::Observer < Methodist::Pattern
  CONST_EXECUTION_BLOCK = 'EXEC_BLOCK'.freeze

  class << self
    ##
    # Subscribe to the instance method of the klass to observe
    #
    # ==== Parameters
    # * +klass+ [Class] - The owner of the method for observation
    # * +method_name+ [String/Symbol] - Observation method name
    #
    # ===== Options
    # * +skip_if+ [Proc] - Skip triggered execution if condition is true
    #
    # ==== Yield
    # main_block - execution block. If this block was passed,
    # `#execute` block will be ignored
    #
    ##
    def observe(klass, method_name, skip_if: nil, &main_block)
      method_name = method_name.to_sym
      original_method = klass.instance_method(method_name)
      method_observe = observer_method(method_name)
      method_dump = method_dump(method_name)
      me = self

      return false if method_defined?(klass, method_dump)

      klass.send(:alias_method, method_dump, method_name) # dump method

      observer_method_proc = -> (*args, &block) do
        result = original_method.bind(self).call(*args, &block)
        unless skip_if.nil?
          return if skip_if.call(result)
        end
        if block_given?
          main_block.call(klass, method_name)
        else
          me.trigger!(klass, method_name)
        end
        result # return the result of the original method
      end

      klass.send(:define_method, method_observe, observer_method_proc)

      klass.send(:alias_method, method_name, method_observe) # redefine the original method
      add_observed(klass, method_name)
      true
    end

    ##
    # Stop observation instance method of klass for observe
    #
    # ==== Parameters
    # * +klass+ [Class] - Klass owner of the observed method
    # * +method_name+ [String/Symbol] - Name of the observed method
    ##
    def stop_observe(klass, method_name)
      method_observe = observer_method(method_name)
      method_dump = method_dump(method_name)
      return false unless method_defined?(klass, method_observe) && method_defined?(klass, method_dump)

      klass.send(:alias_method, method_name, method_dump) # restore dumped method
      klass.send(:remove_method, method_observe) # remove observed method
      klass.send(:remove_method, method_dump) # remove dump method
      remove_from_observed(klass, method_name)
      true
    end

    ##
    # The executable block is passed to #execute
    # Parameters *klass* and *method_name* are passed to block call
    #
    # ==== Parameters
    # * +klass+ [Class] - Klass owner of the observed method
    # * +method+ [Class] - Name of the observed method
    #
    # ===== Raise
    # +ExecuteBlockWasNotDefined+ - when no block was passed to the execute method in the observer class
    ##
    def trigger!(klass, method_name)
      block = const_get(CONST_EXECUTION_BLOCK) rescue nil
      raise ExecuteBlockWasNotDefined, "You must define execute block in your #{self.name}" unless block
      block.call(klass, method_name)
    end

    ##
    # Method for passing execution block for execution after observed method
    ##
    def execute(&block)
      const_set(CONST_EXECUTION_BLOCK, block)
    end

    def observed_methods
      @observed_method ||= []
    end

    private

    def observer_method(method)
      "#{method}_observer"
    end

    def method_dump(method)
      "#{method}_dump"
    end

    def klass_with_method(klass, method)
      "#{klass}##{method}"
    end

    def method_defined?(klass, method)
      klass.instance_methods(false).include?(method.to_sym)
    end

    def add_observed(klass, method_name)
      observed_methods << klass_with_method(klass, method_name)
    end

    def remove_from_observed(klass, method_name)
      observed_methods.delete(klass_with_method(klass, method_name))
    end

    class ExecuteBlockWasNotDefined < StandardError; end
  end
end
