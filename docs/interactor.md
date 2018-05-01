# Methodist::Interactor
Interactor encapsulates your business logic. Interactor is a simple object with an
only one goal.

### How does it work?

Methodist interactors work using
[dry-transaction](https://github.com/dry-rb/dry-transaction)

It's simple. Just create your interactor with:
```
rails generate interactor hello/world
```
This command will generate a file `#{Rails.root}/app/interactors/hello/world.rb` with code:

```ruby
class Hello::World < Methodist::Interactor
  schema do
    # schema code goes here
  end

  step :validate
end
```

As you can see in the class body we have __#schema__ method with the pass block.
We need it for [validation](#validation). We have `step :validate` below, where `step` is one of a step adapter from
[dry-transaction](https://github.com/dry-rb/dry-transaction) and `:validate` is a validation method.
You should read this [doc](http://dry-rb.org/gems/dry-transaction/step-adapters/) to
understand how does the step adapter work. Learn more about validations [below](#validation).

Now add a validation schema and one more step to our interactor:
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
We define `#say_hello` but don't define `#validate`. Why? Because `#validate` has already defined in a
Methodist::Interactor class. You can redefine it after your steps.

Now you can use our first interactor:
```ruby
Hello::World.new.call(name: 'QNester')
#> Hello, QNester
#> Success(nil)
```

You can check the interactor execution result:
```ruby
result = Hello::World.new.call(name: 'QNester')
result.success? #> true
result.value #> { name: 'QNester' }
```

Learn more about dry-transaction behavior here:
http://dry-rb.org/gems/dry-transaction/basic-usage/

### Validation

Methodist interactors have a built-in validation mechanism by
[dry-validation](https://github.com/dry-rb/dry-validation)

To use built in `#validate` method in your interactors, pass your validations to the `#shema` method.

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

# success
result = Hello::World.new.call(name: 'QNester')
result.success? #> true

# failure
another_result = Hello::world.new.call
another_result.success? #> false
another_result.value #> { error: 'ValidationError', field: :name, reason: 'name: must exists' }
```

If you want to customize the value returned in case of validation failure, redefine a `#failure_validation_value` method.

To create your own validation method, use one of these approaches:

1) redefine a `#validate` method;
2) define `#your_custom_method` and use it like that `step :your_custom_method` instead of `step :validate`.

About dry-validation schemas
[here](http://dry-rb.org/gems/dry-validation/).

