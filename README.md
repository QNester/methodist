# Methodist
[![Build Status](https://travis-ci.org/QNester/methodist.svg?branch=master)](https://travis-ci.org/QNester/methodist)
[![Maintainability](https://api.codeclimate.com/v1/badges/eebe37d3169041579416/maintainability)](https://codeclimate.com/github/QNester/methodist/maintainability)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gem-methodist/methodist?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Methodist - gem for Ruby on Rails was created for stop chaos in your buisness logic.
This gem add to your rails application generators for some patterns:

- Interactor: class for doing some complex job.
- Observer: notification one part of application about changes in another part of application
- __[NOT REALISED]__ Service: class with methods collections (it will be pleasure in work with
internal services).
- __[NOT REALISED]__ Command: class for doing some small job.
- __[NOT REALISED]__ Builder: build data for later convenient use
 

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

## Usage
Just execute in terminal
```
rails g <pattern_name> <generated_class>
```
where _<pattern_name>_ - one of ready patterns (observer, interactor).

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
