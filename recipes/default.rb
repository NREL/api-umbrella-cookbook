#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

require "yaml"

if(!node[:api_umbrella][:package_url] || !node[:api_umbrella][:package_checksum])
  raise "Unsupported platform or version: #{node[:platform]} #{node[:platform_version]}"
end

package_name = ::File.basename(node[:api_umbrella][:package_url])
package_local_path = "#{Chef::Config[:file_cache_path]}/#{package_name}"

remote_file "api-umbrella-package" do
  path package_local_path
  source node[:api_umbrella][:package_url]
  checksum node[:api_umbrella][:package_checksum]
  only_if do
    if(::File.exists?("/opt/api-umbrella/bin/api-umbrella"))
      version = `/opt/api-umbrella/bin/api-umbrella --version`.strip
      (version != "version #{node[:api_umbrella][:version]}")
    else
      true
    end
  end
end

if(node[:platform_family] == "debian")
  # dpkg doesn't install dependencies. We should look into a real apt repo.
  package "gcc"
end

package "api-umbrella" do
  source package_local_path
  if(node[:platform_family] == "debian")
    provider Chef::Provider::Package::Dpkg
  end

  only_if { ::File.exists?(package_local_path) }
end

file "api-umbrella-package-cleanup" do
  path package_local_path
  action :delete
end

template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
  notifies :reload, "service[api-umbrella]"
end

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
