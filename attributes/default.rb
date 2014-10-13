#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"
default[:api_umbrella][:package_checksum] = "4be8100b4e54bd987e56b3e3b825e85b5edd762e46119f833f54e91a7cbcb799"

default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]
