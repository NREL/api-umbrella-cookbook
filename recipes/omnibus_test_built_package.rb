#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_test_built_package
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

ruby_block "symlink-api-umbrella-built-package" do
  block do
    package_dir = "/home/vagrant/api-umbrella/pkg/#{node[:platform]}-#{node[:platform_version]}"
    package_files = Dir.glob(File.join(package_dir, "*"))
    package_files.map! { |file| file.gsub(".metadata.json", "") }
    package_files.uniq!

    if(package_files.length > 1)
      raise "multiple packages inside #{package_dir} - cannot detect which to use (#{package_files.inspect})"
    elsif(package_files.length != 1)
      raise "no packages to install found in #{package_dir}"
    end

    package_file = package_files.first
    FileUtils.ln_sf(package_file, "#{Chef::Config[:file_cache_path]}/api-umbrella-omnibus-test#{File.extname(package_file)}")
  end
end

package "api-umbrella" do
  case node[:platform_family]
  when "rhel"
    source "#{Chef::Config[:file_cache_path]}/api-umbrella-omnibus-test.rpm"
  when "debian"
    source "#{Chef::Config[:file_cache_path]}/api-umbrella-omnibus-test.deb"
  end
end

template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
  notifies :reload, "service[api-umbrella]"
end

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
