# -*- encoding: utf-8 -*-
# stub: community-zero

Gem::Specification.new do |s|
  s.name = "chef-community-zero".freeze
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Seth Vargo".freeze]
  s.date = "2014-10-12"
  s.description = "Self-contained, easy-setup, fast-start in-memory Chef Community Site for testing.".freeze
  s.email = "sethvargo@gmail.com".freeze
  s.executables = ["community-zero".freeze]
  s.files = ["bin/community-zero".freeze]
  s.homepage = "https://github.com/chef/chef-community-zero".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "2.6.13".freeze
  s.summary = "Self-contained, easy-setup, fast-start in-memory Chef Community Site for testing.".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
      s.add_development_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_development_dependency(%q<json_spec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rack>.freeze, [">= 0"])
      s.add_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_dependency(%q<json_spec>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<cucumber>.freeze, [">= 0"])
    s.add_dependency(%q<json_spec>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
