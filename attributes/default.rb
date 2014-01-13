#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:bundler][:version] = '1.5.2'

default[:elasticsearch][:version] = '0.90.10'
default[:elasticsearch][:checksum] = '78c87f600878a6cab41c1d447f6a40b25892a59f8fb49da11392a682884fb8df'

# Default environment.
default[:ENV] = 'development'

default[:envbuilder][:base_dir] = '/home/dotenv'
default[:envbuilder][:owner] = 'dotenv'
default[:envbuilder][:group] = 'dotenv'

default[:java][:jdk_version] = '7'

default[:mongodb][:package_version] = '2.4.8-mongodb_1'

default[:nginx][:install_method] = 'source'
default[:nginx][:default_site_enabled] = false
default[:nginx][:worker_processes] = 4
default[:nginx][:gzip_disable] = 'msie6'
default[:nginx][:gzip_types] = ['text/csv']
default[:nginx][:realip][:real_ip_recursive] = 'on'
default[:nginx][:realip][:addresses] = ['10.0.0.0/16']
default[:nginx][:version] = '1.4.4'
default[:nginx][:source][:version] = '1.4.4'
default[:nginx][:source][:prefix] = '/opt/nginx'
default[:nginx][:source][:checksum] = '7c989a58e5408c9593da0bebcd0e4ffc3d892d1316ba5042ddb0be5b0b4102b9'

default[:nginx][:source][:modules] = [
  'nginx::http_ssl_module',
  'nginx::http_gzip_static_module',
  'nginx::headers_more_module',
  'nginx::http_echo_module',
  'nginx::http_realip_module',
  'nginx::http_stub_status_module',
  'nginx::x_rid_header_module',
  'nginx::passenger',
]
default[:nginx][:source][:url] = "http://nginx.org/download/nginx-#{node[:nginx][:source][:version]}.tar.gz"
default[:nginx][:source][:sbin_path] = "#{node[:nginx][:source][:prefix]}/sbin/nginx"
default[:nginx][:source][:default_configure_flags] = %W[
                                                        --prefix=#{node[:nginx][:source][:prefix]}
                                                        --conf-path=#{node[:nginx][:dir]}/nginx.conf
                                                        --sbin-path=#{node[:nginx][:source][:sbin_path]}
                                                      ]

default[:nodejs][:install_method] = 'binary'
default[:nodejs][:dir] = '/opt/nodejs'
default[:nodejs][:version] = '0.10.24'
default[:nodejs][:checksum_linux_x64] = '6ef93f4a5b53cdd4471786dfc488ba9977cb3944285ed233f70c508b50f0cb5f'

default[:rbenv][:git_ref] = 'v0.4.0'
default[:rbenv][:upgrade] = true
default[:rbenv][:root_path] = '/opt/rbenv'
default[:rbenv][:rubies] = ['1.9.3-p484']
default[:rbenv][:global] = '1.9.3-p484'

default[:redis][:version] = '2.8.3'

default[:ruby_build][:git_ref] = 'v20140110.1'
default[:ruby_build][:upgrade] = true

default[:rubygems][:version] = '2.2.1'
default[:rubygems][:default_options] = '--no-ri --no-rdoc'

default[:supervisor][:version] = '3.0'
default[:supervisor][:dir] = '/etc/supervisord.d'

default[:varnish][:backend_port] = 50100

# Don't set a default TTL so responses won't be cached unless a header
# explicitly says to. We want the API Umbrella proxy to be as transparent as
# possible, so caching should be opt-in only.
default[:varnish][:ttl] = 0

# Attempt to work around the ocassional random crash:
# https://www.varnish-cache.org/trac/ticket/1119
default[:varnish][:cli_timeout] = 60

default[:api_umbrella][:gatekeeper][:logrotate_paths] = []
