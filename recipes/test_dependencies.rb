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

  # For shellcheck and Haskell
  "gmp-devel",
  "zlib",
]

packages.each do |package_name|
  package(package_name) do
    action :install
  end
end

# Install Haskell for bash script linting with shellcheck.
# Based on:
# https://github.com/koalaman/shellcheck/wiki/More-Installation-Guides
#
# Note that the haskell-platform 7.10.3 binaries don't appear compatible with
# CentOS 6 (it requires a newer version of glibc).
haskell_platform = "haskell-platform-7.10.2-a-unknown-linux-deb7"
ghc_dir = "/usr/local/haskell/ghc-7.10.2-x86_64"
shellcheck_version = "0.4.3"

remote_file "#{Chef::Config[:file_cache_path]}/#{haskell_platform}.tar.gz" do
  source "https://www.haskell.org/platform/download/7.10.2/#{haskell_platform}.tar.gz"
  checksum "9e9aeb313dfc2307382eeafd67307e3961c632c875e5818532cacc090648e515"
end

bash "install_haskell_platform" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-eos
    mkdir -p #{haskell_platform}
    tar -C #{haskell_platform} -xvf #{haskell_platform}.tar.gz

    cd #{haskell_platform}
    ./install-haskell-platform.sh

    cd #{Chef::Config[:file_cache_path]}
    rm -rf #{haskell_platform}
  eos
  only_if { !File.exist?(ghc_dir) || !File.exist?("/usr/local/bin/cabal") }
end

# The haskell-platform binaries expect "libgmp.so.10" which isn't present on
# CentOS 6. We'll symlink the older version into place as a hacky workaround
# that seems to do the trick.
link "/usr/lib64/libgmp.so.10" do
  to "/usr/lib64/libgmp.so.3"
  only_if { File.exist?("/usr/lib64/libgmp.so.3") && !File.exist?("/usr/lib64/libgmp.so.10") }
end
