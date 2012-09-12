require "rake"
require "rspec/core/rake_task"
require 'ci/reporter/rake/rspec'

task :default do
  system("rake -T")
end

desc "Run RSpec"
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = "**/spec/**/*_spec.rb"
  t.rspec_opts = "--format d --colour"
end


desc "Run CI Build"
task :build => [ "ci:setup:rspec", :test]
