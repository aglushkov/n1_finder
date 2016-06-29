require './lib/n_1_finder/version'

Gem::Specification.new do |s|
  s.name        = 'n_1_finder'
  s.version     = N1Finder::VERSION
  s.summary     = 'N+1 Finder'
  s.description = 'Finds N+1 queries'
  s.authors     = ['Andrey Glushkov']
  s.email       = 'aglushkov@shakuro.com'
  s.files       = `git ls-files lib spec Readme.md`.split("\n")
  s.homepage    = 'https://github.com/aglushkov/n1_finder'
  s.license     = 'MIT'
end
