class SubscriptionObserver < Methodist::Observer
  # observe Klass, :instance_method

  execute do |klass, instance_method|
    # Write your triggered actions
    # Example:
    #     CounterService.new.increment("#{klass.downcase.demodulize}_instance_method")
  end

  class << self
    # If you want use methods in execute you should define them here.
  end
end