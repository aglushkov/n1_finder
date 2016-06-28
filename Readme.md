# N+1 Finder
  This gem can help you to find N+1 queries.

  It works with `ActiveRecord` and `Sequel`.

  And tested with `postgresql`, `mysql` and `sqlite`.

## Installation
  With Gemfile: `gem 'n1_finder', group: :development`

  Without Gemfile: `gem install n1_finder`

## Configuration
### Logger
Default is `Logger.new(STDOUT)`

`N+1 Finder` logger can be any instance of `Logger` class.

```ruby
  N1Finder.logger = Logger.new('log/n1.log')
```

### ORM
Default is `:active_record` if you have activerecord gem installed.

Default is `:sequel` if you have sequel gem installed.

You can set ORM explicitly
```ruby
  N1Finder.orm = :active_record
```

## Using

### Directly
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

### Middleware
`N+1 Finder` provides middleware that you can include to any rack application to find N+1 queries in your requests:

#### Rails
```ruby
class Application < Rails::Application
  config.middleware.use(N1Finder::Middleware)
```

#### Grape
```ruby
class YourAPI < Grape::API
  use N1Finder::Middleware
```

#### Padrino
```ruby
class YourAPP < Padrino::Application
  use N1Finder::Middleware
```

