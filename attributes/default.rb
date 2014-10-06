#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"
default[:api_umbrella][:package_checksum] = "63e1824f6142c73d11fe677e64fe2c1f7065767694591a75a0ddd4a465e190f3"

default[:api_umbrella][:config][:app_env] = "production"
default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]

default[:api_umbrella][:config][:mongodb][:url] = "mongodb://127.0.0.1:50217/api_umbrella_development"
default[:api_umbrella][:config][:elasticsearch][:hosts] = [
  "http://127.0.0.1:50200",
]
