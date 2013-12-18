# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'open_weixin/version'

Gem::Specification.new do |spec|
  spec.name          = "open_weixin"
  spec.version       = OpenWeixin::VERSION
  spec.authors       = ["jhjguxin"]
  spec.email         = ["864248765@qq.com"]
  spec.description   = %q{A wrapper for 'http://open.weixin.qq.com/' OAuth2 API}
  spec.summary       = %q{A wrapper for 'http://open.weixin.qq.com/' OAuth2 API}
  spec.homepage      = "https://github.com/jhjguxin/open_weixin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth2", [">= 0.5","<= 0.9"]
  spec.add_dependency "activemodel", [">= 3.0","<= 4"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "rake"
end
