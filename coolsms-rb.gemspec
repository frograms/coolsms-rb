$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'coolsms/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'coolsms-rb'
  s.version     = Coolsms::VERSION
  s.authors     = ['buzz jung']
  s.email       = %w(buzz@frograms.com)
  s.homepage    = 'http://github.com/frograms/coolsms-rb'
  s.summary     = 'CoolSMS Ruby Client'
  s.description = 'CoolSMS Ruby Client. under construction...'
  s.licenses    = ['MIT']

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(LICENSE Rakefile README.md)
  s.test_files = Dir['test/**/*']

  s.add_dependency 'faraday', '>= 2.0'
  s.add_dependency 'oj'
  s.add_dependency 'tzinfo'
  s.add_dependency 'activesupport'
  s.add_dependency 'awesome_print'
  s.add_dependency 'coaster'

  s.add_development_dependency 'bundler', '>= 1.12'
  s.add_development_dependency 'pry', '>= 0.8'
  s.add_development_dependency 'pry-stack_explorer', '>= 0.4'
  s.add_development_dependency 'pry-byebug', '>= 3.0'
  s.add_development_dependency 'minitest', '>= 5.0'
  s.add_development_dependency 'mocha', '>= 1.0'
  s.add_development_dependency 'shoulda', '>= 3.0'
  s.add_development_dependency 'shoulda-context', '>= 1.0'
  s.add_development_dependency 'forgery', '>= 0.6'
  s.add_development_dependency 'vcr'
end
