class SubscriptionsObserver < Methodist::Observer
  observe Hello::World, :say_hello, skip_if: -> (result) { result.failure? }
  observe HelloService, :say

  execute do |klass, instance_method|
    # Write your triggered actions
    # Example:
    #     CounterService.new.increment("#{klass.downcase.demodulize}_instance_method")
    if klass.name.downcase =~ /service/
      from_service
    else
      from_interactor
    end
  end

  class << self
    def from_service
      puts 'From service!'
    end

    def from_interactor
      puts 'From Interactor!'
    end
  end
end