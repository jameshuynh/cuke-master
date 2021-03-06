# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_master/version'

# rubocop:disable BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'cuke_master'
  spec.version       = CukeMaster::VERSION
  spec.authors       = ['James Huynh']
  spec.email         = ['james@rubify.com']

  spec.summary       = %(Cuke Master Steps)
  spec.description   = %(CukeP Master Steps)
  spec.homepage      = 'https://github.com/jameshuynh/cuke-master'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'capybara', '~> 2.14'
  spec.add_dependency 'capybara-screenshot', '~> 1.0'
  spec.add_dependency 'cucumber', '~> 2.4'
  spec.add_dependency 'minitest', '~> 5.8'
  spec.add_dependency 'selenium-webdriver', '~> 3.4'
  spec.add_dependency 'activesupport', '~> 5.1'
end
