#
# Cookbook Name:: api-umbrella
# Attributes:: router
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:gatekeeper][:logrotate_paths] = [
  "/srv/api-umbrella-router/current/log/gatekeeper/production.log",
  "/srv/api-umbrella-router/current/log/gatekeeper/staging.log",
  "/srv/api-umbrella-router/current/log/gatekeeper/development.log",
]

default[:nginx][:logrotate][:extra_paths] = [
  "/srv/api-umbrella-router/current/log/*.log",
  "/srv/api-umbrella-router/current/log/gatekeeper/access.log",
  "/srv/api-umbrella-router/current/log/gatekeeper/error.log",
  "/srv/api-umbrella-router/current/log/gatekeeper/router.log",
  "/srv/api-umbrella-web/current/log/*.log",
]

default[:supervisor][:logrotate][:extra_paths] = [
  "/srv/api-umbrella-router/current/log/gatekeeper/supervisor.log",
]
