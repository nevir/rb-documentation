# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = "documentation"
  gem.version     = "0.0.0"
  gem.homepage    = "http://github.com/nevir/rb-documentation"
  gem.summary     = "Unified documentation for all Ruby implementations and versions"
  gem.description = "A collection of (hopefully) comprehensive documentation for the Ruby langauge, core API, and standard library.  The intent is to provide a central location for documenting all the things related to Ruby and its various implementations."
  gem.authors = [
    "Ian MacLeod",
  ]

  gem.platform = Gem::Platform::RUBY

  gem.files         = `git ls-files`.split($/)
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "redcarpet", "~> 2.2"
  gem.add_runtime_dependency "babosa",    "~> 0.3"
end
