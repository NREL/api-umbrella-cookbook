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
  checksum "14bfab10d735ef461baff5ceb0a966d6d42569b146f55bcece0fed2f87c23c57"
end

package "api-umbrella" do
  source package_local_path
end

template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
end
