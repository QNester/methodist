require_relative 'pattern'

class Methodist::Builder < Methodist::Pattern
  class << self
    def attr_accessor(*args)
      @attributes ||= []
      @attributes += args
      @attributes.uniq!
      super(*args)
    end

    ##
    # Define attribute and set validation for value
    #
    # ==== Parameters
    # * +attr_name+ [String] - name of defined attribute
    # * +proc+ [Proc] - proc for validate contains value. If proc call result
    # will returns true then #valid_attr? will returns true.
    #
    ##
    def field(attr_name, proc = nil, **options)
      attr_accessor(attr_name)
      define_read_method_with_default(attr_name, options[:default])
      define_write_method(attr_name, proc, options)
    end

    ##
    # Define multiple attributes and set validation for values
    #
    # ==== Parameters
    # * +attr_names+ [Args] - name of defined attribute
    # * +proc+ [Proc] - proc for validate contains values.
    #
    ##
    def fields(*attr_names, &block)
      attr_names.each { |attr_name| field(attr_name, &block) }
    end

    ##
    # Array of defined attributes
    ##
    def attributes
      @attributes || []
    end

    alias_method :attrs, :attributes

    def proc_const_name(attr_name)
      "VALIDATION_PROC_#{attr_name.upcase}"
    end

    private

    def set_proc_to_const(proc, attr_name)
      const_set(proc_const_name(attr_name), proc)
    end

    def define_read_method_with_default(attr_name, default_val)
      define_method(attr_name) do
        res = instance_variable_get("@#{attr_name}".to_sym)
        res.nil? ? default_val : res
      end
    end

    def define_write_method(attr_name, proc, options)
      set_proc_to_const(proc, attr_name) if proc

      define_method("#{attr_name}=") do |val|
        instance_variable_set("@#{attr_name}".to_sym, val)
        return val if valid_attr?(attr_name)
        instance_variable_set("@#{attr_name}".to_sym, nil)

        raise InvalidValueError, "Value #{val} is not valid for your validation." if options[:raise_invalid]

        nil
      end
    end
  end

  ##
  # Convert attributes and values to hash.
  #
  # ==== Example
  #   In builder with attributes 'title', 'author'
  #   when you will use this method you will have:
  #   { title: 'Title', author: 'Author' }
  ##
  def to_h
    hash = {}
    self.class.attributes.each do |att|
      hash[att] = self.send(att)
    end
    hash
  end

  alias_method :to_hash, :to_h

  ##
  # Validate all attributes.
  ##
  def valid?
    self.class.attributes.all? { |att| valid_attr?(att) }
  end

  ##
  # Validate attribute value.
  # Proc passed in #field method use for validation.
  # If proc was not defined just return true.
  #
  # ==== Parameters
  # * +attr_name+ [String/Symbol] - name of attribute
  ##
  def valid_attr?(attr_name)
    proc = get_proc(attr_name)
    return true if proc.nil?
    proc.call(self.send(attr_name))
  end

  private

  def get_proc(attr_name)
    self.class.const_get(self.class.proc_const_name(attr_name)) # rescue nil
  end

  class InvalidValueError < StandardError; end
end
