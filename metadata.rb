name             'api-umbrella'
maintainer       'National Renewable Energy Laboratory'
maintainer_email 'nick.muerdter@nrel.gov'
license          'MIT'
description      'Installs/Configures api-umbrella'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.7.1'

# For the "development" recipe
depends "build-essential"
depends "sudo"
depends "ulimit"

# For the "test_dependencies" recipe
depends "nodejs"
depends "phantomjs"
depends "yum"
depends "yum-epel"
