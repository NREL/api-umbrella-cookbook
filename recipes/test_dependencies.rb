# Install nodejs for running the test suite.
node.set[:nodejs][:install_method] = "binary"
node.set[:nodejs][:version] = "0.10.45"
node.set[:nodejs][:binary][:checksum][:linux_x64] = "54d095d12b6227460f08ec81e50f9db930ec51fa05af1b7722fa85bd2cabb5d7"
include_recipe "nodejs"

# Install PhantomJS for api-umbrella-web tests.
# Download binary from github mirror, since we're seeing semi-frequent 403
# issues from bitbucket similar to:
# https://github.com/Medium/phantomjs/issues/506
node.set[:phantomjs][:version] = "2.1.1"
node.set[:phantomjs][:base_url] = "https://github.com/Medium/phantomjs/releases/download/v#{node[:phantomjs][:version]}"
node.set[:phantomjs][:basename] = "phantomjs-#{node[:phantomjs][:version]}-linux-#{node[:kernel][:machine]}"
node.set[:phantomjs][:checksum] = "86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f"
include_recipe "phantomjs::source"

# For python-virtualenv.
include_recipe "yum-epel"

packages = [
  "expat-devel",
  "libcurl-devel",

  # For installing the mongo-orchestration test dependency.
  "python-virtualenv",

  # For checking for file descriptor leaks during the tests.
  "lsof",
]

packages.each do |package_name|
  package(package_name) do
    action :install
  end
end
