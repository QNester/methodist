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
    # * +skip_if+ [Proc] - Skip triggered execution if condition is true (default nil)
    # * +instance_method+ [Boolean] - True if observer klass instance method, false if observer klass method (default true)
    #
    # ==== Yield
    # main_block - execution block. If this block was passed,
    # `#execute` block will be ignored
    #
    ##
    def observe(klass, method_name, skip_if: nil, instance_method: true, &main_block)
      method_names = generate_method_names(method_name)

      # Make dump original method.
      if instance_method
        alias_instance_method(klass, method_names[:dump], method_names[:name])
      else
        alias_class_method(klass, method_names[:dump], method_names[:name])
      end

      observe_method!(klass, method_names, skip_if: skip_if, instance_method: instance_method, &main_block)
    end

    ##
    # Subscribe to the class method of the klass to observe
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
    def observe_class_method(klass, method_name, skip_if: nil, &main_block)
      observe(klass, method_name, skip_if: skip_if, instance_method: false, &main_block)
    end

    ##
    # Stop observation instance method of klass for observe
    #
    # ==== Parameters
    # * +klass+ [Class] - Klass owner of the observed method
    # * +method_name+ [String/Symbol] - Name of the observed method
    ##
    def stop_observe(klass, method_name, instance_method: true)
      method_names = generate_method_names(method_name)

      if instance_method
        unless method_defined?(klass, method_names[:observed]) && method_defined?(klass, method_names[:dump])
          return false
        end

        klass.send(:alias_method, method_names[:name], method_names[:dump]) # restore dumped instance method
        klass.send(:remove_method, method_names[:observed]) # remove observed instance method
        klass.send(:remove_method, method_names[:dump]) # remove dump instance method
      else
        unless klass_method_defined?(klass, method_names[:observed]) && klass_method_defined?(klass, method_names[:dump])
          return false
        end

        klass.singleton_class.send(:alias_method, method_names[:name], method_names[:dump]) # restore dumped class method
        klass.singleton_class.send(:remove_method, method_names[:observed]) # remove observed class method
        klass.singleton_class.send(:remove_method, method_names[:dump]) # remove dump class method
      end

      remove_from_observed(klass, method_names[:name], instance_method: instance_method)
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
    def trigger!(klass, method_name, result, *args)
      block = const_get(CONST_EXECUTION_BLOCK) rescue nil
      raise ExecuteBlockWasNotDefined, "You must define execute block in your #{self.name}" unless block
      block.call(klass, method_name, result, *args)
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

    def observe_method!(klass, method_names, skip_if:, instance_method: true, &main_block)
      observed_method_proc = observer_proc(
        klass,
        method_names[:name],
        skip_if,
        instance_method: instance_method,
        &main_block
      )

      if instance_method
        define_instance_method(klass, method_names[:observed], observed_method_proc)
        alias_instance_method(klass, method_names[:name], method_names[:observed]) # redefine the original method
      else
        define_class_method(klass, method_names[:observed], observed_method_proc)
        alias_class_method(klass, method_names[:name], method_names[:observed])
      end
      add_observed(klass, method_names[:name], instance_method: instance_method)

      true
    end

    def observer_proc(klass, method_name, skip_if, instance_method: true, &main_block)
      original_method = instance_method ? klass.instance_method(method_name) : klass.method(method_name)
      me = self

      -> (*args, &block) do
        result = if instance_method
          # We must inject context to instance method before call
          original_method.bind(self).call(*args, &block)
        else
          original_method.call(*args, &block)
        end

        unless skip_if.nil?
          return if skip_if.call(result)
        end

        if block_given?
          main_block.call(klass, method_name, result, *args)
        else
          me.trigger!(klass, method_name, result, *args)
        end

        result # return the result of the original method
      end
    end

    def klass_with_method(klass, method, instance_method: true)
      instance_method ? "#{klass}##{method}" : "<ClassMethod:#{klass}##{method}"
    end

    def method_defined?(klass, method)
      klass.instance_methods(false).include?(method.to_sym)
    end

    def klass_method_defined?(klass, method)
      klass.methods(false).include?(method.to_sym)
    end

    def alias_instance_method(klass, alias_method, original_method)
      klass.send(:alias_method, alias_method, original_method)
    end

    def alias_class_method(klass, alias_method, original_method)
      klass.singleton_class.send(:alias_method, alias_method, original_method)
    end

    def define_instance_method(klass, method_name, proc)
      klass.send(:define_method, method_name, proc)
    end

    def define_class_method(klass, method_name, proc)
      klass.singleton_class.send(:define_method, method_name, proc)
    end

    def add_observed(klass, method_name, instance_method: true)
      observed_methods << klass_with_method(klass, method_name, instance_method: instance_method)
    end

    def remove_from_observed(klass, method_name, instance_method: true)
      observed_methods.delete(klass_with_method(klass, method_name, instance_method: instance_method))
    end

    def generate_method_names(method_name)
      {
        name: method_name.to_sym,
        observed: "_methodist_#{method_name}_observer",
        dump: "_methodist_#{method_name}_dump",
      }
    end

    class ExecuteBlockWasNotDefined < StandardError;
    end
  end
end
