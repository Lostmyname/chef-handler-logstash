Description
===========

This is a Chef report handler that exports a report in json format to the configured server/port.
We are using it to report to logstash but probably you can hook it into anything that accepts a json :)


* http://wiki.opscode.com/display/chef/Exception+and+Report+Handlers

Requirements
============

Only works on Chef >= 10.14

Usage
=====

There are two ways to use Chef Handlers.

### Method 1 (recommended)

Use the
[chef_handler cookbook by Opscode](http://community.opscode.com/cookbooks/chef_handler).
Create a recipe with the following:

    include_recipe "chef_handler"

    # Install `chef-handler-logstash` gem during the compile phase
    chef_gem "chef-handler-logstash"

    # load the gem here so it gets added to the $LOAD_PATH, otherwise chef_handler
    # will fail.
    require 'chef/handler/chef_logstash'

    # Activate the handler immediately during compile phase
    chef_handler "Chef::Handler::Logstash" do
      source "chef/handler/chef_logstash"
      arguments [
         :host => 'your_logstash_host',
         :port => 'your_logstash_port',
         :tags => 'array_of_tags',
         :timeout => 'timeout when trying to reach the logstash server. Integer'
      ]
      action :nothing
    end.run_action(:enable)


### Method 2

Install the gem ahead of time, and configure Chef to use
them:

    gem install chef-handler-logstash

Then add to the configuration (`/etc/chef/solo.rb` for chef-solo or
`/etc/chef/client.rb` for chef-client):

    require "chef/handler/chef_logstash"
    report_handlers << Chef::Handler::Logstash.new(:host => 'foo', :port => 'bar', :timeout => 15, :tags => ['chef-client'])
    exception_handlers << Chef::Handler::Logstash.new(:host => 'foo', :port => 'bar', :timeout => 15, :tags => ['chef-client'])


License and Author
==================

Licensed under the MIT license. See `MIT-LICENSE` file for details.

Author:: Nadir Lloret <https://github.com/nadirollo>
