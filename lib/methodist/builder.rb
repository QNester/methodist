require_relative 'pattern'

class Methodist::Builder < Methodist::Pattern
  class << self
    def attr_accessor(*args)
      @attributes ||= []
      @attributes += args
      @attributes.uniq!
      super(*args)
    end

    def field(attr_name, proc = nil)
      attr_accessor(attr_name)
      set_proc_to_const(proc, attr_name) if proc
    end

    def fields(*attr_names, &block)
      attr_names.each { |attr_name| field(attr_name, &block) }
    end

    def attributes
      @attributes || []
    end

    alias_method :attrs, :attributes

    def set_proc_to_const(proc, attr_name)
      const_set(proc_const_name(attr_name), proc)
    end

    def proc_const_name(attr_name)
      "VALIDATION_PROC_#{attr_name.upcase}"
    end
  end

  def to_h
    hash = {}
    self.class.attributes.each do |att|
      hash[att] = self.send(att)
    end
    hash
  end

  alias_method :to_hash, :to_h

  def valid?
    self.class.attributes.all? { |att| valid_attr?(att) }
  end

  def valid_attr?(attr_name)
    proc = get_proc(attr_name)
    return true if proc.nil?
    proc.call(self.send(attr_name))
  end

  private

  def get_proc(attr_name)
    self.class.const_get(self.class.proc_const_name(attr_name)) # rescue nil
  end
end
