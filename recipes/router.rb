#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "logrotate"
include_recipe "sudo"

user "api-umbrella-gatekeeper" do
  system true
  shell "/bin/false"
end

group "api-umbrella"

group "api-umbrella" do
  action :manage
  append true
  members ["api-umbrella-gatekeeper"]
end

sudo "api_umbrella" do
  template "sudo.erb"
end

logrotate_app "api_umbrella_gatekeeper" do
  path node[:api_umbrella][:gatekeeper][:logrotate_paths]
  frequency "daily"
  rotate node[:supervisor][:logrotate][:rotate]
  create "644 api-umbrella-gatekeeper api-umbrella-gatekeeper"
  options %w(missingok compress delaycompress copytruncate notifempty)
  sharedscripts true
end
