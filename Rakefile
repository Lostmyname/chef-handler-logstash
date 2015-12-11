$:.push File.expand_path('../lib/chef/handler', __FILE__)

require 'chef_logstash'


desc "build .gem"
task :build do
  system 'gem build chef-handler-logstash.gemspec'
end

desc "push rubygems.org"
task :release do
  system "gem push chef-handler-logstash-#{Chef::Handler::Logstash::VERSION}.gem"
end

task :default => :build
