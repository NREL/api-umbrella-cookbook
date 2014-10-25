#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_build
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

execute "bundle install" do
  cwd "/home/vagrant/api-umbrella"
  user "vagrant"
  group "vagrant"
  environment({
    "HOME" => "/home/vagrant",
    "USER" => "vagrant",
  })
end

execute "bin/omnibus build api-umbrella -l info" do
  cwd "/home/vagrant/api-umbrella"
  user "vagrant"
  group "vagrant"
  environment({
    "HOME" => "/home/vagrant",
    "USER" => "vagrant",
  })
end
