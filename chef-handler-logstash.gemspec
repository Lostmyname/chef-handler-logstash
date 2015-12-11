Gem::Specification.new do |s|
  s.name = 'chef-handler-logstash'
  s.version = '0.0.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ['LostMyName']
  s.email = ['nadir@lostmy.name']
  s.homepage = 'https://github.com/lostmyname/chef-handler-logstash'
  s.summary = 'Chef Profiler Logstash'
  s.description = 'Send report to logstash port listening for json_events'
  s.files = %w(MIT-LICENSE README.md) + Dir.glob('lib/**/*')
  s.require_paths = ['lib']
  s.add_development_dependency "chef", "> 10.14"
end
