require "rake"
require "rspec/core/rake_task"
require 'ci/reporter/rake/rspec'
require "puppet-lint/tasks/puppet-lint"


PuppetLint.configuration.ignore_paths = [ /modules\/((a|t|j|r|p|ss|std).*)\/*.pp/ ]

task :default do
  system("rake -T")
end

desc "Run RSpec"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "**/spec/**/*_spec.rb"
  t.rspec_opts = "--format d --colour"
end


desc "Run CI Build (puppet-lint and puppet-rspec)"
task :build => [ "ci:setup:rspec", 'lint', :test]
