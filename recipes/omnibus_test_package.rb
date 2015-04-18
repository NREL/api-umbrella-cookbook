#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_test_built_package
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "api-umbrella::omnibus_install_built_package"

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# Write the environment variables to a file so the integration tests can access
# them.
require "yaml"
File.open("/tmp/api_umbrella_omnibus_test_env.yml", "w") do |file|
  file.write(YAML.dump(node[:omnibus][:env].to_hash))
end
