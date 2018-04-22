# Methodist
Methodist - gem for Ruby on Rails was created for stop chaos in your buisness logic.
This gem add to your rails application generators for some patterns:

- Interactor: class for doing some complex job.
- Observer: notification one part of application about changes in another part of application
- __[NOT REALISED]__ Service: class with methods collections (it will be pleasure in work with
internal services).
- __[NOT REALISED]__ Command: class for doing some small job.
- __[NOT REALISED]__ Builder: build data for later convenient use
 

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'methodist'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install methodist
```

## Contributing
For contribute just:
1) Create issue. Issue should contains information about goals of your
 future changes.
2) Fork project.
3) Create branch. Title of branch should starting with ID of your issue. 
Examle: `ISSUE-205-create-new-pattern-generator`
4) Make changes
5) *Write tests*.
6) Make commit. Title of commit should starting with ID of your issue. 
Examle: `[ISSUE-205] Create new pattern generator`
7) Push.
8) Create pull request to `develop` branch.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
