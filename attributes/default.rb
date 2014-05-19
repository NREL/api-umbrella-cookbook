#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:bundler][:version] = '1.6.2'

default[:elasticsearch][:version] = '0.90.13'
default[:elasticsearch][:checksum] = '82904d4c564fc893a1cfc0deb4526073900072a3f4667b995881a2ec5cdfdb43'

# Use soft caches. This may lead to degraded performance, but it should
# ensure ElasticSearch doesn't run out of memory and permanantly lock up.
default[:elasticsearch][:custom_config]["index.fielddata.cache"] = "soft"
default[:elasticsearch][:custom_config]["index.fielddata.cache.expire"] = "10m"

# Default environment.
default[:ENV] = 'development'

default[:envbuilder][:base_dir] = '/home/dotenv'
default[:envbuilder][:owner] = 'dotenv'
default[:envbuilder][:group] = 'dotenv'

default[:java][:jdk_version] = '7'

default[:mongodb][:package_version] = '2.4.10-mongodb_1'

default[:nginx][:install_method] = 'source'
default[:nginx][:user] = 'www-data-local'
default[:nginx][:group] = 'www-data-local'
default[:nginx][:default_site_enabled] = false
default[:nginx][:worker_processes] = 4
default[:nginx][:gzip_disable] = 'msie6'
default[:nginx][:gzip_types] = ['text/plain', 'text/css', 'application/x-javascript', 'text/xml', 'application/xml', 'application/rss+xml', 'application/atom+xml', 'text/javascript', 'application/javascript', 'application/json', 'text/mathml', 'text/csv']
default[:nginx][:server_tokens] = 'off'
override[:nginx][:realip][:real_ip_recursive] = 'on'
override[:nginx][:realip][:addresses] = ['127.0.0.1', '10.0.0.0/16']
default[:nginx][:server_names_hash_bucket_size] = 128
default[:nginx][:version] = '1.4.7'
default[:nginx][:source][:version] = '1.4.7'
default[:nginx][:source][:prefix] = '/opt/nginx'
default[:nginx][:source][:checksum] = '23b8ff4a76817090678f91b0efbfcef59a93492f6612dc8370c44c1f1ce1b626'

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
default[:nodejs][:version] = '0.10.28'
default[:nodejs][:checksum_linux_x64] = '5f41f4a90861bddaea92addc5dfba5357de40962031c2281b1683277a0f75932'

default[:rbenv][:git_ref] = 'v0.4.0'
default[:rbenv][:upgrade] = true
default[:rbenv][:root_path] = '/opt/rbenv'
default[:rbenv][:rubies] = ['1.9.3-p545']
default[:rbenv][:global] = '1.9.3-p545'

default[:redis][:version] = '2.8.8'

default[:ruby_build][:git_ref] = 'v20140408'
default[:ruby_build][:upgrade] = true

default[:rubygems][:version] = '2.2.2'
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
