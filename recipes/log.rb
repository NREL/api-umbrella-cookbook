#
# Cookbook Name:: api-umbrella
# Recipe:: log
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'api-umbrella'
include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'iptables::elasticsearch'
