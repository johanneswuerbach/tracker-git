# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tracker_git/information', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'tracker-git'
  gem.version       = TrackerGit::VERSION
  gem.description   = TrackerGit::GEM_DESCRIPTION
  gem.summary       = TrackerGit::GEM_SUMMARY

  gem.authors       = ['Robbie Clutton']
  gem.email         = ['robert.clutton@gmail.com']
  gem.homepage      = ''

  gem.add_runtime_dependency 'methadone'
  gem.add_runtime_dependency 'pivotal-tracker'
  gem.add_runtime_dependency 'rest-client'

  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = %w(lib)
end
