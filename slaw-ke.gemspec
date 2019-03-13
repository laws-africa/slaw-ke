# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slaw/ke/version'

Gem::Specification.new do |spec|
  spec.name          = "slaw-ke"
  spec.version       = Slaw::KE::VERSION
  spec.authors       = ["Greg Kempe"]
  spec.email         = ["greg@kempe.net"]
  spec.summary       = "A lightweight library for using Akoma Ntoso acts in Ruby."
  spec.description   = "Slaw is a lightweight library for rendering and generating Akoma Ntoso acts from plain text and PDF documents."
  spec.homepage      = "https://github.com/longhotsummer/slaw"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  #spec.add_runtime_dependency "slaw", "~> 1.0"
end
