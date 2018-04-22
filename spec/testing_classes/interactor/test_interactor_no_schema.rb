class TestInteractorNoSchema < Methodist::Interactor
  step :validate
  step :say_hello

  def say_hello
    puts 'Hello!'
    Success(true)
  end
end