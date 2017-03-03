$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'payjp/version'

Gem::Specification.new do |s|
  s.name = 'payjp'
  s.version = Payjp::VERSION
  s.summary = 'Ruby bindings for the Payjp API'
  s.description = 'PAY.JP makes it way easier and less expensive to accept payments.'
  s.authors = ['PAY.JP']
  s.email = ['support@pay.jp']
  s.homepage = 'https://pay.jp'
  s.license = 'MIT'

  s.add_dependency('rest-client', '~> 2.0')

  s.add_development_dependency('mocha', '~> 1.2.1')
  s.add_development_dependency('activesupport', ['< 5.0', '~> 4.2.7'])
  s.add_development_dependency('test-unit', '~> 3.2.2')
  s.add_development_dependency('rake', '~> 11.3.0')
  s.add_development_dependency('bundler', '>= 1.7.6')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
