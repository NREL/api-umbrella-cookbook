#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_test_built_package
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, ::ApiUmbrella::OmnibusHelpers)

package_path = "#{Chef::Config[:file_cache_path]}/api-umbrella-omnibus-test.#{omnibus_package_extension}"
package_dir = omnibus_package_dir
package = omnibus_package

if(node[:omnibus][:env][:aws_s3_bucket])
  aws_s3_file(package_path) do
    bucket node[:omnibus][:env][:aws_s3_bucket]
    aws_access_key_id node[:omnibus][:env][:aws_access_key]
    aws_secret_access_key node[:omnibus][:env][:aws_secret_key]
    remote_path "#{package_dir}/#{package}/#{package}"
  end
else
  link(package_path) do
    to File.join(node[:omnibus][:build_dir], "pkg", package_dir, package)
  end
end

if(node[:platform_family] == "debian")
  # dpkg doesn't install dependencies. We should look into a real apt repo.
  package "gcc"
end

package "api-umbrella" do
  source package_path
  case node[:platform_family]
  when "debian"
    provider Chef::Provider::Package::Dpkg
  end
end

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
