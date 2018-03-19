
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/skip_retry/version'

Gem::Specification.new do |spec|
  spec.name          = 'sidekiq-skip_retry'
  spec.version       = Sidekiq::SkipRetry::VERSION
  spec.authors       = ['Salahutdinov Dmitry']
  spec.email         = ['dsalahutdinov@gmail.com']

  spec.summary       = 'Support skipping if retriable sidekiq job'
  spec.description   = 'Support skipping if retriable sidekiq job'
  spec.homepage      = 'https://github.com/dsalahutdinov/sidekiq-skip_retry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sidekiq'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.53'
end
