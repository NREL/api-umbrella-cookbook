#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"
default[:api_umbrella][:package_checksum] = "b4cb7c005f9fbdb692b5b1cf9387a04b97c4c3a96f8ae9cb5c9543b1859fc7d5"

default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]
