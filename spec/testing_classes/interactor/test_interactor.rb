class TestInteractor < Methodist::Interactor
  schema do
    required(:name).value(:str?)
  end

  step :validate
  step :say_hello

  # Don't define validate method coz it realised in parent class

  def say_hello(input)
    puts "Hello, #{input[:name]}"
    Right(true)
  end
end