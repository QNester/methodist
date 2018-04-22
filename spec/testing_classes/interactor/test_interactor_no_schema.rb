class TestInteractorNoSchema < Methodist::Interactor
  step :validate
  step :say_hello

  def say_hello
    puts 'Hello!'
    Right(true)
  end
end