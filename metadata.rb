name             'api-umbrella'
maintainer       'National Renewable Energy Laboratory'
maintainer_email 'nick.muerdter@nrel.gov'
license          'All rights reserved'
description      'Installs/Configures api-umbrella'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.0'

# For the "development" recipe
depends "aws"
depends "build-essential"
depends "curl"
depends "git"
depends "phantomjs"
depends "sudo"
