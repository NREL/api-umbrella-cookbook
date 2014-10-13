#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"
default[:api_umbrella][:package_checksum] = "a37360eeb6462c33282bba3d2af5d1bab4cfcb500735743f5b5a69c402c1b62f"

default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]
