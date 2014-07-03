name             'api-umbrella'
maintainer       'National Renewable Energy Laboratory'
maintainer_email 'nick.muerdter@nrel.gov'
license          'All rights reserved'
description      'Installs/Configures api-umbrella'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.6'

depends "acl"
depends "bundler"
depends "elasticsearch"
depends "envbuilder"
depends "geoip"
depends "git"
depends "iptables"
depends "java"
depends "logrotate"
depends "man"
depends "mongodb"
depends "nginx"
depends "nodejs"
depends "ntp"
depends "pygments"
depends "rbenv"
depends "redis"
depends "ruby_build"
depends "rubygems"
depends "selinux"
depends "shasum"
depends "sudo"
depends "supervisor"
depends "ulimit"
depends "varnish"
depends "xml"
