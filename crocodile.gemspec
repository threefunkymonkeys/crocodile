# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "crocodile"
  s.version = "2.0"
  s.summary = "Periodic Ruby jobs runner"
  s.license = "MIT"
  s.description = "A simple worker to run Ruby jobs periodically"
  s.authors = ["Lautaro Orazi", "Leonardo Mateo"]
  s.email = ["taro@threefunkymonkeys.com", "kandalf@threefunkymonkeys.com"]
  s.homepage = "https://github.com/threefunkymonkeys/crocodile"
  s.require_paths = ["lib"]
  s.bindir = "bin"
  s.executables << "crocodile"
  s.add_dependency "eventmachine", '~> 1.0'
  s.add_development_dependency 'mocha', '1.1.0'

  s.files = `git ls-files`.split("\n")
end
