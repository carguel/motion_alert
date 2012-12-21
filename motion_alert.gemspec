# -*- encoding: utf-8 -*-

require File.expand_path('../lib/motion_alert/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "motion_alert"
  gem.version       = MotionAlert::VERSION
  gem.summary       = %q{Event handler for the motion program.}
  gem.description   = %q{This gem provides convenient method to manage events detected by the motion program.}
  gem.license       = "MIT"
  gem.authors       = ["Christophe Arguel"]
  gem.email         = "christophe.arguel@free.fr"
  gem.homepage      = "https://rubygems.org/gems/motion_alert"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency     'mail'
  gem.add_runtime_dependency     'aws-sdk'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
