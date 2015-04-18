#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_build_test
#
# Copyright 2015, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "api-umbrella::omnibus_install_built_package"

include_recipe "api-umbrella::development_ulimit"

# Install compilers for building C gems and npm modules.
include_recipe "build-essential"

# Install libcurl as an npm test dependencies.
include_recipe "curl::libcurl"

# Install git for git bundler dependencies.
include_recipe "git"

# Install Java for ElasticSearch
node.set[:java][:jdk_version] = 7
include_recipe "java"

# Install ElasticSearch for api-umbrella-web tests.
node.set[:elasticsearch][:version] = "1.5.1"
node.set[:elasticsearch][:allocated_memory] = "256m"
include_recipe "elasticsearch"
service "elasticsearch" do
  action [:start]
end

# Install MongoDB for api-umbrella-web and api-umbrella-gatekeeper tests.
node.set[:mongodb][:config][:smallfiles] = true
include_recipe "mongodb"

# Install mongo-orchestration for api-umbrella-router tests where we want to
# simulate replicaset changes and failures.
include_recipe "python"
python_pip "argparse"
python_pip "mongo-orchestration"

# Install PhantomJS for api-umbrella-web tests.
node.set[:phantomjs][:version] = "1.9.8"
node.set[:phantomjs][:base_url] = "https://bitbucket.org/ariya/phantomjs/downloads"
node.set[:phantomjs][:basename] = "phantomjs-#{node[:phantomjs][:version]}-linux-#{node[:kernel][:machine]}"
include_recipe "phantomjs::source"

# Install unbound for api-umbrella-router tests.
#
# But make sure unbound is stopped, since on Ubuntu machines it starts up
# automatically at the system level after install (this tends to break DNS
# things on the machine). Our tests just need it present to spin up for testing
# purposes on a separate port.
package "unbound"
service "unbound" do
  action [:stop]
end
