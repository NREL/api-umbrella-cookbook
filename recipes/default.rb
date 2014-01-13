#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Varnish doesn't seem to get along with SELinux. Should investigate more.
include_recipe 'selinux::permissive'

# Manage the sudoers file
include_recipe 'sudo'
include_recipe 'sudo::nrel_defaults'
include_recipe 'sudo::secure_path'

# For fetching and committing our code.
include_recipe 'git'

# Ensure ntp is used to keep clocks in sync.
include_recipe 'ntp'

# Standardize the shasum implementation (used for deployments).
include_recipe 'shasum'
