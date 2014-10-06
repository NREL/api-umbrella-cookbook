#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

require "yaml"

package_name = "api-umbrella-0.6.0-1.el6.x86_64.rpm"
package_local_path = "#{Chef::Config[:file_cache_path]}/#{package_name}"

remote_file(package_local_path) do
  source "https://developer.nrel.gov/downloads/api-umbrella/#{package_name}"
  checksum "c4173e5beb3e65d08888a724b7a360b09e70753acbd79342f60940044d2ecbe8"
end

package "api-umbrella" do
  source package_local_path
end

template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
end
