#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_build_test
#
# Copyright 2015, NREL
#
# All rights reserved - Do Not Redistribute
#

# Additional recipes for running tests on the omnibus build box after packaging
# has finished.

# Install Java for ElasticSearch
node.set[:java][:jdk_version] = 7
include_recipe "java"

# Install ElasticSearch for api-umbrella-web tests.
node.set[:elasticsearch][:version] = "1.4.2"
node.set[:elasticsearch][:allocated_memory] = "256m"
include_recipe "elasticsearch"
service "elasticsearch" do
  action [:start]
end

# Install MongoDB for api-umbrella-web and api-umbrella-gatekeeper tests.
node.set[:mongodb][:config][:smallfiles] = true
include_recipe "mongodb"

# Install PhantomJS for api-umbrella-web tests.
node.set[:phantomjs][:version] = "1.9.8"
node.set[:phantomjs][:base_url] = "https://bitbucket.org/ariya/phantomjs/downloads"
node.set[:phantomjs][:basename] = "phantomjs-#{node[:phantomjs][:version]}-linux-#{node[:kernel][:machine]}"
include_recipe "phantomjs"

# Install unbound for api-umbrella-router tests.
#
# Use the RUNLEVEL=1 environment variable to disable Ubuntu based machines from
# actually starting unbound up at the system level (this tends to break DNS
# things on the machine). Our tests just need it present to spin up for testing
# purposes on a separate port.
ENV["RUNLEVEL"] = "1"
package "unbound"
ENV.delete("RUNLEVEL")
