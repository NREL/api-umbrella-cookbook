#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

yum_repository "api-umbrella" do
  description "API Umbrella"
  baseurl "https://dl.bintray.com/nrel/api-umbrella-el6"
  gpgcheck false
  gpgkey "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"
  enabled true
  action :create
end

package "api-umbrella"

require "yaml"
template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
  notifies :reload, "service[api-umbrella]"
end

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
