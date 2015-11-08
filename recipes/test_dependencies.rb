# Install nodejs for running the test suite.
node.set[:nodejs][:install_method] = "binary"
node.set[:nodejs][:version] = "0.10.40"
node.set[:nodejs][:binary][:checksum][:linux_x64] = "0bb15c00fc4668ce3dc1a70a84b80b1aaaaea61ad7efe05dd4eb91165620a17e"
include_recipe "nodejs"

# Install PhantomJS for api-umbrella-web tests.
node.set[:phantomjs][:version] = "1.9.8"
node.set[:phantomjs][:base_url] = "https://bitbucket.org/ariya/phantomjs/downloads"
node.set[:phantomjs][:basename] = "phantomjs-#{node[:phantomjs][:version]}-linux-#{node[:kernel][:machine]}"
include_recipe "phantomjs::source"

# For python-virtualenv.
include_recipe "yum-epel"

packages = [
  "expat-devel",
  "libcurl-devel",

  # For installing the mongo-orchestration test dependency.
  "python-virtualenv",

  # For checking for file descriptor leaks during the tests.
  "lsof"
]

packages.each do |package_name|
  package(package_name) do
    action :install
  end
end

