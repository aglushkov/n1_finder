require './lib/n_1_finder/version'

Gem::Specification.new do |s|
  s.name        = 'n_1_finder'
  s.version     = N1Finder::VERSION
  s.date        = '2016-05-06'
  s.summary     = 'N+1 Finder'
  s.description = 'Find N+1 queries in blocks'
  s.authors     = ['Andrey Glushkov']
  s.email       = 'aglushkov@shakuro.com'
  s.files       = `git ls-files lib spec Readme.md`.split("\n")
  s.homepage    = 'http://rubygems.org/gems/n_1_finder'
  s.license     = 'MIT'
end
