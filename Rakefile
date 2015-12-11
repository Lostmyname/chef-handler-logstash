version = File.open('VERSION', 'rb').read

desc "build .gem"
task :build do
  system 'gem build chef-handler-logstash.gemspec'
end

desc "push rubygems.org"
task :release do
  system "gem push chef-handler-logstash-#{version}.gem"
end

task :default => :build
