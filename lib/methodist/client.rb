require_relative 'pattern'

class Methodist::Client < Methodist::Pattern
  attr_reader :client

  class << self
    attr_reader :base_client

    def client(base_client)
      @base_client = base_client
    end
  end

  ##
  # Instance method use to get defined client
  ##
  def client
    @client ||= self.class.base_client
  end

  class ResponseError < StandardError; end
end