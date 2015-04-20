#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_build_test
#
# Copyright 2015, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "api-umbrella::development_ulimit"
include_recipe "api-umbrella::test_dependencies"
include_recipe "api-umbrella::omnibus_install_built_package"
