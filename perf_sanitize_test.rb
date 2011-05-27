require "rubygems"
require 'perftools'
require 'faker'
require 'sanitize'

PerfTools::CpuProfiler.start("sanitize_gem_profile") do
  5_000_000.times { Sanitize.clean(%Q(<a href="#{Faker::Internet.domain_name}">Faker::Name.name</a>)) }
end