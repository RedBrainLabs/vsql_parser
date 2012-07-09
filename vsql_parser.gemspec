# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "vsql_parser"
  s.version     = "0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Harper"]
  s.email       = ["tim@redbrainlabs.com"]
  # s.homepage    = "http://github.com/leadtune/queue_map"
  s.summary     = "Vertica SQL Parser"
  s.description = "Provides treetop grammar for Vertica SQL. (Most likely works with Postgres SQL as well)"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "treetop", "~> 1.4"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "rspec", "2.10.0"
  s.add_development_dependency "pry"

  s.files        = Dir.glob("{lib}/**/*") + %w(MIT_LICENSE)
  s.require_path = 'lib'
end
