# N+1 Finder
  [![Gem Version](https://badge.fury.io/rb/n_1_finder.svg)](https://badge.fury.io/rb/n_1_finder)
  [![Build Status](https://api.travis-ci.org/aglushkov/n1_finder.svg?branch=master)](https://travis-ci.org/aglushkov/n1_finder)
  [![Inline docs](http://inch-ci.org/github/aglushkov/n1_finder.svg?branch=master)](http://inch-ci.org/github/aglushkov/n1_finder)

  This gem helps to find N+1 queries.

  It works with `ActiveRecord` and `Sequel`.

  And tested with `postgresql`, `mysql` and `sqlite`.

## Installation
  `gem 'n_1_finder', group: :development`

## Configuration
### Logger
Default is `Logger.new(STDOUT)`

Logger can be any instance of `Logger` class.

```ruby
  N1Finder.logger = Logger.new('log/n1.log')
```

### ORM
Default is `:active_record` if you have activerecord gem installed.

Default is `:sequel` if you have sequel gem installed.

Allowed values are `:active_record` and `:sequel`

```ruby
  N1Finder.orm = :active_record
```

## Using
Include middleware to your Rack app:
```ruby
# Rails
class Application < Rails::Application
  config.middleware.use(N1Finder::Middleware)
  ...
# Grape
class YourAPI < Grape::API
  use N1Finder::Middleware
  ...
# Padrino
class YourAPP < Padrino::Application
  use N1Finder::Middleware
```

Or use it directly:
```ruby
  N1Finder.find do
    User.all.map { |user| user.comments.to_a }
  end
```

Log example:
```log
D, [2016-06-28T11:15:23.019561 #7542] DEBUG -- :
N+1 QUERY DETECTED:
  QUERY: SELECT  "comments".* FROM "comments" WHERE "comments"."user_id" = $1, user_id = [id]
  LINE: /home/andrey/.rvm/rubies/ruby-2.2.1/lib/ruby/2.2.0/pp.rb:187:in `block in pp'
  QUERIES_COUNT: 2
  ORIGINAL_QUERIES:
    SELECT  "comments".* FROM "comments" WHERE "comments"."user_id" = $1, user_id = 618
    SELECT  "comments".* FROM "comments" WHERE "comments"."user_id" = $1, user_id = 947
```

## Running tests
- Copy `spec/.env.example` file to `spec/.env` and set database credentials.
```bash
cp spec/.env.example spec/.env
```

- Load this variables into your system.
```bash
source spec/.env
```

- Run tests.
```bash
rspec
```