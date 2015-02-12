name             'api-umbrella'
maintainer       'National Renewable Energy Laboratory'
maintainer_email 'nick.muerdter@nrel.gov'
license          'All rights reserved'
description      'Installs/Configures api-umbrella'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.7.0'

# For the "development" recipe
depends "build-essential", "~> 2.1.3"
depends "curl", "~> 2.0.1"
depends "git", "~> 4.1.0"
depends "phantomjs", "~> 1.0.3"
depends "sudo", "~> 2.7.1"

# For the omibus build and test recipes
depends "aws", "~> 2.6.0"
depends "elasticsearch", "~> 0.3.13"
depends "java", "~> 1.31.0"
depends "mongodb", "~> 0.16.2"
