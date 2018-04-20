# Methodist interactors use dry-transaction for work.
# See https://github.com/dry-rb/dry-transaction for documentation about

class Hello::World < Methodist::Interactor
  # See http://dry-rb.org/gems/dry-validation/ for syntax of validations
  set_schema do
    required(:name).value(:str?)
  end

  # Use your step, tee, try or map
  # More info: http://dry-rb.org/gems/dry-transaction/step-adapters/
  #
  # Redefine #validate method for custom validation method
  # If you want to change returning value in validated Left, redefine private method #left_validation_value
  step :validate
  tee :say_hello

  def say_hello(input)
    puts "Hello, #{input[:name]}"
  end
end