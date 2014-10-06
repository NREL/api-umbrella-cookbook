#
# Cookbook Name:: api-umbrella
# Recipe:: legacy_router_upgrade
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

service "nginx" do
  action [:stop, :disable]
end

service "redis" do
  action [:stop, :disable]
end

service "supervisor" do
  action [:stop, :disable]
end

service "varnish" do
  action [:stop, :disable]
end

service "varnishlog" do
  action [:stop, :disable]
end

service "varnishncsa" do
  action [:stop, :disable]
end

service "api-umbrella" do
  action [:enable, :start]
end
