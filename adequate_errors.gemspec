
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "adequate_errors/version"

Gem::Specification.new do |spec|
  spec.name          = "adequate_errors"
  spec.version       = AdequateErrors::VERSION
  spec.license       = 'MIT'
  spec.authors       = ["lulalala"]
  spec.email         = ["mark@goodlife.tw"]

  spec.summary       = %q{Overcoming limitation of Rails model errors API}
  spec.homepage      = "https://github.com/lulalala/adequate_errors/"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "activemodel"

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "builder", "~> 3.2.3"
  spec.add_development_dependency "rspec", "~> 3.7"
end
