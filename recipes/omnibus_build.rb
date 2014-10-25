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

    # Use system-installed gecode to speed up installation:
    # https://github.com/berkshelf/berkshelf/issues/1166#issuecomment-41562621
    "USE_SYSTEM_GECODE" => "1",
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
