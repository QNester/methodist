class Methodist::Service < Pattern
  CONST_CLIENT = 'CLIENT'

  class << self
    def client(&block)
      const_set(CONST_CLIENT, block.call)
    end
  end

  attr_reader :client

  def initializer
    client = const_get(CONST_CLIENT) rescue nil
    @client = client if client
  end

  class ResponseError < StandardError; end
end