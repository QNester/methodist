# Methodist::Observer
Observer - kind of centralized after hook. With observer you can know that some method in your 
application was calling explicit indication from the method itself. 
Observer can be useful for various notifications, counters and etc.

### How does it work?

You generate new observer:
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
We can see method `#execute`. Here we must pass block what will be executed after our
observed method will be call.

Let's add observing method in our code:
```ruby
# config/initializers/observers/downcase_observer.rb
class DowncaseObserver < Methodist::Observer
  observe String, :downcase

  execute do |klass, method_name| 
    puts "#{klass}##{method_name} was calling!"
  end
end
```

It located in initializing directory and will be loaded with start rails server or console.
We will use rails console to test it. Run `rails console` and write:
```
str = 'WE WANT TO TEST IT'
str.downcase
# String#downcase was calling!
#=> 'we want to test it'
```

We can observe multiple methods, just add more `observe` to your observer class: 
```ruby
# config/initializers/observers/downcase_observer.rb
class DowncaseObserver < Methodist::Observer
  observe String, :downcase
  observe String, :upcase

  execute do |klass, method_name| 
    puts "#{klass}##{method_name} was calling!"
  end
end
```
You can see all observed method with `#observed_methods`

In console:
```
DowncaseObserver.observed_methods 
#=> ["String#downcase", "String#upcase"]
str = 'WE WANT TO TEST IT'
str = str.downcase
# String#downcase was calling!
#=> 'we want to test it'
str.upcase
# String#upcase was calling!
#=> 'WE WANT TO TEST IT'
``` 

You can add condition to execution block after calling method:
```ruby
observe String, :downcase, skip_if: -> (result) { result.length > 5 }
```
`result` - result of execution observed method.
Execute block will not invoke if string length will be more then 5.

You can stop observe method with `#stop_observe`:
```ruby
str = 'WE WANT TO TEST IT'
str.downcase
# String#downcase was calling!
#> 'we want to test it'
DowncaseObserver.stop_observe(String, :downcase)
DowncaseObserver.observed_methods 
#=> []
str.downcase
#> 'we want to test it'
```


