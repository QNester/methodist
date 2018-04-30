require_relative 'pattern'

class Methodist::Service < Methodist::Pattern
  CONST_CLIENT = 'CLIENT'

  class << self
    def client(client_instance)
      const_set(CONST_CLIENT, client_instance)
    end
  end

  def client
    @client ||= self.class.const_get(CONST_CLIENT) #rescue nil
  end

  class ResponseError < StandardError; end
end