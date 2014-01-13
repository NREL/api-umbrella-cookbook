#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ruby_build'
include_recipe 'api-umbrella'
include_recipe 'rbenv::system'
include_recipe 'envbuilder'
include_recipe 'iptables::http'
include_recipe 'iptables::https'
include_recipe 'logrotate'
include_recipe 'nginx::source'
include_recipe 'pygments'
include_recipe 'rubygems::client'
include_recipe 'sudo'
include_recipe 'xml'
include_recipe 'bundler'
include_recipe 'bundler::auto_exec'

home = '/home/api-umbrella-deployer'
key_file = "#{home}/.ssh/id_rsa"
public_key_file = "#{key_file}.pub"
authorized_keys_file = "#{home}/.ssh/authorized_keys"

user 'api-umbrella-deployer' do
  supports :manage_home => true
  home home
  system true
  shell '/bin/bash'
end

bash 'api-umbrella-deployer-ssh-keygen' do
  user 'api-umbrella-deployer'
  group 'api-umbrella-deployer'
  code <<-EOS
    ssh-keygen -f #{key_file} -N ''
  EOS
  not_if { File.exists?(key_file) }
end

bash 'api-umbrella-deployer-authorized_keys' do
  user 'api-umbrella-deployer'
  group 'api-umbrella-deployer'
  code <<-EOS
    cat #{public_key_file} >> #{authorized_keys_file}
    chmod 600 #{authorized_keys_file}
  EOS
  only_if { !File.exists?(authorized_keys_file) || !File.read(authorized_keys_file).include?(File.read(public_key_file)) }
end

directory '/opt/api-umbrella/static-site' do
  recursive true
  owner 'api-umbrella-deployer'
  group 'api-umbrella-deployer'
  mode '0755'
  action :create
end

group 'api-umbrella' do
  action :manage
  append true
  members ['api-umbrella-gatekeeper']
end

sudo 'api_umbrella' do
  template 'sudo.erb'
end

acl '/etc/nginx/sites-available' do
  user 'api-umbrella-deployer'
  modify 'rwx'
end

acl '/etc/nginx/sites-enabled' do
  user 'api-umbrella-deployer'
  modify 'rwx'
end
