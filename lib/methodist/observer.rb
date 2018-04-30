##
# == Methodist::Observer
# Base class for methodist observers
#
#
class Methodist::Observer < Methodist::Pattern
  CONST_EXECUTION_BLOCK = 'EXEC_BLOCK'.freeze

  class << self
    ##
    # Subscribe instance method of klass for observe
    #
    # ==== Parameters
    # * +klass+ [Class] - Owner of method for observe
    # * +method_name+ [String/Symbol] - Method name for observe
    #
    # ===== Options
    # * +skip_if+ [Proc] - Skip trigerred execution if condition true
    #
    # ==== Yield
    # main_block - execution block. If this block was passed,
    # `#execute` block will be ignore
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
        result # return result of original method
      end

      klass.send(:define_method, method_observe, observer_method_proc)

      klass.send(:alias_method, method_name, method_observe) # redefine original method
      add_observed(klass, method_name)
      true
    end

    ##
    # Stop observe instance method of klass for observe
    #
    # ==== Parameters
    # * +klass+ [Class] - Klass owner of observed method
    # * +method_name+ [String/Symbol] - Name of observed method
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
    # Execute block passed in #execute
    # Parameters *klass* and *method_name* passing to block call
    #
    # ==== Parameters
    # * +klass+ [Class] - Klass owner of observed method
    # * +method+ [Class] - Name of observed method
    #
    # ===== Raise
    # +ExecuteBlockWasNotDefined+ - when block was not passing to execute in observer class
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