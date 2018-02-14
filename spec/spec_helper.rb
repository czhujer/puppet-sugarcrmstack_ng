require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
#require 'rspec-puppet-augeas'

include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'
require 'simplecov-cobertura'

SimpleCov.start do
  #add_filter '/spec'
  add_filter '/spec/fixtures'
  add_filter '/vendor'
  coverage_dir 'shippable/codecoverage'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter,
    SimpleCov::Formatter::Console
  ])
end

RSpec.configure do |c|
  c.hiera_config = File.expand_path(File.join(__FILE__, '../fixtures/hiera.yaml'))
#  c.augeas_fixtures = File.join(File.dirname(File.expand_path(__FILE__)), 'fixtures', 'augeas')
end
