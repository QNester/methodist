class Methodist::Observer < Methodist::Pattern
  CONST_EXECUTION_BLOCK = 'EXEC_BLOCK'.freeze

  class << self
    def observe(klass, method_name, skip_if: nil)
      original_method = klass.instance_method(method_name)
      method_observe = observer_method(method_name)
      method_dump = method_dump(method_name)
      me = self

      return if method_defined?(klass, method_dump)

      klass.alias_method method_dump, method_name # dump method

      klass.define_method(method_observe) do |*args, &block|
        result = original_method.bind(self).call(*args, &block)
        unless skip_if.nil?
          return if skip_if.call(result)
        end
        me.trigger!(klass, method_name)
        result
      end

      klass.alias_method method_name, method_observe # redefine method
    end

    def stop_observe(klass, method_name)
      method_observe = observer_method(method_name)
      method_dump = method_dump(method_name)
      return unless method_defined?(klass, method_observe) && method_defined?(klass, method_dump)

      klass.alias_method method_name, method_dump # restore dumped method
      klass.remove_method(method_observe) # remove observed method
      klass.remove_method(method_dump) # remove dump method
    end

    def stop_observe_if(klass, method_name, &if_block)
      if if_block.call
        stop_observe(klass, method_name)
      end
    end

    def trigger!(klass, method)
      const_get(CONST_EXECUTION_BLOCK).call(klass, method)
    end

    def execute(&block)
      const_set(CONST_EXECUTION_BLOCK, block)
    end

    private

    def apply_observe(klass, method, new_method)

    end

    def observer_method(method)
      "#{method}_observer"
    end

    def method_dump(method)
      "#{method}_dump"
    end

    def method_defined?(klass, method)
      klass.instance_methods(false).include?(method.to_sym)
    end
  end
end

# Methodist::Observer.observe(Hello::World, :say_hello)
# Hello::World.new.call(name: 'Sergey')