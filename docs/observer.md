# Methodist::Observer
Observer - a kind of centralized after-hook. With an observer you can find out that some method in your
application was called without explicit indication from the method itself.
Observer can be useful for various notifications, counters, etc.

### How does it work?

Generate new observer:
```
rails g observer downcase
```
This command will generate file `#{Rails.root}/config/initializers/observers/downcase_observer.rb`
with code:
```ruby
# config/initializers/observers/downcase_observer.rb
class DowncaseObserver < Methodist::Observer
  execute do |klass, method_name|
    # your execution code here
  end
end
```
The `#execute` method takes a block and executes it after calling the observed method.

Let's add the observed method:
```ruby
# config/initializers/observers/downcase_observer.rb
class DowncaseObserver < Methodist::Observer
  observe String, :downcase

  execute do |klass, method_name|
    puts "#{klass}##{method_name} was called!"
  end
end
```

File is located in initializers directory and will be loaded right after rails server or console start.
We will use rails console to test it. Run `rails console` and execute the following:
```
str = 'WE WANT TO TEST IT'
str.downcase
# String#downcase was calling!
#=> 'we want to test it'
```

You can observe multiple methods, just add more `observe` lines in your observer class:
```ruby
# config/initializers/observers/downcase_observer.rb
class DowncaseObserver < Methodist::Observer
  observe String, :downcase
  observe String, :upcase

  execute do |klass, method_name|
    puts "#{klass}##{method_name} was called!"
  end
end
```
You can list all the observed methods using `#observed_methods`

In the console:
```
DowncaseObserver.observed_methods
#=> ["String#downcase", "String#upcase"]
str = 'WE WANT TO TEST IT'
str = str.downcase
# String#downcase was called!
#=> 'we want to test it'
str.upcase
# String#upcase was called!
#=> 'WE WANT TO TEST IT'
```

You can use conditional execution using `skip_if`:
```ruby
observe String, :downcase, skip_if: -> (result) { result.length > 5 }
```
Where `result` is the value returned by the observed method.
In the example above the `#execute` method won't be called because
the value returned by the observed method satisfies the condition.

You can stop observation the method with `#stop_observe`:
```ruby
str = 'WE WANT TO TEST IT'
str.downcase
# String#downcase was called!
#> 'we want to test it'
DowncaseObserver.stop_observe(String, :downcase)
DowncaseObserver.observed_methods
#=> []
str.downcase
#> 'we want to test it'
```


