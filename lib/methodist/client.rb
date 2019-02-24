require_relative 'pattern'

class Methodist::Client < Methodist::Pattern
  CONST_CLIENT = 'CLIENT'

  class << self
    ##
    # Define client for client
    #
    # ==== Parameters
    # * +client_instance+ [Instance of client klass] - Instance of client class.
    # It could be different clients like redis, elastic, internal api etc.
    ##
    def client(client_instance)
      const_set(CONST_CLIENT, client_instance)
    end
  end

  ##
  # Instance method use to get defined client
  ##
  def client
    @client ||= self.class.const_get(CONST_CLIENT) #rescue nil
  end

  class ResponseError < StandardError; end
end