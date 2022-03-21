# -*- encoding: utf-8 -*-
# stub: community-zero

Gem::Specification.new do |s|
  s.name = "chef-community-zero".freeze
  s.version = "2.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Seth Vargo".freeze]
  s.date = "2014-10-12"
  s.description = "Self-contained, easy-setup, fast-start in-memory Chef Community Site for testing.".freeze
  s.email = "sethvargo@gmail.com".freeze
  s.executables = ["community-zero".freeze]
  s.files = ["bin/community-zero".freeze]
  s.homepage = "https://github.com/chef/chef-community-zero".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.summary = "Self-contained, easy-setup, fast-start in-memory Chef Community Site for testing.".freeze

  s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<webrick>.freeze, [">= 0"])
  s.add_development_dependency(%q<cucumber>.freeze, [">= 0"])
  s.add_development_dependency(%q<json_spec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
end
