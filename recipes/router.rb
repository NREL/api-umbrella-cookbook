#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "api-umbrella-gatekeeper" do
  system true
  shell "/bin/false"
end

group "api-umbrella"

group "api-umbrella" do
  action :manage
  append true
  members ["api-umbrella-gatekeeper"]
end

sudo "api_umbrella" do
  user "api-umbrella-gatekeeper"

  commands [
    "/etc/init.d/nginx configtest",
    "/etc/init.d/nginx reload",
  ]

  host "ALL"
  nopasswd true
end
