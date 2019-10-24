# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'container_ship/version'

Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name          = 'container_ship'
  spec.version       = ContainerShip::VERSION
  spec.authors       = ['Yuji Ueki']
  spec.email         = ['unhappychoice@gmail.com']

  spec.summary       = 'Yet another ECS deployment tool'
  spec.description   = 'container_ship is a simple ECS deployment tool. You only need to prepare Dockerfile and task_definition.json' # rubocop:disable Metrics/LineLength
  spec.homepage      = 'https://github.com/seibii/container_ship'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/seibii/container_ship'
  spec.metadata['changelog_uri'] = 'https://github.com/seibii/container_ship'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-cloudwatchlogs'
  spec.add_dependency 'aws-sdk-ecs'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'github_changelog_generator'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
end
