# Methodist
[![Build Status](https://travis-ci.org/QNester/methodist.svg?branch=master)](https://travis-ci.org/QNester/methodist)
[![Maintainability](https://api.codeclimate.com/v1/badges/eebe37d3169041579416/maintainability)](https://codeclimate.com/github/QNester/methodist/maintainability)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/gem-methodist/methodist?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Methodist - a gem for Ruby on Rails created to stop chaos in your buisness logic.
This gem adds generators to your rails application using some patterns:

- __Interactor__: a class for doing some complex job.
- __Observer__: notifies one part of an application about changes in another part of an application.
- __Builder__: is used to create an object with complex configuration (including your business logic, validation etc.)
- __Client__: a class with collection of methods for external services (databases, APIs and etc). 


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'methodist'
```

And then execute:
```bash
$ bundle
```

Or install it yourself:
```bash
$ gem install methodist
```

## Usage
Just execute in a terminal
```
rails g <pattern_name> <generated_class>
```
where _<pattern_name>_ is one of the patterns (observer, interactor, etc.)

About every Methodist pattern you can read [here](https://github.com/QNester/methodist/wiki)

## Contributing
To contribute just:
1) Create issue. Issue should contain information about goals of your
 future changes.
2) Fork project.
3) Create branch. The name of the branch should begin with the ID of your issue.
Examle: `ISSUE-205-create-new-pattern-generator`.
4) Make changes.
5) *Write tests*.
6) Make a commit. The name of the commit should begin with the ID of your issue.
Examle: `[ISSUE-205] Create new pattern generator`.
7) Push.
8) Create a pull request to the `develop` branch.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
