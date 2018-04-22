class Hello::World < Methodist::Interactor
  schema do
    required(:name).value(:str?)
  end
  
  step :validate
  step :say_hello

  def say_hello(input)
    puts "Hello, #{input[:name]}"
    Success(input)
  end
end