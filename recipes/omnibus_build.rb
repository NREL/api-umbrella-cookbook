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

Chef::Log.info("Building api-umbrella, this could take a while...")
execute "omnibus build api-umbrella" do
  # Output to a temp log file, in addition to the screen. Since the build takes
  # a long time, this allows us to login to the machine to view progress, while
  # also ensuring the output is captured by Chef in case things error.
  command "bin/omnibus build api-umbrella -l info 2>&1 | tee /tmp/api-umbrella-build.log"
  cwd "/home/vagrant/api-umbrella"
  user "vagrant"
  group "vagrant"
  environment({
    "HOME" => "/home/vagrant",
    "USER" => "vagrant",
  })
end
