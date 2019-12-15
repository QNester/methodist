class TestInteractorContract < Methodist::Interactor
  contract do
    params do
      optional(:username).value(:str?)
      optional(:email).value(:str?)
      required(:password).value(:str?)
    end

    rule(:username, :email) do
      unless values[:email] || values[:username]
        key.failure('username or email must exists')
      end
    end
  end

  step :validate
  step :say_hello

  # Don't define validate method coz it realised in parent class

  def say_hello(input)
    puts "Hello, #{input[:name]}"
    Success(true)
  end
end