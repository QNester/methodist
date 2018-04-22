# Methodist::Interactor
Interactor encapsulate your business logic. Interactor - simple object with 
only one goal. 

### How does it work?

Methodist interactors work with usage 
[dry-transaction](https://github.com/dry-rb/dry-transaction)

It so simple. Just create your interactor with:
```
rails generate interactor hello/world
```
This command will generate file `#{Rails.root}/app/interactors/hello/world.rb` with code:

```ruby
class Hello::World < Methodist::Interactor
  schema do
    # Your schema code here
  end
  
  step :validate
end
```

As we can see in class body we have method __#schema__ with pass block. 
We need it for [validation](#validation). After we see `step :validate`, where `step` - one of step adapter from 
[dry-transaction](https://github.com/dry-rb/dry-transaction) and `:validate` - validation method. 
You should read this [doc](http://dry-rb.org/gems/dry-transaction/step-adapters/) to 
understand how does work step adapter. About validations we will write [below](#validation).

Now we add validation schema and one more step to our interactor:
```ruby
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
```
We define `#say_hello` but no define `#validate`. Why? Because `#validate` was defined in
Methodist::Interactor. If you want just redefine in after your steps.

Now we can use our first interactor:
```ruby
Hello::World.new.call(name: 'QNester')
#> Hello, QNester
#> Success(nil)
```

We can check interactor execution result:
```ruby
result = Hello::World.new.call(name: 'QNester')
result.success? #> true
result.value #> { name: 'QNester' }
```

For more about dry-transaction behavior here: 
http://dry-rb.org/gems/dry-transaction/basic-usage/

### Validation

Methodist interactors has built-in validation mechanism dependency by 
[dry-validation](https://github.com/dry-rb/dry-validation)

If you want use built in `#validate` method in your interactors, you should 
pass your schema with method `schema`. 

Example:

```ruby
# app/interactors/hello/world.rb
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

# success usage
result = Hello::World.new.call(name: 'QNester')
result.success? #> true

# failure usage
another_result = Hello::world.new.call
another_result.success? #> false
another_result.value #> { error: 'ValidationError', field: :name, reason: 'name: must exists' }
```

About dry-validation schemas 
[here](http://dry-rb.org/gems/dry-validation/).

