#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"
default[:api_umbrella][:package_checksum] = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"

default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]
