source 'https://rubygems.org'

gemspec

gem 'activerecord', '~> 4.2'
gem 'sequel', '~> 4.35'

platforms :ruby do
  gem 'sqlite3'
  gem 'pg'
  gem 'mysql'
  gem 'pry'
  gem 'pry-nav', '~> 0.2.4'
end

platforms :jruby do
  gem 'jdbc-sqlite3', '~> 3.8', '>= 3.8.11.2'
  gem 'jdbc-postgres', '~> 9.4', '>= 9.4.1206'
  gem 'jdbc-mysql', '~> 5.1', '>= 5.1.38'
  gem 'activerecord-jdbc-adapter', '~> 1.3', '>= 1.3.20'
end

gem 'rspec', '~> 3.4.0'
gem 'rubocop', require: false
gem 'rubocop-rspec', require: false
gem 'yard', require: false
